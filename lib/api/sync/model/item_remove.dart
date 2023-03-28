import 'package:json_annotation/json_annotation.dart';

part 'item_remove.g.dart';

@JsonSerializable()
class ItemRemove {
  late String guidfixed;
  late String shopid;
  late String createdat;
  late String updatedat;
  late String deletedat;

  ItemRemove({
    this.guidfixed = "",
    this.shopid = "",
    this.createdat = "",
    this.updatedat = "",
    this.deletedat = "",
  });

  factory ItemRemove.fromJson(Map<String, dynamic> json) =>
      _$ItemRemoveFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRemoveToJson(this);
}
