import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:gettoeat_flutter/core/database/database.dart';

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
}
