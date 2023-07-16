import 'dart:async';
import 'dart:convert';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/model/trans_model.dart';
import 'package:dedepos/api/user_repository.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';
import 'package:dio/dio.dart';

Future syncBillData() async {
  List<BillObjectBoxStruct> bills = (global.billHelper.selectSyncIsFalse());
  for (int index = 0; index < bills.length; index++) {
    BillObjectBoxStruct bill = bills[index];
    List<TransNameInfoModel> custNames = [
      TransNameInfoModel(
        code: "th",
        isauto: false,
        isdelete: false,
        name: bill.customer_name,
      )
    ];

    List<BillDetailObjectBoxStruct> billDetails = global.objectBoxStore
        .box<BillDetailObjectBoxStruct>()
        .query(BillDetailObjectBoxStruct_.doc_number.equals(bill.doc_number))
        .order(BillDetailObjectBoxStruct_.line_number)
        .build()
        .find();

    List<TransDetailModel> details = [];
    for (var detail in billDetails) {
      details.add(TransDetailModel(
        averagecost: 0,
        barcode: detail.barcode,
        calcflag: 0,
        discount: detail.discount_text,
        discountamount: detail.discount,
        standvalue: 1,
        dividevalue: 1,
        docdatetime: bill.date_time.toUtc().toIso8601String(),
        docref: "",
        docrefdatetime: null,
        inquirytype: 0,
        ispos: 1,
        itemcode: detail.item_code,
        itemguid: "",
        itemnames: [
          TransNameInfoModel(
            code: "th",
            isauto: false,
            isdelete: false,
            name: detail.item_name,
          )
        ],
        itemtype: 0,
        laststatus: 0,
        linenumber: detail.line_number,
        locationcode: "",
        locationnames: [],
        multiunit: false,
        price: detail.price,
        priceexcludevat: 0,
        qty: detail.qty,
        remark: "",
        shelfcode: "",
        sumamount: 0,
        sumamountexcludevat: 0,
        sumofcost: 0,
        taxtype: 0,
        tolocationcode: "",
        tolocationnames: [],
        totalqty: detail.qty,
        totalvaluevat: 0,
        towhcode: "",
        towhnames: [],
        unitcode: detail.unit_code,
        unitnames: [
          TransNameInfoModel(
            code: "th",
            isauto: false,
            isdelete: false,
            name: detail.unit_name,
          )
        ],
        vatcal: 0,
        vattype: 0,
        whcode: "",
        whnames: [],
      ));
    }
    List<BillPayObjectBoxStruct> payDetails =
        (jsonDecode(bill.pay_json) as List)
            .map((e) => BillPayObjectBoxStruct.fromJson(e))
            .toList();
    List<TransPaymentCreditCardModel> paymentCreditCards = [];
    List<TransPaymentTransferModel> paymentTransfers = [];
    for (var payDetail in payDetails) {
      // 1=บัตรเครดิต,2=เงินโอน,3=เช็ค,4=คูปอง,5=QR
      switch (payDetail.trans_flag) {
        case 1: // 1=บัตรเครดิต
          paymentCreditCards.add(TransPaymentCreditCardModel(
              amount: payDetail.amount,
              cardnumber: payDetail.card_number,
              chargevalue: 0,
              chargeword: "",
              docdatetime: payDetail.doc_date_time.toString(),
              totalnetworth: payDetail.amount));
          break;
        case 2: // 2=เงินโอน
          paymentTransfers.add(TransPaymentTransferModel(
            accountnumber: payDetail.bank_account_no,
            amount: payDetail.amount,
            bankcode: payDetail.bank_code,
            banknames: [
              TransNameInfoModel(
                code: "th",
                isauto: false,
                isdelete: false,
                name: payDetail.bank_name,
              )
            ],
            docdatetime: payDetail.doc_date_time.toString(),
          ));
          break;
        case 3: // 3=เช็ค
          break;
        case 4: // 4=คูปอง
          break;
        case 5: // 5=QR
          break;
      }
    }

    TransPaymentDetailModel paymentDetail = TransPaymentDetailModel(
      cashamount: bill.pay_cash_amount,
      cashamounttext: "",
      paymentcreditcards: paymentCreditCards,
      paymenttransfers: paymentTransfers,
    );
    TransactionModel trans = TransactionModel(
        cashiercode: bill.cashier_code,
        custcode: bill.customer_code,
        custnames: custNames,
        description: "POS",
        discountword: bill.discount_formula,
        docdatetime: bill.date_time.toUtc().toIso8601String(),
        docno: bill.doc_number,
        docrefdate: null,
        docrefno: "",
        docreftype: 0,
        doctype: 0,
        guidref: "",
        inquirytype: 0,
        iscancel: bill.is_cancel,
        ismanualamount: false,
        ispos: true,
        membercode: bill.customer_code,
        salecode: bill.sale_code,
        salename: bill.sale_name,
        status: 0,
        taxdocdate: bill.date_time.toUtc().toIso8601String(),
        taxdocno: bill.doc_number,
        totalaftervat: 0,
        totalamount: bill.total_amount,
        totalbeforevat: 0,
        totalcost: 0,
        totaldiscount: bill.total_discount,
        totalexceptvat: bill.total_except_amount,
        totalvalue: bill.total_amount,
        totalvatvalue: bill.total_vat_amount,
        transflag: 0,
        vatrate: bill.vat_rate,
        vattype: 0,
        details: details,
        paymentdetail: paymentDetail);

    await saveTransaction(trans);

    /*BillObjectBoxStruct bill = bills[index];
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
    serviceLocator<Log>().debug(json);*/
  }
}

Future<ApiResponse> saveTransaction(TransactionModel trx) async {
  Dio client = Client().init();
  String jsonPayload = jsonEncode(trx.toJson());
  try {
    final response =
        await client.post('/transaction/sale-invoice', data: trx.toJson());
    try {
      final rawData = json.decode(response.toString());

      //   print(rawData);

      if (rawData['error'] != null) {
        String errorMessage = '${rawData['code']}: ${rawData['message']}';
        serviceLocator<Log>().error(errorMessage);
        throw Exception('${rawData['code']}: ${rawData['message']}');
      }

      return ApiResponse.fromMap(rawData);
    } catch (ex) {
      serviceLocator<Log>().error(ex);
      throw Exception(ex);
    }
  } on DioError catch (ex) {
    String errorMessage = ex.response.toString();
    serviceLocator<Log>().error(errorMessage);
    throw Exception(errorMessage);
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
              serviceLocator<Log>().debug("Login Success");
              ApiResponse selectShop =
                  await userRepository.selectShop(global.apiShopID);
              if (selectShop.success) {
                serviceLocator<Log>().debug("Select Shop Success");
              }
            }
          }).catchError((e) {
            serviceLocator<Log>().error(e);
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
