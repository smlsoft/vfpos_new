// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill_struct.g.dart';

@Entity()
class BillObjectBoxStruct {
  int id = 0;
  @Unique()

  /// เลขที่เอกสาร
  String doc_number;
  @Property(type: PropertyType.date)

  /// วันที่เอกสาร
  DateTime date_time;

  /// 0=บิลทั่วไปไม่มีภาษี,1=ใบเสร็จรับเงิน/ใบกำกับภาษีอย่างย่อ,2=ใบเสร็จรับเงิน/ใบกำกับภาษีอย่างเต็ม
  int bill_tax_type;

  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

  /// รหัสลูกค้า
  String customer_code;

  /// ชื่อลูกค้า
  String customer_name;

  /// เบอร์โทรลูกค้า (สะสมแต้ม)
  String customer_telephone;

  /// จำนวนชิ้น
  double total_qty;

  /// ยอดรวมสินค้ามีภาษี
  double total_item_vat_amount;

  // ยอดรวมสินค้ายกเว้นภาษี
  double total_item_except_vat_amount;

  /// สูตรส่วนลดท้ายบิล
  String discount_formula;

  /// ส่วนลดทั้งหมด (ท้ายบิล)
  double total_discount;

  /// ส่วนลดสินค้ามีภาษี
  double total_discount_vat_amount;

  /// ส่วนลดสินค้ายกเว้นภาษี
  double total_discount_except_vat_amount;

  /// มูลค่าก่อนคิดภาษี (สินค้ามีภาษี)
  double amount_before_calc_vat;

  /// มูลค่าหลังคิดภาษี (สินค้ามีภาษี)
  double amount_after_calc_vat;

  // มูลค่า สินค้ายกเว้นภาษี
  double amount_except_vat;

  /// ยอดรวมทั้งสิ้น
  double total_amount;

  /// ยอด vat
  double total_vat_amount;

  /// อัตรา vat
  double vat_rate;

  /// รหัสพนักงานขาย
  String sale_code;

  /// ชื่อพนักงานขาย
  String sale_name;

  /// สถานะการ Sync (true = Sync แล้ว, false = ยังไม่ Sync)
  bool is_sync;

  /// สถานะการยกเลิก (true = ยกเลิก, false = ยังไม่ยกเลิก)
  bool is_cancel;

  /// วันที่ยกเลิก
  String cancel_date_time;

  /// เหตุผลที่ยกเลิก
  String cancel_description;

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

  /// เงินทอน
  double pay_cash_change;

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

  /// พิมพ์ใบกำกับภาษีแบบเต็มแล้ว
  bool full_vat_print;

  /// เลขที่ใบกำกับภาษีแบบเต็ม
  String full_vat_doc_number;

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

  // หมายเลขโต๊ะ
  String table_number;

  /// จำนวนคน ชาย
  int man_count;

  /// จำนวนคน หญิง
  int woman_count;

  /// จำนวนเด็ก
  int child_count;

  /// False=สั่งแบบอลาคาร์ทไม่ได้,True=สั่งแบบอลาคาร์ทได้
  bool table_al_la_crate_mode;

  String buffet_code;

  /// เวลาเปิดโต๊ะ
  @Property(type: PropertyType.date)
  DateTime table_open_date_time;

  /// เวลาปิดโต๊ะ
  @Property(type: PropertyType.date)
  DateTime table_close_date_time;

  String pay_json;

  /// 1=ภาษีมูลค่าเพิ่มรวมใน,2=ภาษีมูลค่าเพิ่มแยกนอก
  int vat_type;

  bool is_vat_register;

