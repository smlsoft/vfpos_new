// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_process_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosProcessDetailModel _$PosProcessDetailModelFromJson(
        Map<String, dynamic> json) =>
    PosProcessDetailModel(
      guid: json['guid'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      barcode: json['barcode'] as String? ?? '',
      item_code: json['item_code'] as String? ?? '',
      item_name: json['item_name'] as String? ?? '',
      unit_code: json['unit_code'] as String? ?? '',
      unit_name: json['unit_name'] as String? ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      price_original: (json['price_original'] as num?)?.toDouble() ?? 0,
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
              PosProcessDetailExtraModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PosProcessDetailModelToJson(
        PosProcessDetailModel instance) =>
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
      'price_original': instance.price_original,
      'discount_text': instance.discount_text,
      'discount': instance.discount,
      'total_amount': instance.total_amount,
      'total_amount_with_extra': instance.total_amount_with_extra,
      'is_void': instance.is_void,
      'remark': instance.remark,
      'image_url': instance.image_url,
      'extra': instance.extra,
    };

PosProcessDetailExtraModel _$PosProcessDetailExtraModelFromJson(
        Map<String, dynamic> json) =>
    PosProcessDetailExtraModel(
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

Map<String, dynamic> _$PosProcessDetailExtraModelToJson(
        PosProcessDetailExtraModel instance) =>
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

PosProcessPromotionModel _$PosProcessPromotionModelFromJson(
        Map<String, dynamic> json) =>
    PosProcessPromotionModel(
      promotion_name: json['promotion_name'] as String,
      discount_word: json['discount_word'] as String,
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$PosProcessPromotionModelToJson(
        PosProcessPromotionModel instance) =>
    <String, dynamic>{
      'promotion_name': instance.promotion_name,
      'discount_word': instance.discount_word,
      'discount': instance.discount,
    };

PosProcessModel _$PosProcessModelFromJson(Map<String, dynamic> json) =>
    PosProcessModel(
      total_piece: (json['total_piece'] as num?)?.toDouble() ?? 0.0,
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      total_discount_from_promotion:
          (json['total_discount_from_promotion'] as num?)?.toDouble() ?? 0,
      qr_code: json['qr_code'] as String? ?? "",
      details: (json['details'] as List<dynamic>?)
              ?.map((e) =>
                  PosProcessDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      select_promotion_temp_list: (json['select_promotion_temp_list']
                  as List<dynamic>?)
              ?.map(
                  (e) => PromotionTempModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      promotion_list: (json['promotion_list'] as List<dynamic>?)
              ?.map((e) =>
                  PosProcessPromotionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PosProcessModelToJson(PosProcessModel instance) =>
    <String, dynamic>{
      'total_piece': instance.total_piece,
      'total_amount': instance.total_amount,
      'total_discount_from_promotion': instance.total_discount_from_promotion,
      'qr_code': instance.qr_code,
      'details': instance.details,
      'select_promotion_temp_list': instance.select_promotion_temp_list,
      'promotion_list': instance.promotion_list,
    };
