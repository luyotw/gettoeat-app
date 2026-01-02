import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

/// 餐廳資料模型
@freezed
class Store with _$Store {
  const factory Store({
    required int id,
    required String account,
    String? nickname,
    String? dateChangeAt,
    String? paymentMethods,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
