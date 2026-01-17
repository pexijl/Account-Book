import 'package:flutter/material.dart';

class NoteInput extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  const NoteInput({super.key, this.controller, required this.onChanged});

  @override
  State<NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  late TextEditingController _controller;

  final String labelText = '备注';
  final IconData prefixIcon = Icons.note;

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
      margin: const EdgeInsets.only(top: 16, bottom: 40),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon),
        ),
        maxLines: 50,
        minLines: 1,
        onChanged: widget.onChanged,
      ),
    );
  }
}
