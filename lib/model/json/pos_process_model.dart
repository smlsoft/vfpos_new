// ignore_for_file: non_constant_identifier_names

import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/api/sync/model/promotion_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pos_process_model.g.dart';

@JsonSerializable()
class PosProcessDetailModel {
  late String guid;
  late int index;
  late String barcode;
  late String item_code;
  late String item_name;
  late String unit_code;
  late String unit_name;
  late double qty;
  late double price;
  late double price_original;
  late String discount_text;
  late double discount;
  late double total_amount;
  late double total_amount_with_extra;
  late bool is_void;
  late String remark;
  late String image_url;
  late List<PosProcessDetailExtraModel> extra;

  PosProcessDetailModel({
    this.guid = '',
    this.index = 0,
    this.barcode = '',
    this.item_code = '',
    this.item_name = '',
    this.unit_code = '',
    this.unit_name = '',
    this.qty = 0,
    this.price = 0,
    this.price_original = 0,
    this.discount_text = '',
    this.discount = 0,
    this.total_amount = 0,
    this.total_amount_with_extra = 0,
    this.is_void = false,
    this.remark = "",
    this.image_url = "",
    required this.extra,
  });

  factory PosProcessDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PosProcessDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessDetailModelToJson(this);
}

@JsonSerializable()
class PosProcessDetailExtraModel {
  late String guid_auto_fixed;
  late String guid_code_or_ref;
  late String guid_category;
  late int index;
  late String barcode;
  late String item_code;
  late String item_name;
  late String unit_code;
  late String unit_name;
  late double qty;
  late double qty_fixed;
  late double price;
  late double total_amount;
  late bool is_void;

  PosProcessDetailExtraModel(
      {this.guid_auto_fixed = '',
      this.guid_category = '',
      this.guid_code_or_ref = '',
      this.index = 0,
      this.barcode = '',
      this.item_code = '',
      this.item_name = '',
      this.unit_code = '',
      this.unit_name = '',
      this.qty = 0,
      this.qty_fixed = 0,
      this.price = 0,
      this.total_amount = 0,
      this.is_void = false});

  factory PosProcessDetailExtraModel.fromJson(Map<String, dynamic> json) =>
      _$PosProcessDetailExtraModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessDetailExtraModelToJson(this);
}

@JsonSerializable()
class PosProcessPromotionModel {
  late String promotion_name;
  late String discount_word;
  late double discount;

  PosProcessPromotionModel(
      {required this.promotion_name,
      required this.discount_word,
      required this.discount});

  factory PosProcessPromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PosProcessPromotionModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessPromotionModelToJson(this);
}

@JsonSerializable()
class PosProcessModel {
  late String customer_code;
  late String customer_name;
  late String customer_phone;
  late double total_piece;
  late double total_amount;
  late double total_discount_from_promotion;
  late String qr_code;
  late List<PosProcessDetailModel> details;
  late List<PromotionTempModel> select_promotion_temp_list;
  late List<PosProcessPromotionModel> promotion_list;

  PosProcessModel(
      {this.total_piece = 0.0,
      this.total_amount = 0.0,
      this.total_discount_from_promotion = 0,
      this.qr_code = "",
      this.details = const [],
      this.select_promotion_temp_list = const [],
      this.promotion_list = const []});

  factory PosProcessModel.fromJson(Map<String, dynamic> json) =>
      _$PosProcessModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessModelToJson(this);
}
