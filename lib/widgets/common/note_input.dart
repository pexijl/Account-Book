import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String labelText;
  final int maxLines;
  final int minLines;
  final IconData prefixIcon;

  const NoteInput({
    super.key,
    this.controller,
    this.validator,
    this.labelText = '备注',
    this.maxLines = 50,
    this.minLines = 1,
    this.prefixIcon = Icons.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 40),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon),
        ),
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
      ),
    );
  }
}
