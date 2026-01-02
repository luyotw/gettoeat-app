import 'package:sqflite/sqflite.dart';
import 'package:gettoeat_flutter/core/database/database.dart';

/// 餐廳服務類別
/// 處理餐廳相關的業務邏輯
class StoreService {
  /// 檢查是否已有餐廳資料（應用程式是否已初始化）
  Future<bool> isInitialized() async {
    final db = await AppDatabase().database;
    final result = await db.query('stores', limit: 1);
    return result.isNotEmpty;
  }

  /// 檢查帳號是否已存在
  Future<bool> checkAccountExists(String account) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'stores',
      where: 'account = ?',
      whereArgs: [account],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// 建立餐廳資料
  /// 使用預設值：
  /// - dateChangeAt: "04:00"
  /// - paymentMethods: "1" (現金)
  Future<void> createStore(String account, String nickname) async {
    final db = await AppDatabase().database;
    final now = DateTime.now().toIso8601String();

    await db.insert('stores', {
      'account': account,
      'nickname': nickname,
      'date_change_at': '04:00',
      'payment_methods': '1',
      'created_at': now,
      'updated_at': now,
    });
  }
}
