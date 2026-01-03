import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/models/category.dart';

void main() {
  group('Category Model', () {
    test('建立 Category 實例', () {
      final category = Category(
        id: 1,
        storeId: 1,
        name: '飲品',
        off: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(category.id, 1);
      expect(category.storeId, 1);
      expect(category.name, '飲品');
      expect(category.off, 0);
    });

    test('fromMap 反序列化', () {
      final map = {
        'id': 1,
        'store_id': 1,
        'name': '飲品',
        'off': 0,
        'created_at': '2024-01-01 00:00:00',
        'updated_at': '2024-01-01 00:00:00',
      };

      final category = Category.fromMap(map);

      expect(category.id, 1);
      expect(category.storeId, 1);
      expect(category.name, '飲品');
      expect(category.off, 0);
    });

    test('toMap 序列化', () {
      final category = Category(
        id: 1,
        storeId: 1,
        name: '飲品',
        off: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final map = category.toMap();

      expect(map['id'], 1);
      expect(map['store_id'], 1);
      expect(map['name'], '飲品');
      expect(map['off'], 0);
    });

    test('copyWith 方法', () {
      final category = Category(
        id: 1,
        storeId: 1,
        name: '飲品',
        off: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updated = category.copyWith(name: '食品');

      expect(updated.id, 1);
      expect(updated.name, '食品');
      expect(updated.off, 0);
    });
  });
}
