import 'dart:convert';

import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'dart:async';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:flutter/material.dart';

class SaveBillResultClass {
  late String docNumber;
  late DateTime docDate;
}

Future<SaveBillResultClass> saveBill(
    {required double cashAmount, required String discountFormula}) async {
  SaveBillResultClass result = SaveBillResultClass();
  String docNumber = await global.billRunning();
  DateTime docDate = DateTime.now();
  result.docNumber = docNumber;
  result.docDate = docDate;

  PosHoldProcessModel posHoldProcess = global.posHoldProcessResult[
      global.findPosHoldProcessResultIndex(global.posHoldActiveCode)];

  // จ่าย
  List<BillPayObjectBoxStruct> pays = [];
  // บัตรเครดิต
  if (global.payScreenData.credit_card != null) {
    for (var value in global.payScreenData.credit_card!) {
      pays.add(BillPayObjectBoxStruct(
        trans_flag: 1,
        bank_code: value.bank_code,
        bank_name: value.bank_name,
        card_number: value.card_number,
        amount: value.amount,
      ));
    }
  }
  // เงินโอน
  if (global.payScreenData.transfer != null) {
    for (var value in global.payScreenData.transfer!) {
      pays.add(BillPayObjectBoxStruct(
        trans_flag: 2,
        bank_code: value.bank_code,
        bank_name: value.bank_name,
        bank_account_no: value.account_number,
        amount: value.amount,
      ));
    }
  }
  // เช็ค
  if (global.payScreenData.cheque != null) {
    for (var value in global.payScreenData.cheque!) {
      BillPayObjectBoxStruct data = BillPayObjectBoxStruct(
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
  }
  // คูปอง
  if (global.payScreenData.coupon != null) {
    for (var value in global.payScreenData.coupon!) {
      pays.add(BillPayObjectBoxStruct(
        trans_flag: 4,
        number: value.number,
        description: value.description,
        amount: value.amount,
      ));
    }
  }
  // จ่ายด้วย QR
  if (global.payScreenData.qr != null) {
    for (var value in global.payScreenData.qr!) {
      pays.add(BillPayObjectBoxStruct(
        trans_flag: 5,
        provider_code: value.provider_code,
        provider_name: value.provider_name,
        description: value.description,
        amount: value.amount,
      ));
    }
  }

  // รายละเอียด
  int lineNumber = 1;
  List<BillDetailObjectBoxStruct> details = [];
  for (var value in posHoldProcess.posProcess.details) {
    List<BillDetailExtraObjectBoxStruct> detailExtras = [];
    for (var element in value.extra) {
      detailExtras.add(BillDetailExtraObjectBoxStruct(
          barcode: element.barcode,
          item_code: element.item_code,
          item_name: element.item_name,
          unit_code: element.unit_code,
          unit_name: element.unit_name,
          qty: element.qty,
          total_amount: element.total_amount));
    }
    details.add(BillDetailObjectBoxStruct(
        doc_number: docNumber,
        line_number: lineNumber,
        barcode: value.barcode,
        item_code: value.item_code,
        item_name: value.item_name,
        unit_code: value.unit_code,
        unit_name: value.unit_name,
        sku: "",
        qty: value.qty,
        price: value.price,
        discount_text: value.discount_text,
        discount: value.discount,
        extra_json: jsonEncode(detailExtras),
        total_amount: value.total_amount));
    lineNumber++;
  }
  // รายละเอียดโต๊ะ (DEDE POS Cafe)
  int manCount = 0;
  int womanCount = 0;
  int childCount = 0;
  String buffetCode = "";
  // ยอดรวมก่อนคำนวณภาษี
  // Save
  BillObjectBoxStruct billData = BillObjectBoxStruct(
      doc_mode: 1, // 1=ขาย,2=คืน
      vat_mode: posHoldProcess.posProcess.vat_mode,
      is_cancel: false,
      cancel_date_time: "",
      cancel_user_code: "",
      cancel_user_name: "",
      cancel_description: "",
      cancel_reason: "",
      full_vat_address: "",
      full_vat_branch_number: "",
      full_vat_name: "",
      full_vat_doc_number: "",
      full_vat_print: false,
      full_vat_tax_id: "",
      table_al_la_crate_mode: false,
      table_number: global.tableNumberSelected,
      child_count: childCount,
      woman_count: womanCount,
      man_count: manCount,
      buffet_code: buffetCode,
      total_qty: posHoldProcess.posProcess.total_piece,
      print_copy_bill_date_time: [],
      date_time: docDate,
      table_close_date_time: DateTime.now(),
      table_open_date_time: DateTime.now(),
      doc_number: docNumber,
      customer_code: posHoldProcess.customerCode,
      customer_name: posHoldProcess.customerName,
      customer_telephone: posHoldProcess.customerPhone,
      sale_code: posHoldProcess.saleCode,
      sale_name: posHoldProcess.saleName,
      total_amount: posHoldProcess.posProcess.total_amount,
      cashier_code: global.userLogin!.code,
      cashier_name: global.userLogin!.name,
      pay_cash_amount: cashAmount,
      pay_cash_change: 0,
      is_sync: false,
      amount_except_vat: posHoldProcess.posProcess.amount_except_vat,
      amount_before_calc_vat: posHoldProcess.posProcess.amount_before_calc_vat,
      amount_after_calc_vat: posHoldProcess.posProcess.amount_after_calc_vat,
      vat_rate: posHoldProcess.posProcess.vat_rate,
      is_vat_register: posHoldProcess.posProcess.is_vat_register,
      total_item_vat_amount: posHoldProcess.posProcess.total_item_vat_amount,
      total_item_except_vat_amount:
          posHoldProcess.posProcess.total_item_except_vat_amount,
      total_vat_amount: posHoldProcess.posProcess.total_vat_amount,
      discount_formula: discountFormula,
      total_discount: posHoldProcess.posProcess.total_discount,
      total_discount_vat_amount:
          posHoldProcess.posProcess.total_discount_vat_amount,
      total_discount_except_vat_amount:
          posHoldProcess.posProcess.total_discount_except_vat_amount,
      pay_json: jsonEncode(pays),
      sum_coupon: sumCoupon(),
      sum_qr_code: sumQr(),
      sum_credit_card: sumCreditCard(),
      sum_money_transfer: sumTransfer(),
      sum_cheque: sumCheque());

  global.billHelper.insert(billData);
  global.objectBoxStore.box<BillDetailObjectBoxStruct>().putMany(details);
  // update Order Temp ร้านอาหาร
  if (global.tableNumberSelected.isNotEmpty) {
    final orderTemps = global.objectBoxStore
        .box<OrderTempObjectBoxStruct>()
        .query(OrderTempObjectBoxStruct_.orderId
            .equals(global.tableNumberSelected)
            .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)))
        .build()
        .find();
    for (int index = 0; index < orderTemps.length; index++) {
      orderTemps[index].isPaySuccess = true;
      global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .put(orderTemps[index], mode: PutMode.update);
    }
  }
  return result;
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

Widget posBill(BillObjectBoxStruct bill) {
  return Container(
      width: 300,
      padding: const EdgeInsets.all(4),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(3),
        },
        children: [
          TableRow(children: [
            Text(global.language("doc_number")),
            Text(
              bill.doc_number,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          TableRow(children: [
            Text(global.language("doc_date")),
            Text(
              global.dateFormat(bill.date_time),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          TableRow(children: [
            Text(global.language("doc_time")),
            Text(
              global.timeFormat(bill.date_time),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          TableRow(children: [
            Text(global.language("amount")),
            Text(
              global.moneyFormat.format(bill.total_amount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          TableRow(children: [
            Text(global.language("copy")),
            Text(
              global.moneyFormat.format(bill.print_copy_bill_date_time.length),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
        ],
      ));
}

Widget posBillDetail({required String docNumber}) {
  BillObjectBoxStruct? bill = global.billHelper
      .selectByDocNumber(docNumber: docNumber, posScreenMode: 1);
  if (bill == null) {
    return Text("Bill {$docNumber} not found");
  }
  List<BillDetailObjectBoxStruct> billDetails = global.objectBoxStore
      .box<BillDetailObjectBoxStruct>()
      .query(BillDetailObjectBoxStruct_.doc_number.equals(bill.doc_number))
      .order(BillDetailObjectBoxStruct_.line_number)
      .build()
      .find();

  return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                children: [
                  Text(global.language("doc_number")),
                  Text(bill.doc_number),
                ],
              ),
              TableRow(
                children: [
                  Text(global.language("doc_date")),
                  Text(global.dateTimeFormatFull(bill.date_time)),
                ],
              ),
              TableRow(
                children: [
                  Text(global.language("total_amount")),
                  Text(global.moneyFormat.format(bill.total_amount)),
                ],
              ),
              TableRow(
                children: [
                  Text(global.language("discount")),
                  Text(bill.discount_formula),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Table(
            border: TableBorder.all(width: 0.5, color: Colors.grey),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(5),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.cyan.shade100),
                children: [
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        global.language("line"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(global.language("item_name"),
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(global.language("unit_name"),
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(global.language("qty"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(global.language("price"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(global.language("total_amount"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                ],
              ),
              for (var i = 0; i < billDetails.length; i++)
                TableRow(
                  decoration: BoxDecoration(
                      color:
                          (i % 2 == 0) ? Colors.white : Colors.grey.shade200),
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text((i + 1).toString(),
                            textAlign: TextAlign.center)),
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(global.getNameFromJsonLanguage(
                            billDetails[i].item_name,
                            global.userScreenLanguage))),
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(global.getNameFromJsonLanguage(
                            billDetails[i].unit_name,
                            global.userScreenLanguage))),
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            global.moneyFormat.format(billDetails[i].qty),
                            textAlign: TextAlign.right)),
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            global.moneyFormat.format(billDetails[i].price),
                            textAlign: TextAlign.right)),
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            global.moneyFormat
                                .format(billDetails[i].total_amount),
                            textAlign: TextAlign.right)),
                  ],
                ),
            ],
          ),
        ],
      ));
}
