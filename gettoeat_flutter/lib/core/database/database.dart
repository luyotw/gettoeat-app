import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 應用程式資料庫管理類別
/// 使用 Singleton 模式確保整個應用程式只有一個資料庫實例
class AppDatabase {
  static Database? _database;
  static final AppDatabase _instance = AppDatabase._internal();

  static const String dbName = 'gettoeat.db';
  static const int dbVersion = 1;

  // 私有建構子
  AppDatabase._internal();

  // Factory 建構子回傳單例
  factory AppDatabase() {
    return _instance;
  }

  /// 取得資料庫實例
  /// 如果資料庫尚未初始化，會自動建立
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化資料庫連接
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 建立所有資料表（首次建立資料庫時執行）
  Future<void> _onCreate(Database db, int version) async {
    // 待實作：建立所有資料表
  }

  /// 資料庫版本升級處理
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 待實作：資料庫版本升級邏輯
  }
}
