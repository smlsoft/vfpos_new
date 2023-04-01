import 'dart:async';
import 'dart:convert';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/api/api_bill_model.dart';
import 'package:dedepos/api/sync/api/api_repository.dart';
import 'package:dedepos/api/user_repository.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/db/master_bank_helper.dart';
import 'package:dedepos/db/product_category_helper.dart';
import 'package:dedepos/model/system/bank_and_wallet_model.dart';
import 'package:dedepos/api/sync/model/bank_and_wallet_model.dart';
import 'package:dedepos/api/sync/model/employee_model.dart';
import 'package:dedepos/model/objectbox/bank_and_wallet_struct.dart';
import 'package:dedepos/api/sync/model/sync_inventory_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

Future syncBillData() async {
  List<BillObjectBoxStruct> bills = (global.billHelper.selectSyncIsFalse());
  for (int index = 0; index < bills.length; index++) {
    BillObjectBoxStruct bill = bills[index];
    List<ApiBillDetailStruct> apiBillDetails = [];
    List<BillDetailObjectBoxStruct> billDetails =
        (global.billDetailHelper.selectByDocNumber(docNumber: bill.doc_number));
    for (var detail in billDetails) {
      List<ApiBillDetailExtraStruct> extraDetails = [];
      List<BillDetailExtraObjectBoxStruct> extras = global.billDetailExtraHelper
          .selectByDocNumberAndLineNumber(
              docNumber: detail.doc_number, lineNumber: detail.line_number);
      for (var extra in extras) {
        extraDetails.add(ApiBillDetailExtraStruct(
          doc_number: extra.doc_number,
          date_time: bill.date_time,
          barcode: extra.barcode,
          item_code: extra.item_code,
          item_name: extra.item_name,
          unit_code: extra.unit_code,
          unit_name: extra.unit_name,
          qty: extra.qty,
          price: extra.price,
          total_amount: extra.total_amount,
          line_number: extra.line_number,
          ref_line_number: extra.ref_line_number,
        ));
      }
      apiBillDetails.add(
        ApiBillDetailStruct(
          doc_number: detail.doc_number,
          date_time: bill.date_time,
          line_number: detail.line_number,
          barcode: detail.barcode,
          item_code: detail.item_code,
          item_name: detail.item_name,
          unit_code: detail.unit_code,
          unit_name: detail.unit_name,
          discount_text: detail.discount_text,
          qty: detail.qty,
          price: detail.price,
          discount: detail.discount,
          total_amount: detail.total_amount,
          extra_details: extraDetails,
        ),
      );
    }

    List<ApiBillPayQrStruct> payQrs = [];
    List<ApiBillPayChequeStruct> payCheques = [];
    List<ApiBillPayCreditCardStruct> payCreditCards = [];
    List<ApiBillPayTransferStruct> payTransfers = [];
    List<ApiBillPayCouponStruct> coupons = [];

    List<BillPayObjectBoxStruct> payDetails =
        global.billPayHelper.selectByDocNumber(docNumber: bill.doc_number);
    for (var payDetail in payDetails) {
      // 1=บัตรเครดิต,2=เงินโอน,3=เช็ค,4=คูปอง,5=QR
      switch (payDetail.trans_flag) {
        case 1:
          payCreditCards.add(ApiBillPayCreditCardStruct(
            doc_number: payDetail.doc_number,
            date_time: payDetail.doc_date_time,
            edc_code: payDetail.bank_code,
            card_number: payDetail.card_number,
            approved_code: payDetail.approved_code,
            edc_name: payDetail.bank_name,
            amount: payDetail.amount,
          ));
          break;
        case 2:
          payTransfers.add(ApiBillPayTransferStruct(
            doc_number: payDetail.doc_number,
            date_time: payDetail.doc_date_time,
            bank_code: payDetail.bank_code,
            bank_name: payDetail.bank_name,
            amount: payDetail.amount,
          ));
          break;
        case 3:
          payCreditCards.add(ApiBillPayCreditCardStruct(
            doc_number: payDetail.doc_number,
            date_time: payDetail.doc_date_time,
            edc_code: payDetail.bank_code,
            card_number: payDetail.card_number,
            approved_code: payDetail.approved_code,
            edc_name: payDetail.bank_name,
            amount: payDetail.amount,
          ));
          break;
        case 4:
          coupons.add(ApiBillPayCouponStruct(
            doc_number: payDetail.doc_number,
            date_time: payDetail.doc_date_time,
            number: payDetail.number,
            amount: payDetail.amount,
          ));
          break;
        case 5:
          payQrs.add(ApiBillPayQrStruct(
            doc_number: payDetail.doc_number,
            date_time: payDetail.doc_date_time,
            description: payDetail.description,
            provider_code: payDetail.provider_code,
            provider_name: payDetail.provider_name,
            amount: payDetail.amount,
          ));
          break;
      }
    }

    ApiBillStruct apiBill = ApiBillStruct(
      doc_number: bill.doc_number,
      date_time: bill.date_time,
      customer_code: bill.customer_code,
      customer_name: bill.customer_name,
      customer_telephone: bill.customer_telephone,
      total_amount: bill.total_amount,
      sale_code: bill.sale_code,
      sale_name: bill.sale_name,
      cashier_code: bill.cashier_code,
      cashier_name: bill.cashier_name,
      pay_cash_amount: bill.pay_cash_amount,
      sum_discount: bill.sum_discount,
      sum_qrcode: bill.sum_qr_code,
      sum_credit_card: bill.sum_credit_card,
      sum_money_transfer: bill.sum_money_transfer,
      sum_cheque: bill.sum_cheque,
      sum_coupon: bill.sum_coupon,
      bill_details: apiBillDetails,
      pay_qrcodes: payQrs,
      pay_cheques: payCheques,
      pay_credit_cards: payCreditCards,
      coupons: coupons,
      pay_money_transfers: payTransfers,
    );
    String json = jsonEncode(apiBill.toJson());
    print(json);
  }
}

Future syncBillProcess() async {
  if (global.syncDataProcess == false) {
    global.syncDataProcess = true;
    global.isOnline = await global.hasNetwork();
    if (global.isOnline) {
      if (global.apiConnected == false) {
        if (!global.loginProcess) {
          global.loginProcess = true;
          UserRepository userRepository = UserRepository();
          await userRepository
              .authenUser(global.apiUserName, global.apiUserPassword)
              .then((result) async {
            if (result.success) {
              global.apiConnected = true;
              global.appStorage.write("token", result.data["token"]);
              print("Login Succerss");
              ApiResponse selectShop =
                  await userRepository.selectShop(global.apiShopID);
              if (selectShop.success) {
                print("Select Shop Sucess");
              }
            }
          }).catchError((e) {
            print(e);
          }).whenComplete(() async {
            global.loginProcess = false;
            await syncBillData();
          });
        }
      } else {
        await syncBillData();
      }
    }
    global.syncDataProcess = false;
  }
}
