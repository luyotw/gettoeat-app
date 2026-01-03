// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Store _$StoreFromJson(Map<String, dynamic> json) {
  return _Store.fromJson(json);
}

/// @nodoc
mixin _$Store {
  int get id => throw _privateConstructorUsedError;
  String get account => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get dateChangeAt => throw _privateConstructorUsedError;
  String? get paymentMethods => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Store to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreCopyWith<Store> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreCopyWith<$Res> {
  factory $StoreCopyWith(Store value, $Res Function(Store) then) =
      _$StoreCopyWithImpl<$Res, Store>;
  @useResult
  $Res call({
    int id,
    String account,
    String? nickname,
    String? dateChangeAt,
    String? paymentMethods,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$StoreCopyWithImpl<$Res, $Val extends Store>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? account = null,
    Object? nickname = freezed,
    Object? dateChangeAt = freezed,
    Object? paymentMethods = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            account: null == account
                ? _value.account
                : account // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: freezed == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateChangeAt: freezed == dateChangeAt
                ? _value.dateChangeAt
                : dateChangeAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMethods: freezed == paymentMethods
                ? _value.paymentMethods
                : paymentMethods // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoreImplCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$$StoreImplCopyWith(
    _$StoreImpl value,
    $Res Function(_$StoreImpl) then,
  ) = __$$StoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String account,
    String? nickname,
    String? dateChangeAt,
    String? paymentMethods,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$StoreImplCopyWithImpl<$Res>
    extends _$StoreCopyWithImpl<$Res, _$StoreImpl>
    implements _$$StoreImplCopyWith<$Res> {
  __$$StoreImplCopyWithImpl(
    _$StoreImpl _value,
    $Res Function(_$StoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? account = null,
    Object? nickname = freezed,
    Object? dateChangeAt = freezed,
    Object? paymentMethods = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$StoreImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        account: null == account
            ? _value.account
            : account // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: freezed == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateChangeAt: freezed == dateChangeAt
            ? _value.dateChangeAt
            : dateChangeAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMethods: freezed == paymentMethods
            ? _value.paymentMethods
            : paymentMethods // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreImpl implements _Store {
  const _$StoreImpl({
    required this.id,
    required this.account,
    this.nickname,
    this.dateChangeAt,
    this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$StoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreImplFromJson(json);

  @override
  final int id;
  @override
  final String account;
  @override
  final String? nickname;
  @override
  final String? dateChangeAt;
  @override
  final String? paymentMethods;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Store(id: $id, account: $account, nickname: $nickname, dateChangeAt: $dateChangeAt, paymentMethods: $paymentMethods, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.dateChangeAt, dateChangeAt) ||
                other.dateChangeAt == dateChangeAt) &&
            (identical(other.paymentMethods, paymentMethods) ||
                other.paymentMethods == paymentMethods) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    account,
    nickname,
    dateChangeAt,
    paymentMethods,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      __$$StoreImplCopyWithImpl<_$StoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreImplToJson(this);
  }
}

abstract class _Store implements Store {
  const factory _Store({
    required final int id,
    required final String account,
    final String? nickname,
    final String? dateChangeAt,
    final String? paymentMethods,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$StoreImpl;

  factory _Store.fromJson(Map<String, dynamic> json) = _$StoreImpl.fromJson;

  @override
  int get id;
  @override
  String get account;
  @override
  String? get nickname;
  @override
  String? get dateChangeAt;
  @override
  String? get paymentMethods;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
