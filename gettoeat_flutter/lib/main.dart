import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gettoeat_flutter/screens/setup/initialization.dart';
import 'package:gettoeat_flutter/screens/management/basic.dart';
import 'package:gettoeat_flutter/services/store_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GetToEat POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

/// 應用程式路由設定
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        // 檢查是否已初始化
        final storeService = StoreService();
        final isInitialized = await storeService.isInitialized();

        // 如果未初始化，導向至初始化畫面
        if (!isInitialized) {
          return '/setup';
        }

        // 已初始化則導向基本設定頁面（暫時，後續會改為主畫面）
        return '/management/basic';
      },
    ),
    GoRoute(
      path: '/setup',
      builder: (context, state) => const InitializationScreen(),
    ),
    GoRoute(
      path: '/management/basic',
      builder: (context, state) => const BasicSettingsScreen(),
    ),
  ],
);
