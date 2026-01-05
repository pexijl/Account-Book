import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String prefixText;

  const AmountInput({
    super.key,
    this.controller,
    this.labelText = '金额',
    this.onSaved,
    this.validator,
    this.onChanged,
    this.prefixText = '¥ ',
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;

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
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixText: widget.prefixText,
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        validator:
            widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return '请输入金额';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return '请输入有效的金额';
              }
              return null;
            },
        onChanged: widget.onChanged,
      ),
    );
  }
}
