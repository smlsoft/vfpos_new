// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_category_struct.g.dart';

@JsonSerializable()
@Entity()
class ProductCategoryObjectBoxStruct {
  @Id()
  int id = 0;

  /// Guid สำหรับอ้างอิง
  @Unique()
  String guid_fixed;

  String parent_guid_fixed;

  /// ชื่อกลุ่มสินค้า
  String names;

  /// url รูปภาพกลุ่มสินค้า
  String image_url;

  /// True=Image,False=Color
  bool use_image_or_color;

  /// สีที่เลือก
  String colorselect;

  /// สีที่เลือก (Hex)
  String colorselecthex;

  // Json รายการสินค้าย่อย
  String codelist;

  int xorder;

  int category_count;

  ProductCategoryObjectBoxStruct(
      {required this.guid_fixed,
      required this.parent_guid_fixed,
      required this.names,
      required this.image_url,
      required this.category_count,
      required this.use_image_or_color,
      required this.xorder,
      required this.colorselect,
      required this.colorselecthex,
      required this.codelist});

  factory ProductCategoryObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryObjectBoxStructToJson(this);
}
