import 'package:account_book/models/transaction.dart';
import 'package:account_book/screens/transaction/widgets/expense/widgets/custom_dropdown_menu.dart';
import 'package:account_book/services/hive_transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPaymentMethod = '现金';
  DateTime _selectedDate = DateTime.now();
  final HiveTransactionService _transactionService = HiveTransactionService();

  // 收入方式列表
  final List<DropdownMenuEntry<String>> _paymentMethods = [
    DropdownMenuEntry(value: '现金', label: '现金'),
    DropdownMenuEntry(value: '银行卡', label: '银行卡'),
    DropdownMenuEntry(value: '支付宝', label: '支付宝'),
    DropdownMenuEntry(value: '微信', label: '微信'),
    DropdownMenuEntry(value: '其他', label: '其他'),
  ];

  // 收入分类列表
  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.work, 'name': '工资'},
    {'icon': Icons.trending_up, 'name': '奖金'},
    {'icon': Icons.account_balance, 'name': '理财'},
    {'icon': Icons.card_giftcard, 'name': '礼金'},
    {'icon': Icons.sell, 'name': '二手出售'},
    {'icon': Icons.receipt_long, 'name': '报销'},
    {'icon': Icons.volunteer_activism, 'name': '兼职'},
    {'icon': Icons.more_horiz, 'name': '其他'},
  ];

  Future<void> _initTransactionService() async {
    await _transactionService.init();
  }

  @override
  void initState() {
    super.initState();
    // 确保服务已初始化（虽然 main.dart 中通常已经打开了 box）
    _initTransactionService();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveIncome() async {
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

    final transaction = Transaction.income(
      amount: amount,
      category: _selectedCategory!,
      date: _selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      method: _selectedPaymentMethod!,
    );

    try {
      await _transactionService.addTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('收入已保存')));
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
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white),
              child: TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: '金额',
                  prefixText: '¥ ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入金额';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  // 日期选择
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextFormField(
                        readOnly: true, // 防止调起系统键盘
                        onTap: () => _selectDate(context),
                        // 自动显示当前选中的日期
                        controller: TextEditingController(
                          text:
                              "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                        ),
                        decoration: const InputDecoration(
                          labelText: '日期',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                          // 添加一个清除按钮（可选）
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ),
                  // 收入方式选择
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(color: Colors.white),
                      child: CustomDropdownMenu<String>(
                        title: '收入方式',
                        icon: Icons.payment,
                        initialSelection: _selectedPaymentMethod,
                        onSelected: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        items: _paymentMethods,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 分类选择
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: const Text(
                      '分类',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected =
                            _selectedCategory == category['name'];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category['name'];
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    )
                                  : Border.all(color: Colors.transparent),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category['icon'],
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category['name'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[800],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 备注输入
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 40),
              decoration: BoxDecoration(color: Colors.white),
              child: TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: '备注',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 50,
                minLines: 1,
              ),
            ),

            // 保存按钮
            ElevatedButton(
              onPressed: _saveIncome,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('保存收入', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
