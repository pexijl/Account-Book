import 'dart:io';
import 'package:account_book/data/tables/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'app_database.g.dart';

enum TransactionType { income, expense, transfer }

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- 这里编写高效的查询逻辑 ---

  /// 核心统计查询：根据类型和日期过滤并求和
  Stream<double> watchTotalAmount({
    required TransactionType type,
    DateTime? date,
  }) {
    final query = select(transactions);

    query.where((t) => t.type.equals(type.index));

    if (date != null) {
      // 过滤同年同月
      query.where((t) => t.date.year.equals(date.year));
      query.where((t) => t.date.month.equals(date.month));
    }

    // watch() 会在数据库发生任何变化时重新发送数据
    return query.watch().map((rows) {
      return rows.fold(0.0, (sum, row) => sum + row.amount);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
