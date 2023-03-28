import 'package:json_annotation/json_annotation.dart';
part 'member_api.g.dart';

@JsonSerializable()
class MemberApi {
  late String guidfixed;
  late String address;
  late String branchcode;
  late int branchtype;
  late int contacttype;
  late String name;
  late int personaltype;
  late String surname;
  late String taxid;
  late String telephone;
  late String zipcode;

  MemberApi({
    this.guidfixed = "",
    this.address = "",
    this.branchcode = "",
    required this.branchtype,
    required this.contacttype,
    required this.name,
    required this.personaltype,
    this.surname = "",
    this.taxid = "",
    this.telephone = "",
    this.zipcode = "",
  });

  factory MemberApi.fromJson(Map<String, dynamic> json) =>
      _$MemberApiFromJson(json);
  Map<String, dynamic> toJson() => _$MemberApiToJson(this);
}
