import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gettoeat_flutter/screens/management/basic.dart';

void main() {
  group('BasicSettingsScreen 測試', () {
    testWidgets('測試畫面能正常顯示', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: BasicSettingsScreen(),
        ),
      );

      // Assert - 檢查畫面標題是否顯示
      expect(find.text('基本設定'), findsOneWidget);
    });

    testWidgets('測試畫面包含佔位文字', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: BasicSettingsScreen(),
        ),
      );

      // Assert - 檢查佔位文字是否顯示
      expect(find.textContaining('此畫面將在後續'), findsOneWidget);
    });
  });
}
