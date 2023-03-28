import 'package:json_annotation/json_annotation.dart';
part 'zone_struct.g.dart';

@JsonSerializable()
class ZoneStruct {
  late String guidfixed;
  late String code;
  late String name1;
  late String shopid;

  ZoneStruct({
    this.guidfixed = "",
    this.code = "",
    this.name1 = "",
  });
  factory ZoneStruct.fromJson(Map<String, dynamic> json) =>
      _$ZoneStructFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneStructToJson(this);
}
