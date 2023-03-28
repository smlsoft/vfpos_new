class PayStruct {
  String cash_amount_text = "";
  double cash_amount = 0; // ยอดชำระเงินสด
  String discount_formula = ""; // สูตรส่วนลด
  double discount_amount = 0; // ยอดส่วนลด
  List<PayCreditCardStruct> credit_card = []; // บัตรเครดิต
  List<PayTransferStruct> transfer = []; // เงินโอน
  List<PayChequeStruct> cheque = []; // เช็ค
  List<PayCouponStruct> coupon = []; // คูปอง
  List<PayQrStruct> qr = [];
}

class PayCouponStruct {
  String number; // เลขที่คูปอง
  String description; // รายละเอียด
  double amount; // จำนวนเงิน

  PayCouponStruct(
      {required this.number, required this.description, required this.amount});
}

class PayCashStruct {
  String wallet_id; // รหัส
  String amount; // จำนวนเงิน

  PayCashStruct({required this.wallet_id, required this.amount});
}

class PayCreditCardStruct {
  String bank_code; // รหัสธนาคาร
  String bank_name; // ธนาคาร
  String card_number; // เลขที่บัตรเครดิต
  String approved_code; // รหัสอนุมัติ
  double amount; // จำนวนเงิน

  PayCreditCardStruct(
      {required this.bank_code,
      required this.bank_name,
      required this.card_number,
      required this.approved_code,
      required this.amount});
}

class PayTransferStruct {
  String bank_code; // รหัสธนาคาร
  String bank_name; // ธนาคาร
  String account_number; // เลขที่บัญชี
  double amount; // จำนวนเงิน

  PayTransferStruct(
      {required this.bank_code,
      required this.bank_name,
      required this.amount,
      required this.account_number});
}

class PayChequeStruct {
  DateTime due_date; // วันที่สั่งจ่ายบนเช็ค
  String bank_code; // รหัสธนาคาร
  String bank_name; // ธนาคาร
  String branch_number; // สาขาธนาคาร
  String cheque_number; // เลขที่เช็ค
  double amount; // จำนวนเงิน

  PayChequeStruct(
      {required this.due_date,
      required this.bank_code,
      required this.bank_name,
      required this.branch_number,
      required this.cheque_number,
      required this.amount});
}

class PayDiscountStruct {
  String code; // รหัสส่วนลด
  String description; // รายละเอียด (เพิ่มเติม)
  String formula; // สูตร
  double amount; // มูลค่าส่วนลด

  PayDiscountStruct(
      {required this.code,
      required this.description,
      required this.formula,
      required this.amount});
}

class PayQrStruct {
  String provider_code; // รหัสกระเป๋า เจ้าของเงิน (Provider)
  String provider_name; // เจ้าของเงิน (Provider)
  String description; // รายละเอียด (อื่นๆ)
  double amount; // จำนวนเงิน

  PayQrStruct(
      {this.provider_code = "",
      this.provider_name = "",
      this.description = "",
      required this.amount});
}
