// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ShopUser _$ShopUserFromJson(Map<String, dynamic> json) {
  return _ShopUser.fromJson(json);
}

/// @nodoc
mixin _$ShopUser {
  String get shopid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get branchcode => throw _privateConstructorUsedError;
  int get role => throw _privateConstructorUsedError;
  bool get isfavorite => throw _privateConstructorUsedError;
  String get lastaccessedat => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShopUserCopyWith<ShopUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopUserCopyWith<$Res> {
  factory $ShopUserCopyWith(ShopUser value, $Res Function(ShopUser) then) =
      _$ShopUserCopyWithImpl<$Res, ShopUser>;
  @useResult
  $Res call(
      {String shopid,
      String name,
      String branchcode,
      int role,
      bool isfavorite,
      String lastaccessedat});
}

/// @nodoc
class _$ShopUserCopyWithImpl<$Res, $Val extends ShopUser>
    implements $ShopUserCopyWith<$Res> {
  _$ShopUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopid = null,
    Object? name = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_ShopUserCopyWith<$Res> implements $ShopUserCopyWith<$Res> {
  factory _$$_ShopUserCopyWith(
          _$_ShopUser value, $Res Function(_$_ShopUser) then) =
      __$$_ShopUserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shopid,
      String name,
      String branchcode,
      int role,
      bool isfavorite,
      String lastaccessedat});
}

/// @nodoc
class __$$_ShopUserCopyWithImpl<$Res>
    extends _$ShopUserCopyWithImpl<$Res, _$_ShopUser>
    implements _$$_ShopUserCopyWith<$Res> {
  __$$_ShopUserCopyWithImpl(
      _$_ShopUser _value, $Res Function(_$_ShopUser) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopid = null,
    Object? name = null,
    Object? branchcode = null,
    Object? role = null,
    Object? isfavorite = null,
    Object? lastaccessedat = null,
  }) {
    return _then(_$_ShopUser(
      shopid: null == shopid
          ? _value.shopid
          : shopid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
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
class _$_ShopUser extends _ShopUser {
  const _$_ShopUser(
      {this.shopid = '',
      this.name = '',
      this.branchcode = '',
      this.role = 0,
      this.isfavorite = false,
      this.lastaccessedat = ''})
      : super._();

  factory _$_ShopUser.fromJson(Map<String, dynamic> json) =>
      _$$_ShopUserFromJson(json);

  @override
  @JsonKey()
  final String shopid;
  @override
  @JsonKey()
  final String name;
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
    return 'ShopUser(shopid: $shopid, name: $name, branchcode: $branchcode, role: $role, isfavorite: $isfavorite, lastaccessedat: $lastaccessedat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ShopUser &&
            (identical(other.shopid, shopid) || other.shopid == shopid) &&
            (identical(other.name, name) || other.name == name) &&
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
  int get hashCode => Object.hash(
      runtimeType, shopid, name, branchcode, role, isfavorite, lastaccessedat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ShopUserCopyWith<_$_ShopUser> get copyWith =>
      __$$_ShopUserCopyWithImpl<_$_ShopUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ShopUserToJson(
      this,
    );
  }
}

abstract class _ShopUser extends ShopUser {
  const factory _ShopUser(
      {final String shopid,
      final String name,
      final String branchcode,
      final int role,
      final bool isfavorite,
      final String lastaccessedat}) = _$_ShopUser;
  const _ShopUser._() : super._();

  factory _ShopUser.fromJson(Map<String, dynamic> json) = _$_ShopUser.fromJson;

  @override
  String get shopid;
  @override
  String get name;
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
  _$$_ShopUserCopyWith<_$_ShopUser> get copyWith =>
      throw _privateConstructorUsedError;
}
