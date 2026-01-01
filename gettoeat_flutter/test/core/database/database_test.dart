import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:gettoeat_flutter/core/database/database.dart';
import 'package:path/path.dart' as path;

void main() {
  // 初始化 sqflite_ffi 用於測試環境
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('AppDatabase', () {
    test('測試資料庫實例建立成功', () async {
      // Arrange & Act
      final db = AppDatabase();
      final database = await db.database;

      // Assert
      expect(database, isNotNull);
      expect(database.isOpen, isTrue);
    });

    test('測試 Singleton 模式（多次呼叫回傳同一實例）', () async {
      // Arrange & Act
      final db1 = AppDatabase();
      final db2 = AppDatabase();
      final database1 = await db1.database;
      final database2 = await db2.database;

      // Assert
      expect(database1, equals(database2));
    });
  });

  group('資料表結構測試', () {
    late Database database;

    setUpAll(() async {
      // 重置資料庫實例並建立新的資料庫
      AppDatabase.resetInstance();
      await databaseFactory.deleteDatabase(path.join(await getDatabasesPath(), 'gettoeat.db'));
      final db = AppDatabase();
      database = await db.database;
    });

    test('驗證 stores 資料表存在且結構正確', () async {
      // Act
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='stores'",
      );

      // Assert
      expect(result, isNotEmpty);
      expect(result.first['name'], 'stores');

      // 驗證欄位結構
      final columns = await database.rawQuery('PRAGMA table_info(stores)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('account'));
      expect(columnNames, contains('nickname'));
      expect(columnNames, contains('date_change_at'));
      expect(columnNames, contains('payment_methods'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 staffs 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='staffs'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(staffs)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('group_id'));
      expect(columnNames, contains('name'));
      expect(columnNames, contains('email'));
      expect(columnNames, contains('phone'));
      expect(columnNames, contains('code'));
      expect(columnNames, contains('off'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 staff_groups 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='staff_groups'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(staff_groups)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('name'));
      expect(columnNames, contains('created_at'));
    });

    test('驗證 categories 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='categories'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(categories)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('name'));
      expect(columnNames, contains('off'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 products 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='products'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(products)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('category_id'));
      expect(columnNames, contains('name'));
      expect(columnNames, contains('price'));
      expect(columnNames, contains('position'));
      expect(columnNames, contains('off'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 bills 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='bills'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(bills)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('table_name'));
      expect(columnNames, contains('customers'));
      expect(columnNames, contains('price'));
      expect(columnNames, contains('final_price'));
      expect(columnNames, contains('payment_method'));
      expect(columnNames, contains('ordered_at'));
      expect(columnNames, contains('paid_at'));
      expect(columnNames, contains('created_by'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 bill_items 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='bill_items'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(bill_items)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('bill_id'));
      expect(columnNames, contains('product_id'));
      expect(columnNames, contains('product_name'));
      expect(columnNames, contains('unit_price'));
      expect(columnNames, contains('amount'));
      expect(columnNames, contains('subtotal'));
      expect(columnNames, contains('created_at'));
    });

    test('驗證 bill_discounts 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='bill_discounts'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(bill_discounts)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('bill_id'));
      expect(columnNames, contains('event_id'));
      expect(columnNames, contains('title'));
      expect(columnNames, contains('value'));
      expect(columnNames, contains('created_at'));
    });

    test('驗證 events 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='events'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(events)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('type'));
      expect(columnNames, contains('title'));
      expect(columnNames, contains('start_at'));
      expect(columnNames, contains('end_at'));
      expect(columnNames, contains('config'));
      expect(columnNames, contains('off'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 punch_logs 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='punch_logs'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(punch_logs)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('staff_id'));
      expect(columnNames, contains('type'));
      expect(columnNames, contains('timestamp'));
      expect(columnNames, contains('ip_address'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('驗證 shifts 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='shifts'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(shifts)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('open_amount'));
      expect(columnNames, contains('close_amount'));
      expect(columnNames, contains('paid_out'));
      expect(columnNames, contains('paid_in'));
      expect(columnNames, contains('adjustment_type'));
      expect(columnNames, contains('adjustment_amount'));
      expect(columnNames, contains('adjustment_by'));
      expect(columnNames, contains('note'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('created_by'));
    });

    test('驗證 tables_info 資料表存在且結構正確', () async {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tables_info'",
      );
      expect(result, isNotEmpty);

      final columns = await database.rawQuery('PRAGMA table_info(tables_info)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      expect(columnNames, contains('id'));
      expect(columnNames, contains('store_id'));
      expect(columnNames, contains('version'));
      expect(columnNames, contains('data'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });
  });

  group('初始資料測試', () {
    late Database database;

    setUpAll(() async {
      // 重置資料庫實例並建立新的資料庫
      AppDatabase.resetInstance();
      await databaseFactory.deleteDatabase(path.join(await getDatabasesPath(), 'gettoeat.db'));
      final db = AppDatabase();
      database = await db.database;
    });

    test('驗證預設門店資料成功插入', () async {
      // Act
      final stores = await database.query('stores');

      // Assert
      expect(stores, isNotEmpty);
      expect(stores.length, 1);
    });

    test('驗證預設門店資料欄位值正確', () async {
      // Act
      final stores = await database.query('stores');
      final defaultStore = stores.first;

      // Assert
      expect(defaultStore['id'], 1);
      expect(defaultStore['account'], 'default');
      expect(defaultStore['nickname'], '我的餐廳');
      expect(defaultStore['date_change_at'], '04:00');
      expect(defaultStore['payment_methods'], '["cash","card","mobile"]');
      expect(defaultStore['created_at'], isNotNull);
      expect(defaultStore['updated_at'], isNotNull);
    });

    test('驗證預設管理員資料成功插入', () async {
      // Act
      final staffs = await database.query('staffs');

      // Assert
      expect(staffs, isNotEmpty);
      expect(staffs.length, 1);
    });

    test('驗證預設管理員資料欄位值正確', () async {
      // Act
      final staffs = await database.query('staffs');
      final defaultAdmin = staffs.first;

      // Assert
      expect(defaultAdmin['id'], 1);
      expect(defaultAdmin['store_id'], 1);
      expect(defaultAdmin['name'], '管理員');
      expect(defaultAdmin['code'], '0000');
      expect(defaultAdmin['off'], 0);
      expect(defaultAdmin['created_at'], isNotNull);
      expect(defaultAdmin['updated_at'], isNotNull);
    });

    test('驗證時間戳格式為 ISO8601', () async {
      // Act
      final stores = await database.query('stores');
      final defaultStore = stores.first;

      // Assert - ISO8601 格式驗證
      final createdAt = defaultStore['created_at'] as String;
      final updatedAt = defaultStore['updated_at'] as String;

      // 嘗試解析 ISO8601 格式，如果格式正確不會拋出異常
      expect(() => DateTime.parse(createdAt), returnsNormally);
      expect(() => DateTime.parse(updatedAt), returnsNormally);

      // 驗證解析後的時間是有效的
      final createdDateTime = DateTime.parse(createdAt);
      final updatedDateTime = DateTime.parse(updatedAt);
      expect(createdDateTime.year, greaterThan(2020));
      expect(updatedDateTime.year, greaterThan(2020));
    });
  });

  group('資料庫版本遷移測試', () {
    test('驗證資料庫版本號為 1', () async {
      // Arrange & Act
      AppDatabase.resetInstance();
      await databaseFactory.deleteDatabase(path.join(await getDatabasesPath(), 'gettoeat.db'));
      final db = AppDatabase();
      final database = await db.database;

      // Assert
      final version = await database.getVersion();
      expect(version, 1);
    });

    test('驗證重複初始化不會報錯或重複插入資料', () async {
      // Arrange
      AppDatabase.resetInstance();
      await databaseFactory.deleteDatabase(path.join(await getDatabasesPath(), 'gettoeat.db'));

      // Act - 第一次初始化
      final db1 = AppDatabase();
      final database1 = await db1.database;
      final storesCount1 = await database1.rawQuery('SELECT COUNT(*) as count FROM stores');
      final firstCount = storesCount1.first['count'] as int;

      // Act - 重置並再次初始化（模擬重複啟動應用）
      AppDatabase.resetInstance();
      final db2 = AppDatabase();
      final database2 = await db2.database;
      final storesCount2 = await database2.rawQuery('SELECT COUNT(*) as count FROM stores');
      final secondCount = storesCount2.first['count'] as int;

      // Assert - 確認資料沒有重複插入
      expect(firstCount, 1);
      expect(secondCount, 1);
      expect(database2.isOpen, isTrue);
    });
  });
}
