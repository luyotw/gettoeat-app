import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/models/product.dart';

void main() {
  group('Product Model', () {
    test('建立 Product 實例', () {
      final product = Product(
        id: 1,
        storeId: 1,
        categoryId: 1,
        name: '冰紅茶',
        price: 35.0,
        position: 1,
        off: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(product.id, 1);
      expect(product.storeId, 1);
      expect(product.categoryId, 1);
      expect(product.name, '冰紅茶');
      expect(product.price, 35.0);
      expect(product.position, 1);
      expect(product.off, 0);
    });

    test('fromMap 反序列化', () {
      final map = {
        'id': 1,
        'store_id': 1,
        'category_id': 1,
        'name': '冰紅茶',
        'price': 35.0,
        'position': 1,
        'off': 0,
        'created_at': '2024-01-01 00:00:00',
        'updated_at': '2024-01-01 00:00:00',
      };

      final product = Product.fromMap(map);

      expect(product.id, 1);
      expect(product.categoryId, 1);
      expect(product.name, '冰紅茶');
      expect(product.price, 35.0);
      expect(product.position, 1);
    });

    test('toMap 序列化', () {
      final product = Product(
        id: 1,
        storeId: 1,
        categoryId: 1,
        name: '冰紅茶',
        price: 35.0,
        position: 1,
        off: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final map = product.toMap();

      expect(map['id'], 1);
      expect(map['store_id'], 1);
      expect(map['category_id'], 1);
      expect(map['name'], '冰紅茶');
      expect(map['price'], 35.0);
      expect(map['position'], 1);
      expect(map['off'], 0);
    });

    test('copyWith 方法', () {
      final product = Product(
        id: 1,
        storeId: 1,
        categoryId: 1,
        name: '冰紅茶',
        price: 35.0,
        position: 1,
        off: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updated = product.copyWith(price: 40.0);

      expect(updated.id, 1);
      expect(updated.name, '冰紅茶');
      expect(updated.price, 40.0);
    });
  });
}
