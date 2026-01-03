import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// 交易模型
/// 使用 HiveType 注解标记需要持久化的类
part 'transaction.g.dart'; // 会在运行 build_runner 后生成

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  /// 使用 HiveField 注解标记需要持久化的字段
  @HiveField(0)
  late String id;

  /// 金额
  @HiveField(1)
  late double amount;

  /// 日期
  @HiveField(2)
  late DateTime date;

  /// 交易方式
  @HiveField(3)
  late String method;

  /// 分类
  @HiveField(4)
  late String category;

  /// 备注
  @HiveField(5)
  String? note;

  /// 交易类型
  @HiveField(6)
  late TransactionType type;

  Transaction({
    String? id,
    required this.amount,
    required this.date,
    required this.method,
    required this.category,
    this.note,
    required this.type,
  }): id = id ?? const Uuid().v4();

  /// 工厂构造函数 - 创建支出记录
  factory Transaction.expense({
    required double amount,
    required DateTime date,
    required String method,
    required String category,
    String? note,
  }) {
    return Transaction(
      amount: amount,
      date: date,
      method: method,
      category: category,
      note: note,
      type: TransactionType.expense,
    );
  }

  /// 工厂构造函数 - 创建收入记录
  factory Transaction.income({
    required double amount,
    required DateTime date,
    required String method,
    required String category,
    String? note,
  }) {
    return Transaction(
      amount: amount,
      date: date,
      method: method,
      category: category,
      note: note,
      type: TransactionType.income,
    );
  }

  /// 工厂构造函数 - 创建转账记录
  factory Transaction.transfer({
    required double amount,
    required DateTime date,
    required String method,
    required String category,
    String? note,
  }) {
    return Transaction(
      amount: amount,
      date: date,
      method: method,
      category: category,
      note: note,
      type: TransactionType.transfer,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'method': method,
      'category': category,
      'note': note,
      'type': type.toString(),
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, method: $method, date: $date, category: $category, type: $type)';
  }
}

/// 交易类型枚举
@HiveType(typeId: 1)
enum TransactionType {
  /// 收入
  @HiveField(0)
  income,

  /// 支出
  @HiveField(1)
  expense,

  /// 转账
  @HiveField(2)
  transfer,
}
