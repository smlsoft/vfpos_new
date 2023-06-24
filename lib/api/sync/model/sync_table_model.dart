import 'package:json_annotation/json_annotation.dart';
part 'sync_table_model.g.dart';

@JsonSerializable()
class SyncTableModel {
  String guidfixed;
  String number;
  String name1;
  String zone;

  SyncTableModel({
    required this.guidfixed,
    required this.number,
    required this.name1,
    required this.zone,
  });

  factory SyncTableModel.fromJson(Map<String, dynamic> json) =>
      _$SyncTableModelFromJson(json);
  Map<String, dynamic> toJson() => _$SyncTableModelToJson(this);
}
