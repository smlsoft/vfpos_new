import 'package:dedepos/global.dart' as global;

double sumCreditCard() {
  double _result = 0.0;
  for (var _data in global.payScreenData.credit_card) {
    _result += _data.amount;
  }
  return _result;
}

double sumTransfer() {
  double _result = 0.0;
  for (var _data in global.payScreenData.transfer) {
    _result += _data.amount;
  }
  return _result;
}

double sumCheque() {
  double _result = 0.0;
  for (var _data in global.payScreenData.cheque) {
    _result += _data.amount;
  }
  return _result;
}

double sumQr() {
  double _result = 0.0;
  for (var _data in global.payScreenData.qr) {
    _result += _data.amount;
  }
  return _result;
}

double sumCoupon() {
  double _result = 0.0;
  for (var _data in global.payScreenData.coupon) {
    _result += _data.amount;
  }
  return _result;
}

double diffAmount() {
  double _totalAmount = global
      .posHoldProcessResult[global.posHoldActiveNumber].posProcess.total_amount;
  double _sumCash = global.payScreenData.cash_amount;
  double _sumDiscount = global.payScreenData.discount_amount;
  double _sumCreditCard = sumCreditCard();
  double _sumTransfer = sumTransfer();
  double _sumCheque = sumCheque();
  double _sumQr = sumQr();
  double _sumCoupon = sumCoupon();
  double _sumTotalPayAmount = _sumCash +
      _sumCreditCard +
      _sumTransfer +
      _sumCheque +
      _sumQr +
      _sumCoupon +
      _sumDiscount;

  return _totalAmount - _sumTotalPayAmount;
}
