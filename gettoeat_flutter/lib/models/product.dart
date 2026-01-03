import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// 商品資料模型
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    @JsonKey(name: 'store_id') required int storeId,
    @JsonKey(name: 'category_id') required int categoryId,
    required String name,
    required double price,
    required int position,
    required int off,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      storeId: map['store_id'] as int,
      categoryId: map['category_id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      position: map['position'] as int,
      off: map['off'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  const Product._();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'position': position,
      'off': off,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
