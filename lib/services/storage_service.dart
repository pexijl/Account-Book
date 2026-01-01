import 'package:hive/hive.dart';

/// Hive 存储服务示例
/// 展示如何使用 Hive 进行本地数据存储
class StorageService {
  // Box 名称常量
  static const String _settingsBox = 'settings';
  static const String _transactionsBox = 'transactions';
  static const String _categoriesBox = 'categories';

  /// 获取 settings box
  Future<Box> _getSettingsBox() async {
    if (Hive.isBoxOpen(_settingsBox)) {
      return Hive.box(_settingsBox);
    }
    return await Hive.openBox(_settingsBox);
  }

  /// 获取 transactions box
  Future<Box> _getTransactionsBox() async {
    if (Hive.isBoxOpen(_transactionsBox)) {
      return Hive.box(_transactionsBox);
    }
    return await Hive.openBox(_transactionsBox);
  }

  /// 获取 categories box
  Future<Box> _getCategoriesBox() async {
    if (Hive.isBoxOpen(_categoriesBox)) {
      return Hive.box(_categoriesBox);
    }
    return await Hive.openBox(_categoriesBox);
  }

  // ==================== 基本操作示例 ====================

  /// 保存数据到 settings
  Future<void> saveSetting(String key, dynamic value) async {
    final box = await _getSettingsBox();
    await box.put(key, value);
  }

  /// 从 settings 读取数据
  T? getSetting<T>(String key) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: null);
  }

  /// 删除 settings 中的数据
  Future<void> deleteSetting(String key) async {
    final box = await _getSettingsBox();
    await box.delete(key);
  }

  /// 检查 key 是否存在
  bool hasSetting(String key) {
    final box = Hive.box(_settingsBox);
    return box.containsKey(key);
  }

  /// 清空整个 box
  Future<void> clearSettings() async {
    final box = await _getSettingsBox();
    await box.clear();
  }

  // ==================== 复杂操作示例 ====================

  /// 保存交易记录（使用 Map）
  Future<void> saveTransaction(Map<String, dynamic> transaction) async {
    final box = await _getTransactionsBox();
    final id = transaction['id'] ?? DateTime.now().millisecondsSinceEpoch;
    await box.put(id, transaction);
  }

  /// 获取所有交易记录
  List<Map<dynamic, dynamic>> getAllTransactions() {
    final box = Hive.box(_transactionsBox);
    return box.values.map((e) => Map<dynamic, dynamic>.from(e)).toList();
  }

  /// 根据条件筛选交易
  List<Map<dynamic, dynamic>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    final box = Hive.box(_transactionsBox);
    return box.values
        .where((transaction) {
          final date = transaction['date'] as DateTime;
          return date.isAfter(start) && date.isBefore(end);
        })
        .map((e) => Map<dynamic, dynamic>.from(e))
        .toList();
  }

  /// 删除交易记录
  Future<void> deleteTransaction(int id) async {
    final box = await _getTransactionsBox();
    await box.delete(id);
  }

  // ==================== 使用示例 ====================
  ///
  /// // 1. 保存简单数据
  /// await storageService.saveSetting('theme', 'dark');
  /// await storageService.saveSetting('budget', 1000.0);
  /// await storageService.saveSetting('notifications', true);
  ///
  /// // 2. 读取数据
  /// final theme = storageService.getSetting<String>('theme');
  /// final budget = storageService.getSetting<double>('budget');
  ///
  /// // 3. 保存复杂对象（Map）
  /// await storageService.saveTransaction({
  ///   'id': 1,
  ///   'amount': 100.0,
  ///   'category': 'food',
  ///   'date': DateTime.now(),
  ///   'note': '午餐',
  /// });
  ///
  /// // 4. 读取所有数据
  /// final transactions = storageService.getAllTransactions();
  ///
  /// // 5. 删除数据
  /// await storageService.deleteTransaction(1);
}
