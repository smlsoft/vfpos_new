import 'package:dedepos/global.dart' as global;

double sumCreditCard() {
  double result = 0.0;
  if (global.payScreenData.credit_card != null) {
    for (var data in global.payScreenData.credit_card!) {
      result += data.amount;
    }
  }
  return result;
}

double sumTransfer() {
  double result = 0.0;
  if (global.payScreenData.transfer != null) {
    for (var data in global.payScreenData.transfer!) {
      result += data.amount;
    }
  }
  return result;
}

double sumCheque() {
  double result = 0.0;
  if (global.payScreenData.cheque != null) {
    for (var data in global.payScreenData.cheque!) {
      result += data.amount;
    }
  }
  return result;
}

double sumQr() {
  double result = 0.0;
  if (global.payScreenData.qr != null) {
    for (var data in global.payScreenData.qr!) {
      result += data.amount;
    }
  }
  return result;
}

double sumCoupon() {
  double result = 0.0;
  if (global.payScreenData.coupon != null) {
    for (var data in global.payScreenData.coupon!) {
      result += data.amount;
    }
  }
  return result;
}

double diffAmount() {
  double totalAmount = global.posHoldProcessResult[global.findPosHoldProcessResultIndex(global.posHoldActiveCode)].posProcess.total_amount;
  double sumCash = global.payScreenData.cash_amount;
  double sumDiscount = global.payScreenData.discount_amount;
  double sumTotalPayAmount = (sumCash + sumCreditCard() + sumTransfer() + sumCheque() + sumQr() + sumCoupon() + sumDiscount) - global.payScreenData.round_amount;

  return totalAmount - sumTotalPayAmount;
}
