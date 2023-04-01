class PosPayModel {
  String cash_amount_text = "";
  double cash_amount = 0; // ยอดชำระเงินสด
  String discount_formula = ""; // สูตรส่วนลด
  double discount_amount = 0; // ยอดส่วนลด
  List<PayCreditCardModel> credit_card = []; // บัตรเครดิต
  List<PayTransferModel> transfer = []; // เงินโอน
  List<PayChequeModel> cheque = []; // เช็ค
  List<PayCouponModel> coupon = []; // คูปอง
  List<PayQrModel> qr = [];
}

class PayCouponModel {
  String number; // เลขที่คูปอง
  String description; // รายละเอียด
  double amount; // จำนวนเงิน

  PayCouponModel(
      {required this.number, required this.description, required this.amount});
}

class PayCashModel {
  String wallet_id; // รหัส
  String amount; // จำนวนเงิน

  PayCashModel({required this.wallet_id, required this.amount});
}

class PayCreditCardModel {
  String bank_code; // รหัสธนาคาร
  String bank_name; // ธนาคาร
  String card_number; // เลขที่บัตรเครดิต
  String approved_code; // รหัสอนุมัติ
  double amount; // จำนวนเงิน

  PayCreditCardModel(
      {required this.bank_code,
      required this.bank_name,
      required this.card_number,
      required this.approved_code,
      required this.amount});
}

class PayTransferModel {
  String bank_code; // รหัสธนาคาร
  String bank_name; // ธนาคาร
  String account_number; // เลขที่บัญชี
  double amount; // จำนวนเงิน

  PayTransferModel(
      {required this.bank_code,
      required this.bank_name,
      required this.amount,
      required this.account_number});
}

class PayChequeModel {
  DateTime due_date; // วันที่สั่งจ่ายบนเช็ค
  String bank_code; // รหัสธนาคาร
  String bank_name; // ธนาคาร
  String branch_number; // สาขาธนาคาร
  String cheque_number; // เลขที่เช็ค
  double amount; // จำนวนเงิน

  PayChequeModel(
      {required this.due_date,
      required this.bank_code,
      required this.bank_name,
      required this.branch_number,
      required this.cheque_number,
      required this.amount});
}

class PayDiscountModel {
  String code; // รหัสส่วนลด
  String description; // รายละเอียด (เพิ่มเติม)
  String formula; // สูตร
  double amount; // มูลค่าส่วนลด

  PayDiscountModel(
      {required this.code,
      required this.description,
      required this.formula,
      required this.amount});
}

class PayQrModel {
  String provider_code; // รหัสกระเป๋า เจ้าของเงิน (Provider)
  String provider_name; // เจ้าของเงิน (Provider)
  String description; // รายละเอียด (อื่นๆ)
  double amount; // จำนวนเงิน

  PayQrModel(
      {this.provider_code = "",
      this.provider_name = "",
      this.description = "",
      required this.amount});
}
