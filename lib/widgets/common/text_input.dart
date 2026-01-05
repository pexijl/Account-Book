import 'package:flutter/material.dart';

/// 通用输入组件
class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String labelText;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;

  const TextInput({
    super.key,
    this.controller,
    this.validator,
    this.labelText = '',
    this.maxLines,
    this.minLines,
    this.prefixIcon,
    this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        ),
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
