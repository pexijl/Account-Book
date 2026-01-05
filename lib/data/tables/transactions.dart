import 'package:account_book/data/app_database.dart';
import 'package:drift/drift.dart';


class Transactions extends Table {
  /// ID
  IntColumn get id => integer().autoIncrement()();

  /// 金额
  RealColumn get amount => real()();

  /// 日期
  DateTimeColumn get date => dateTime()();

  /// 分类
  TextColumn get category => text()();

  /// 交易类型
  IntColumn get type => intEnum<TransactionType>()();

  /// 资金流出的账户
  TextColumn get fromAccount => text().nullable()();

  /// 资金流入的账户
  TextColumn get toAccount => text().nullable()();

  /// 备注
  TextColumn get note => text().nullable()();
}
