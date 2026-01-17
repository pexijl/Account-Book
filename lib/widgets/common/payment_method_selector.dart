import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String?> onChanged;

  const PaymentMethodSelector({
    super.key,
    this.controller,
    required this.onChanged,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late TextEditingController _controller;
  final _fieldKey = GlobalKey<FormFieldState>();

  // TODO: 从sqllite 中获取支付方式列表
  final List<PaymentMethodOption<String>> paymentMethods = [
    PaymentMethodOption(value: '现金', label: '现金'),
    PaymentMethodOption(value: '银行卡', label: '银行卡'),
    PaymentMethodOption(value: '支付宝', label: '支付宝'),
    PaymentMethodOption(value: '微信', label: '微信'),
    PaymentMethodOption(value: '其他', label: '其他'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _showPaymentMethodDialog() async {
    final selectedMethod = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.payment, color: Colors.blue),
              const SizedBox(width: 8),
              Text('选择支付方式'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: RadioGroup<String>(
              groupValue: _controller.text,
              onChanged: (String? value) {
                Navigator.of(context).pop(value);
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  final isSelected = _controller.text == method.value;

                  return RadioListTile<String>(
                    title: Text(method.label),
                    value: method.value,
                    selected: isSelected,
                    activeColor: Theme.of(context).primaryColor,
                    selectedTileColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框，不选择任何值
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );

    // 确保只在 selectedMethod 确实改变了时才更新状态
    if (selectedMethod != null && selectedMethod != _controller.text) {
      // 使用 WidgetsBinding.instance.addPostFrameCallback 确保在当前构建完成后执行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // 检查 widget 是否仍然挂载
          setState(() {
            _controller.text = selectedMethod;
          });
          widget.onChanged.call(selectedMethod);
          _fieldKey.currentState?.validate();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        key: _fieldKey,
        readOnly: true,
        onTap: _showPaymentMethodDialog,
        controller: _controller,
        decoration: InputDecoration(
          labelText: '支付方式',
          border: const OutlineInputBorder(),
          prefixIcon: Icon(Icons.payment),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          hintText: '请选择支付方式',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请选择支付方式';
          }
          return null;
        },
      ),
    );
  }
}

class PaymentMethodOption<T> {
  final T value;
  final String label;

  const PaymentMethodOption({required this.value, required this.label});
}
