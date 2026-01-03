import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gettoeat_flutter/providers/products_provider.dart';

/// 商品分類列表組件
/// 顯示所有啟用的分類，支持單選篩選
class CategoryListWidget extends ConsumerWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // 「全部」按鈕
              _buildCategoryButton(
                context,
                ref,
                label: '全部',
                categoryId: null,
                isSelected: selectedCategoryId == null,
              ),
              // 分類按鈕
              ...categories.map((category) {
                return _buildCategoryButton(
                  context,
                  ref,
                  label: category.name,
                  categoryId: category.id,
                  isSelected: selectedCategoryId == category.id,
                );
              }).toList(),
            ],
          ),
        );
      },
      loading: () {
        return const SizedBox(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stack) {
        return SizedBox(
          height: 50,
          child: Center(
            child: Text('載入分類失敗: $error'),
          ),
        );
      },
    );
  }

  /// 構建分類按鈕
  Widget _buildCategoryButton(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required int? categoryId,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // 更新選取的分類
          ref.read(selectedCategoryProvider.notifier).state = categoryId;
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
