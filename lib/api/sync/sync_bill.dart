import 'dart:async';
import 'dart:convert';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/model/shift_model.dart';
import 'package:dedepos/api/sync/model/trans_model.dart';
import 'package:dedepos/api/user_repository.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/shift_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

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
          itemnames: (jsonDecode(detail.item_name) as List).map((e) => TransNameInfoModel.fromJson(e)).toList(),
          itemtype: 0,
          laststatus: 0,
          linenumber: detail.line_number,
          locationcode: global.posConfig.location.code,
          locationnames: global.posConfig.location.names,
          multiunit: false,
          price: detail.price,
          priceexcludevat: detail.price_exclude_vat,
          qty: detail.qty,
          remark: "",
          shelfcode: "",
          sumamount: (detail.price * detail.qty) - detail.discount,
          sumamountexcludevat: 0,
          sumofcost: 0,
          taxtype: bill.bill_tax_type,
          tolocationcode: "",
          tolocationnames: [],
          totalqty: detail.qty,
          totalvaluevat: 0,
          towhcode: "",
          towhnames: [],
          unitcode: detail.unit_code,
          unitnames: (jsonDecode(detail.unit_name) as List).map((e) => TransNameInfoModel.fromJson(e)).toList(),
          vatcal: (detail.is_except_vat) ? 1 : 0,
          vattype: detail.vat_type,
          whcode: global.posConfig.warehouse.code,
          whnames: global.posConfig.warehouse.names,
          sku: detail.sku,
          extrajson: detail.extra_json));
    }
    List<BillPayObjectBoxStruct> payDetails = (jsonDecode(bill.pay_json) as List).map((e) => BillPayObjectBoxStruct.fromJson(e)).toList();
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
            accountnumber: payDetail.book_bank_code,
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
      cashamount: 0,
      cashamounttext: "",
      paymentcreditcards: [],
      paymenttransfers: [],
    );
    int trans_vat_type = 0;
    if (!global.posConfig.isvatregister) {
      trans_vat_type = 3;
    } else if (global.posConfig.isvatregister && global.posConfig.vattype == 0) {
      trans_vat_type = 1;
    } else if (global.posConfig.isvatregister && global.posConfig.vattype == 1) {
      trans_vat_type = 0;
    }
    TransactionModel trans = TransactionModel(
        cashiercode: bill.cashier_code,
        custcode: bill.customer_code,
        custnames: custNames,
        description: "POS",
        discountword: bill.discount_formula,
        docdatetime: bill.date_time.toUtc().toIso8601String(),
        docno: bill.doc_number,
        docrefdate: bill.date_time.toUtc().toIso8601String(),
        docrefno: "",
        docreftype: 0,
        doctype: 0,
        guidref: "",
        inquirytype: (bill.doc_mode == 1) ? 1 : 2,
        iscancel: bill.is_cancel,
        ismanualamount: false,
        ispos: true,
        posid: global.posConfig.code,
        membercode: bill.customer_code,
        salecode: bill.sale_code,
        salename: bill.sale_name,
        status: 0,
        taxdocdate: bill.date_time.toUtc().toIso8601String(),
        taxdocno: bill.doc_number,
        totalaftervat: bill.amount_after_calc_vat,
        totalamount: (bill.amount_after_calc_vat + bill.amount_except_vat) - bill.total_discount,
        totalbeforevat: bill.amount_before_calc_vat,
        totalcost: 0,
        totaldiscount: bill.total_discount,
        totalexceptvat: bill.amount_except_vat,
        totalvalue: bill.detail_total_amount,
        totalvatvalue: bill.total_vat_amount,
        transflag: 0,
        vatrate: bill.vat_rate,
        vattype: trans_vat_type,
        details: details,
        paycashamount: bill.pay_cash_amount,
        paymentdetail: paymentDetail,
        paymentdetailraw: bill.pay_json,
        billtaxtype: bill.bill_tax_type,
        buffetcode: bill.buffet_code,
        canceldatetime: bill.cancel_date_time,
        canceldescription: bill.cancel_description,
        cancelusercode: bill.cancel_user_code,
        cancelusername: bill.cancel_user_name,
        cancelreason: bill.cancel_reason,
        cashiername: bill.cashier_name,
        childcount: bill.child_count,
        customertelephone: bill.customer_telephone,
        detaildiscountformula: bill.detail_discount_formula,
        detailtotalamount: bill.detail_total_amount,
        detailtotalamountbeforediscount: bill.detail_total_amount_before_discount,
        detailtotaldiscount: bill.detail_total_discount,
        fullvataddress: bill.full_vat_address,
        fullvatname: bill.full_vat_name,
        fullvatbranchnumber: bill.full_vat_branch_number,
        fullvatdocnumber: bill.full_vat_doc_number,
        fullvatprint: bill.full_vat_print,
        fullvattaxid: bill.full_vat_tax_id,
        isvatregister: bill.is_vat_register,
        mancount: bill.man_count,
        paycashchange: bill.pay_cash_change,
        printcopybilldatetime: bill.print_copy_bill_date_time,
        roundamount: bill.round_amount,
        sumcheque: bill.sum_cheque,
        sumcoupon: bill.sum_coupon,
        sumcreditcard: bill.sum_credit_card,
        summoneytransfer: bill.sum_money_transfer,
        sumqrcode: bill.sum_qr_code,
        sumcredit: bill.sum_credit,
        istableallacratemode: bill.table_al_la_crate_mode,
        tableclosedatetime: bill.table_close_date_time.toUtc().toIso8601String(),
        tablenumber: bill.table_number,
        tableopendatetime: bill.table_open_date_time.toUtc().toIso8601String(),
        totalamountafterdiscount: bill.total_amount_after_discount,
        totaldiscountexceptvatamount: bill.total_discount_except_vat_amount,
        totaldiscountvatamount: bill.total_discount_vat_amount,
        totalqty: bill.total_qty,
        womancount: bill.woman_count);

    if (bill.doc_mode == 1) {
      await saveTransaction(trans);
    } else {
      await saveReturn(trans);
    }

    BillHelper().updatesSyncSuccess(docNumber: bill.doc_number);
  }
}

