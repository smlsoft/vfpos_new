// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_log_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosLogObjectBoxStruct _$PosLogObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    PosLogObjectBoxStruct(
      id: json['id'] as int? ?? 0,
      doc_mode: json['doc_mode'] as int? ?? 1,
      guid_ref: json['guid_ref'] as String? ?? "",
      guid_code_ref: json['guid_code_ref'] as String? ?? "",
      log_date_time: DateTime.parse(json['log_date_time'] as String),
      hold_code: json['hold_code'] as String,
      command_code: json['command_code'] as int,
      barcode: json['barcode'] as String? ?? "",
      is_void: json['is_void'] as int? ?? 0,
      success: json['success'] as int? ?? 0,
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      qty_fixed: (json['qty_fixed'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      selected: json['selected'] as bool? ?? false,
      remark: json['remark'] as String? ?? "",
      name: json['name'] as String? ?? "",
      code: json['code'] as String? ?? "",
      default_code: json['default_code'] as String? ?? "",
      discount_text: json['discount_text'] as String? ?? "",
      extra_code: json['extra_code'] as String? ?? "",
      unit_code: json['unit_code'] as String? ?? "",
      unit_name: json['unit_name'] as String? ?? "",
      exclude_vat: json['exclude_vat'] as bool? ?? false,
    )..guid_auto_fixed = json['guid_auto_fixed'] as String;

Map<String, dynamic> _$PosLogObjectBoxStructToJson(
        PosLogObjectBoxStruct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid_auto_fixed': instance.guid_auto_fixed,
      'doc_mode': instance.doc_mode,
      'guid_ref': instance.guid_ref,
      'guid_code_ref': instance.guid_code_ref,
      'log_date_time': instance.log_date_time.toIso8601String(),
      'hold_code': instance.hold_code,
      'command_code': instance.command_code,
      'is_void': instance.is_void,
      'success': instance.success,
      'extra_code': instance.extra_code,
      'remark': instance.remark,
      'discount_text': instance.discount_text,
      'code': instance.code,
      'price': instance.price,
      'name': instance.name,
      'qty': instance.qty,
      'qty_fixed': instance.qty_fixed,
      'default_code': instance.default_code,
      'selected': instance.selected,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'barcode': instance.barcode,
      'exclude_vat': instance.exclude_vat,
    };
