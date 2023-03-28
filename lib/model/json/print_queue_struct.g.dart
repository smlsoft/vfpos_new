// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_queue_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintQueueStruct _$PrintQueueStructFromJson(Map<String, dynamic> json) =>
    PrintQueueStruct(
      code: json['code'] as int,
      doc_number: json['doc_number'] as String,
      line_number: json['line_number'] as int? ?? 0,
      printer_code: json['printer_code'] as String,
    )..guid = json['guid'] as String;

Map<String, dynamic> _$PrintQueueStructToJson(PrintQueueStruct instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'code': instance.code,
      'doc_number': instance.doc_number,
      'line_number': instance.line_number,
      'printer_code': instance.printer_code,
    };
