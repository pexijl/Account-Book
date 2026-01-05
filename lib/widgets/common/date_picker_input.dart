import 'package:flutter/material.dart';

class DatePickerInput extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateChanged;
  final String labelText;
  final IconData icon;

  DatePickerInput({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    DateTime? firstDate,
    DateTime? lastDate,
    this.labelText = '日期',
    this.icon = Icons.calendar_today,
  }) : firstDate = firstDate ?? DateTime(2000),
       lastDate = lastDate ?? DateTime(2101);

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  late DateTime _selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void didUpdateWidget(DatePickerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部的 initialDate 更新时，同步更新内部状态
    if (oldWidget.initialDate != widget.initialDate) {
      _selectedDate = widget.initialDate;
      _controller.text = _formatDate(_selectedDate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(_selectedDate);
      });
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        readOnly: true,
        onTap: () => _selectDate(context),
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(widget.icon),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
