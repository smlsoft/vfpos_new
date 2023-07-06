import 'package:dedepos/global_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pos_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductCategoryCodeListModel {
  String code;
  List<LanguageDataModel> names;
  int xorder;
  String barcode;
  String unitcode;
  List<LanguageDataModel> unitnames;

  ProductCategoryCodeListModel(
      {required this.code,
      required this.names,
      required this.xorder,
      required this.barcode,
      required this.unitcode,
      required this.unitnames});

  factory ProductCategoryCodeListModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryCodeListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryCodeListModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SortDataModel {
  String code;
  int xorder;

  SortDataModel({required this.code, required this.xorder});

  factory SortDataModel.fromJson(Map<String, dynamic> json) =>
      _$SortDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortDataModelToJson(this);
}

@JsonSerializable()
class BarcodeModel {
  final String barcode;
  final String item_code;
  final String item_name;
  final String unit_code;
  final String unit_name;

  const BarcodeModel(
      {this.barcode = '',
      this.item_code = '',
      this.item_name = '',
      this.unit_code = '',
      this.unit_name = ''});
  factory BarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$BarcodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$BarcodeModelToJson(this);

  /*factory BarcodeStruct.fromJson(dynamic json) {
    return BarcodeStruct(
      barcode: json['barcode'],
      item_code: json['item_code'],
      item_name: json['item_name'],
      unit_code: json['unit_code'],
      unit_name: json['unit_name'],
    );
  }*/
}

class SelectItemConditionModel {
  int command;
  double qty;
  String prices;
  BarcodeModel data;

  SelectItemConditionModel(
      {required this.command,
      required this.data,
      required this.qty,
      required this.prices});
}

/*class ItemStruct {
  final int index = 0;
  final String barcode = '';
  final String itemCode = '';
  final String itemName = '';
  final String unitCode = '';
  final String unitName = '';
  final double price = 0;

  const ItemStruct({required index, required barcode, required itemCode, required itemName, required unitCode, required unitName, required price});

  factory ItemStruct.fromJson(Map<String, dynamic> jsonString) {
    return ItemStruct(
      index: int.parse(jsonString['index'].toString()),
      barcode: jsonString['barcode'].toString(),
      itemCode: jsonString['item_code'].toString(),
      itemName: jsonString['item_name'].toString(),
      unitCode: jsonString['unit_code'].toString(),
      unitName: jsonString['unit_name'].toString(),
      price: double.parse(jsonString['price'].toString()),
    );
  }
}
*/

