import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShiftModel {
  String guidfixed;
  int doctype;
  DateTime docdate;
  String usercode;
  String username;
  String remark;
  double amount;
  double creditcard;
  double promptpay;
  double transfer;
  double cheque;
  double coupon;

  ShiftModel(
      {String? guidfixed,
      int? doctype,
      DateTime? docdate,
      String? usercode,
      String? username,
      String? remark,
      double? amount,
      double? creditcard,
      double? promptpay,
      double? transfer,
      double? cheque,
      double? coupon})
      : guidfixed = guidfixed ?? "",
        doctype = doctype ?? 0,
        docdate = docdate ?? DateTime.now(),
        usercode = usercode ?? '',
        username = username ?? '',
        remark = remark ?? '',
        amount = amount ?? 0,
        creditcard = creditcard ?? 0,
        promptpay = promptpay ?? 0,
        transfer = transfer ?? 0,
        cheque = cheque ?? 0,
        coupon = coupon ?? 0;

  factory ShiftModel.fromJson(Map<String, dynamic> json) => _$ShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}
