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

  /// 重置資料庫實例（僅用於測試）
  static void resetInstance() {
    _database = null;
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
      onConfigure: (db) async {
        // 啟用外鍵約束
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// 建立所有資料表（首次建立資料庫時執行）
  Future<void> _onCreate(Database db, int version) async {
    // 1. 建立 stores 資料表（無依賴）
    await db.execute('''
      CREATE TABLE stores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account TEXT NOT NULL UNIQUE,
        nickname TEXT,
        date_change_at TEXT,
        payment_methods TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 2. 建立 staff_groups 資料表（依賴 stores）
    await db.execute('''
      CREATE TABLE staff_groups (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        store_id INTEGER NOT NULL DEFAULT 1,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (store_id) REFERENCES stores(id)
      )
    ''');

    // 3. 建立 staffs 資料表（依賴 stores）
    await db.execute('''
      CREATE TABLE staffs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        store_id INTEGER NOT NULL DEFAULT 1,
        group_id INTEGER,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        code TEXT NOT NULL UNIQUE,
        off INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        created_by INTEGER,
        updated_at TEXT NOT NULL,
        updated_by INTEGER,
        FOREIGN KEY (store_id) REFERENCES stores(id)
      )
    ''');

    // 4. 建立 categories 資料表（依賴 stores）
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        store_id INTEGER NOT NULL DEFAULT 1,
        name TEXT NOT NULL,
        off INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (store_id) REFERENCES stores(id)
      )
    ''');
  }

  /// 資料庫版本升級處理
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 待實作：資料庫版本升級邏輯
  }
}
