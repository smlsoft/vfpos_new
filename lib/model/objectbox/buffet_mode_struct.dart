import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'buffet_mode_struct.g.dart';

@JsonSerializable()
@Entity()
class BuffetModeObjectBoxStruct {
  int id = 0;
  @Unique()
  String guid_fixed;
  @Unique()
  String code;
  List<String> names;
  double adultPrice;
  double childPrice;
  int maxMinute = 0;

  BuffetModeObjectBoxStruct({
    required this.guid_fixed,
    required this.code,
    required this.names,
    required this.adultPrice,
    required this.childPrice,
    required this.maxMinute,
  });

  factory BuffetModeObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$BuffetModeObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$BuffetModeObjectBoxStructToJson(this);
}
