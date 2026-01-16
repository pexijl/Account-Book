import 'package:account_book/models/enums.dart';
import 'package:account_book/screens/transaction/widgets/add_transaction_form.dart';
import 'package:account_book/screens/transaction/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense;

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
            selected: _selectedType,
            segments: _segments,
            onSelectionChanged: (selected) {
              setState(() {
                _selectedType = selected;
              });
            },
          ),
          AddTransactionForm(),
        ],
      ),
    );
  }
}
