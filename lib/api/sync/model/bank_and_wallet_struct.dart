import 'package:json_annotation/json_annotation.dart';

part 'bank_and_wallet_struct.g.dart';

@JsonSerializable()
class ApiBankAndWalletStruct {
  late String countrycode;
  late String paymentcode;
  late String name1;
  late String name2;
  late String name3;
  late String name4;
  late String name5;
  late String paymentlogo;
  late int paymenttype;
  late double feerate;
  late int wallettype;

  ApiBankAndWalletStruct({
    this.paymentcode = "",
    this.countrycode = "",
    this.name1 = "",
    this.name2 = "",
    this.name3 = "",
    this.name4 = "",
    this.name5 = "",
    this.paymentlogo = "",
    this.paymenttype = 0,
    this.feerate = 0,
    this.wallettype = 0,
  });

  factory ApiBankAndWalletStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBankAndWalletStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBankAndWalletStructToJson(this);
}
