// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneStruct _$ZoneStructFromJson(Map<String, dynamic> json) => ZoneStruct(
      guidfixed: json['guidfixed'] as String? ?? "",
      code: json['code'] as String? ?? "",
      name1: json['name1'] as String? ?? "",
    )..shopid = json['shopid'] as String;

Map<String, dynamic> _$ZoneStructToJson(ZoneStruct instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'code': instance.code,
      'name1': instance.name1,
      'shopid': instance.shopid,
    };
