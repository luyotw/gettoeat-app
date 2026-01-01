# GetToEat Flutter 遷移規劃書

## 📋 專案概述

**目標**: 將 GetToEat Web POS 系統完全改寫為 Flutter iOS & Android 應用程式

**架構決策**:
- ✅ 純前端應用 (無後端 server)
- ✅ 使用 SQLite 本地資料庫 (單機版)
- ✅ 員工代碼登入機制
- ✅ 單一門店版本
- ✅ 暫時移除 LINE Bot 功能

**主要使用場景**:
1. 平板上的 POS 結帳系統
2. 手機上的員工管理和打卡
3. 手機上的統計報表查看

---

## 🏗️ 技術架構

### 1. Flutter 專案結構

```
gettoeat_flutter/
├── lib/
│   ├── main.dart                 # 應用入口
│   ├── app.dart                  # App 配置
│   │
│   ├── core/                     # 核心功能
│   │   ├── database/
│   │   │   ├── database.dart     # SQLite 資料庫初始化
│   │   │   ├── tables/           # 資料表定義
│   │   │   └── migrations/       # 資料庫版本遷移
│   │   ├── router/
│   │   │   └── app_router.dart   # 路由配置 (go_router)
│   │   ├── theme/
│   │   │   └── app_theme.dart    # 主題配置
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       └── number_utils.dart
│   │
│   ├── models/                   # 資料模型
│   │   ├── staff.dart
│   │   ├── product.dart
│   │   ├── category.dart
│   │   ├── bill.dart
│   │   ├── bill_item.dart
│   │   ├── event.dart
│   │   ├── punch_log.dart
│   │   ├── shift.dart
│   │   └── table_info.dart
│   │
│   ├── services/                 # 業務邏輯服務
│   │   ├── database_service.dart # 資料庫操作服務
│   │   ├── auth_service.dart     # 認證服務
│   │   ├── pos_service.dart      # POS 結帳邏輯
│   │   ├── staff_service.dart    # 員工管理
│   │   ├── statistics_service.dart # 統計服務
│   │   └── storage_service.dart  # 本地儲存 (SharedPreferences)
│   │
│   ├── providers/                # 狀態管理 (Riverpod)
│   │   ├── auth_provider.dart
│   │   ├── cart_provider.dart
│   │   ├── products_provider.dart
│   │   ├── bills_provider.dart
│   │   └── staff_provider.dart
│   │
│   ├── screens/                  # 畫面
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── pos/
│   │   │   ├── pos_screen.dart        # 主要 POS 介面
│   │   │   ├── cart_sheet.dart        # 購物車側欄
│   │   │   └── table_map_widget.dart  # 桌位地圖
│   │   ├── management/
│   │   │   ├── products_screen.dart
│   │   │   ├── categories_screen.dart
│   │   │   ├── staffs_screen.dart
│   │   │   ├── events_screen.dart
│   │   │   └── tables_screen.dart
│   │   ├── punch/
│   │   │   ├── punch_screen.dart
│   │   │   └── punch_logs_screen.dart
│   │   ├── shift/
│   │   │   ├── shift_list_screen.dart
│   │   │   └── create_shift_screen.dart
│   │   └── statistics/
│   │       ├── statistics_screen.dart
│   │       └── widgets/
│   │           ├── overview_chart.dart
│   │           └── sales_chart.dart
│   │
│   └── widgets/                  # 共用元件
│       ├── custom_app_bar.dart
│       ├── loading_indicator.dart
│       └── error_dialog.dart
│
├── assets/                       # 資源檔案
│   ├── images/
│   └── fonts/
│
├── test/                         # 測試
│   ├── unit/
│   └── widget/
│
└── pubspec.yaml                  # 套件依賴
```

### 2. 核心技術棧

```yaml
# pubspec.yaml 主要依賴

dependencies:
  flutter:
    sdk: flutter

  # 狀態管理
  flutter_riverpod: ^2.6.1

  # 資料庫
  sqflite: ^2.3.3+1
  path: ^1.9.0

  # 本地儲存
  shared_preferences: ^2.3.3

  # 路由
  go_router: ^14.6.2

  # UI 元件
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.3.1

  # 日期處理
  intl: ^0.19.0

  # 表單驗證
  flutter_form_builder: ^9.4.1

  # 圖表
  fl_chart: ^0.69.2

  # 工具
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # 程式碼生成
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0

  # Linting
  flutter_lints: ^5.0.0
```

