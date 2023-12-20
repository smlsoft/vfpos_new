// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posterminal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Posterminal _$$_PosterminalFromJson(Map<String, dynamic> json) =>
    _$_Posterminal(
      shopid: json['shopid'] as String? ?? '',
      guidfixed: json['guidfixed'] as String? ?? '',
      name: json['name'] as String? ?? '',
      name1: json['name1'] as String? ?? '',
      branchcode: json['branchcode'] as String? ?? '',
      role: json['role'] as int? ?? 0,
      isfavorite: json['isfavorite'] as bool? ?? false,
      lastaccessedat: json['lastaccessedat'] as String? ?? '',
    );

Map<String, dynamic> _$$_PosterminalToJson(_$_Posterminal instance) =>
    <String, dynamic>{
      'shopid': instance.shopid,
      'guidfixed': instance.guidfixed,
      'name': instance.name,
      'name1': instance.name1,
      'branchcode': instance.branchcode,
      'role': instance.role,
      'isfavorite': instance.isfavorite,
      'lastaccessedat': instance.lastaccessedat,
    };
