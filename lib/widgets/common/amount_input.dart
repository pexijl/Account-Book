import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  const AmountInput({super.key, this.controller, required this.onChanged});

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final String labelText = '金额';
  final String prefixText = '￥';
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  late TextEditingController _controller;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        key: _fieldKey,
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          prefixText: prefixText,
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入金额';
          }
          return null;
        },
        onChanged: (value) {
          widget.onChanged.call(value);
          _fieldKey.currentState?.validate();
        },
      ),
    );
  }
}
