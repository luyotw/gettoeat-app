import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:gettoeat_flutter/core/database/database.dart';
import 'package:gettoeat_flutter/services/store_service.dart';
import 'package:path/path.dart' as path;

void main() {
  // 初始化 sqflite_ffi 用於測試環境
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('StoreService 測試', () {
    late Database database;
    late StoreService storeService;

    setUp(() async {
      // 重置資料庫實例
      AppDatabase.resetInstance();
      await databaseFactory.deleteDatabase(
        path.join(await getDatabasesPath(), 'gettoeat.db'),
      );

      // 建立新的資料庫實例
      final db = AppDatabase();
      database = await db.database;
      storeService = StoreService();
    });

    group('isInitialized 測試', () {
      test('測試資料庫為空時回傳 false', () async {
        // Arrange - 先刪除依賴 stores 的資料，再刪除 stores
        await database.delete('staffs');
        await database.delete('stores');

        // Act
        final result = await storeService.isInitialized();

        // Assert
        expect(result, isFalse);
      });

      test('測試資料庫有資料時回傳 true', () async {
        // Arrange - 明確插入測試資料
        final now = DateTime.now().toIso8601String();
        await database.insert('stores', {
          'account': 'test_store',
          'nickname': '測試餐廳',
          'date_change_at': '04:00',
          'payment_methods': '1',
          'created_at': now,
          'updated_at': now,
        });

        // Act
        final result = await storeService.isInitialized();

        // Assert
        expect(result, isTrue);
      });
    });

    group('checkAccountExists 測試', () {
      test('測試帳號不存在時回傳 false', () async {
        // Arrange
        const account = 'nonexistent_account';

        // Act
        final result = await storeService.checkAccountExists(account);

        // Assert
        expect(result, isFalse);
      });

      test('測試帳號存在時回傳 true', () async {
        // Arrange
        const account = 'default'; // 預設資料庫會插入 'default' 帳號

        // Act
        final result = await storeService.checkAccountExists(account);

        // Assert
        expect(result, isTrue);
      });

      test('測試檢查新插入的帳號', () async {
        // Arrange
        const account = 'test_account';
        final now = DateTime.now().toIso8601String();
        await database.insert('stores', {
          'account': account,
          'nickname': '測試餐廳',
          'date_change_at': '04:00',
          'payment_methods': '1',
          'created_at': now,
          'updated_at': now,
        });

        // Act
        final result = await storeService.checkAccountExists(account);

        // Assert
        expect(result, isTrue);
      });
    });

    group('createStore 測試', () {
      setUp(() async {
        // 清空 stores 表以便測試插入（先刪除依賴資料）
        await database.delete('staffs');
        await database.delete('stores');
      });

      test('測試成功建立餐廳資料', () async {
        // Arrange
        const account = 'restaurant001';
        const nickname = '美味餐廳';

        // Act
        await storeService.createStore(account, nickname);

        // Assert
        final stores = await database.query('stores');
        expect(stores.length, 1);
        expect(stores.first['account'], account);
        expect(stores.first['nickname'], nickname);
      });

      test('測試建立餐廳時使用預設值', () async {
        // Arrange
        const account = 'restaurant002';
        const nickname = '測試餐廳';

        // Act
        await storeService.createStore(account, nickname);

        // Assert
        final stores = await database.query('stores');
        final store = stores.first;
        expect(store['date_change_at'], '04:00');
        expect(store['payment_methods'], '1');
      });

      test('測試建立餐廳時正確設定時間戳', () async {
        // Arrange
        const account = 'restaurant003';
        const nickname = '新餐廳';
        final beforeCreate = DateTime.now();

        // Act
        await storeService.createStore(account, nickname);

        // Assert
        final stores = await database.query('stores');
        final store = stores.first;
        final createdAt = DateTime.parse(store['created_at'] as String);
        final updatedAt = DateTime.parse(store['updated_at'] as String);

        expect(createdAt.isAfter(beforeCreate.subtract(const Duration(seconds: 1))), isTrue);
        expect(updatedAt.isAfter(beforeCreate.subtract(const Duration(seconds: 1))), isTrue);
      });

      test('測試建立餐廳後 id 自動遞增', () async {
        // Arrange & Act
        await storeService.createStore('account1', 'Restaurant 1');
        await storeService.createStore('account2', 'Restaurant 2');

        // Assert
        final stores = await database.query('stores', orderBy: 'id');
        expect(stores.length, 2);
        // 驗證第二筆 id 比第一筆大 1
        final firstId = stores[0]['id'] as int;
        final secondId = stores[1]['id'] as int;
        expect(secondId, firstId + 1);
      });
    });
  });
}
