import 'package:account_book/models/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionService {
  /// 交易服务单例
  static final TransactionService _instance = TransactionService._internal();

  /// 工厂函数获取单例
  factory TransactionService() => _instance;

  /// 私有构造函数
  TransactionService._internal();

  /// 交易 Box
  late Box<Transaction> _box;

  /// Hive Box 名称
  static const String _boxName = 'transactions_box';

  /// 初始化服务，打开 Hive Box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Transaction>(_boxName);
    } else {
      _box = Hive.box<Transaction>(_boxName);
    }
  }

  /// 获取交易 Box
  Box<Transaction> get box => _box;

  /// 添加交易记录
  /// 如果 id 已存在，会覆盖原有记录
  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  /// 获取单个交易记录
  Transaction? getTransaction(String id) {
    return _box.get(id);
  }

  /// 获取所有交易记录
  List<Transaction> getAllTransactions() {
    return _box.values.toList();
  }

  /// 更新交易记录
  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  /// 删除交易记录
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  /// 清空所有交易记录
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// 按类型获取交易
  List<Transaction> getTransactionsByType(TransactionType type) {
    return _box.values.where((t) => t.type == type).toList();
  }

  /// 按分类获取交易
  List<Transaction> getTransactionsByCategory(String category) {
    return _box.values.where((t) => t.category == category).toList();
  }

  /// 按日期范围获取交易
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  /// [排序获取] 获取按时间倒序排列的所有记录（最新的在最前面）
  List<Transaction> getAllTransactionsSorted() {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// [按月筛选] 获取特定月份的记录 (例如: 2024-05)
  List<Transaction> getTransactionsByMonth(DateTime month) {
    return _box.values.where((t) {
      return t.date.year == month.year && t.date.month == month.month;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 获取总收入 (可选按月/年过滤)
  double getTotalIncome({DateTime? date}) {
    return _box.values
        .where((t) => t.type == TransactionType.income)
        .where((t) => _isSamePeriod(t.date, date)) // 这里的过滤逻辑是关键
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// 获取总支出 (可选按月/年过滤)
  double getTotalExpense({DateTime? date}) {
    return _box.values
        .where((t) => t.type == TransactionType.expense)
        .where((t) => _isSamePeriod(t.date, date))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// 获取结余
  double getSurplus({DateTime? date}) {
    return getTotalIncome(date: date) - getTotalExpense(date: date);
  }

  /// 私有辅助工具：判断日期是否属于同一周期
  /// 如果 target 为 null，则返回 true (不过滤)
  /// 如果你想支持“月度统计”，这里对比 year 和 month
  bool _isSamePeriod(DateTime transactionDate, DateTime? target) {
    if (target == null) return true;
    return transactionDate.year == target.year &&
        transactionDate.month == target.month;
  }

  /// [分类排行] 获取指定类型的分类汇总统计 (常用于饼图)
  /// 返回 Map，例如: {"餐饮": 150.0, "交通": 50.0}
  Map<String, double> getCategoryStats(TransactionType type) {
    Map<String, double> stats = {};
    for (var t in _box.values.where((t) => t.type == type)) {
      stats[t.category] = (stats[t.category] ?? 0) + t.amount;
    }
    return stats;
  }

  /// [响应式监听] 提供一个 ValueListenable，让 UI 随数据库自动刷新
  /// 使用方式: ValueListenableBuilder(valueListenable: txService.listenable(), ...)
  ValueListenable<Box<Transaction>> listenable() {
    return _box.listenable();
  }

  /// [调试工具] 逐条打印 JSON，防止控制台截断
  void debugExportAsJson() {
    final transactions = _box.values.toList();

    print("--- 数据库 JSON 导出开始 (共 ${transactions.length} 条) ---");
    print("["); // 打印数组开始符号

    for (int i = 0; i < transactions.length; i++) {
      final t = transactions[i];

      // 构建单条数据的 Map
      final map = {
        'id': t.id,
        'amount': t.amount,
        'date': t.date.toIso8601String(),
        'category': t.category,
        'type': t.type.toString().split('.').last, // 只取枚举值，去掉前缀
        'fromAccount': t.fromAccount,
        'toAccount': t.toAccount,
        'note': t.note,
      };

      // 转换为格式化的字符串
      // 如果你不需要美化，直接用 map.toString()
      String line = "  ${map.toString()}";

      // 如果不是最后一条，加上逗号
      if (i < transactions.length - 1) {
        line += ",";
      }

      print(line); // 每一笔交易占用一行，避免触发长度限制
    }

    print("]"); // 打印数组结束符号
    print("--- 数据库 JSON 导出结束 ---");
  }
}
