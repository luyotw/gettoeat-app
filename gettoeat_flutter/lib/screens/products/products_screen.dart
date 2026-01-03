import 'package:flutter/material.dart';
import 'package:gettoeat_flutter/screens/products/category_list_widget.dart';
import 'package:gettoeat_flutter/screens/products/product_list_widget.dart';

/// 商品列表頁面
/// 整合分類列表和商品列表，為 POS 點餐功能提供商品展示
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品列表'),
      ),
      body: Column(
        children: [
          // 分類列表
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const CategoryListWidget(),
          ),
          // 商品列表
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: const ProductListWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