---

## 🗄️ SQLite 資料庫設計

### 資料表結構

#### 1. stores (門店資訊)
```sql
CREATE TABLE stores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account TEXT NOT NULL UNIQUE,
  nickname TEXT,
  date_change_at TEXT,  -- 營業日切換時間 (HH:mm)
  payment_methods TEXT, -- JSON array
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

#### 2. staffs (員工)
```sql
CREATE TABLE staffs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  group_id INTEGER,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  code TEXT NOT NULL UNIQUE, -- 員工代碼 (用於登入)
  off INTEGER NOT NULL DEFAULT 0, -- 0=啟用, 1=停用
  created_at TEXT NOT NULL,
  created_by INTEGER,
  updated_at TEXT NOT NULL,
  updated_by INTEGER,
  FOREIGN KEY (store_id) REFERENCES stores(id)
);
```

#### 3. staff_groups (員工分組)
```sql
CREATE TABLE staff_groups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  name TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id)
);
```

#### 4. categories (商品分類)
```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  name TEXT NOT NULL,
  off INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id)
);
```

#### 5. products (商品)
```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  position INTEGER NOT NULL DEFAULT 0, -- 排序
  off INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

#### 6. bills (帳單)
```sql
CREATE TABLE bills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  table_name TEXT, -- 桌位名稱
  customers INTEGER, -- 客人數
  price REAL NOT NULL, -- 原始總價
  final_price REAL NOT NULL, -- 折扣後總價
  payment_method TEXT, -- 支付方式
  ordered_at TEXT NOT NULL, -- 點餐時間
  paid_at TEXT, -- 結帳時間
  created_by INTEGER,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id),
  FOREIGN KEY (created_by) REFERENCES staffs(id)
);
```

