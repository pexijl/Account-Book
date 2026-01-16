// services/transaction_service.dart

import 'package:account_book/database/app_database.dart';
import 'package:account_book/di/locators.dart';
import 'package:account_book/models/enums.dart';
import 'package:account_book/models/form/transaction_form.dart';
import 'package:account_book/repositories/transaction_repository.dart';
import 'package:drift/drift.dart';

class TransactionService {
  /// 仓库实例
  final _repo = getIt<TransactionRepository>();

  /// 添加交易记录
  Future<int> addTransaction({
    required double amount,
    required DateTime date,
    required String category,
    required TransactionType type,
    String? fromAccount,
    String? toAccount,
    String? note,
  }) async {
    // TODO: 增加业务校验 (Validation)
    return await _repo.insert(
      TransactionsCompanion.insert(
        amount: amount,
        date: date,
        category: category,
        type: type,
        fromAccount: Value(fromAccount),
        toAccount: Value(toAccount),
        note: Value(note),
      ),
    );
  }

  /// 添加交易记录 by TransactionForm
  Future<int> addTransactionByForm({required TransactionForm form}) async {
    // TODO: 增加业务校验 (Validation)
    return await _repo.insert(
      TransactionsCompanion.insert(
        amount: form.amount!,
        date: form.date,
        category: form.category,
        type: form.type,
        fromAccount: Value(form.fromAccount),
        toAccount: Value(form.toAccount),
        note: Value(form.note),
      ),
    );
  }

  /// 删除数据
  Future<void> deleteTransaction(int id) async {
    await _repo.delete(id);
  }

  /// 更新数据
  Future<bool> updateTransaction({
    required int id,
    required double amount,
    required DateTime date,
    required String category,
    required TransactionType type,
    String? fromAccount,
    String? toAccount,
    String? note,
  }) async {
    return await _repo.update(
      TransactionsCompanion(
        id: Value(id),
        amount: Value(amount),
        date: Value(date),
        category: Value(category),
        type: Value(type),
        fromAccount: Value(fromAccount),
        toAccount: Value(toAccount),
        note: Value(note),
      ),
    );
  }

  /// 查询单条数据 by Id
  Transaction? getById(int id) {
    return _repo.getById(id) as Transaction?;
  }

  /// 实时监听单条记录 by Id
  Stream<Transaction?> watchById(int id) {
    return _repo.watchById(id);
  }

  /// 获取收入流
  Stream<double> watchTotalIncome({DateTime? date}) {
    return _repo.watchTotalIncome(date: date);
  }

  /// 获取支出流
  Stream<double> watchTotalExpense({DateTime? date}) {
    return _repo.watchTotalExpense(date: date);
  }

  /// 获取结余流 (组合两个流)
  Stream<double> watchTotalBalance({DateTime? date}) {
    return _repo.watchTotalBalance(date: date);
  }

  /// 获取最近的交易记录流
  Stream<List<Transaction>> watchRecentTransactions(int count) {
    return _repo.watchRecentTransactions(count);
  }
}
