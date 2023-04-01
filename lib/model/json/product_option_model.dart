// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'product_option_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductOptionModel {
  /// GUID อ้างอิง
  String guid_fixed;

  /// ประเภทข้อเลือก (0=Check Box,1=Radio Button)
  int choice_type = 0;

  /// เลือกได้สูงสุด (รายการ 1=Radio Button,2=Check Box)
  int max_select = 0;

  /// ชื่อข้อเลือก
  List<String> names;

  /// รายการข้อเลือก ProductChoiceStruct
  List<ProductChoiceModel> choices;

  /// ตัวเลือกที่เลือก
  int select_index = 0;

  ProductOptionModel(
      {required this.guid_fixed,
      required this.choice_type,
      required this.max_select,
      required this.names,
      required this.choices});

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductChoiceModel {
  /// GUID (ดึงจาก API)
  String guid_fixed;

  // GUID Code เชื่อมไปยัง Extra Process
  String guid_code;

  /// ข้อเลือกแรก
  bool is_default;

  /// Barcode สินค้า (กรณีมีการตัดสต๊อก)
  String barcode;

  /// รหัสสินค้า (กรณีมีการตัดสต๊อก)
  String product_code;

  /// รหัสหน่วยนับ (กรณีมีการตัดสต๊อก)
  String item_unit_code;

  /// ชื่อข้อเลือก
  List<String> names;

  /// ราคาขาย (คิดเพิ่ม)
  double price;

  /// จำนวนตัดสต๊อก (กรณีมีการตัดสต๊อก)
  double qty;

  /// เลือกแล้ว กรณีเป็น check box (True/False)
  bool selected;

  ProductChoiceModel({
    required this.guid_fixed,
    required this.product_code,
    required this.barcode,
    required this.is_default,
    required this.item_unit_code,
    required this.names,
    required this.guid_code,
    required this.price,
    required this.qty,
    required this.selected,
  });
  factory ProductChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductChoiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductChoiceModelToJson(this);
}
