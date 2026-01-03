import 'package:gettoeat_flutter/core/database/database.dart';
import 'package:gettoeat_flutter/models/category.dart';
import 'package:gettoeat_flutter/models/product.dart';

/// 資料庫操作服務層
/// 提供分類和商品資料的讀取功能
class DatabaseService {
  static const String _storeId = '1'; // 預設門店 ID

  /// 取得所有啟用的分類
  /// 只回傳 off=0 的分類
  Future<List<Category>> getCategories() async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'categories',
      where: 'off = ?',
      whereArgs: [0],
      orderBy: 'id ASC',
    );

    return maps.map((map) => Category.fromMap(map)).toList();
  }

  /// 取得所有啟用的商品
  /// 只回傳 off=0 的商品，按 position 欄位排序
  Future<List<Product>> getProducts() async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'products',
      where: 'off = ?',
      whereArgs: [0],
      orderBy: 'position ASC',
    );

    return maps.map((map) => Product.fromMap(map)).toList();
  }

  /// 取得特定分類下的所有啟用商品
  /// 只回傳 off=0 的商品，按 position 欄位排序
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'products',
      where: 'category_id = ? AND off = ?',
      whereArgs: [categoryId, 0],
      orderBy: 'position ASC',
    );

    return maps.map((map) => Product.fromMap(map)).toList();
  }
}
