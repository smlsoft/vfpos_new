// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';

@Entity()
class BillObjectBoxStruct {
  int id = 0;
  @Unique()
  String doc_number;
  @Property(type: PropertyType.date)
  DateTime date_time;
  String customer_code;
  String customer_name;
  String customer_telephone;
  double total_amount;
  String sale_code;
  String sale_name;
  bool is_sync;
  String cashier_code;
  String cashier_name;
  double pay_cash_amount;
  String discount_formula;
  double sum_discount;
  double sum_qr_code;
  double sum_credit_card;
  double sum_money_transfer;
  double sum_cheque;
  double sum_coupon;

  BillObjectBoxStruct(
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
      required this.is_sync,
      required this.discount_formula,
      required this.pay_cash_amount,
      required this.sum_discount,
      required this.sum_qr_code,
      required this.sum_credit_card,
      required this.sum_money_transfer,
      required this.sum_coupon,
      required this.sum_cheque});
}

@Entity()
class BillDetailObjectBoxStruct {
  int id;
  String doc_number;
  int line_number;
  String barcode;
  String item_code;
  String item_name;
  String unit_code;
  String unit_name;
  double qty;
  double price;
  String discount_text;
  double discount;
  double total_amount;

  BillDetailObjectBoxStruct(
      {this.id = 0,
      this.line_number = 0,
      this.barcode = "",
      this.item_code = "",
      this.item_name = "",
      this.unit_code = "",
      this.unit_name = "",
      this.qty = 0,
      this.doc_number = "",
      this.price = 0,
      this.discount_text = "",
      this.discount = 0,
      this.total_amount = 0});
}

@Entity()
class BillDetailExtraObjectBoxStruct {
  int id;
  String doc_number;
  int ref_line_number;
  int line_number;
  String barcode;
  String item_code;
  String item_name;
  String unit_code;
  String unit_name;
  double qty;
  double price;
  double total_amount;

  BillDetailExtraObjectBoxStruct(
      {this.id = 0,
      this.line_number = 0,
      this.barcode = "",
      this.item_code = "",
      this.item_name = "",
      this.unit_code = "",
      this.unit_name = "",
      this.qty = 0,
      this.doc_number = "",
      this.price = 0,
      this.ref_line_number = 0,
      this.total_amount = 0});
}

@Entity()
class BillPayObjectBoxStruct {
  int id;
  late String doc_number;
  late int trans_flag; // 1=บัตรเครดิต,2=เงินโอน,3=เช็ค,4=คูปอง,5=QR
  late String bank_code; // รหัสธนาคาร
  late String bank_name; // ชื่อธนาคาร (อื่นๆ)
  late String bank_account_no; // เลขที่บัญชี (เงินเข้า)
  late String card_number; // เลขที่บัตรเครดิต
  late String approved_code; // รหัสอนุมัติ
  late DateTime doc_date_time; // วันที่โอนเงิน
  late String branch_number; // สาขาธนาคาร
  late String bank_referance; // รหัสอ้างอิงธนาคาร
  late DateTime due_date; // วันที่สั่งจ่ายบนเช็ค
  late String cheque_number; // เลขที่เช็ค
  late String code; // รหัสส่วนลด
  late String description; // รายละเอียด (เพิ่มเติม)
  late String number; // เลขคูปอง
  late String referance_one; // อ้างอิง 1
  late String referance_two; // อ้างอิง 2
  late String provider_code; // รหัสกระเป๋า เจ้าของเงิน (Provider)
  late String provider_name; // เจ้าของเงิน (Provider)
  late double amount; // จำนวนเงิน

  BillPayObjectBoxStruct({
    this.id = 0,
    this.doc_number = "",
    this.trans_flag = 0,
    this.bank_code = "",
    this.card_number = "",
    this.approved_code = "",
    this.bank_name = "",
    this.bank_account_no = "",
    this.branch_number = "",
    this.bank_referance = "",
    this.cheque_number = "",
    this.code = "",
    this.description = "",
    this.number = "",
    this.referance_one = "",
    this.referance_two = "",
    this.provider_code = "",
    this.provider_name = "",
    this.amount = 0,
  })  : due_date = DateTime.now(),
        doc_date_time = DateTime.now();
}
