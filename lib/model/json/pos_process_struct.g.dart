// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_process_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosProcessDetailStruct _$PosProcessDetailStructFromJson(
        Map<String, dynamic> json) =>
    PosProcessDetailStruct(
      guid: json['guid'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      barcode: json['barcode'] as String? ?? '',
      item_code: json['item_code'] as String? ?? '',
      item_name: json['item_name'] as String? ?? '',
      unit_code: json['unit_code'] as String? ?? '',
      unit_name: json['unit_name'] as String? ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discount_text: json['discount_text'] as String? ?? '',
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      total_amount_with_extra:
          (json['total_amount_with_extra'] as num?)?.toDouble() ?? 0,
      is_void: json['is_void'] as bool? ?? false,
      remark: json['remark'] as String? ?? "",
      image_url: json['image_url'] as String? ?? "",
      extra: (json['extra'] as List<dynamic>)
          .map((e) =>
              PosProcessDetailExtraStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      category_guid: json['category_guid'] as String? ?? "",
    );

Map<String, dynamic> _$PosProcessDetailStructToJson(
        PosProcessDetailStruct instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'index': instance.index,
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'price': instance.price,
      'discount_text': instance.discount_text,
      'discount': instance.discount,
      'total_amount': instance.total_amount,
      'total_amount_with_extra': instance.total_amount_with_extra,
      'is_void': instance.is_void,
      'remark': instance.remark,
      'image_url': instance.image_url,
      'category_guid': instance.category_guid,
      'extra': instance.extra,
    };

PosProcessDetailExtraStruct _$PosProcessDetailExtraStructFromJson(
        Map<String, dynamic> json) =>
    PosProcessDetailExtraStruct(
      guid_auto_fixed: json['guid_auto_fixed'] as String? ?? '',
      guid_category: json['guid_category'] as String? ?? '',
      guid_code_or_ref: json['guid_code_or_ref'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      barcode: json['barcode'] as String? ?? '',
      item_code: json['item_code'] as String? ?? '',
      item_name: json['item_name'] as String? ?? '',
      unit_code: json['unit_code'] as String? ?? '',
      unit_name: json['unit_name'] as String? ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      qty_fixed: (json['qty_fixed'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      is_void: json['is_void'] as bool? ?? false,
    );

Map<String, dynamic> _$PosProcessDetailExtraStructToJson(
        PosProcessDetailExtraStruct instance) =>
    <String, dynamic>{
      'guid_auto_fixed': instance.guid_auto_fixed,
      'guid_code_or_ref': instance.guid_code_or_ref,
      'guid_category': instance.guid_category,
      'index': instance.index,
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'qty_fixed': instance.qty_fixed,
      'price': instance.price,
      'total_amount': instance.total_amount,
      'is_void': instance.is_void,
    };

PosProcessPromotionStruct _$PosProcessPromotionStructFromJson(
        Map<String, dynamic> json) =>
    PosProcessPromotionStruct(
      promotion_name: json['promotion_name'] as String,
      discount_word: json['discount_word'] as String,
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$PosProcessPromotionStructToJson(
        PosProcessPromotionStruct instance) =>
    <String, dynamic>{
      'promotion_name': instance.promotion_name,
      'discount_word': instance.discount_word,
      'discount': instance.discount,
    };

PosProcessStruct _$PosProcessStructFromJson(Map<String, dynamic> json) =>
    PosProcessStruct(
      total_piece: (json['total_piece'] as num?)?.toDouble() ?? 0.0,
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      total_discount_from_promotion:
          (json['total_discount_from_promotion'] as num?)?.toDouble() ?? 0,
      active_line_number: json['active_line_number'] as int? ?? -1,
      customer_code: json['customer_code'] as String? ?? "",
      customer_name: json['customer_name'] as String? ?? "",
      customer_phone: json['customer_phone'] as String? ?? "",
      qr_code: json['qr_code'] as String? ?? "",
      details: (json['details'] as List<dynamic>)
          .map(
              (e) => PosProcessDetailStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      select_promotion_temp_list: (json['select_promotion_temp_list']
              as List<dynamic>)
          .map((e) => PromotionTempStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      promotion_list: (json['promotion_list'] as List<dynamic>)
          .map((e) =>
              PosProcessPromotionStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PosProcessStructToJson(PosProcessStruct instance) =>
    <String, dynamic>{
      'customer_code': instance.customer_code,
      'customer_name': instance.customer_name,
      'customer_phone': instance.customer_phone,
      'total_piece': instance.total_piece,
      'total_amount': instance.total_amount,
      'total_discount_from_promotion': instance.total_discount_from_promotion,
      'active_line_number': instance.active_line_number,
      'qr_code': instance.qr_code,
      'details': instance.details,
      'select_promotion_temp_list': instance.select_promotion_temp_list,
      'promotion_list': instance.promotion_list,
    };
