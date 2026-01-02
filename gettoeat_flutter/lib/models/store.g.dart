// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreImpl _$$StoreImplFromJson(Map<String, dynamic> json) => _$StoreImpl(
  id: (json['id'] as num).toInt(),
  account: json['account'] as String,
  nickname: json['nickname'] as String?,
  dateChangeAt: json['dateChangeAt'] as String?,
  paymentMethods: json['paymentMethods'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$StoreImplToJson(_$StoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'nickname': instance.nickname,
      'dateChangeAt': instance.dateChangeAt,
      'paymentMethods': instance.paymentMethods,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
