// services/transaction_service.dart

import 'package:account_book/data/app_database.dart';
import 'package:account_book/di/locators.dart';
import 'package:drift/drift.dart';

class TransactionService {
  /// 数据库实例
  final _db = getIt<AppDatabase>();

  /// 这样定义，UI层调用时最舒服
  Future<void> add({
    required double amount,
    required DateTime date,
    required String category,
    required TransactionType type,
    String? note,
  }) async {
    await _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(
            amount: amount,
            date: date,
            category: category,
            type: type,
            note: Value(note), // 自动处理 String? 到 Value<String?> 的转换
          ),
        );
  }

  // 插入数据
  Future<int> insertTransaction(TransactionsCompanion entry) async {
    // 直接插入即可，Drift 会自动处理里面的 Value
    return await _db.into(_db.transactions).insert(entry);
  }

  /// 删除数据
  Future<void> deleteTransaction(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  /// 更新数据
  Future<void> updateTransaction(Transaction original, double newAmount) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(original.id)))
        .write(TransactionsCompanion(amount: Value(newAmount)));
  }

  // 获取收入流
  Stream<double> getIncomeStream({DateTime? date}) {
    return _db.watchTotalAmount(type: TransactionType.income, date: date);
  }

  // 获取支出流
  Stream<double> getExpenseStream({DateTime? date}) {
    return _db.watchTotalAmount(type: TransactionType.expense, date: date);
  }

  // 获取结余流 (组合两个流)
  Stream<double> getBalanceStream({DateTime? date}) {
    final income = getIncomeStream(date: date);
    final expense = getExpenseStream(date: date);

    // 使用 rxdart 的 combineLatest 会更优雅，这里用基础 Stream 实现
    // 简单起见，在 UI 层做减法，或者在这里通过 StreamZip 实现
    return income.asyncMap((inc) async {
      final exp = await getExpenseStream(date: date).first;
      return inc - exp;
    });
  }

  // 1. 获取本月总额的流 (SQL 计算版)
  Stream<double> watchTotal(TransactionType type, DateTime month) {
    final query = _db.selectOnly(_db.transactions);

    // 相当于 SQL: SELECT SUM(amount) FROM transactions WHERE ...
    query.addColumns([_db.transactions.amount.sum()]);
    query.where(_db.transactions.type.equals(type.index));
    query.where(_db.transactions.date.year.equals(month.year));
    query.where(_db.transactions.date.month.equals(month.month));

    return query.watchSingle().map(
      (row) => row.read(_db.transactions.amount.sum()) ?? 0.0,
    );
  }

  // 获取所有交易并按时间倒序排列
  Stream<List<Transaction>> watchAll() {
    return (_db.select(
      _db.transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  }

  // 获取所有交易的实时流
  Stream<List<Transaction>> watchAllTransactions() {
    final database = getIt<AppDatabase>();
    return database.select(database.transactions).watch();
  }

  // 条件查询：获取本月的收入
  Stream<List<Transaction>> watchMonthlyIncome(DateTime month) {
    final database = getIt<AppDatabase>();
    return (database.select(database.transactions)
          ..where((t) => t.type.equals(TransactionType.income.index))
          ..where((t) => t.date.year.equals(month.year))
          ..where((t) => t.date.month.equals(month.month)))
        .watch();
  }

  // 获取最近的交易记录（按日期降序，取前10条）
  Stream<List<Transaction>> watchRecentTransactions({int limit = 10}) {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]) // 按日期降序
          ..limit(limit)) // 限制数量
        .watch();
  }

  // 在 Service 里定义
  // Stream<DashboardData> watchSummary(DateTime month) {
  //   return Rx.combineLatest2(
  //     watchTotal(TransactionType.income, month),
  //     watchTotal(TransactionType.expense, month),
  //     (inc, exp) => DashboardData(income: inc, expense: exp),
  //   );
  // }

  /// 获取所有数据并以 JSON 格式打印到控制台
  Future<void> debugPrintAllAsJson() async {
    // 1. 从数据库获取所有原始数据对象
    final allTransactions = await _db.select(_db.transactions).get();

    print('--- 📂 数据库 JSON 导出开始 (共 ${allTransactions.length} 条) ---');

    // 2. 使用 for 循环遍历并打印
    for (final t in allTransactions) {
      // Drift 自动生成的类拥有 toJson() 方法，返回一个 Map
      final Map<String, dynamic> jsonMap = t.toJson();

      // 或者直接打印生成的 JSON 字符串
      print(t.toJsonString());
    }

    print('--- 📂 数据库 JSON 导出结束 ---');
  }
}
