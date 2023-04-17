import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/pos_screen/pay/pay_util.dart';
import 'dart:async';
import 'package:dedepos/model/objectbox/config_struct.dart';
import 'package:dedepos/global.dart' as global;

Future<String> saveBill(
    {required double cashAmount,
    required String discountFormula,
    required double discountAmount}) async {
  String docNumber = await global.billRunning();

  // Header
  global.billHelper.insert(BillObjectBoxStruct(
      date_time: DateTime.now(),
      doc_number: docNumber,
      customer_code:
          global.posHoldProcessResult[global.posHoldActiveNumber].customerCode,
      customer_name:
          global.posHoldProcessResult[global.posHoldActiveNumber].customerName,
      customer_telephone: "",
      sale_code:
          global.posHoldProcessResult[global.posHoldActiveNumber].saleCode,
      sale_name:
          global.posHoldProcessResult[global.posHoldActiveNumber].saleName,
      total_amount: global.posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess.total_amount,
      cashier_code: global.userLoginCode,
      cashier_name: global.userLoginName,
      pay_cash_amount: cashAmount,
      is_sync: false,
      vat_rate: global.posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess.vat_rate,
      total_before_amount: global.posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess.total_before_amount,
      total_except_amount: global.posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess.total_except_amount,
      total_vat_amount: global.posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess.total_vat_amount,          
      discount_formula: discountFormula,
      sum_discount: discountAmount,
      sum_coupon: sumCoupon(),
      sum_qr_code: sumQr(),
      sum_credit_card: sumCreditCard(),
      sum_money_transfer: sumTransfer(),
      sum_cheque: sumCheque()));

  // รายละเอียด
  int lineNumber = 1;
  List<BillDetailObjectBoxStruct> details = [];
  for (var value in global
      .posHoldProcessResult[global.posHoldActiveNumber].posProcess.details) {
    details.add(BillDetailObjectBoxStruct(
        doc_number: docNumber,
        line_number: lineNumber,
        barcode: value.barcode,
        item_code: value.item_code,
        item_name: value.item_name,
        unit_code: value.unit_code,
        unit_name: value.unit_name,
        qty: value.qty,
        price: value.price,
        discount_text: value.discount_text,
        discount: value.discount,
        total_amount: value.total_amount));
    List<BillDetailExtraObjectBoxStruct> detailExtras = [];
    int extraLineNumber = 1;
    for (var element in value.extra) {
      detailExtras.add(BillDetailExtraObjectBoxStruct(
          doc_number: docNumber,
          line_number: extraLineNumber++,
          ref_line_number: lineNumber,
          barcode: element.barcode,
          item_code: element.item_code,
          item_name: element.item_name,
          unit_code: element.unit_code,
          unit_name: element.unit_name,
          qty: element.qty,
          total_amount: element.total_amount));
    }
    if (detailExtras.isNotEmpty) {
      global.billDetailExtraHelper.insertMany(detailExtras);
    }
    lineNumber++;
  }
  global.billDetailHelper.insertMany(details);
  // จ่าย
  List<BillPayObjectBoxStruct> pays = [];
  // บัตรเครดิต
  for (var value in global.payScreenData.credit_card) {
    pays.add(BillPayObjectBoxStruct(
      doc_number: docNumber,
      trans_flag: 1,
      bank_code: value.bank_code,
      bank_name: value.bank_name,
      card_number: value.card_number,
      amount: value.amount,
    ));
  }
  // เงินโอน
  for (var value in global.payScreenData.transfer) {
    pays.add(BillPayObjectBoxStruct(
      doc_number: docNumber,
      trans_flag: 2,
      bank_code: value.bank_code,
      bank_name: value.bank_name,
      bank_account_no: value.account_number,
      amount: value.amount,
    ));
  }
  // เช็ค
  for (var value in global.payScreenData.cheque) {
    BillPayObjectBoxStruct data = BillPayObjectBoxStruct(
      doc_number: docNumber,
      trans_flag: 3,
      bank_code: value.bank_code,
      bank_name: value.bank_name,
      cheque_number: value.cheque_number,
      branch_number: value.branch_number,
      amount: value.amount,
    );
    data.due_date = value.due_date;
    pays.add(data);
  }
  // คูปอง
  for (var value in global.payScreenData.coupon) {
    pays.add(BillPayObjectBoxStruct(
      doc_number: docNumber,
      trans_flag: 4,
      number: value.number,
      description: value.description,
      amount: value.amount,
    ));
  }
  // จ่ายด้วย QR
  for (var value in global.payScreenData.qr) {
    pays.add(BillPayObjectBoxStruct(
      doc_number: docNumber,
      trans_flag: 5,
      provider_code: value.provider_code,
      provider_name: value.provider_name,
      description: value.description,
      amount: value.amount,
    ));
  }

  global.billPayHelper.insertMany(pays);
  // Running เลขที่ใบเสร็จ
  global.configHelper.update(ConfigObjectBoxStruct(
      device_id: global.deviceId, last_doc_number: docNumber));
  return docNumber;
}

Future<void> processPromotionTemp() async {
  /*await global.promotionTempHelper.deleteAll();
    {
      // Discount
      await global.promotionHelper.select().then((promotion) {
        for (final _getPromotion in promotion)
          global.promotionDiscountHelper
              .select(
                  where: global.promotionDiscountTableName +
                      ".promotion_code='" +
                      _getPromotion.promotion_code +
                      "'")
              .then((promotionDiscount) {
            for (final _getPromotionDiscount in promotionDiscount) {
              final List<Product> _product = global.productHelper
                  .selectByBarcode(_getPromotionDiscount.promotion_barcode);
              for (final _getProduct in _product) {
                PromotionTempStruct _temp = PromotionTempStruct(
                    promotion_code: _getPromotion.promotion_code,
                    date_begin: _getPromotion.date_begin,
                    date_end: _getPromotion.date_end,
                    barcode_promotion: _getPromotionDiscount.promotion_barcode,
                    name_1: _getProduct.name1!,
                    name_2: _getProduct.name2!,
                    name_3: _getProduct.name3!,
                    name_4: _getProduct.name4!,
                    name_5: _getProduct.name5!,
                    customer_only: _getPromotion.customer_only,
                    discount: _getPromotionDiscount.promotion_discount,
                    limit_qty: _getPromotionDiscount.limit_qty,
                    promotion_name_1: _getPromotion.promotion_name_1,
                    promotion_name_2: _getPromotion.promotion_name_2,
                    promotion_name_3: _getPromotion.promotion_name_3,
                    promotion_name_4: _getPromotion.promotion_name_4,
                    promotion_name_5: _getPromotion.promotion_name_5);
                global.promotionTempHelper.insert(_temp);
              }
            }
          });
      });
    }*/
}
