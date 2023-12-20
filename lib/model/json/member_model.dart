import 'package:dedepos/global_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberModel {
  String code;
  List<LanguageDataModel> names;
  MemberAddressForBillingModel addressforbilling;

  MemberModel({
    required this.code,
    required this.names,
    required this.addressforbilling,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MemberAddressForBillingModel {
  String phoneprimary;
  String phonesecondary;

  MemberAddressForBillingModel({
    required this.phoneprimary,
    required this.phonesecondary,
  });

  factory MemberAddressForBillingModel.fromJson(Map<String, dynamic> json) => _$MemberAddressForBillingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberAddressForBillingModelToJson(this);
}
