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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            AmountInput(
              onChanged: (value) {
                widget.transactionForm.amount = double.tryParse(value) ?? 0.0;
              },
            ),
            // 日期选择
            DatePickerInput(
              onChanged: (DateTime newDate) {
                setState(() {
                  widget.transactionForm.date = newDate;
                });
              },
            ),
            // 支付方式选择
            // TODO: 根据TransactionType动态显示支付方式选择器
            PaymentMethodSelector(
              onChanged: (String? value) {
                setState(() {
                  widget.transactionForm.fromAccount = value;
                });
              },
            ),
            // 分类选择
            // TODO: 根据TransactionType动态显示分类选择器
            CategorySelector(
              onChanged: (String categoryName) {
                setState(() {
                  widget.transactionForm.category = categoryName;
                });
              },
            ),
            // 备注输入
            NoteInput(
              onChanged: (String value) {
                setState(() {
                  widget.transactionForm.note = value;
                });
              },
            ),
            // 保存按钮
          ],
        ),
      ),
    );
  }
}
