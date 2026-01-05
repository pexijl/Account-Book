import 'package:flutter/material.dart';

enum TransactionActionType { save, update, delete, cancel }

class TransactionActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TransactionActionType actionType;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;

  const TransactionActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.actionType = TransactionActionType.save,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.fontSize = 18,
  });

  // 根据操作类型设置默认颜色
  Color _getDefaultBackgroundColor(BuildContext context) {
    switch (actionType) {
      case TransactionActionType.save:
        return Theme.of(context).primaryColor;
      case TransactionActionType.update:
        return Theme.of(context).primaryColor;
      case TransactionActionType.delete:
        return Colors.red;
      case TransactionActionType.cancel:
        return Colors.grey;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  Color _getDefaultForegroundColor() {
    switch (actionType) {
      case TransactionActionType.delete:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: backgroundColor ?? _getDefaultBackgroundColor(context),
        foregroundColor: foregroundColor ?? _getDefaultForegroundColor(),
      ),
      child: Text(text, style: TextStyle(fontSize: fontSize)),
    );
  }
}
