import 'package:account_book/di/locators.dart';
import 'package:account_book/models/enums.dart';
import 'package:account_book/widgets/common/amount_input.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:account_book/widgets/common/category_selector.dart';
import 'package:account_book/widgets/common/date_picker_input.dart';
import 'package:account_book/widgets/common/note_input.dart';
import 'package:account_book/widgets/common/payment_method_selector.dart';
import 'package:account_book/widgets/common/save_button.dart';
import 'package:flutter/material.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPaymentMethod = '现金';
  DateTime _selectedDate = DateTime.now();
  final _transactionService = getIt<TransactionService>();

  // 支付方式列表
  final List<PaymentMethodOption<String>> _paymentMethods = [
    PaymentMethodOption(value: '现金', label: '现金'),
    PaymentMethodOption(value: '银行卡', label: '银行卡'),
    PaymentMethodOption(value: '支付宝', label: '支付宝'),
    PaymentMethodOption(value: '微信', label: '微信'),
    PaymentMethodOption(value: '其他', label: '其他'),
  ];

  // 临时分类列表 - 使用新的 CategoryItem 类型
  final List<CategoryItem> _categories = [
    CategoryItem(icon: Icons.restaurant, name: '餐饮'),
    CategoryItem(icon: Icons.directions_bus, name: '交通'),
    CategoryItem(icon: Icons.shopping_bag, name: '购物'),
    CategoryItem(icon: Icons.movie, name: '娱乐'),
    CategoryItem(icon: Icons.medical_services, name: '医疗'),
    CategoryItem(icon: Icons.school, name: '教育'),
    CategoryItem(icon: Icons.home, name: '居家'),
    CategoryItem(icon: Icons.more_horiz, name: '其他'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的金额')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('请选择分类')));
        return;
      }
    }

    try {
      await _transactionService.addTransaction(
        amount: amount,
        date: _selectedDate,
        category: _selectedCategory!,
        type: TransactionType.expense,
        fromAccount: _selectedPaymentMethod,
        note: _noteController.text,
      );
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 金额输入
            AmountInput(
              controller: _amountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入金额';
                }
                return null;
              },
            ),
            // 日期选择
            DatePickerInput(
              initialDate: _selectedDate,
              onDateChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),
            // 支付方式选择
            PaymentMethodSelector(
              initialSelection: _selectedPaymentMethod,
              paymentMethods: _paymentMethods,
              onSelected: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              labelText: '支付方式',
            ),
            // 分类选择
            CategorySelector(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (String categoryName) {
                setState(() {
                  _selectedCategory = categoryName;
                });
              },
            ),
            // 备注输入
            NoteInput(controller: _noteController),
            // 保存按钮
            SaveButton(onPressed: _saveExpense, text: '保存支出'),
          ],
        ),
      ),
    );
  }
}
