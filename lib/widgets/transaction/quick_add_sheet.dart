import 'package:account_book/models/transaction.dart';
import 'package:account_book/services/hive_transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final HiveTransactionService _transactionService = HiveTransactionService();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = '餐饮'; // 默认分类
  DateTime _selectedDate = DateTime.now();

  // 预定义分类
  final List<String> _expenseCategories = [
    '餐饮',
    '交通',
    '购物',
    '娱乐',
    '居住',
    '医疗',
    '教育',
    '其他',
  ];
  final List<String> _incomeCategories = ['工资', '奖金', '投资', '兼职', '礼金', '其他'];

  @override
  void initState() {
    super.initState();
    // 确保服务已初始化（通常在main中已初始化，这里作为安全检查或直接使用已打开的box）
    _transactionService.init();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入金额')));
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的金额')));
      return;
    }

    // 生成唯一ID (使用时间戳)
    // final id = DateTime.now().millisecondsSinceEpoch;

    final transaction = Transaction(
      amount: amount,
      date: _selectedDate,
      method: '现金', // TODO: 添加支付方式
      category: _selectedCategory,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      type: _selectedType,
    );

    await _transactionService.addTransaction(transaction);

    if (mounted) {
      Navigator.pop(context, true); // 返回true表示保存成功
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _selectedType == TransactionType.expense
        ? _expenseCategories
        : _incomeCategories;

    // 确保当前选中的分类在列表中，否则重置为第一个
    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶部标题和关闭按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('快速记账', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 收支类型切换
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(
                value: TransactionType.expense,
                label: Text('支出'),
                icon: Icon(Icons.money_off),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text('收入'),
                icon: Icon(Icons.attach_money),
              ),
            ],
            selected: {_selectedType},
            onSelectionChanged: (Set<TransactionType> newSelection) {
              setState(() {
                _selectedType = newSelection.first;
                // 切换类型时重置分类
                _selectedCategory = _selectedType == TransactionType.expense
                    ? _expenseCategories.first
                    : _incomeCategories.first;
              });
            },
          ),

          const SizedBox(height: 16),

          // 金额输入
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: '金额',
              prefixText: '¥ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            autofocus: true, // 打开时自动聚焦
          ),

          const SizedBox(height: 16),

          // 分类选择 (使用Chips)
          Text('分类', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 备注输入
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: '备注 (可选)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.note),
            ),
          ),

          const SizedBox(height: 24),

          // 保存按钮
          FilledButton(
            onPressed: _saveTransaction,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('保存', style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 16), // 底部留白
        ],
      ),
    );
  }
}
