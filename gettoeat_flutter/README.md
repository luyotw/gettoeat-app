# GetToEat Flutter App

GetToEat POS 系統的 iOS & Android 應用程式。

## 專案架構

```
lib/
├── core/                    # 核心功能
│   ├── database/           # SQLite 資料庫
│   ├── router/             # 路由配置
│   ├── theme/              # 主題配置
│   └── utils/              # 工具函數
├── models/                 # 資料模型
├── services/               # 業務邏輯服務
├── providers/              # 狀態管理 (Riverpod)
├── screens/                # 畫面
│   ├── auth/              # 登入
│   ├── pos/               # POS 結帳
│   ├── management/        # 管理功能
│   ├── punch/             # 打卡
│   ├── shift/             # 班表
│   └── statistics/        # 統計
└── widgets/                # 共用元件
```

## 技術棧

- **Framework**: Flutter 3.35.4
- **State Management**: Riverpod
- **Database**: SQLite (sqflite)
- **Routing**: go_router
- **Charts**: fl_chart

## 開發環境設置

```bash
# 確認 Flutter 環境
flutter doctor

# 安裝依賴
flutter pub get

# 執行應用
flutter run
```

## 開發階段

詳細的開發計畫請參考根目錄的 [FLUTTER_MIGRATION_PLAN.md](../FLUTTER_MIGRATION_PLAN.md)

### Phase 1: MVP 核心功能
- SQLite 資料庫建立
- 員工代碼登入
- 商品顯示和購物車
- 基本結帳功能

### Phase 2-7
請參考 GitHub Issues

## GitHub Issues

所有開發任務都已建立為 GitHub issues:
https://github.com/luyotw/gettoeat-app/issues

## License

私有專案
