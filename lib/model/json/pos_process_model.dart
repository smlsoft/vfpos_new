// ignore_for_file: non_constant_identifier_names

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
  late bool exclude_vat;
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
    this.exclude_vat = false,
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
  /// จำนวนชิ้น
  double total_piece;

  /// ยอดรวมภาษี
  double total_vat_amount;

  /// ยอดรวมทั้งสิ้น (มีภาษี และ ยกเว้นภาษี)
  double total_amount;

  /// ยอดรวม Promotion
  double total_discount_from_promotion;

  // Qr Code
  String qr_code;

  /// อัตราภาษี
  double vat_rate;

  /// ยอดรวมสินค้ามีภาษี
  double total_item_vat_amount;

  /// ยอดรวมสินค้ายกเว้นภาษี
  double total_item_except_amount;

  /// รายการสินค้า
  List<PosProcessDetailModel> details;

  /// รายการ Promotion
  List<PromotionTempModel> select_promotion_temp_list;

  /// รายการ Promotion ที่เลือก
  List<PosProcessPromotionModel> promotion_list;

  /// 1=ภาษีมูลค่าเพิ่มรวมใน,2=ภาษีมูลค่าเพิ่มแยกนอก
  int vat_mode;

  /// สูตรส่วนลดท้ายบิล
  String discount_formula;

  /// ส่วนลดทั้งหมด (ท้ายบิล)
  double total_discount;

  /// ส่วนลดสินค้ามีภาษี
  double total_discount_vat_amount;

  /// ส่วนลดสินค้ายกเว้นภาษี
  double total_discount_except_vat_amount;

  /// ยอดรวมสินค้ามีภาษี หลังหักส่วนลด
  double total_item_vat_after_discount_amount;

  // ยอดรวมสินค้ายกเว้นภาษี หลังหักส่วนลด
  double total_item_except_vat_after_discount_amount;

  /// ยอดรวมก่อนคำนวณภาษีสินค้ามีภาษี
  double total_calc_vat_amount;

  /// ยอดรวมก่อนคำนวณภาษีสินค้ายกเว้น
  double total_calc_except_vat_amount;

  PosProcessModel(
      {this.total_piece = 0.0,
      this.total_amount = 0.0,
      this.total_discount_from_promotion = 0,
      this.qr_code = "",
      this.vat_rate = 0,
      this.total_vat_amount = 0,
      this.total_item_vat_amount = 0,
      this.total_item_except_amount = 0,
      this.details = const [],
      this.select_promotion_temp_list = const [],
      this.vat_mode = 1,
      this.discount_formula = "",
      this.total_discount = 0,
      this.total_discount_vat_amount = 0,
      this.total_discount_except_vat_amount = 0,
      this.total_item_vat_after_discount_amount = 0,
      this.total_item_except_vat_after_discount_amount = 0,
      this.total_calc_vat_amount = 0,
      this.total_calc_except_vat_amount = 0,
      this.promotion_list = const []});

  factory PosProcessModel.fromJson(Map<String, dynamic> json) =>
      _$PosProcessModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessModelToJson(this);
}
