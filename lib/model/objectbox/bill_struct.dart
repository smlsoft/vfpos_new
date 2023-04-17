// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';

@Entity()
class BillObjectBoxStruct {
  int id = 0;
  @Unique()

  /// เลขที่เอกสาร
  String doc_number;
  @Property(type: PropertyType.date)

  /// วันที่เอกสาร
  DateTime date_time;

  /// รหัสลูกค้า
  String customer_code;

  /// ชื่อลูกค้า
  String customer_name;

  /// เบอร์โทรลูกค้า (สะสมแต้ม)
  String customer_telephone;

  /// ยอดรวมทั้งสิ้น
  double total_amount;

  /// ยอดรวมก่อน vat
  double total_before_amount;

  /// ยอด vat
  double total_vat_amount;

  /// อัตรา vat
  double vat_rate;

  /// ยอดรวมสินค้ายกเว้น vat
  double total_except_amount;

  /// พนักงานขาย
  String sale_code;
  String sale_name;

  /// สถานะการ Sync (true = Sync แล้ว, false = ยังไม่ Sync)
  bool is_sync;

  /// สถานะการยกเลิก (true = ยกเลิก, false = ยังไม่ยกเลิก)
  bool is_cancel;

  /// วันที่ยกเลิก
  String cancel_date_time;

  /// พนักงานที่ยกเลิก
  String cancel_user_code;

  /// ชื่อพนักงานที่ยกเลิก
  String cancel_user_name;

  /// เหตุผลที่ยกเลิก
  String cancel_reason;

  /// พนักงาน Cashier
  String cashier_code;

  /// ชื่อพนักงาน Cashier
  String cashier_name;

  /// ชำระเงินสด
  double pay_cash_amount;

  /// สูตรส่วนลด
  String discount_formula;

  /// ส่วนลดทั้งหมด
  double sum_discount;

  /// ชำระเงินโดย QR Code
  double sum_qr_code;

  /// ชำระเงินโดย Credit Card
  double sum_credit_card;

  /// ชำระเงินโดยเงินโอน
  double sum_money_transfer;

  /// ชำระเงินโดยเช็ค
  double sum_cheque;

  /// ชำระเงินโดย Coupon
  double sum_coupon;

  /// ชื่อลูกค้าใบกำกับภาษีแบบเต็ม
  String full_vat_name;

  /// ที่อยู่ใบกำกับภาษีแบบเต็ม
  String full_vat_address;

  /// เลขประจำตัวผู้เสียภาษีใบกำกับภาษีแบบเต็ม
  String full_vat_tax_id;

  /// เลขสาขาใบกำกับภาษีแบบเต็ม
  String full_vat_branch_number;

  /// วันที่พิมพ์ใบเสร็จ (สำเนา)
  List<String> print_copy_bill_date_time;

  BillObjectBoxStruct(
      {required this.doc_number,
      required this.date_time,
      required this.customer_code,
      required this.customer_name,
      required this.customer_telephone,
      required this.vat_rate,
      required this.total_amount,
      required this.total_before_amount,
      required this.total_vat_amount,
      required this.total_except_amount,
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
      required this.sum_cheque,
      this.is_cancel = false,
      this.cancel_date_time = "",
      this.cancel_user_code = "",
      this.cancel_user_name = "",
      this.cancel_reason = "",
      this.full_vat_name = "",
      this.full_vat_address = "",
      this.full_vat_tax_id = "",
      this.full_vat_branch_number = "",
      this.print_copy_bill_date_time = const []});
}

@Entity()
class BillDetailObjectBoxStruct {
  int id;

  /// เลขที่เอกสาร
  String doc_number;

  /// ลำดับรายการ
  int line_number;

  /// บาร์โค้ด
  String barcode;

  /// รหัสสินค้า
  String item_code;

  /// ชื่อสินค้า
  String item_name;

  /// รหัสหน่วย
  String unit_code;

  /// ชื่อหน่วย
  String unit_name;

  /// SKU สินค้า
  String sku;

  /// จำนวน
  double qty;

  /// ราคา
  double price;

  /// ส่วนลด
  String discount_text;

  /// ส่วนลดเป็นเงิน
  double discount;

  /// ยอดรวมมูลค่า
  double total_amount;

  BillDetailObjectBoxStruct(
      {this.id = 0,
      this.line_number = 0,
      this.barcode = "",
      this.item_code = "",
      this.item_name = "",
      this.unit_code = "",
      this.unit_name = "",
      this.sku = "",
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

  /// เลขที่เอกสาร
  String doc_number;

  /// ลำดับรายการ ในเอกสารอ้างอิง
  int ref_line_number;

  /// ลำดับรายการ
  int line_number;

  /// บาร์โค้ด
  String barcode;

  /// รหัสสินค้า
  String item_code;

  /// ชื่อสินค้า
  String item_name;

  /// รหัสหน่วย
  String unit_code;

  /// ชื่อหน่วย
  String unit_name;

  /// จำนวน
  double qty;

  /// ราคา
  double price;

  /// ยอดรวมมูลค่า
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

  /// 1=บัตรเครดิต,2=เงินโอน,3=เช็ค,4=คูปอง,5=QR
  late int trans_flag;

  /// รหัสธนาคาร
  late String bank_code;

  /// ชื่อธนาคาร (อื่นๆ)
  late String bank_name;

  /// เลขที่บัญชี (เงินเข้า)
  late String bank_account_no;

  /// เลขที่บัตรเครดิต
  late String card_number;

  /// รหัสอนุมัติ
  late String approved_code;

  /// วันที่โอนเงิน
  late DateTime doc_date_time;

  /// สาขาธนาคาร
  late String branch_number;

  /// รหัสอ้างอิงธนาคาร
  late String bank_referance;

  /// วันที่สั่งจ่ายบนเช็ค
  late DateTime due_date;

  /// เลขที่เช็ค
  late String cheque_number;

  /// รหัสส่วนลด
  late String code;

  /// รายละเอียด (เพิ่มเติม)
  late String description;

  /// เลขคูปอง
  late String number;

  /// อ้างอิง 1
  late String referance_one;

  /// อ้างอิง 2
  late String referance_two;

  /// รหัสกระเป๋า เจ้าของเงิน (Provider)
  late String provider_code;

  /// เจ้าของเงิน (Provider)
  late String provider_name;

  /// จำนวนเงิน
  late double amount;

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
