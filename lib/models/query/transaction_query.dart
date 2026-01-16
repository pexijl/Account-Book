// lib/models/queries/transaction_query.dart

import 'package:account_book/models/enums.dart';

class TransactionQuery {
  /// 金额
  final double? amount;

  /// 开始日期
  final DateTime? startDate;

  /// 结束日期
  final DateTime? endDate;

  /// 分类
  final String? category;

  /// 交易类型
  final TransactionType? type;

  /// 流出账户
  final String? fromAccount;

  /// 流入账户
  final String? toAccount;

  /// 页码
  final int page;

  /// 每页大小
  final int pageSize;

  TransactionQuery({
    this.amount,
    this.startDate,
    this.endDate,
    this.category,
    this.type,
    this.fromAccount,
    this.toAccount,
    this.page = 1,
    this.pageSize = 10,
  });

  // 像 Java 的工具类一样计算偏移量
  int get offset => (page - 1) * pageSize;

  // 方便进行“下一页”的拷贝，类似于 Lombok 的 @With
  TransactionQuery copyWithNextPage() {
    return TransactionQuery(
      startDate: startDate,
      endDate: endDate,
      category: category,
      type: type,
      fromAccount: fromAccount,
      toAccount: toAccount,
      page: page + 1,
      pageSize: pageSize,
    );
  }
}
