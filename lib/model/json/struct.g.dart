// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategoryCodeListModel _$ProductCategoryCodeListModelFromJson(
        Map<String, dynamic> json) =>
    ProductCategoryCodeListModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      xorder: json['xorder'] as int,
      barcode: json['barcode'] as String,
      unitcode: json['unitcode'] as String,
      unitnames: (json['unitnames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductCategoryCodeListModelToJson(
        ProductCategoryCodeListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'xorder': instance.xorder,
      'barcode': instance.barcode,
      'unitcode': instance.unitcode,
      'unitnames': instance.unitnames.map((e) => e.toJson()).toList(),
    };

SortDataModel _$SortDataModelFromJson(Map<String, dynamic> json) =>
    SortDataModel(
      code: json['code'] as String,
      xorder: json['xorder'] as int,
    );

Map<String, dynamic> _$SortDataModelToJson(SortDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'xorder': instance.xorder,
    };

BarcodeStruct _$BarcodeStructFromJson(Map<String, dynamic> json) =>
    BarcodeStruct(
      barcode: json['barcode'] as String? ?? '',
      item_code: json['item_code'] as String? ?? '',
      item_name: json['item_name'] as String? ?? '',
      unit_code: json['unit_code'] as String? ?? '',
      unit_name: json['unit_name'] as String? ?? '',
    );

Map<String, dynamic> _$BarcodeStructToJson(BarcodeStruct instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
    };
