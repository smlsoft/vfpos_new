import 'package:dedepos/global.dart' as global;

double sumCreditCard() {
  double result = 0.0;
  for (var data in global.payScreenData.credit_card) {
    result += data.amount;
  }
  return result;
}

double sumTransfer() {
  double result = 0.0;
  for (var data in global.payScreenData.transfer) {
    result += data.amount;
  }
  return result;
}

double sumCheque() {
  double result = 0.0;
  for (var data in global.payScreenData.cheque) {
    result += data.amount;
  }
  return result;
}

double sumQr() {
  double result = 0.0;
  for (var data in global.payScreenData.qr) {
    result += data.amount;
  }
  return result;
}

double sumCoupon() {
  double result = 0.0;
  for (var data in global.payScreenData.coupon) {
    result += data.amount;
  }
  return result;
}

double diffAmount() {
  int ticketNumber = global.findTicketNumber(global.posTicketActiveNumber);

  double totalAmount = (ticketNumber == -1)
      ? 0.0
      : global.posTicketProcessResult[ticketNumber].posProcess.total_amount;
  double sumCash = global.payScreenData.cash_amount;
  double sumDiscount = global.payScreenData.discount_amount;
  double sumTotalPayAmount = sumCash +
      sumCreditCard() +
      sumTransfer() +
      sumCheque() +
      sumQr() +
      sumCoupon() +
      sumDiscount;

  return totalAmount - sumTotalPayAmount;
}
