import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gettoeat_flutter/models/category.dart';
import 'package:gettoeat_flutter/models/product.dart';
import 'package:gettoeat_flutter/services/database_service.dart';

/// 資料庫服務提供者
final databaseServiceProvider = Provider((ref) {
  return DatabaseService();
});

/// 分類列表提供者
/// 非同步提供所有啟用的分類
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.watch(databaseServiceProvider);
  return await service.getCategories();
});

/// 商品列表提供者
/// 非同步提供所有啟用的商品
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(databaseServiceProvider);
  return await service.getProducts();
});

/// 選取的分類提供者
/// 管理使用者選取的分類 ID (null 表示顯示所有商品)
final selectedCategoryProvider = StateProvider<int?>((ref) {
  return null;
});

/// 篩選後的商品提供者
/// 根據 selectedCategoryProvider 的值動態篩選商品
final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final selectedCategoryId = ref.watch(selectedCategoryProvider);
  final service = ref.watch(databaseServiceProvider);

  // 如果沒有選取分類，顯示所有商品
  if (selectedCategoryId == null) {
    return await service.getProducts();
  }

  // 否則顯示特定分類的商品
  return await service.getProductsByCategory(selectedCategoryId);
});
