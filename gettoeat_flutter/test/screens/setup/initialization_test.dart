import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/screens/setup/initialization.dart';
import 'package:gettoeat_flutter/services/store_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:gettoeat_flutter/core/database/database.dart';
import 'package:path/path.dart' as path;

void main() {
  // 初始化 sqflite_ffi 用於測試環境
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // 重置資料庫實例
    AppDatabase.resetInstance();
    await databaseFactory.deleteDatabase(
      path.join(await getDatabasesPath(), 'gettoeat.db'),
    );
    // 建立新的資料庫實例
    final db = AppDatabase();
    await db.database;
  });

  group('InitializationScreen UI 測試', () {
    testWidgets('測試 UI 元件正確顯示', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: InitializationScreen(),
        ),
      );

      // Assert - 檢查標題
      expect(find.text('餐廳初始化設定'), findsOneWidget);

      // Assert - 檢查帳號輸入欄位
      expect(find.widgetWithText(TextFormField, '餐廳帳號'), findsOneWidget);

      // Assert - 檢查暱稱輸入欄位
      expect(find.widgetWithText(TextFormField, '餐廳暱稱'), findsOneWidget);

      // Assert - 檢查確認按鈕
      expect(find.widgetWithText(ElevatedButton, '確認'), findsOneWidget);
    });

    testWidgets('測試空值驗證', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: InitializationScreen(),
        ),
      );

      // Act - 不輸入任何資料，直接點擊確認
      await tester.tap(find.widgetWithText(ElevatedButton, '確認'));
      await tester.pumpAndSettle();

      // Assert - 應該顯示錯誤訊息
      expect(find.text('請輸入餐廳帳號'), findsOneWidget);
      expect(find.text('請輸入餐廳暱稱'), findsOneWidget);
    });

    testWidgets('測試帳號已存在錯誤訊息', (WidgetTester tester) async {
      // Arrange - 先建立一個帳號
      final storeService = StoreService();
      await storeService.createStore('existing_account', '已存在的餐廳');

      await tester.pumpWidget(
        const MaterialApp(
          home: InitializationScreen(),
        ),
      );

      // Act - 輸入已存在的帳號
      await tester.enterText(
        find.widgetWithText(TextFormField, '餐廳帳號'),
        'existing_account',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '餐廳暱稱'),
        '新餐廳',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, '確認'));
      await tester.pumpAndSettle();

      // Assert - 應該顯示帳號已存在的錯誤訊息
      expect(find.text('帳號已存在'), findsOneWidget);
    });
  });
}
