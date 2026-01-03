import 'package:flutter/material.dart';

/// 自定义底部导航栏，包含中间的 + 号按钮
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavItem> items;
  final Function(int) onTap;
  final Function() onAddPressed;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    int midIndex = (items.length / 2).ceil();
    List<BottomNavItem> leftItems = items.sublist(0, midIndex);
    List<BottomNavItem> rightItems = items.length > 1
        ? items.sublist(midIndex)
        : [];

    return SizedBox(
      height: 72,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // 左侧导航项
                      children: [
                        ...leftItems.asMap().entries.map((e) {
                          final i = e.key;
                          final item = e.value;
                          return Expanded(
                            child: _buildNavItem(
                              context: context,
                              icon: item.icon,
                              label: item.label,
                              index: i,
                              isSelected: currentIndex == i,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // 右侧导航项
                      children: [
                        ...rightItems.asMap().entries.map((e) {
                          final i = midIndex + e.key;
                          final item = e.value;
                          return Expanded(
                            child: _buildNavItem(
                              context: context,
                              icon: item.icon,
                              label: item.label,
                              index: i,
                              isSelected: currentIndex == i,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 中间的 + 号按钮
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 32,
            top: 4,
            child: FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                fixedSize: WidgetStateProperty.all(const Size(64, 64)),
              ),
              onPressed: onAddPressed,
              child: const Icon(Icons.add, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 底部导航项
class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({required this.icon, required this.label});
}
