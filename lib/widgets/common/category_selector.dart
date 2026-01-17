import 'package:flutter/material.dart';

class CategoryItemModel {
  final IconData icon;
  final String name;

  CategoryItemModel({required this.icon, required this.name});
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
  final List<CategoryItemModel> categories = [
    CategoryItemModel(icon: Icons.restaurant, name: '餐饮'),
    CategoryItemModel(icon: Icons.directions_bus, name: '交通'),
    CategoryItemModel(icon: Icons.shopping_bag, name: '购物'),
    CategoryItemModel(icon: Icons.movie, name: '娱乐'),
    CategoryItemModel(icon: Icons.medical_services, name: '医疗'),
    CategoryItemModel(icon: Icons.school, name: '教育'),
    CategoryItemModel(icon: Icons.home, name: '居家'),
    CategoryItemModel(icon: Icons.more_horiz, name: '其他'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_buildTitle(), _buildCategoryGrid()],
    );
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      // TODO: 添加新增分类功能
    );
  }

  Widget _buildCategoryGrid() {
    return FormField<String>(
      validator: (value) {
        print('CategorySelector validator value: $value');
        if (value == null || value.isEmpty) {
          return '请选择分类';
        }
        return null;
      },
      builder: (field) {
        return Column(
          children: [
            GridView.builder(
              padding: EdgeInsets.only(bottom: 16),
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
                return CategoryItem(
                  field: field,
                  category: category,
                  isSelected: isSelected,
                  onCategorySelected: onCategorySelected,
                );
              },
            ),
            if (field.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(color: Colors.red[800], fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final FormFieldState<String> field;
  final CategoryItemModel category;
  final bool isSelected;
  final Function(String) onCategorySelected;
  const CategoryItem({
    super.key,
    required this.field,
    required this.category,
    required this.isSelected,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        field.didChange(category.name),
        onCategorySelected(category.name),
        field.validate(),
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : Border.all(color: Colors.grey[300]!),
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
  }
}