Future syncShift() async {
  List<ShiftObjectBoxStruct> shifts = (global.shiftHelper.selectSyncIsFalse());

  for (int index = 0; index < shifts.length; index++) {
    ShiftObjectBoxStruct shift = shifts[index];

    ShiftModel postShift = ShiftModel(
      guidfixed: shift.guidfixed,
      doctype: shift.doctype,
      amount: shift.amount,
      creditcard: shift.creditcard,
      promptpay: shift.promptpay,
      transfer: shift.transfer,
      cheque: shift.cheque,
      coupon: shift.coupon,
      docdate: shift.docdate.toUtc().toIso8601String(),
      remark: shift.remark,
      usercode: shift.usercode,
      username: shift.username,
    );
    await saveShift(postShift);
    global.shiftHelper.updatesSyncSuccess(docNumber: shift.guidfixed);
  }
}

Future<ApiResponse> saveTransaction(TransactionModel trx) async {
  Dio client = Client().init();

  //String jsonPayload = jsonEncode(trx.toJson());
  try {
    final response = await client.post('/transaction/sale-invoice', data: trx.toJson());
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
      global.syncDataProcess = false;
      serviceLocator<Log>().error(ex);
      throw Exception(ex);
    }
  } on DioError catch (ex) {
    global.syncDataProcess = false;
    String errorMessage = ex.response.toString();
    serviceLocator<Log>().error(errorMessage);
    throw Exception(errorMessage);
  }
}

Future<ApiResponse> saveShift(ShiftModel tran) async {
  Dio client = Client().init();
  //String jsonPayload = jsonEncode(trx.toJson());
  try {
    final response = await client.post('/pos/shift', data: tran.toJson());
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
      global.syncDataProcess = false;
      serviceLocator<Log>().error(ex);
      throw Exception(ex);
    }
  } on DioError catch (ex) {
    global.syncDataProcess = false;
    String errorMessage = ex.response.toString();
    serviceLocator<Log>().error(errorMessage);
    throw Exception(errorMessage);
  }
}

Future<ApiResponse> saveReturn(TransactionModel trx) async {
  Dio client = Client().init();
  //String jsonPayload = jsonEncode(trx.toJson());
  try {
    final response = await client.post('/transaction/sale-invoice-return', data: trx.toJson());
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
      global.syncDataProcess = false;
      serviceLocator<Log>().error(ex);
      throw Exception(ex);
    }
  } on DioError catch (ex) {
    global.syncDataProcess = false;
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
          await userRepository.authenUser(global.apiUserName, global.apiUserPassword).then((result) async {
            if (result.success) {
              global.apiConnected = true;
              global.appStorage.write("token", result.data["token"]);
              serviceLocator<Log>().debug("Login Success");
              ApiResponse selectShop = await userRepository.selectShop(global.apiShopID);
              if (selectShop.success) {
                serviceLocator<Log>().debug("Select Shop Success");
              }
            }
          }).catchError((e) {
            serviceLocator<Log>().error(e);
          }).whenComplete(() async {
            global.loginProcess = false;
            await syncBillData();
            await syncShift();
          });
        }
      } else {
        await syncBillData();
        await syncShift();
      }
    }
    global.syncDataProcess = false;
  }
}
