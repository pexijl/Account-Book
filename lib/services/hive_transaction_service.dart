import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

/// Hive 交易服务
/// 演示如何使用 Hive 存储自定义对象
class HiveTransactionService {
  static const String _boxName = 'transactions_box';
  Box<Transaction>? _box;

  /// 初始化 - 打开 Box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Transaction>(_boxName);
    } else {
      _box = Hive.box<Transaction>(_boxName);
    }
  }

  /// 确保已初始化
  Box<Transaction> get box {
    if (_box == null) {
      throw Exception('HiveTransactionService 未初始化，请先调用 init()');
    }
    return _box!;
  }

  // ==================== CRUD 操作 ====================

  /// 添加交易记录
  /// 如果 id 已存在，会覆盖原有记录
  Future<void> addTransaction(Transaction transaction) async {
    print('添加交易记录: $transaction');
    await box.put(transaction.id, transaction);
  }

  /// 获取单个交易记录
  Transaction? getTransaction(int id) {
    return box.get(id);
  }

  /// 获取所有交易记录
  List<Transaction> getAllTransactions() {
    return box.values.toList();
  }

  /// 更新交易记录
  Future<void> updateTransaction(Transaction transaction) async {
    await box.put(transaction.id, transaction);
  }

  /// 删除交易记录
  Future<void> deleteTransaction(int id) async {
    await box.delete(id);
  }

  /// 清空所有交易记录
  Future<void> clearAll() async {
    await box.clear();
  }

  // ==================== 查询操作 ====================

  /// 按类型获取交易
  List<Transaction> getTransactionsByType(TransactionType type) {
    return box.values.where((t) => t.type == type).toList();
  }

  /// 按分类获取交易
  List<Transaction> getTransactionsByCategory(String category) {
    return box.values.where((t) => t.category == category).toList();
  }

  /// 按日期范围获取交易
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return box.values
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  /// 获取总收入
  double getTotalIncome() {
    return box.values
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// 获取总支出
  double getTotalExpense() {
    return box.values
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// 获取余额
  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  // ==================== 使用示例 ====================
  ///
  /// // 1. 初始化（在 main.dart 中调用一次）
  /// final service = HiveTransactionService();
  /// await service.init();
  ///
  /// // 2. 添加交易
  /// final transaction = Transaction.expense(
  ///   id: 1,
  ///   amount: 50.0,
  ///   category: '餐饮',
  ///   date: DateTime.now(),
  ///   note: '午餐',
  /// );
  /// await service.addTransaction(transaction);
  ///
  /// // 3. 获取所有交易
  /// final allTransactions = service.getAllTransactions();
  ///
  /// // 4. 按类型查询
  /// final expenses = service.getTransactionsByType(TransactionType.expense);
  ///
  /// // 5. 统计
  /// final balance = service.getBalance();
  /// print('余额: $balance');
}
