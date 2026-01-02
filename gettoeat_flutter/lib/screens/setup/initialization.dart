import 'package:flutter/material.dart';
import 'package:gettoeat_flutter/services/store_service.dart';

/// 餐廳初始化設定畫面
/// 用於首次啟動時讓使用者輸入餐廳帳號和暱稱
class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _storeService = StoreService();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _accountController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  /// 驗證帳號欄位
  String? _validateAccount(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入餐廳帳號';
    }
    return null;
  }

  /// 驗證暱稱欄位
  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入餐廳暱稱';
    }
    return null;
  }

  /// 提交表單
  Future<void> _submitForm() async {
    // 清除之前的錯誤訊息
    setState(() {
      _errorMessage = null;
    });

    // 驗證表單
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 檢查帳號是否已存在
      final accountExists = await _storeService.checkAccountExists(
        _accountController.text.trim(),
      );

      if (accountExists) {
        setState(() {
          _errorMessage = '帳號已存在';
          _isLoading = false;
        });
        return;
      }

      // 建立餐廳資料
      await _storeService.createStore(
        _accountController.text.trim(),
        _nicknameController.text.trim(),
      );

      // 導向至基本設定頁面
      if (mounted) {
        // 使用 Navigator 進行導向（稍後會在 Task 5 改用 go_router）
        Navigator.of(context).pushReplacementNamed('/management/basic');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '發生錯誤：${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('餐廳初始化設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // 帳號輸入欄位
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(
                  labelText: '餐廳帳號',
                  hintText: '請輸入餐廳的唯一識別帳號',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAccount,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              // 暱稱輸入欄位
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '餐廳暱稱',
                  hintText: '請輸入餐廳的顯示名稱',
                  border: OutlineInputBorder(),
                ),
                validator: _validateNickname,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),
              // 錯誤訊息顯示
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // 確認按鈕
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('確認'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
