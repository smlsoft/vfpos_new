// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return _Shop.fromJson(json);
}

/// @nodoc
mixin _$Shop {
  String get shopid => throw _privateConstructorUsedError;
  String get guidfixed => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get name1 => throw _privateConstructorUsedError;
  String get branchcode => throw _privateConstructorUsedError;
  int get role => throw _privateConstructorUsedError;
  bool get isfavorite => throw _privateConstructorUsedError;
  String get lastaccessedat => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShopCopyWith<Shop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCopyWith<$Res> {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) then) =
      _$ShopCopyWithImpl<$Res, Shop>;
  @useResult
  $Res call(
      {String shopid,
      String guidfixed,
      String name,
      String name1,
      String branchcode,
      int role,
      bool isfavorite,
      String lastaccessedat});
}

/// @nodoc
class _$ShopCopyWithImpl<$Res, $Val extends Shop>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopid = null,
    Object? guidfixed = null,
    Object? name = null,
    Object? name1 = null,
    Object? branchcode = null,
    Object? role = null,
    Object? isfavorite = null,
    Object? lastaccessedat = null,
  }) {
    return _then(_value.copyWith(
      shopid: null == shopid
          ? _value.shopid
          : shopid // ignore: cast_nullable_to_non_nullable
              as String,
      guidfixed: null == guidfixed
          ? _value.guidfixed
          : guidfixed // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      name1: null == name1
          ? _value.name1
          : name1 // ignore: cast_nullable_to_non_nullable
              as String,
      branchcode: null == branchcode
          ? _value.branchcode
          : branchcode // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as int,
      isfavorite: null == isfavorite
          ? _value.isfavorite
          : isfavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      lastaccessedat: null == lastaccessedat
          ? _value.lastaccessedat
          : lastaccessedat // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ShopCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$$_ShopCopyWith(_$_Shop value, $Res Function(_$_Shop) then) =
      __$$_ShopCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shopid,
      String guidfixed,
      String name,
      String name1,
      String branchcode,
      int role,
      bool isfavorite,
      String lastaccessedat});
}

/// @nodoc
class __$$_ShopCopyWithImpl<$Res> extends _$ShopCopyWithImpl<$Res, _$_Shop>
    implements _$$_ShopCopyWith<$Res> {
  __$$_ShopCopyWithImpl(_$_Shop _value, $Res Function(_$_Shop) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopid = null,
    Object? guidfixed = null,
    Object? name = null,
    Object? name1 = null,
    Object? branchcode = null,
    Object? role = null,
    Object? isfavorite = null,
    Object? lastaccessedat = null,
  }) {
    return _then(_$_Shop(
      shopid: null == shopid
          ? _value.shopid
          : shopid // ignore: cast_nullable_to_non_nullable
              as String,
      guidfixed: null == guidfixed
          ? _value.guidfixed
          : guidfixed // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      name1: null == name1
          ? _value.name1
          : name1 // ignore: cast_nullable_to_non_nullable
              as String,
      branchcode: null == branchcode
          ? _value.branchcode
          : branchcode // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as int,
      isfavorite: null == isfavorite
          ? _value.isfavorite
          : isfavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      lastaccessedat: null == lastaccessedat
          ? _value.lastaccessedat
          : lastaccessedat // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Shop implements _Shop {
  const _$_Shop(
      {this.shopid = '',
      this.guidfixed = '',
      this.name = '',
      this.name1 = '',
      this.branchcode = '',
      this.role = 0,
      this.isfavorite = false,
      this.lastaccessedat = ''});

  factory _$_Shop.fromJson(Map<String, dynamic> json) => _$$_ShopFromJson(json);

  @override
  @JsonKey()
  final String shopid;
  @override
  @JsonKey()
  final String guidfixed;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String name1;
  @override
  @JsonKey()
  final String branchcode;
  @override
  @JsonKey()
  final int role;
  @override
  @JsonKey()
  final bool isfavorite;
  @override
  @JsonKey()
  final String lastaccessedat;

  @override
  String toString() {
    return 'Shop(shopid: $shopid, guidfixed: $guidfixed, name: $name, name1: $name1, branchcode: $branchcode, role: $role, isfavorite: $isfavorite, lastaccessedat: $lastaccessedat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Shop &&
            (identical(other.shopid, shopid) || other.shopid == shopid) &&
            (identical(other.guidfixed, guidfixed) ||
                other.guidfixed == guidfixed) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.name1, name1) || other.name1 == name1) &&
            (identical(other.branchcode, branchcode) ||
                other.branchcode == branchcode) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isfavorite, isfavorite) ||
                other.isfavorite == isfavorite) &&
            (identical(other.lastaccessedat, lastaccessedat) ||
                other.lastaccessedat == lastaccessedat));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, shopid, guidfixed, name, name1,
      branchcode, role, isfavorite, lastaccessedat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ShopCopyWith<_$_Shop> get copyWith =>
      __$$_ShopCopyWithImpl<_$_Shop>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ShopToJson(
      this,
    );
  }
}

abstract class _Shop implements Shop {
  const factory _Shop(
      {final String shopid,
      final String guidfixed,
      final String name,
      final String name1,
      final String branchcode,
      final int role,
      final bool isfavorite,
      final String lastaccessedat}) = _$_Shop;

  factory _Shop.fromJson(Map<String, dynamic> json) = _$_Shop.fromJson;

  @override
  String get shopid;
  @override
  String get guidfixed;
  @override
  String get name;
  @override
  String get name1;
  @override
  String get branchcode;
  @override
  int get role;
  @override
  bool get isfavorite;
  @override
  String get lastaccessedat;
  @override
  @JsonKey(ignore: true)
  _$$_ShopCopyWith<_$_Shop> get copyWith => throw _privateConstructorUsedError;
}
