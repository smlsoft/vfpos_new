import 'package:dedepos/global_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sync_kitchen_model.g.dart';

@JsonSerializable()
class SyncKitchenModel {
  String guidfixed;
  String code;
  List<LanguageDataModel> names;
  List<String> products;
  List<String> zones;

  SyncKitchenModel({
    required this.guidfixed,
    required this.products,
    required this.code,
    required this.names,
    required this.zones,
  });

  factory SyncKitchenModel.fromJson(Map<String, dynamic> json) =>
      _$SyncKitchenModelFromJson(json);
  Map<String, dynamic> toJson() => _$SyncKitchenModelToJson(this);
}
