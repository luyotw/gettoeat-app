import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/core/database/database.dart';
import 'package:gettoeat_flutter/services/database_service.dart';
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

  group('DatabaseService', () {
    test('資料庫操作方法正確回傳資料', () async {
      final db = await AppDatabase().database;

      // 插入測試用門店資料
      await db.insert(
        'stores',
        {
          'account': 'test@example.com',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      // 插入分類資料
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

      // 插入商品資料
      await db.insert('products', {
        'store_id': 1,
        'category_id': 1,
        'name': '熱紅茶',
        'price': 40.0,
        'position': 1,
        'off': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await db.insert('products', {
        'store_id': 1,
        'category_id': 1,
        'name': '冰紅茶',
        'price': 35.0,
        'position': 2,
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

      final service = DatabaseService();

      // 測試 getCategories - 只回傳啟用的分類
      final categories = await service.getCategories();
      expect(categories.length, 1);
      expect(categories[0].name, '飲品');
      expect(categories[0].off, 0);

      // 測試 getProducts - 只回傳啟用的商品，並按 position 排序
      final allProducts = await service.getProducts();
      expect(allProducts.length, 2);
      expect(allProducts[0].name, '熱紅茶'); // position 1
      expect(allProducts[0].position, 1);
      expect(allProducts[1].name, '冰紅茶'); // position 2
      expect(allProducts[1].position, 2);

      // 測試 getProductsByCategory - 特定分類的啟用商品
      final categoryProducts = await service.getProductsByCategory(1);
      expect(categoryProducts.length, 2);
      expect(categoryProducts.every((p) => p.categoryId == 1), true);
    });
  });
}
