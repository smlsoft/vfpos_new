// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_bundle_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBundleStruct _$ProductBundleStructFromJson(Map<String, dynamic> json) =>
    ProductBundleStruct(
      main_barcode: json['main_barcode'] as String,
      bundle_barcode: json['bundle_barcode'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ProductBundleStructToJson(
        ProductBundleStruct instance) =>
    <String, dynamic>{
      'main_barcode': instance.main_barcode,
      'bundle_barcode': instance.bundle_barcode,
      'price': instance.price,
    };
