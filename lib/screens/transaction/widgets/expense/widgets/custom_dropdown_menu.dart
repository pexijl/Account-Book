import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  final String title;
  final IconData? icon;
  final List<DropdownMenuEntry<T>> items;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  const CustomDropdownMenu({
    super.key,
    required this.title,
    this.icon,
    required this.items,
    this.initialSelection,
    this.onSelected,
  });
  @override
  State<CustomDropdownMenu<T>> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      expandedInsets: const EdgeInsets.all(0),
      label: Text(widget.title),
      leadingIcon: widget.icon != null ? Icon(widget.icon) : null,
      initialSelection: widget.initialSelection,
      onSelected: (T? value) {
        widget.onSelected?.call(value);
      },
      dropdownMenuEntries: widget.items,
    );
  }
}