#### 7. bill_items (帳單明細)
```sql
CREATE TABLE bill_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  product_name TEXT NOT NULL, -- 冗餘欄位，防止商品刪除後找不到名稱
  unit_price REAL NOT NULL,
  amount INTEGER NOT NULL,
  subtotal REAL NOT NULL, -- unit_price * amount
  created_at TEXT NOT NULL,
  FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

#### 8. bill_discounts (折扣記錄)
```sql
CREATE TABLE bill_discounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER NOT NULL,
  event_id INTEGER,
  title TEXT NOT NULL, -- 折扣名稱
  value REAL NOT NULL, -- 折扣金額 (正數)
  created_at TEXT NOT NULL,
  FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE,
  FOREIGN KEY (event_id) REFERENCES events(id)
);
```

#### 9. events (促銷活動)
```sql
CREATE TABLE events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  type TEXT NOT NULL, -- 'price_off', 'percent_off', 'category_percent_off'
  title TEXT NOT NULL,
  start_at TEXT, -- 開始時間 (nullable = 永久)
  end_at TEXT,   -- 結束時間 (nullable = 永久)
  config TEXT,   -- JSON 配置
  off INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id)
);
```

#### 10. punch_logs (打卡記錄)
```sql
CREATE TABLE punch_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  staff_id INTEGER NOT NULL,
  type INTEGER NOT NULL, -- 1=上班, 2=下班
  timestamp TEXT NOT NULL, -- 打卡時間
  ip_address TEXT, -- 裝置 IP (可選)
  created_at TEXT NOT NULL,
  created_by INTEGER,
  updated_at TEXT NOT NULL,
  updated_by INTEGER,
  FOREIGN KEY (staff_id) REFERENCES staffs(id)
);
```

#### 11. shifts (班表/關帳記錄)
```sql
CREATE TABLE shifts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  open_amount REAL NOT NULL DEFAULT 0, -- 期初現金
  close_amount REAL, -- 實際現金
  paid_out REAL NOT NULL DEFAULT 0, -- 臨時支出
  paid_in REAL NOT NULL DEFAULT 0, -- 臨時收入
  adjustment_type TEXT, -- 'withdraw' 或 'supplement'
  adjustment_amount REAL NOT NULL DEFAULT 0, -- 調整金額
  adjustment_by INTEGER,
  note TEXT,
  created_at TEXT NOT NULL,
  created_by INTEGER,
  FOREIGN KEY (store_id) REFERENCES stores(id),
  FOREIGN KEY (created_by) REFERENCES staffs(id),
  FOREIGN KEY (adjustment_by) REFERENCES staffs(id)
);
```

#### 12. tables_info (桌位配置)
```sql
CREATE TABLE tables_info (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL DEFAULT 1,
  version INTEGER NOT NULL DEFAULT 1,
  data TEXT NOT NULL, -- JSON: {totalWidth, totalHeight, tables: [...]}
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id)
);
```

### 資料庫初始化範例

```dart
// core/database/database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static const String dbName = 'gettoeat.db';
  static const int dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

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

  Future<void> _onCreate(Database db, int version) async {
    // 創建所有資料表
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

    // ... 其他表格創建語句

    // 插入初始資料
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // 插入預設門店
    await db.insert('stores', {
      'account': 'default',
      'nickname': '我的餐廳',
      'date_change_at': '04:00',
      'payment_methods': '["cash","card","mobile"]',
      'created_at': now,
      'updated_at': now,
    });

    // 插入預設管理員
    await db.insert('staffs', {
      'store_id': 1,
      'name': '管理員',
      'code': '0000',
      'off': 0,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 處理資料庫升級
  }
}
```

---

## 🎨 UI/UX 設計方案

### 1. 響應式設計策略

**平板 (POS 主要介面)**
- 橫向佈局 (Landscape)
- 左側: 商品分類 + 商品列表 (60%)
- 右側: 購物車 + 結帳區 (40%)
- 頂部: 桌位選擇 + 今日營收

**手機 (員工管理、統計)**
- 直向佈局 (Portrait)
- 底部導航列 (BottomNavigationBar)
- 卡片式佈局

### 2. 主要畫面設計

#### A. 登入畫面 (LoginScreen)
```
┌─────────────────────┐
│   GetToEat Logo     │
│                     │
│   ┌─────────────┐   │
│   │ 員工代碼     │   │
│   └─────────────┘   │
│                     │
│   [ 0 1 2 3 ]       │ <- 數字鍵盤
│   [ 4 5 6 7 ]       │
│   [ 8 9 ✓ ✗ ]       │
│                     │
└─────────────────────┘
```

#### B. POS 結帳畫面 (平板橫向)
```
┌─────────────────────────────────────────────────────┐
│ [桌位: 3桌] [人數: 4]    今日營收: $12,500  [登出] │
├────────────────┬────────────────────────────────────┤
│ 分類列表       │ 商品列表                           │
│ ┌──────────┐  │ ┌──────┐ ┌──────┐ ┌──────┐        │
│ │全部      │  │ │牛排飯│ │雞腿飯│ │滷肉飯│        │
│ ├──────────┤  │ │$150  │ │$120  │ │$80   │        │
│ │主餐      │◀─│ └──────┘ └──────┘ └──────┘        │
│ ├──────────┤  │                                    │
│ │飲料      │  │ ┌──────┐ ┌──────┐                 │
│ ├──────────┤  │ │豬排飯│ │魚排飯│                 │
│ │甜點      │  │ │$130  │ │$140  │                 │
│ └──────────┘  │ └──────┘ └──────┘                 │
├────────────────┼────────────────────────────────────┤
│                │ 購物車                             │
│                │ ┌────────────────────────────┐    │
│                │ │ 牛排飯 x2      $300        │    │
│                │ │ 雞腿飯 x1      $120        │    │
│                │ └────────────────────────────┘    │
│                │                                    │
│                │ 小計:          $420                │
│                │ 折扣:          -$20                │
│                │ 總計:          $400                │
│                │                                    │
│                │ [套用折扣] [清空] [結帳]           │
└────────────────┴────────────────────────────────────┘
```

#### C. 手機主選單 (BottomNavigationBar)
```
┌─────────────────────┐
│   主要內容區域      │
│                     │
│                     │
│                     │
│                     │
│                     │
├─────────────────────┤
│ [POS] [打卡] [統計] │ <- 底部導航
│ [管理] [關帳]       │
└─────────────────────┘
```

### 3. 關鍵互動設計

**快速點餐流程**:
1. 點擊桌位 → 選擇商品 → 自動加入購物車
2. 點擊購物車項目 → 快速調整數量 (+/- 按鈕)
3. 長按購物車項目 → 刪除

**折扣套用**:
1. 點擊「套用折扣」→ 顯示可用活動列表
2. 選擇活動 → 自動計算折扣金額
3. 可手動輸入自訂折扣金額

**打卡流程**:
1. 輸入員工代碼 → 顯示員工姓名
2. 點擊「上班」或「下班」
3. 顯示打卡時間和成功訊息

---

## 🔄 資料遷移策略

### 從現有 MySQL 匯出到 SQLite

#### 步驟 1: 匯出 MySQL 資料
```bash
# 匯出為 SQL 格式
mysqldump -u username -p gettoeat_db > gettoeat_export.sql

# 或匯出為 CSV
mysql -u username -p -e "SELECT * FROM staffs" gettoeat_db > staffs.csv
```

#### 步驟 2: 轉換腳本 (Python)
```python
# migration_tool.py
import sqlite3
import mysql.connector
from datetime import datetime

def migrate_mysql_to_sqlite():
    # 連接 MySQL
    mysql_conn = mysql.connector.connect(
        host='localhost',
        user='username',
        password='password',
        database='gettoeat_db'
    )

    # 連接 SQLite
    sqlite_conn = sqlite3.connect('gettoeat.db')

    # 遷移 staffs 表
    mysql_cursor = mysql_conn.cursor(dictionary=True)
    mysql_cursor.execute("SELECT * FROM staffs")

    sqlite_cursor = sqlite_conn.cursor()
    for row in mysql_cursor:
        sqlite_cursor.execute('''
            INSERT INTO staffs (id, store_id, name, code, email, phone, off, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            row['id'],
            row['store_id'],
            row['name'],
            row['code'],
            row['email'],
            row['phone'],
            row['off'],
            row['created_at'],
            row['updated_at']
        ))

    # ... 遷移其他表格

    sqlite_conn.commit()
    sqlite_conn.close()
    mysql_conn.close()

if __name__ == '__main__':
    migrate_mysql_to_sqlite()
```

#### 步驟 3: 在 Flutter app 中載入初始資料
```dart
// 將 gettoeat.db 放入 assets/
// pubspec.yaml
assets:
  - assets/gettoeat.db

// 首次啟動時複製到本地
Future<void> copyDatabaseFromAssets() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'gettoeat.db');

  // 如果資料庫已存在，不覆蓋
  if (!await File(path).exists()) {
    final data = await rootBundle.load('assets/gettoeat.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes);
  }
}
```

---

## 📱 功能實作優先順序

### Phase 1: MVP 核心功能 (2-3 週)
- [x] 專案初始化和架構設置
- [ ] SQLite 資料庫建立和初始化
- [ ] 員工代碼登入功能
- [ ] 商品分類和商品列表顯示
- [ ] 購物車功能 (新增、刪除、修改數量)
- [ ] 基本結帳功能 (建立帳單)
- [ ] 桌位選擇

### Phase 2: POS 進階功能 (2 週)
- [ ] 折扣活動系統
- [ ] 多種支付方式
- [ ] 今日營收顯示
- [ ] 帳單歷史查看
- [ ] 桌位地圖拖拽編輯

### Phase 3: 員工管理 (1 週)
- [ ] 員工列表和新增編輯
- [ ] 員工分組管理
- [ ] 打卡功能 (上下班)
- [ ] 打卡記錄查看和編輯

### Phase 4: 班表和關帳 (1 週)
- [ ] 關帳記錄建立
- [ ] 現金盤點和計算
- [ ] 臨時收支記錄
- [ ] 班表歷史查看

### Phase 5: 統計報表 (1-2 週)
- [ ] 營業概況統計
- [ ] 商品銷售排行
- [ ] 分類銷售統計
- [ ] 支付方式分析
- [ ] 圖表視覺化 (fl_chart)

### Phase 6: 管理功能 (1 週)
- [ ] 商品管理 (新增、編輯、上下架)
- [ ] 分類管理
- [ ] 活動管理
- [ ] 桌位管理

### Phase 7: 優化和測試 (1 週)
- [ ] 效能優化
- [ ] 錯誤處理和異常處理
- [ ] 單元測試和整合測試
- [ ] UI/UX 調整

---

## 🛠️ 開發環境設置

### 1. Flutter 環境確認
```bash
# 確認 Flutter 版本
flutter --version

# 確認可用平台
flutter doctor

# 建議使用 Flutter 3.27 或以上
```

### 2. 建立新專案
```bash
# 進入專案目錄
cd /Users/YO_1/side_projects/gettoeat-app

# 建立 Flutter 專案 (在 flutter_app 子目錄)
flutter create flutter_app

# 進入 Flutter 專案
cd flutter_app

# 安裝依賴
flutter pub get
```

### 3. 設置 VSCode 或 Android Studio
```bash
# VSCode 必要外掛
- Flutter
- Dart
- Flutter Riverpod Snippets

# 啟用 IDE 支援
flutter config --enable-web  # (如果需要 web 測試)
```

### 4. 初始化 Git
```bash
# Flutter 專案已有 .gitignore
git add flutter_app/
git commit -m "Initial Flutter project setup"
```

---

## 📊 效能和限制考量

### SQLite 單機版的優缺點

**優點**:
✅ 完全離線運作，不依賴網路
✅ 沒有伺服器成本
✅ 資料存取速度快
✅ 簡單易部署

**缺點和解決方案**:
❌ **無法多裝置同步**
  - 解決: 單一平板作為主要 POS 機，其他裝置僅用於查詢
  - 未來可考慮定期匯出備份

❌ **資料備份風險**
  - 解決: 實作定期自動備份功能
  - 可備份到裝置的 Documents 目錄或雲端儲存 (Google Drive, Dropbox)

❌ **無法遠端管理**
  - 解決: 提供匯出 CSV/Excel 功能
  - 可透過電腦讀取備份檔案進行分析

### 備份策略建議

```dart
// 每日自動備份
class BackupService {
  Future<void> autoBackup() async {
    final db = await AppDatabase().database;
    final dbPath = db.path;

    // 取得 Documents 目錄
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    // 複製資料庫檔案
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    final backupPath = '${backupDir.path}/gettoeat_$timestamp.db';

    await File(dbPath).copy(backupPath);

    // 保留最近 30 天的備份
    await _cleanOldBackups(backupDir, days: 30);
  }
}
```

---

## 🚀 下一步行動

### 立即開始

1. **建立 Flutter 專案**
   ```bash
   cd /Users/YO_1/side_projects/gettoeat-app
   flutter create flutter_app
   cd flutter_app
   ```

2. **更新 pubspec.yaml**
   - 複製上方建議的依賴清單

3. **建立資料庫架構**
   - 實作 `core/database/database.dart`
   - 定義所有資料表

4. **實作登入功能**
   - 建立 `screens/auth/login_screen.dart`
   - 實作員工代碼驗證

5. **開始 POS 主畫面開發**
   - 商品列表顯示
   - 購物車功能

### 需要決定的事項

- [ ] 是否需要資料匯出功能 (CSV/Excel)?
- [ ] 是否需要收據列印功能?
- [ ] 桌位地圖的互動方式 (拖拽 vs 固定位置)?
- [ ] 統計圖表的類型偏好 (長條圖、折線圖、圓餅圖)?

---

## 💡 額外建議

### 未來可選功能 (非必要)

1. **雲端備份** (Phase 8+)
   - 使用 Firebase Storage 或 Google Drive API
   - 自動定期上傳備份

2. **收據列印** (Phase 8+)
   - 使用藍牙印表機
   - 套件: `blue_thermal_printer` 或 `esc_pos_printer`

3. **QR Code 點餐** (Phase 9+)
   - 客人掃描桌上 QR code 自助點餐
   - 需要簡單的後端 API (可用 Firebase)

4. **多語言支援** (Phase 9+)
   - 使用 `flutter_localizations`
   - 支援繁中、英文

5. **深色模式** (Phase 9+)
   - 實作 ThemeMode 切換

---

## 📞 需要協助?

如果在實作過程中遇到問題，可以詢問:
- 特定功能的程式碼範例
- UI 設計建議
- 資料庫查詢優化
- 狀態管理最佳實踐

**下一步**: 我可以幫你開始建立 Flutter 專案架構和資料庫程式碼。準備好開始了嗎?
