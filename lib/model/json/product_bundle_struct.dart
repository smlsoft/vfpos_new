// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'product_bundle_struct.g.dart';

@JsonSerializable()
class ProductBundleStruct {
  late String main_barcode;
  late String bundle_barcode;
  late double price;

  ProductBundleStruct(
      {required this.main_barcode,
      required this.bundle_barcode,
      this.price = 0});

  factory ProductBundleStruct.fromJson(Map<String, dynamic> json) =>
      _$ProductBundleStructFromJson(json);
  Map<String, dynamic> toJson() => _$ProductBundleStructToJson(this);

  /*ProductBundleStruct.map(dynamic obj) {
    mainBarcode = obj["main_barcode"];
    bundleBarcode = obj["bundle_barcode"];
    price = double.parse(obj["price"].toString());
  }

  Map<String, dynamic> toMap() {
    var _map = <String, dynamic>{};

    _map["main_barcode"] = mainBarcode;
    _map["bundle_barcode"] = bundleBarcode;
    _map["price"] = price;

    return _map;
  }*/
}
