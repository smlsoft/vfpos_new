// ignore_for_file: non_constant_identifier_names
/*
import 'package:json_annotation/json_annotation.dart';
part 'api_bill_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiBillStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่-เวลา เอกสาร
  String customer_code; // รหัสลูกค้า
  String customer_name; // ชื่อลูกค้า
  String customer_telephone; // เบอร์โทรลูกค้า
  double total_amount; // ยอดรวม
  String sale_code; // รหัสพนักงานขาย
  String sale_name; // ชื่อพนักงานขาย
  String cashier_code; // รหัสพนักงานเก็บเงิน
  String cashier_name; // ชื่อพนักงานเก็บเงิน
  double pay_cash_amount; // ยอดเงินสดที่รับ
  double sum_discount; // ยอดส่วนลด
  double sum_qrcode; // ยอด QR Code
  double sum_credit_card; // ยอดบัตรเครดิต
  double sum_money_transfer; // ยอดโอนเงิน
  double sum_cheque; // ยอดเช็ค
  double sum_coupon; // ยอดคูปอง
  List<ApiBillDetailStruct> bill_details; // รายการสินค้า
  List<ApiBillPayQrStruct> pay_qrcodes; // รายการชำระเงินด้วย QR Code
  List<ApiBillPayCreditCardStruct>
      pay_credit_cards; // รายการชำระเงินด้วยบัตรเครดิต
  List<ApiBillPayTransferStruct>
      pay_money_transfers; // รายการชำระเงินด้วยโอนเงิน
  List<ApiBillPayChequeStruct> pay_cheques; // รายการชำระเงินด้วยเช็ค
  List<ApiBillPayCouponStruct> coupons; // รายการคูปอง

  ApiBillStruct(
      {required this.doc_number,
      required this.date_time,
      required this.customer_code,
      required this.customer_name,
      required this.customer_telephone,
      required this.total_amount,
      required this.cashier_code,
      required this.cashier_name,
      required this.sale_code,
      required this.sale_name,
      required this.pay_cash_amount,
      required this.sum_discount,
      required this.sum_qrcode,
      required this.sum_credit_card,
      required this.sum_coupon,
      required this.sum_money_transfer,
      required this.sum_cheque,
      required this.bill_details,
      required this.pay_qrcodes,
      required this.pay_credit_cards,
      required this.pay_money_transfers,
      required this.coupons,
      required this.pay_cheques});

  factory ApiBillStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillStructToJson(this);
}

@JsonSerializable()
class ApiBillDetailStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่-เวลา เอกสาร
  int line_number; // บรรทัดที่
  String barcode; // บาร์โค้ด
  String item_code; // รหัสสินค้า
  String item_name; // ชื่อสินค้า
  String unit_code; // รหัสหน่วยนับ
  String unit_name; // ชื่อหน่วยนับ
  double qty; // จำนวน
  double price; // ราคา
  double total_amount; // จำนวนเงิน
  String discount_text; // ส่วนลด
  double discount; // ส่วนลด
  List<ApiBillDetailExtraStruct> extra_details; // รายการ Extra

  ApiBillDetailStruct({
    required this.doc_number,
    required this.date_time,
    required this.line_number,
    required this.barcode,
    required this.item_code,
    required this.item_name,
    required this.unit_code,
    required this.unit_name,
    required this.qty,
    required this.price,
    required this.total_amount,
    required this.discount_text,
    required this.discount,
    required this.extra_details,
  });

  factory ApiBillDetailStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillDetailStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillDetailStructToJson(this);
}

@JsonSerializable()
class ApiBillDetailExtraStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่-เวลา เอกสาร
  int line_number; // บรรทัดที่
  int ref_line_number; // บรรทัดที่อ้างอิง
  String barcode; // บาร์โค้ด
  String item_code; // รหัสสินค้า
  String item_name; // ชื่อสินค้า
  String unit_code; // รหัสหน่วยนับ
  String unit_name; // ชื่อหน่วยนับ
  double qty; // จำนวน
  double price; // ราคา
  double total_amount; // จำนวนเงิน

  ApiBillDetailExtraStruct(
      {required this.line_number,
      required this.doc_number,
      required this.date_time,
      required this.ref_line_number,
      required this.barcode,
      required this.item_code,
      required this.item_name,
      required this.unit_code,
      required this.unit_name,
      required this.qty,
      required this.price,
      required this.total_amount});

  factory ApiBillDetailExtraStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillDetailExtraStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillDetailExtraStructToJson(this);
}

@JsonSerializable()
class ApiBillPayQrStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่-เวลา เอกสาร
  String provider_code; // รหัสกระเป๋า เจ้าของเงิน (Provider)
  String provider_name; // รหัสกระเป๋า เจ้าของเงิน (Provider)
  String description; // รายละเอียด (เพิ่มเติม)
  double amount; // จำนวนเงิน

  ApiBillPayQrStruct({
    required this.doc_number,
    required this.date_time,
    required this.description,
    required this.provider_code,
    required this.provider_name,
    required this.amount,
  });

  factory ApiBillPayQrStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillPayQrStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillPayQrStructToJson(this);
}

@JsonSerializable()
class ApiBillPayCreditCardStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่-เวลา เอกสาร
  String edc_code; // รหัสธนาคาร
  String edc_name; // ชื่อธนาคาร
  String card_number; // เลขที่บัตรเครดิต
  String approved_code; // รหัสอนุมัติ
  double amount; // จำนวนเงิน

  ApiBillPayCreditCardStruct({
    required this.doc_number,
    required this.date_time,
    required this.edc_code,
    required this.card_number,
    required this.approved_code,
    required this.edc_name,
    required this.amount,
  });

  factory ApiBillPayCreditCardStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillPayCreditCardStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillPayCreditCardStructToJson(this);
}

@JsonSerializable()
class ApiBillPayTransferStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่โอนเงิน
  String bank_code; // รหัสธนาคาร
  String bank_name; // ชื่อธนาคาร
  double amount; // จำนวนเงิน

  ApiBillPayTransferStruct({
    required this.doc_number,
    required this.date_time,
    required this.bank_code,
    required this.bank_name,
    required this.amount,
  });

  factory ApiBillPayTransferStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillPayTransferStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillPayTransferStructToJson(this);
}

@JsonSerializable()
class ApiBillPayChequeStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่บันทึก
  String bank_code; // รหัสธนาคาร
  String bank_name; // ชื่อธนาคาร
  String branch_name; // สาขาธนาคาร
  DateTime due_date; // วันที่สั่งจ่ายบนเช็ค
  String cheque_number; // เลขที่เช็ค
  double amount; // จำนวนเงิน

  ApiBillPayChequeStruct({
    required this.doc_number,
    required this.date_time,
    required this.due_date,
    required this.bank_code,
    required this.bank_name,
    required this.branch_name,
    required this.cheque_number,
    required this.amount,
  });

  factory ApiBillPayChequeStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillPayChequeStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillPayChequeStructToJson(this);
}

@JsonSerializable()
class ApiBillPayCouponStruct {
  String doc_number; // เลขที่เอกสาร
  DateTime date_time; // วันที่บันทึก
  String number; // เลขคูปอง
  double amount; // จำนวนเงิน

  ApiBillPayCouponStruct({
    required this.doc_number,
    required this.date_time,
    required this.number,
    required this.amount,
  });

  factory ApiBillPayCouponStruct.fromJson(Map<String, dynamic> json) =>
      _$ApiBillPayCouponStructFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBillPayCouponStructToJson(this);
}
*/