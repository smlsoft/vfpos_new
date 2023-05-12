// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Shop _$$_ShopFromJson(Map<String, dynamic> json) => _$_Shop(
      shopid: json['shopid'] as String? ?? '',
      guidfixed: json['guidfixed'] as String? ?? '',
      name: json['name'] as String? ?? '',
      name1: json['name1'] as String? ?? '',
      branchcode: json['branchcode'] as String? ?? '',
      role: json['role'] as int? ?? 0,
      isfavorite: json['isfavorite'] as bool? ?? false,
      lastaccessedat: json['lastaccessedat'] as String? ?? '',
    );

Map<String, dynamic> _$$_ShopToJson(_$_Shop instance) => <String, dynamic>{
      'shopid': instance.shopid,
      'guidfixed': instance.guidfixed,
      'name': instance.name,
      'name1': instance.name1,
      'branchcode': instance.branchcode,
      'role': instance.role,
      'isfavorite': instance.isfavorite,
      'lastaccessedat': instance.lastaccessedat,
    };
