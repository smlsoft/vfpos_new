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

  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

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
  DateTime table_open_date_time;

  /// เวลาปิดโต๊ะ
  DateTime table_close_date_time;

  BillObjectBoxStruct(
      {required this.date_time,
      required this.table_open_date_time,
      required this.table_close_date_time,
      this.doc_number = "",
      this.doc_mode = 1,
      this.customer_code = "",
      this.customer_name = "",
      this.customer_telephone = "",
      this.vat_rate = 0.0,
      this.total_amount = 0.0,
      this.total_before_amount = 0.0,
      this.total_vat_amount = 0.0,
      this.total_except_amount = 0.0,
      this.cashier_code = "",
      this.cashier_name = "",
      this.sale_code = "",
      this.sale_name = "",
      this.is_sync = false,
      this.discount_formula = "",
      this.pay_cash_amount = 0.0,
      this.sum_discount = 0.0,
      this.sum_qr_code = 0.0,
      this.sum_credit_card = 0.0,
      this.sum_money_transfer = 0.0,
      this.sum_coupon = 0.0,
      this.sum_cheque = 0.0,
      this.is_cancel = false,
      this.cancel_date_time = "",
      this.cancel_user_code = "",
      this.cancel_user_name = "",
      this.cancel_reason = "",
      this.cancel_description = "",
      this.full_vat_print = false,
      this.full_vat_doc_number = "",
      this.full_vat_name = "",
      this.full_vat_address = "",
      this.full_vat_tax_id = "",
      this.full_vat_branch_number = "",
      this.table_number = "",
      this.child_count = 0,
      this.woman_count = 0,
      this.man_count = 0,
      this.table_al_la_crate_mode = false,
      this.buffet_code = "",
      this.print_copy_bill_date_time = const []});
}

@Entity()
class BillDetailObjectBoxStruct {
  int id;

  /// เลขที่เอกสาร
  String doc_number;

  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

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

  BillDetailObjectBoxStruct({
    this.id = 0,
    this.line_number = 0,
    this.doc_mode = 1,
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
    this.total_amount = 0,
  });
}

@Entity()
class BillDetailExtraObjectBoxStruct {
  int id;

  /// เลขที่เอกสาร
  String doc_number;

  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

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
      this.doc_mode = 1,
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
  String doc_number;

  /// ประเภทเอกสาร (1 = ขาย, 2 = คืน)
  int doc_mode;

  /// 1=บัตรเครดิต,2=เงินโอน,3=เช็ค,4=คูปอง,5=QR
  int trans_flag;

  /// รหัสธนาคาร
  String bank_code;

  /// ชื่อธนาคาร (อื่นๆ)
  String bank_name;

  /// เลขที่บัญชี (เงินเข้า)
  String bank_account_no;

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
    this.id = 0,
    this.doc_number = "",
    this.doc_mode = 1,
    this.trans_flag = 0,
    this.bank_code = "",
    this.card_number = "",
    this.approved_code = "",
    this.bank_name = "",
    this.bank_account_no = "",
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
}
