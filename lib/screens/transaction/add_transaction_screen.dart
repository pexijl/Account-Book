import 'package:account_book/database/app_database.dart';
import 'package:account_book/di/locators.dart';
import 'package:account_book/models/enums.dart';
import 'package:account_book/models/form/transaction_form.dart';
import 'package:account_book/screens/transaction/widgets/add_transaction_form.dart';
import 'package:account_book/screens/transaction/widgets/transaction_type_selector.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:account_book/widgets/common/category_selector.dart';
import 'package:account_book/widgets/common/payment_method_selector.dart';
import 'package:account_book/widgets/common/save_button.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late TransactionForm transactionForm;

  final _transactionService = getIt<TransactionService>();

  final _segments = [
    ButtonSegment<TransactionType>(
      value: TransactionType.expense,
      label: const Text('支出'),
      icon: const Icon(Icons.arrow_downward),
    ),
    ButtonSegment<TransactionType>(
      value: TransactionType.income,
      label: const Text('收入'),
      icon: const Icon(Icons.arrow_upward),
    ),
    ButtonSegment<TransactionType>(
      value: TransactionType.transfer,
      label: const Text('转账'),
      icon: const Icon(Icons.compare_arrows),
    ),
  ];

  @override
  void initState() {
    super.initState();
    transactionForm = TransactionForm();
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加账单'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: '设置',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TransactionTypeSelector(
            selected: transactionForm.type,
            segments: _segments,
            onSelectionChanged: (selected) {
              setState(() {
                transactionForm.type = selected;
              });
            },
          ),
          AddTransactionForm(
            formKey: _formKey,
            transactionForm: transactionForm,
          ),
          SaveButton(onPressed: _saveExpense, text: '保存'),
        ],
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _transactionService.addTransactionByForm(form: transactionForm);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('支出已保存')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
        }
      }
    }
  }
}
