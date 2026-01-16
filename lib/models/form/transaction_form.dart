import 'package:account_book/models/enums.dart';

class TransactionForm {
  double amount;
  DateTime date;
  String category;
  TransactionType type;
  String? fromAccount;
  String? toAccount;
  String? note;

  TransactionForm({
    this.amount = 0.0,
    DateTime? date,
    this.category = '',
    this.type = TransactionType.expense,
    this.fromAccount,
    this.toAccount,
    this.note,
  }) : date = date ?? DateTime.now();

  @override
  String toString() {
    return 'TransactionForm(amount: $amount, date: $date, category: $category, type: $type, fromAccount: $fromAccount, toAccount: $toAccount, note: $note)';
  }
}
