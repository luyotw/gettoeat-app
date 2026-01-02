import 'package:flutter/material.dart';

/// 基本設定畫面
/// 此畫面為初始化完成後的導向目標
/// 完整功能將在後續 issue 中實作
class BasicSettingsScreen extends StatelessWidget {
  const BasicSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基本設定'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            '此畫面將在後續 issue 中完整實作\n\n'
            '預計功能：\n'
            '- 設定營業日期變更時間\n'
            '- 設定支付方式',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
