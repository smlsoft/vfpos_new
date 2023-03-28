// ignore_for_file: non_constant_identifier_names

import 'package:dedepos/model/pos_pay_struct.dart';
import 'package:dedepos/api/sync/model/promotion_struct.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pos_process_struct.g.dart';

class PosHoldStruct {
  int countLog = 0;
  String saleCode = "";
  PayStruct payScreenData = PayStruct();
}

@JsonSerializable()
class PosProcessDetailStruct {
  late String guid;
  late int index;
  late String barcode;
  late String item_code;
  late String item_name;
  late String unit_code;
  late String unit_name;
  late double qty;
  late double price;
  late String discount_text;
  late double discount;
  late double total_amount;
  late double total_amount_with_extra;
  late bool is_void;
  late String remark;
  late String image_url;
  late String category_guid;
  late List<PosProcessDetailExtraStruct> extra;

  PosProcessDetailStruct(
      {this.guid = '',
      this.index = 0,
      this.barcode = '',
      this.item_code = '',
      this.item_name = '',
      this.unit_code = '',
      this.unit_name = '',
      this.qty = 0,
      this.price = 0,
      this.discount_text = '',
      this.discount = 0,
      this.total_amount = 0,
      this.total_amount_with_extra = 0,
      this.is_void = false,
      this.remark = "",
      this.image_url = "",
      required this.extra,
      this.category_guid = ""});

  factory PosProcessDetailStruct.fromJson(Map<String, dynamic> json) =>
      _$PosProcessDetailStructFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessDetailStructToJson(this);
}

@JsonSerializable()
class PosProcessDetailExtraStruct {
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

  PosProcessDetailExtraStruct(
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

  factory PosProcessDetailExtraStruct.fromJson(Map<String, dynamic> json) =>
      _$PosProcessDetailExtraStructFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessDetailExtraStructToJson(this);
}

@JsonSerializable()
class PosProcessPromotionStruct {
  late String promotion_name;
  late String discount_word;
  late double discount;

  PosProcessPromotionStruct(
      {required this.promotion_name,
      required this.discount_word,
      required this.discount});

  factory PosProcessPromotionStruct.fromJson(Map<String, dynamic> json) =>
      _$PosProcessPromotionStructFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessPromotionStructToJson(this);
}

@JsonSerializable()
class PosProcessStruct {
  late String customer_code;
  late String customer_name;
  late String customer_phone;
  late double total_piece;
  late double total_amount;
  late double total_discount_from_promotion;
  late int active_line_number;
  late String qr_code;
  late List<PosProcessDetailStruct> details;
  late List<PromotionTempStruct> select_promotion_temp_list;
  late List<PosProcessPromotionStruct> promotion_list;

  PosProcessStruct(
      {this.total_piece = 0.0,
      this.total_amount = 0.0,
      this.total_discount_from_promotion = 0,
      this.active_line_number = -1,
      this.customer_code = "",
      this.customer_name = "",
      this.customer_phone = "",
      this.qr_code = "",
      required this.details,
      required this.select_promotion_temp_list,
      required this.promotion_list});

  factory PosProcessStruct.fromJson(Map<String, dynamic> json) =>
      _$PosProcessStructFromJson(json);
  Map<String, dynamic> toJson() => _$PosProcessStructToJson(this);
}
