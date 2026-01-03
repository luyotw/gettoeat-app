import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gettoeat_flutter/providers/products_provider.dart';
import 'package:gettoeat_flutter/screens/products/product_card_widget.dart';

/// 商品列表組件
/// 根據篩選的分類動態顯示商品
class ProductListWidget extends ConsumerWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(filteredProductsProvider);

    return filteredProductsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                '沒有符合條件的商品',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCardWidget(product: products[index]);
          },
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stack) {
        return Center(
          child: Text('載入商品失敗: $error'),
        );
      },
    );
  }
}
