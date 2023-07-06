// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableProcessObjectBoxStruct _$TableProcessObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    TableProcessObjectBoxStruct(
      guidfixed: json['guidfixed'] as String,
      number: json['number'] as String,
      names: json['names'] as String,
      zone: json['zone'] as String,
      table_status: json['table_status'] as int,
      order_count: (json['order_count'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      order_success: json['order_success'] as bool,
      qr_code: json['qr_code'] as String,
      table_open_datetime:
          DateTime.parse(json['table_open_datetime'] as String),
      man_count: json['man_count'] as int,
      woman_count: json['woman_count'] as int,
      child_count: json['child_count'] as int,
      table_al_la_crate_mode: json['table_al_la_crate_mode'] as bool,
      buffet_code: json['buffet_code'] as String,
    )..id = json['id'] as int;

Map<String, dynamic> _$TableProcessObjectBoxStructToJson(
        TableProcessObjectBoxStruct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guidfixed': instance.guidfixed,
      'number': instance.number,
      'names': instance.names,
      'zone': instance.zone,
      'table_status': instance.table_status,
      'order_count': instance.order_count,
      'amount': instance.amount,
      'order_success': instance.order_success,
      'table_open_datetime': instance.table_open_datetime.toIso8601String(),
      'qr_code': instance.qr_code,
      'man_count': instance.man_count,
      'woman_count': instance.woman_count,
      'child_count': instance.child_count,
      'table_al_la_crate_mode': instance.table_al_la_crate_mode,
      'buffet_code': instance.buffet_code,
    };
