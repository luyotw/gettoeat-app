import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/models/store.dart';

void main() {
  group('Store 模型測試', () {
    test('測試 Store 模型建立', () {
      // Arrange
      final now = DateTime.now();

      // Act
      final store = Store(
        id: 1,
        account: 'test_account',
        nickname: '測試餐廳',
        dateChangeAt: '04:00',
        paymentMethods: '1',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(store.id, 1);
      expect(store.account, 'test_account');
      expect(store.nickname, '測試餐廳');
      expect(store.dateChangeAt, '04:00');
      expect(store.paymentMethods, '1');
      expect(store.createdAt, now);
      expect(store.updatedAt, now);
    });

    test('測試 Store 模型 toJson 序列化', () {
      // Arrange
      final now = DateTime.parse('2026-01-02T10:30:00.000Z');
      final store = Store(
        id: 1,
        account: 'restaurant001',
        nickname: '美味餐廳',
        dateChangeAt: '04:00',
        paymentMethods: '1',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final json = store.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['account'], 'restaurant001');
      expect(json['nickname'], '美味餐廳');
      expect(json['dateChangeAt'], '04:00');
      expect(json['paymentMethods'], '1');
      expect(json['createdAt'], now.toIso8601String());
      expect(json['updatedAt'], now.toIso8601String());
    });

    test('測試 Store 模型 fromJson 反序列化', () {
      // Arrange
      final json = {
        'id': 1,
        'account': 'restaurant001',
        'nickname': '美味餐廳',
        'dateChangeAt': '04:00',
        'paymentMethods': '1',
        'createdAt': '2026-01-02T10:30:00.000Z',
        'updatedAt': '2026-01-02T10:30:00.000Z',
      };

      // Act
      final store = Store.fromJson(json);

      // Assert
      expect(store.id, 1);
      expect(store.account, 'restaurant001');
      expect(store.nickname, '美味餐廳');
      expect(store.dateChangeAt, '04:00');
      expect(store.paymentMethods, '1');
      expect(store.createdAt, DateTime.parse('2026-01-02T10:30:00.000Z'));
      expect(store.updatedAt, DateTime.parse('2026-01-02T10:30:00.000Z'));
    });

    test('測試 Store 模型可選欄位為 null', () {
      // Arrange & Act
      final now = DateTime.now();
      final store = Store(
        id: 1,
        account: 'test_account',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(store.nickname, isNull);
      expect(store.dateChangeAt, isNull);
      expect(store.paymentMethods, isNull);
    });
  });
}
