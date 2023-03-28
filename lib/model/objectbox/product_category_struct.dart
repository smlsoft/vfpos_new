import 'package:dedepos/model/json/language_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProductCategoryObjectBoxStruct {
  @Id()
  int id = 0;

  /// Guid สำหรับอ้างอิง
  @Unique()
  String guid_fixed;

  /// ชื่อกลุ่มสินค้า (ภาษา 1)
  List<String> names;

  /// url รูปภาพกลุ่มสินค้า
  String image_url;

  /// รหัสกลุ่มสินค้าหลัก (กรณีมีการกำหนดกลุ่มสินค้าหลัก)
  @Index(type: IndexType.value)
  String parent_category_guid;

  /// จำนวนสินค้าในกลุ่ม (Query Sum)
  double product_count;

  /// จำนวนกลุ่มลูก (Query Sum)
  int category_count;

  /// ลำดับการแสดงผล
  int xorder;

  /// True=Image,False=Color
  bool useimageorcolor;

  /// สีที่เลือก
  String colorselect;

  /// สีที่เลือก (Hex)
  String colorselecthex;

  // Json รายการสินค้าย่อย
  String codelist;

  ProductCategoryObjectBoxStruct(
      {required this.guid_fixed,
      required this.names,
      required this.image_url,
      required this.parent_category_guid,
      required this.product_count,
      required this.category_count,
      required this.xorder,
      required this.useimageorcolor,
      required this.colorselect,
      required this.colorselecthex,
      required this.codelist});
}
