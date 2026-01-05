import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatefulWidget {
  final String? initialSelection;
  final List<PaymentMethodOption<String>> paymentMethods;
  final ValueChanged<String?>? onSelected;
  final String labelText;
  final IconData icon;

  const PaymentMethodSelector({
    super.key,
    this.initialSelection,
    required this.paymentMethods,
    this.onSelected,
    this.labelText = '支付方式',
    this.icon = Icons.payment,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedPaymentMethod;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.initialSelection;
    _controller = TextEditingController(text: _selectedPaymentMethod ?? '');
  }

  @override
  void didUpdateWidget(PaymentMethodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 widget 的 initialSelection 更新时，同步更新控制器
    if (oldWidget.initialSelection != widget.initialSelection) {
      _selectedPaymentMethod = widget.initialSelection;
      _controller.text = _selectedPaymentMethod ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showPaymentMethodDialog() async {
    final selectedMethod = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(widget.icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text('选择${widget.labelText}'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: RadioGroup<String>(
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                Navigator.of(context).pop(value);
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = widget.paymentMethods[index];
                  final isSelected = _selectedPaymentMethod == method.value;

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
    if (selectedMethod != null && selectedMethod != _selectedPaymentMethod) {
      // 使用 WidgetsBinding.instance.addPostFrameCallback 确保在当前构建完成后执行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // 检查 widget 是否仍然挂载
          setState(() {
            _selectedPaymentMethod = selectedMethod;
            _controller.text = selectedMethod;
          });
          widget.onSelected?.call(selectedMethod);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        readOnly: true,
        onTap: _showPaymentMethodDialog,
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(widget.icon),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          hintText: '请选择${widget.labelText}',
        ),
      ),
    );
  }
}

class PaymentMethodOption<T> {
  final T value;
  final String label;

  const PaymentMethodOption({required this.value, required this.label});
}
