import 'package:flutter/material.dart';

class CategoryItem {
  final IconData icon;
  final String name;

  CategoryItem({required this.icon, required this.name});
}

// TODO: 添加自定义校验
class CategorySelector extends StatelessWidget {
  final TextEditingController controller;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final String title;

  CategorySelector({
    super.key,
    required this.controller,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.title = '分类',
  });

  // TODO: 从sqllite 中获取分类列表
  final List<CategoryItem> categories = [
    CategoryItem(icon: Icons.restaurant, name: '餐饮'),
    CategoryItem(icon: Icons.directions_bus, name: '交通'),
    CategoryItem(icon: Icons.shopping_bag, name: '购物'),
    CategoryItem(icon: Icons.movie, name: '娱乐'),
    CategoryItem(icon: Icons.medical_services, name: '医疗'),
    CategoryItem(icon: Icons.school, name: '教育'),
    CategoryItem(icon: Icons.home, name: '居家'),
    CategoryItem(icon: Icons.more_horiz, name: '其他'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // TODO: 添加新增分类功能
          ),
          Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category.name;
                return InkWell(
                  onTap: () => onCategorySelected(category.name),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            )
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[800],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
