// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buffet_mode_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuffetModeObjectBoxStruct _$BuffetModeObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    BuffetModeObjectBoxStruct(
      guid_fixed: json['guid_fixed'] as String,
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>).map((e) => e as String).toList(),
      adultPrice: (json['adultPrice'] as num).toDouble(),
      childPrice: (json['childPrice'] as num).toDouble(),
      maxMinute: json['maxMinute'] as int,
    )..id = json['id'] as int;

Map<String, dynamic> _$BuffetModeObjectBoxStructToJson(
        BuffetModeObjectBoxStruct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid_fixed': instance.guid_fixed,
      'code': instance.code,
      'names': instance.names,
      'adultPrice': instance.adultPrice,
      'childPrice': instance.childPrice,
      'maxMinute': instance.maxMinute,
    };
