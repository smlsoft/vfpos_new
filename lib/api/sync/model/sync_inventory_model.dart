import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sync_inventory_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SyncPriceDataModel {
  int keynumber;
  double price;

  SyncPriceDataModel({required this.keynumber, required this.price});

  factory SyncPriceDataModel.fromJson(Map<String, dynamic> json) =>
      _$SyncPriceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPriceDataModelToJson(this);
}

/// ข้อเลือกย่อยสินค้า
@JsonSerializable(explicitToJson: true)
class SyncProductChoiceModel {
  String guid;

  /// ชื่อข้อเลือกย่อย
  List<LanguageDataModel> names;

  /// ราคาข้อเลือกย่อย (เพิ่ม)
  String price;

  /// เลือกเป็นค่าเริ่มต้น (Defailt)
  bool isdefault;

  /// ตัดสต๊อกสินค้า
  bool isstock;

  /// อ้างอิง Barcode
  String refbarcode;

  /// อ้างอิงสินค้า เพื่อตัดสต๊อก
  String refproductcode;

  /// อ้างอิงหน่วยนับ เพื่อตัดสต๊อก
  String refunitcode;

  /// จำนวนเพื่อตัดสต๊อก
  double qty;

  SyncProductChoiceModel({
    required this.guid,
    required this.refbarcode,
    required this.refproductcode,
    required this.refunitcode,
    required this.names,
    required this.isstock,
    required this.price,
    required this.qty,
    required this.isdefault,
  });

  factory SyncProductChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$SyncProductChoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncProductChoiceModelToJson(this);
}

/// ข้อเลือกพิเศษ
@JsonSerializable(explicitToJson: true)
class SyncProductOptionModel {
  String guid;

  /// ประเภทข้อเลือก (0=Check Box,1=Radio Button)
  int choicetype;

  /// เลือกได้น้อยสุด
  int minselect;

  /// เลือกได้สูงสุด
  int maxselect;

  /// ชื่อข้อเลือกพิเศษ
  List<LanguageDataModel> names;

  /// รายการข้อเลือกย่อย
  List<SyncProductChoiceModel> choices;

  SyncProductOptionModel({
    required this.guid,
    required this.maxselect,
    required this.names,
    required this.minselect,
    required this.choices,
    required this.choicetype,
  });

  factory SyncProductOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SyncProductOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncProductOptionModelToJson(this);
}

@JsonSerializable()
class SyncProductBarcodeModel {
  /// guid ฐานข้อมูล
  String guidfixed;

  /// รหัสสินค้า
  String itemcode;

  /// guid กลุ่มสินค้า
  String? groupcode;

  /// ชื่อกลุ่มสินค้า
  List<LanguageDataModel>? groupname;

  /// Barcode
  String barcode;

  /// ชื่อสินค้า
  List<LanguageDataModel> names;

  /// รหัสหน่วยนับ
  String itemunitcode;

  /// ชื่อหน่วยนับ
  List<LanguageDataModel> itemunitnames;

  /// uri รูปภาพ
  String imageuri;

  /// ใช้รูปหรือสี True=Image,False=Color
  bool useimageorcolor;

  /// สีที่เลือก
  String colorselect;

  /// สีที่เลือก (Hex)
  String colorselecthex;

  /// ข้อเลือกสินค้า (เช่น เพิ่มไข่)
  List<SyncProductOptionModel>? options;

  List<SyncPriceDataModel>? prices;

  SyncProductBarcodeModel({
    required this.guidfixed,
    required this.groupcode,
    required this.groupname,
    required this.barcode,
    required this.names,
    required this.itemcode,
    required this.itemunitcode,
    required this.itemunitnames,
    required this.imageuri,
    required this.options,
    required this.useimageorcolor,
    required this.colorselect,
    required this.colorselecthex,
    required this.prices,
  });

  factory SyncProductBarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$SyncProductBarcodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncProductBarcodeModelToJson(this);
}

@JsonSerializable()
class SyncCategoryModel {
  String guidfixed; // อ้างอิง
  String parentguid; // อ้างอิิงก่อนหน้า (แม่)
  String parentguidall; // อ้างอิงก่อนหน้าทั้งหมด
  List<LanguageDataModel>? names; // ชื่อ
  int childcount; // จำนวนลูก
  String imageuri; // รูปภาพ
  List<SortDataModel>? xsorts; // ลำดับ
  List<SortDataModel>? barcodes; // บาร์โค้ด
  bool useimageorcolor; // True=Image,False=Color
  String colorselect; // สีที่เลือก
  String colorselecthex; // สีที่เลือก (Hex)
  List<SyncCategoryCodeListModel>? codelist; // รหัสสินค้าย่อย

  SyncCategoryModel({
    required this.guidfixed,
    required this.parentguid,
    required this.parentguidall,
    required this.names,
    required this.imageuri,
    required this.childcount,
    required this.xsorts,
    required this.barcodes,
    required this.useimageorcolor,
    required this.colorselect,
    required this.colorselecthex,
    required this.codelist,
  });

  factory SyncCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SyncCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncCategoryModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SyncCategoryCodeListModel {
  String code;
  List<LanguageDataModel> names;
  int xorder;
  String barcode;
  String unitcode;
  List<LanguageDataModel> unitnames;

  SyncCategoryCodeListModel({
    required this.code,
    required this.names,
    required this.xorder,
    required this.barcode,
    required this.unitcode,
    required this.unitnames,
  });

  factory SyncCategoryCodeListModel.fromJson(Map<String, dynamic> json) =>
      _$SyncCategoryCodeListModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncCategoryCodeListModelToJson(this);
}
