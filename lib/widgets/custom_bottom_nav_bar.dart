import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Function() onAddPressed;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          // 背景容器
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            icon: Icons.home,
                            label: '首页',
                            index: 0,
                            isSelected: currentIndex == 0,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            icon: Icons.bar_chart,
                            label: '统计',
                            index: 1,
                            isSelected: currentIndex == 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 中间占位符
                  // const SizedBox(width: 60),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            icon: Icons.account_balance,
                            label: '资产',
                            index: 2,
                            isSelected: currentIndex == 2,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            icon: Icons.settings,
                            label: '设置',
                            index: 3,
                            isSelected: currentIndex == 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 中间的 + 号按钮
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 28,
            top: 0,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
