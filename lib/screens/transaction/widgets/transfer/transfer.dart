import 'package:account_book/di/locators.dart';
import 'package:account_book/models/transaction.dart';
import 'package:account_book/screens/transaction/widgets/expense/widgets/custom_dropdown_menu.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedFromAccount;
  String? _selectedToAccount;
  DateTime _selectedDate = DateTime.now();
  final _transactionService = getIt<TransactionService>();

  // 账户列表
  final List<DropdownMenuEntry<String>> _accounts = [
    DropdownMenuEntry(value: '现金', label: '现金'),
    DropdownMenuEntry(value: '银行卡', label: '银行卡'),
    DropdownMenuEntry(value: '支付宝', label: '支付宝'),
    DropdownMenuEntry(value: '微信', label: '微信'),
    DropdownMenuEntry(value: '信用卡', label: '信用卡'),
    DropdownMenuEntry(value: '其他', label: '其他'),
  ];

  // 转账分类
  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.sync_alt, 'name': '账户互转'},
    {'icon': Icons.credit_card, 'name': '还款'},
    {'icon': Icons.account_balance_wallet, 'name': '提现'},
    {'icon': Icons.payment, 'name': '充值'},
    {'icon': Icons.more_horiz, 'name': '其他'},
  ];

  String? _selectedCategory;

  Future<void> _initTransactionService() async {
    await _transactionService.init();
  }

  @override
  void initState() {
    super.initState();
    _initTransactionService();
    // 设置默认值
    _selectedFromAccount = '银行卡';
    _selectedToAccount = '现金';
    _selectedCategory = '账户互转';
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

  Future<void> _saveTransfer() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的金额')));
      return;
    }

    if (_selectedFromAccount == null || _selectedToAccount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择转出和转入账户')));
      return;
    }

    if (_selectedFromAccount == _selectedToAccount) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('转出和转入账户不能相同')));
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

    // 创建转账记录
    final transaction = Transaction.transfer(
      amount: amount,
      category: _selectedCategory!,
      date: _selectedDate,
      note: _noteController.text.isEmpty
          ? '从 $_selectedFromAccount 转到 $_selectedToAccount'
          : _noteController.text,
      fromAccount: _selectedFromAccount,
      toAccount: _selectedToAccount,
    );

    try {
      await _transactionService.addTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('转账已保存')));
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

  void _swapAccounts() {
    setState(() {
      final temp = _selectedFromAccount;
      _selectedFromAccount = _selectedToAccount;
      _selectedToAccount = temp;
    });
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

            // 账户选择区域
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 转出账户
                  CustomDropdownMenu<String>(
                    title: '从',
                    icon: Icons.account_balance_wallet_outlined,
                    initialSelection: _selectedFromAccount,
                    onSelected: (String? value) {
                      setState(() {
                        _selectedFromAccount = value;
                      });
                    },
                    items: _accounts,
                  ),
                  const SizedBox(height: 12),

                  // 交换按钮
                  InkWell(
                    onTap: _swapAccounts,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 转入账户
                  CustomDropdownMenu<String>(
                    title: '到',
                    icon: Icons.account_balance_wallet,
                    initialSelection: _selectedToAccount,
                    onSelected: (String? value) {
                      setState(() {
                        _selectedToAccount = value;
                      });
                    },
                    items: _accounts,
                  ),
                ],
              ),
            ),

            // 日期选择
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white),
              child: TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text:
                      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                ),
                decoration: const InputDecoration(
                  labelText: '日期',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
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
                  labelText: '备注（可选）',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  hintText: '留空则自动生成转账说明',
                ),
                maxLines: 50,
                minLines: 1,
              ),
            ),

            // 保存按钮
            ElevatedButton(
              onPressed: _saveTransfer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('保存转账', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
