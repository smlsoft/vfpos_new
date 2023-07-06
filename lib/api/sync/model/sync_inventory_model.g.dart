// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPriceDataModel _$SyncPriceDataModelFromJson(Map<String, dynamic> json) =>
    SyncPriceDataModel(
      keynumber: json['keynumber'] as int,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$SyncPriceDataModelToJson(SyncPriceDataModel instance) =>
    <String, dynamic>{
      'keynumber': instance.keynumber,
      'price': instance.price,
    };

SyncProductChoiceModel _$SyncProductChoiceModelFromJson(
        Map<String, dynamic> json) =>
    SyncProductChoiceModel(
      guid: json['guid'] as String,
      refbarcode: json['refbarcode'] as String,
      refproductcode: json['refproductcode'] as String,
      refunitcode: json['refunitcode'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isstock: json['isstock'] as bool,
      price: json['price'] as String,
      qty: (json['qty'] as num).toDouble(),
      isdefault: json['isdefault'] as bool,
    );

Map<String, dynamic> _$SyncProductChoiceModelToJson(
        SyncProductChoiceModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'price': instance.price,
      'isdefault': instance.isdefault,
      'isstock': instance.isstock,
      'refbarcode': instance.refbarcode,
      'refproductcode': instance.refproductcode,
      'refunitcode': instance.refunitcode,
      'qty': instance.qty,
    };

SyncProductOptionModel _$SyncProductOptionModelFromJson(
        Map<String, dynamic> json) =>
    SyncProductOptionModel(
      guid: json['guid'] as String,
      maxselect: json['maxselect'] as int,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      minselect: json['minselect'] as int,
      choices: (json['choices'] as List<dynamic>)
          .map(
              (e) => SyncProductChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      choicetype: json['choicetype'] as int,
    );

Map<String, dynamic> _$SyncProductOptionModelToJson(
        SyncProductOptionModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'choicetype': instance.choicetype,
      'minselect': instance.minselect,
      'maxselect': instance.maxselect,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'choices': instance.choices.map((e) => e.toJson()).toList(),
    };

ProductOrderTypeFromServerModel _$ProductOrderTypeFromServerModelFromJson(
        Map<String, dynamic> json) =>
    ProductOrderTypeFromServerModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductOrderTypeFromServerModelToJson(
        ProductOrderTypeFromServerModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'price': instance.price,
    };

SyncProductBarcodeModel _$SyncProductBarcodeModelFromJson(
        Map<String, dynamic> json) =>
    SyncProductBarcodeModel(
      guidfixed: json['guidfixed'] as String,
      groupcode: json['groupcode'] as String?,
      groupname: (json['groupname'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      barcode: json['barcode'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemcode: json['itemcode'] as String,
      itemunitcode: json['itemunitcode'] as String,
      itemunitnames: (json['itemunitnames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageuri: json['imageuri'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map(
              (e) => SyncProductOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      useimageorcolor: json['useimageorcolor'] as bool,
      colorselect: json['colorselect'] as String,
      colorselecthex: json['colorselecthex'] as String,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => SyncPriceDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isalacarte: json['isalacarte'] as bool?,
      ordertypes: (json['ordertypes'] as List<dynamic>?)
          ?.map((e) => ProductOrderTypeFromServerModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncProductBarcodeModelToJson(
        SyncProductBarcodeModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'itemcode': instance.itemcode,
      'groupcode': instance.groupcode,
      'groupname': instance.groupname,
      'barcode': instance.barcode,
      'names': instance.names,
      'itemunitcode': instance.itemunitcode,
      'itemunitnames': instance.itemunitnames,
      'imageuri': instance.imageuri,
      'useimageorcolor': instance.useimageorcolor,
      'colorselect': instance.colorselect,
      'colorselecthex': instance.colorselecthex,
      'options': instance.options,
      'prices': instance.prices,
      'isalacarte': instance.isalacarte,
      'ordertypes': instance.ordertypes,
    };

SyncCategoryModel _$SyncCategoryModelFromJson(Map<String, dynamic> json) =>
    SyncCategoryModel(
      guidfixed: json['guidfixed'] as String,
      parentguid: json['parentguid'] as String,
      parentguidall: json['parentguidall'] as String,
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageuri: json['imageuri'] as String,
      childcount: json['childcount'] as int,
      xsorts: (json['xsorts'] as List<dynamic>?)
          ?.map((e) => SortDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      barcodes: (json['barcodes'] as List<dynamic>?)
          ?.map((e) => SortDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      useimageorcolor: json['useimageorcolor'] as bool,
      colorselect: json['colorselect'] as String,
      colorselecthex: json['colorselecthex'] as String,
      codelist: (json['codelist'] as List<dynamic>?)
          ?.map((e) =>
              SyncCategoryCodeListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncCategoryModelToJson(SyncCategoryModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'parentguid': instance.parentguid,
      'parentguidall': instance.parentguidall,
      'names': instance.names,
      'childcount': instance.childcount,
      'imageuri': instance.imageuri,
      'xsorts': instance.xsorts,
      'barcodes': instance.barcodes,
      'useimageorcolor': instance.useimageorcolor,
      'colorselect': instance.colorselect,
      'colorselecthex': instance.colorselecthex,
      'codelist': instance.codelist,
    };

SyncCategoryCodeListModel _$SyncCategoryCodeListModelFromJson(
        Map<String, dynamic> json) =>
    SyncCategoryCodeListModel(
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

Map<String, dynamic> _$SyncCategoryCodeListModelToJson(
        SyncCategoryCodeListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'xorder': instance.xorder,
      'barcode': instance.barcode,
      'unitcode': instance.unitcode,
      'unitnames': instance.unitnames.map((e) => e.toJson()).toList(),
    };
