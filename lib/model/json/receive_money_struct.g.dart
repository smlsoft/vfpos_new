// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_money_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiveMoneyStruct _$ReceiveMoneyStructFromJson(Map<String, dynamic> json) =>
    ReceiveMoneyStruct(
      create_date_time: DateTime.parse(json['create_date_time'] as String),
      doc_number: json['doc_number'] as String? ?? "",
      person_code: json['person_code'] as String? ?? "",
      receive_money: (json['receive_money'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ReceiveMoneyStructToJson(ReceiveMoneyStruct instance) =>
    <String, dynamic>{
      'create_date_time': instance.create_date_time.toIso8601String(),
      'doc_number': instance.doc_number,
      'person_code': instance.person_code,
      'receive_money': instance.receive_money,
    };