  BillObjectBoxStruct(
      {required this.date_time,
      required this.table_open_date_time,
      required this.table_close_date_time,
      required this.doc_number,
      required this.doc_mode,
      required this.customer_code,
      required this.bill_tax_type,
      required this.customer_name,
      required this.customer_telephone,
      required this.vat_rate,
      required this.total_amount,
      required this.total_vat_amount,
      required this.cashier_code,
      required this.cashier_name,
      required this.sale_code,
      required this.amount_except_vat,
      required this.amount_before_calc_vat,
      required this.amount_after_calc_vat,
      required this.total_discount_vat_amount,
      required this.total_discount_except_vat_amount,
      required this.sale_name,
      required this.vat_type,
      required this.total_qty,
      required this.is_sync,
      required this.discount_formula,
      required this.pay_cash_amount,
      required this.total_discount,
      required this.sum_qr_code,
      required this.sum_credit_card,
      required this.sum_money_transfer,
      required this.sum_coupon,
      required this.sum_cheque,
      required this.is_cancel,
      required this.cancel_date_time,
      required this.cancel_user_code,
      required this.cancel_user_name,
      required this.pay_cash_change,
      required this.cancel_reason,
      required this.cancel_description,
      required this.full_vat_print,
      required this.full_vat_doc_number,
      required this.full_vat_name,
      required this.full_vat_address,
      required this.full_vat_tax_id,
      required this.full_vat_branch_number,
      required this.table_number,
      required this.child_count,
      required this.woman_count,
      required this.man_count,
      required this.table_al_la_crate_mode,
      required this.buffet_code,
      required this.pay_json,
      required this.total_item_vat_amount,
      required this.total_item_except_vat_amount,
      required this.is_vat_register,
      required this.print_copy_bill_date_time});
}

@Entity()
class BillDetailObjectBoxStruct {
  int id = 0;

  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

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

  /// ยกเว้นภาษี (True=ยกเว้นภาษี,False=ไม่ยกเว้นภาษี)
  bool is_except_vat;

  String extra_json;

  BillDetailObjectBoxStruct({
    required this.doc_mode,
    required this.doc_number,
    required this.line_number,
    required this.barcode,
    required this.item_code,
    required this.item_name,
    required this.unit_code,
    required this.unit_name,
    required this.sku,
    required this.qty,
    required this.price,
    required this.discount_text,
    required this.discount,
    required this.is_except_vat,
    required this.extra_json,
    required this.total_amount,
  });
}

@JsonSerializable(explicitToJson: true)
class BillDetailExtraObjectBoxStruct {
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

  /// ยกเว้นภาษี (True=ยกเว้นภาษี,False=ไม่ยกเว้นภาษี)
  bool is_except_vat;

  BillDetailExtraObjectBoxStruct(
      {required this.barcode,
      required this.item_code,
      required this.item_name,
      required this.unit_code,
      required this.unit_name,
      required this.qty,
      required this.price,
      required this.is_except_vat,
      required this.total_amount});

  factory BillDetailExtraObjectBoxStruct.fromJson(Map<String, dynamic> json) => _$BillDetailExtraObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$BillDetailExtraObjectBoxStructToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BillPayObjectBoxStruct {
  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

  /// 1=บัตรเครดิต,2=เงินโอน,3=เช็ค,4=คูปอง,5=QR
  int trans_flag;

  /// รหัสธนาคาร
  String bank_code;

  /// ชื่อธนาคาร (อื่นๆ)
  String bank_name;

  /// เลขที่บัญชี (เงินเข้า)
  String book_bank_code;

  /// เลขที่บัตรเครดิต
  String card_number;

  /// รหัสอนุมัติ
  String approved_code;

  /// วันที่โอนเงิน
  DateTime doc_date_time;

  /// สาขาธนาคาร
  String branch_number;

  /// รหัสอ้างอิงธนาคาร
  String bank_reference;

  /// วันที่สั่งจ่ายบนเช็ค
  DateTime due_date;

  /// เลขที่เช็ค
  String cheque_number;

  /// รหัสส่วนลด
  String code;

  /// รายละเอียด (เพิ่มเติม)
  String description;

  /// เลขคูปอง
  String number;

  /// อ้างอิง 1
  String reference_one;

  /// อ้างอิง 2
  String reference_two;

  /// รหัสกระเป๋า เจ้าของเงิน (Provider)
  String provider_code;

  /// เจ้าของเงิน (Provider)
  String provider_name;

  /// จำนวนเงิน
  double amount;

  BillPayObjectBoxStruct({
    this.doc_mode = 0,
    this.trans_flag = 0,
    this.bank_code = "",
    this.card_number = "",
    this.approved_code = "",
    this.bank_name = "",
    this.book_bank_code = "",
    this.branch_number = "",
    this.bank_reference = "",
    this.cheque_number = "",
    this.code = "",
    this.description = "",
    this.number = "",
    this.reference_one = "",
    this.reference_two = "",
    this.provider_code = "",
    this.provider_name = "",
    this.amount = 0,
  })  : due_date = DateTime.now(),
        doc_date_time = DateTime.now();

  factory BillPayObjectBoxStruct.fromJson(Map<String, dynamic> json) => _$BillPayObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$BillPayObjectBoxStructToJson(this);
}
