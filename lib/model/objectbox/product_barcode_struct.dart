// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';
import 'package:dedepos/model/objectbox/product_option.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProductBarcodeObjectBoxStruct {
  int id = 0;

  /// Barcode สินค้า
  @Unique()
  String barcode;

  /// ชื่อสินค้า
  List<String> names;

  /// ชื่อสินค้าทั้งหมด (เอาไว้ค้นหา)
  String name_all;

  /// รหัสกลุ่มสินค้า
  String group_code;

  /// ลำดับในกลุ่มสินค้า
  int category_index;

  /// GUID อ้างอิง
  String guid_fixed;

  /// GUID อ้างอิง
  String item_guid;

  /// รายละเอียดสินค้า
  List<String> descriptions;

  /// รหัสสินค้า
  String item_code;

  /// รหัสหน่วยนับ
  String item_unit_code;

  /// รหัสหน่วยนับ
  String unit_code = "";

  /// ชื่อหน่วยนับ
  List<String> unit_names;

  /// ราคาขายสินค้า
  List<String> prices;

  /// ขึ้นบรรทัดใหม่
  int new_line;

  /// นับจำนวนที่เลือกแล้ว
  double product_count;

  /// ตัวเลือกพิเศษ ProductOptionStruct
  String options_json;

  /// รูปภาพสินค้า
  String images_url;

  /// ใช้รูปหรือสี True=Image,False=Color
  bool image_or_color;

  /// สีที่เลือก
  String color_select;

  /// สีที่เลือก (Hex)
  String color_select_hex;

  String parent_group_guid;

  int group_count;

  ProductBarcodeObjectBoxStruct(
      {required this.barcode,
      required this.names,
      required this.name_all,
      required this.group_code,
      required this.category_index,
      required this.guid_fixed,
      required this.item_guid,
      required this.descriptions,
      required this.item_code,
      required this.item_unit_code,
      required this.unit_names,
      required this.prices,
      required this.new_line,
      required this.unit_code,
      required this.options_json,
      required this.images_url,
      required this.parent_group_guid,
      required this.group_count,
      required this.image_or_color,
      required this.color_select,
      required this.color_select_hex,
      required this.product_count});

  List<ProductOptionStruct> options() {
    try {
      return jsonDecode(options_json)
          .map<ProductOptionStruct>((e) => ProductOptionStruct.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}