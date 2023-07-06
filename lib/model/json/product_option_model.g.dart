// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionModel _$ProductOptionModelFromJson(Map<String, dynamic> json) =>
    ProductOptionModel(
      guid: json['guid'] as String,
      choicetype: json['choicetype'] as int,
      maxselect: json['maxselect'] as int,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      choices: (json['choices'] as List<dynamic>)
          .map((e) => ProductChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..select_index = json['select_index'] as int?;

Map<String, dynamic> _$ProductOptionModelToJson(ProductOptionModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'choicetype': instance.choicetype,
      'maxselect': instance.maxselect,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'choices': instance.choices.map((e) => e.toJson()).toList(),
      'select_index': instance.select_index,
    };

ProductChoiceModel _$ProductChoiceModelFromJson(Map<String, dynamic> json) =>
    ProductChoiceModel(
      guid: json['guid'] as String,
      refproductcode: json['refproductcode'] as String?,
      barcode: json['barcode'] as String?,
      isdefault: json['isdefault'] as bool?,
      refunitcode: json['refunitcode'] as String?,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      guidcode: json['guidcode'] as String?,
      price: json['price'] as String,
      qty: (json['qty'] as num).toDouble(),
      isstock: json['isstock'] as bool?,
      selected: json['selected'] as bool?,
    );

Map<String, dynamic> _$ProductChoiceModelToJson(ProductChoiceModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'price': instance.price,
      'guidcode': instance.guidcode,
      'isdefault': instance.isdefault,
      'isstock': instance.isstock,
      'barcode': instance.barcode,
      'refproductcode': instance.refproductcode,
      'refunitcode': instance.refunitcode,
      'qty': instance.qty,
      'selected': instance.selected,
    };
