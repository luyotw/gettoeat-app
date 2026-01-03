import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/core/database/database.dart';
import 'package:gettoeat_flutter/providers/products_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    AppDatabase.resetInstance();
  });

  tearDown(() {
    AppDatabase.resetInstance();
  });

  group('Products Provider', () {
    test('分類和商品 Provider 正確運作', () async {
      final db = await AppDatabase().database;

      // 插入測試資料
      await db.insert(
        'stores',
        {
          'account': 'test@example.com',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      await db.insert('categories', {
        'store_id': 1,
        'name': '飲品',
        'off': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('categories', {
        'store_id': 1,
        'name': '停用分類',
        'off': 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('categories', {
        'store_id': 1,
        'name': '食品',
        'off': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('products', {
        'store_id': 1,
        'category_id': 1,
        'name': '冰紅茶',
        'price': 35.0,
        'position': 1,
        'off': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('products', {
        'store_id': 1,
        'category_id': 1,
        'name': '熱紅茶',
        'price': 40.0,
        'position': 2,
        'off': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('products', {
        'store_id': 1,
        'category_id': 2,
        'name': '米飯',
        'price': 50.0,
        'position': 1,
        'off': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('products', {
        'store_id': 1,
        'category_id': 1,
        'name': '停用商品',
        'price': 30.0,
        'position': 3,
        'off': 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      final container = ProviderContainer();

      // 測試 categoriesProvider - 只回傳啟用的分類
      final categories = await container.read(categoriesProvider.future);
      expect(categories.length, 2);
      expect(categories.every((c) => c.off == 0), true);

      // 測試 productsProvider - 只回傳啟用的商品
      final allProducts = await container.read(productsProvider.future);
      expect(allProducts.length, 3);
      expect(allProducts.every((p) => p.off == 0), true);

      // 測試 selectedCategoryProvider - 初始為 null
      expect(container.read(selectedCategoryProvider), null);

      // 測試 filteredProductsProvider - null 時顯示所有商品
      var filtered = await container.read(filteredProductsProvider.future);
      expect(filtered.length, 3);

      // 設定選取分類為 1，應該只顯示分類 1 的商品
      container.read(selectedCategoryProvider.notifier).state = 1;
      filtered = await container.read(filteredProductsProvider.future);
      expect(filtered.length, 2);
      expect(filtered.every((p) => p.categoryId == 1), true);

      // 設定選取分類為 2
      container.read(selectedCategoryProvider.notifier).state = 2;
      filtered = await container.read(filteredProductsProvider.future);
      expect(filtered.length, 1);
      expect(filtered[0].name, '米飯');

      // 重新設定為 null，應該顯示所有商品
      container.read(selectedCategoryProvider.notifier).state = null;
      filtered = await container.read(filteredProductsProvider.future);
      expect(filtered.length, 3);
    });
  });
}
