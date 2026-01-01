import 'package:hive/hive.dart';

/// 交易模型
/// 使用 HiveType 注解标记需要持久化的类
part 'transaction.g.dart'; // 会在运行 build_runner 后生成

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  /// 使用 HiveField 注解标记需要持久化的字段
  @HiveField(0)
  late int id;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  String? note;

  @HiveField(5)
  late TransactionType type;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.type,
  });

  /// 工厂构造函数 - 创建支出记录
  factory Transaction.expense({
    required int id,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) {
    return Transaction(
      id: id,
      amount: amount,
      category: category,
      date: date,
      note: note,
      type: TransactionType.expense,
    );
  }

  /// 工厂构造函数 - 创建收入记录
  factory Transaction.income({
    required int id,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) {
    return Transaction(
      id: id,
      amount: amount,
      category: category,
      date: date,
      note: note,
      type: TransactionType.income,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'type': type.toString(),
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, category: $category, type: $type)';
  }
}

/// 交易类型枚举
@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}
