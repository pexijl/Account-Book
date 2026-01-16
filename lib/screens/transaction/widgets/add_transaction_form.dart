import 'package:account_book/di/locators.dart';
import 'package:account_book/models/enums.dart';
import 'package:account_book/models/form/transaction_form.dart';
import 'package:account_book/widgets/common/amount_input.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:account_book/widgets/common/category_selector.dart';
import 'package:account_book/widgets/common/date_picker_input.dart';
import 'package:account_book/widgets/common/note_input.dart';
import 'package:account_book/widgets/common/payment_method_selector.dart';
import 'package:account_book/widgets/common/save_button.dart';
import 'package:flutter/material.dart';

class AddTransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TransactionForm transactionForm;
  const AddTransactionForm({
    super.key,
    required this.formKey,
    required this.transactionForm,
  });

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    // --- 初始化控制器：将对象的值赋给控制器 ---
    _amountController = TextEditingController(
      text: widget.transactionForm.amount == 0.0
          ? ''
          : widget.transactionForm.amount.toString(),
    );
    _categoryController = TextEditingController(
      text: widget.transactionForm.category,
    );
    _noteController = TextEditingController(
      text: widget.transactionForm.note ?? '',
    );

    // --- 监听控制器变化：将输入框的值写回对象 ---
    _amountController.addListener(_updateAmount);
    // _categoryController.addListener(_updateCategory);
    // _noteController.addListener(_updateNote);
  }

  @override
  void dispose() {
    // 记得释放控制器，防止内存泄漏
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final value = double.tryParse(_amountController.text);
    if (value != null) {
      setState(() {
        widget.transactionForm.amount = value;
      });
    }
  }

  void _updateDate(DateTime newDate) {
    setState(() {
      widget.transactionForm.date = newDate;
    });
  }

  void _updateCategory() {
    final newCategory = _categoryController.text;
    setState(() {
      widget.transactionForm.category = newCategory;
    });
  }

  void _updatefromAccount(String newAccount) {
    setState(() {
      widget.transactionForm.fromAccount = newAccount;
    });
  }

  void _updateToAccount(String newAccount) {
    setState(() {
      widget.transactionForm.toAccount = newAccount;
    });
  }

  void _updateNote() {
    setState(() {
      widget.transactionForm.note = _noteController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 金额输入
            AmountInput(controller: _amountController),
            // 日期选择
            DatePickerInput(
              initialDate: widget.transactionForm.date,
              onDateChanged: (DateTime newDate) {
                setState(() {
                  widget.transactionForm.date = newDate;
                });
              },
            ),
            // 支付方式选择
            PaymentMethodSelector(
              initialSelection: widget.transactionForm.fromAccount,
              onSelected: (String? value) {
                setState(() {
                  widget.transactionForm.fromAccount = value;
                });
              },
              labelText: '支付方式',
            ),
            // 分类选择
            CategorySelector(
              controller: _categoryController,
              selectedCategory: widget.transactionForm.category,
              onCategorySelected: (String categoryName) {
                setState(() {
                  widget.transactionForm.category = categoryName;
                });
              },
            ),
            // 备注输入
            NoteInput(controller: _noteController),
            // 保存按钮
          ],
        ),
      ),
    );
  }
}
