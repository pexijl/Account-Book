import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// 交易模型
/// 使用 HiveType 注解标记需要持久化的类
part 'transaction.g.dart'; // 会在运行 build_runner 后生成

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  /// ID
  @HiveField(0)
  late String id;

  /// 金额
  @HiveField(1)
  late double amount;

  /// 日期
  @HiveField(2)
  late DateTime date;

  /// 分类
  @HiveField(3)
  late String category;

  /// 交易类型
  @HiveField(4)
  late TransactionType type;

  /// 资金流出的账户
  @HiveField(5)
  String? fromAccount;

  /// 资金流入的账户
  @HiveField(6)
  String? toAccount;

  /// 备注
  @HiveField(7)
  String? note;

  /// - 支出：fromAccount 有值 (如: 支付宝), toAccount 为空
  /// - 收入：fromAccount 为空, toAccount 有值 (如: 银行卡)
  /// - 转账：fromAccount 有值, toAccount 有值 (内部流转)

  /// 是否为支出
  bool get isExpense => type == TransactionType.expense;

  /// 是否为收入
  bool get isIncome => type == TransactionType.income;

  /// 是否为转账
  bool get isTransfer => type == TransactionType.transfer;

  /// 构造函数
  Transaction({
    String? id,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.fromAccount,
    this.toAccount,
    this.note,
  }) : id = id ?? const Uuid().v4();

  /// 工厂构造函数 - 创建支出记录
  factory Transaction.expense({
    required double amount,
    required DateTime date,
    required String category,
    String? fromAccount,
    String? note,
  }) {
    return Transaction(
      amount: amount,
      date: date,
      category: category,
      type: TransactionType.expense,
      fromAccount: fromAccount,
      note: note,
    );
  }

  /// 工厂构造函数 - 创建收入记录
  factory Transaction.income({
    required double amount,
    required DateTime date,
    required String category,
    String? toAccount,
    String? note,
  }) {
    return Transaction(
      amount: amount,
      date: date,
      category: category,
      type: TransactionType.income,
      toAccount: toAccount,
      note: note,
    );
  }

  /// 工厂构造函数 - 创建转账记录
  factory Transaction.transfer({
    required double amount,
    required DateTime date,
    required String category,
    String? fromAccount,
    String? toAccount,
    String? note,
  }) {
    return Transaction(
      amount: amount,
      date: date,
      category: category,
      type: TransactionType.transfer,
      fromAccount: fromAccount,
      toAccount: toAccount,
      note: note,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type.toString(),
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'note': note,
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, fromAccount: $fromAccount, toAccount: $toAccount, date: $date, category: $category, type: $type)';
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

/// 交易类型扩展 - 处理颜色和图标等
extension TransactionTypeExtension on TransactionType {
  // 处理颜色
  Color get color => switch (this) {
    TransactionType.expense => Colors.red,
    TransactionType.income => Colors.green,
    TransactionType.transfer => Colors.blue,
  };

  // 处理浅色背景
  Color get backgroundColor => color.withValues(alpha: 0.1);

  // 处理默认图标
  IconData get icon => switch (this) {
    TransactionType.expense => Icons.remove,
    TransactionType.income => Icons.add,
    TransactionType.transfer => Icons.compare_arrows,
  };
}
