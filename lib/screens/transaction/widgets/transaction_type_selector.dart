import 'package:flutter/material.dart';

class TransactionTypeSelector<T> extends StatefulWidget {
  final T selected;
  final List<ButtonSegment<T>> segments;
  final void Function(T) onSelectionChanged;
  const TransactionTypeSelector({
    super.key,
    required this.selected,
    required this.segments,
    required this.onSelectionChanged,
  });

  @override
  State<TransactionTypeSelector<T>> createState() =>
      _TransactionTypeSelectorState<T>();
}

class _TransactionTypeSelectorState<T>
    extends State<TransactionTypeSelector<T>> {
  T get selected => widget.selected;
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      expandedInsets: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      style:  ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      segments: widget.segments,
      selected: {selected},
      onSelectionChanged: (newSelection) {
        widget.onSelectionChanged(newSelection.first);
      },
    );
  }
}
