import 'package:account_book/database/app_database.dart';
import 'package:account_book/di/locators.dart';
import 'package:account_book/models/enums.dart';
import 'package:account_book/models/queries/transaction_query.dart';
import 'package:drift/drift.dart';

// repositories/transaction_repository.dart

/*
Stream 做法：
你的首页 UI 像一个“监听器”一样挂在管道出口。
只要底层 SQLite 表里多了一条数据，
Drift 就会自动感知并将最新的 List<Transaction> 推送到管道。
首页 UI 会瞬间自动跳变，你不需要写一行刷新代码。

 */

class TransactionRepository {
  final _db = getIt<AppDatabase>();

  /// 插入数据
  Future<int> insert(TransactionsCompanion entry) =>
      _db.into(_db.transactions).insert(entry);

  /// 删除数据
  Future<void> delete(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  /// 更新数据
  Future<bool> update(TransactionsCompanion entry) async {
    // replace 会根据 entry 里的主键 ID 自动定位并更新
    // 返回 bool 表示是否更新成功
    return _db.update(_db.transactions).replace(entry);
  }

  /// 查询数据(by id)
  Future<Transaction?> getById(int id) {
    return (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 实时监听单条记录
  Stream<Transaction?> watchById(int id) {
    return (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// 获取所有数据
  Future<List<Transaction>> getAll() {
    return _db.select(_db.transactions).get();
  }

  /// 实时监听所有交易 (对应 getAll 的 Stream 版)
  Stream<List<Transaction>> watchAll() {
    return (_db.select(
      _db.transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  }

  /// 分页查询
  Future<List<Transaction>> getPage(TransactionQuery query) {
    final q = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(query.pageSize, offset: query.offset);
    return q.get();
  }

  /// 实时监听分页数据 (对应 getPage 的 Stream 版)
  Stream<List<Transaction>> watchPage(TransactionQuery query) {
    final q = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(query.pageSize, offset: query.offset);
    return q.watch();
  }

  /// 实时监听总收入
  Stream<double> watchTotalIncome({DateTime? date}) {
    // 1. 创建一个“只选列”的查询，而不是“选整行”
    final query = _db.selectOnly(_db.transactions);

    // 2. 定义求和表达式：SUM(amount)
    final sumAmount = _db.transactions.amount.sum();

    // 3. 添加聚合列到查询中
    query.addColumns([sumAmount]);

    // 4. 构建过滤条件 (WHERE)
    // 条件一：类型必须是收入
    query.where(_db.transactions.type.equals(TransactionType.income.index));

    // 条件二：如果有传入日期，则按月筛选（假设传入的是当月某天）
    if (date != null) {
      query.where(_db.transactions.date.year.equals(date.year));
      query.where(_db.transactions.date.month.equals(date.month));
    }

    // 5. 监听并转换结果
    // watchSingle 会返回一个 TypedResult 对象
    return query.watchSingle().map((row) {
      // 从行结果中读取我们定义的 sumAmount 表达式的值
      return row.read(sumAmount) ?? 0.0;
    });
  }

  /// 实时监听总支出
  Stream<double> watchTotalExpense({DateTime? date}) {
    // 1. 创建一个“只选列”的查询，而不是“选整行”
    final query = _db.selectOnly(_db.transactions);

    // 2. 定义求和表达式：SUM(amount)
    final sumAmount = _db.transactions.amount.sum();

    // 3. 添加聚合列到查询中
    query.addColumns([sumAmount]);

    // 4. 构建过滤条件 (WHERE)
    // 条件一：类型必须是收入
    query.where(_db.transactions.type.equals(TransactionType.expense.index));

    // 条件二：如果有传入日期，则按月筛选（假设传入的是当月某天）
    if (date != null) {
      query.where(_db.transactions.date.year.equals(date.year));
      query.where(_db.transactions.date.month.equals(date.month));
    }

    // 5. 监听并转换结果
    // watchSingle 会返回一个 TypedResult 对象
    return query.watchSingle().map((row) {
      // 从行结果中读取我们定义的 sumAmount 表达式的值
      return row.read(sumAmount) ?? 0.0;
    });
  }

  /// 实时监听总余额
  Stream<double> watchTotalBalance({DateTime? date}) {
    final incomeStream = watchTotalIncome(date: date);
    final expenseStream = watchTotalExpense(date: date);

    return incomeStream.asyncMap((income) async {
      final expense = await expenseStream.first;
      return income - expense;
    });
  }

  /// 获取最近交易记录
  Stream<List<Transaction>> watchRecentTransactions(int count) {
    final query = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(count);
    return query.watch();
  }
}
