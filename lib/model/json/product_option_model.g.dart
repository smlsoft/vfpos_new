// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionModel _$ProductOptionModelFromJson(Map<String, dynamic> json) =>
    ProductOptionModel(
      guid_fixed: json['guid_fixed'] as String,
      choice_type: json['choice_type'] as int,
      max_select: json['max_select'] as int,
      names: (json['names'] as List<dynamic>).map((e) => e as String).toList(),
      choices: (json['choices'] as List<dynamic>)
          .map((e) => ProductChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..select_index = json['select_index'] as int;

Map<String, dynamic> _$ProductOptionModelToJson(ProductOptionModel instance) =>
    <String, dynamic>{
      'guid_fixed': instance.guid_fixed,
      'choice_type': instance.choice_type,
      'max_select': instance.max_select,
      'names': instance.names,
      'choices': instance.choices.map((e) => e.toJson()).toList(),
      'select_index': instance.select_index,
    };

ProductChoiceModel _$ProductChoiceModelFromJson(Map<String, dynamic> json) =>
    ProductChoiceModel(
      guid_fixed: json['guid_fixed'] as String,
      product_code: json['product_code'] as String,
      barcode: json['barcode'] as String,
      is_default: json['is_default'] as bool,
      item_unit_code: json['item_unit_code'] as String,
      names: (json['names'] as List<dynamic>).map((e) => e as String).toList(),
      guid_code: json['guid_code'] as String,
      price: (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
      selected: json['selected'] as bool,
    );

Map<String, dynamic> _$ProductChoiceModelToJson(ProductChoiceModel instance) =>
    <String, dynamic>{
      'guid_fixed': instance.guid_fixed,
      'guid_code': instance.guid_code,
      'is_default': instance.is_default,
      'barcode': instance.barcode,
      'product_code': instance.product_code,
      'item_unit_code': instance.item_unit_code,
      'names': instance.names,
      'price': instance.price,
      'qty': instance.qty,
      'selected': instance.selected,
    };
