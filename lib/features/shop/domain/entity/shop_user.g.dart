// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'shop_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ShopUser _$$_ShopUserFromJson(Map<String, dynamic> json) => _$_ShopUser(
      shopid: json['shopid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      branchcode: json['branchcode'] as String? ?? '',
      role: json['role'] as int? ?? 0,
      isfavorite: json['isfavorite'] as bool? ?? false,
      lastaccessedat: json['lastaccessedat'] as String? ?? '',
    );

Map<String, dynamic> _$$_ShopUserToJson(_$_ShopUser instance) =>
    <String, dynamic>{
      'shopid': instance.shopid,
      'name': instance.name,
      'branchcode': instance.branchcode,
      'role': instance.role,
      'isfavorite': instance.isfavorite,
      'lastaccessedat': instance.lastaccessedat,
    };
