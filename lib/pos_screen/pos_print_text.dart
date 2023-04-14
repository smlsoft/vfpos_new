import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:charset_converter/charset_converter.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:collection/collection.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:promptpay/promptpay.dart';

Future<void> printBillText(String docNo) async {
  PaperSize paper = PaperSize.mm80;
  CapabilityProfile profile = await CapabilityProfile.load();
  NetworkPrinter printer = NetworkPrinter(paper, profile);
  PosPrintResult res = await printer.connect(global.printerCashierIpAddress,
      port: global.printerCashierIpPort);
  int charPerLine = 48;

  if (res == PosPrintResult.success) {
    double totalDiscountAndPromotion = 0;
    /*ByteData data = await rootBundle.load('assets/images/logo.jpg');
    Uint8List bytes = data.buffer.asUint8List();
    Image? image = decodeImage(bytes);

    printer.image(image!);*/

    printer.reset();

    //
    if (global.posTicket.logo && 1 == 2) {
      // พิมพ์ Logo
      ByteData data = await rootBundle.load('assets/images/logo.jpg');
      Uint8List bytes = data.buffer.asUint8List();
      Image? image = decodeImage(bytes);
      printer.image(image!);
    }
    PrintProcess printProcess = PrintProcess(length: charPerLine);
    if (global.posTicket.shopName) {
      // พิมพ์ชื่อร้าน
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(1);
      printProcess.column
          .add(PrintColumn(text: "ร้านโซลาว", align: PrintColumnAlign.left));
      await printProcess.lineFeed(
          printer, const PosStyles(bold: true, width: PosTextSize.size2));
    }
    if (global.posTicket.shopAddress) {
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(1);
      printProcess.column
          .add(PrintColumn(text: "สำนักงานใหญ่", align: PrintColumnAlign.left));
      await printProcess.lineFeed(printer, const PosStyles(bold: false));
      // พิมพ์ ที่อยู่ร้าน
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(1);
      printProcess.column.add(PrintColumn(
          text:
              "141/469 หมู่ที่ 2 ต.ต้นเปา อ.สันกำแพง จ.เชียงใหม่ 50130, อาคารซอฟท์แวร์พาร์ค ชั้น 7 ถ.แจ้งวัฒนะ ต.คลองเกลือ อ.ปากเกร็ด จ.นนทบุรี 11120",
          align: PrintColumnAlign.left));
      await printProcess.lineFeed(printer, const PosStyles(bold: false));
    }
    //
    if (global.posTicket.shopTaxId) {
      // พิมพ์ เลขที่ผู้เสียภาษี
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(1);
      printProcess.column.add(PrintColumn(
          text: "Tax : 0135549000236", align: PrintColumnAlign.left));
      await printProcess.lineFeed(printer, const PosStyles(bold: false));
    }
    //
    if (global.posTicket.shopTel) {
      // พิมพ์ เลขที่ผู้เสียภาษี
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(1);
      printProcess.column.add(PrintColumn(
          text: "โทรศัพท์ : 0899223131", align: PrintColumnAlign.left));
      await printProcess.lineFeed(printer, const PosStyles(bold: false));
    }
    //
    await printProcess.drawLine(printer);
    //
    BillObjectBoxStruct bill =
        global.billHelper.selectByDocNumber(docNumber: docNo)[0];
    printProcess.column.clear();
    printProcess.columnWidth.clear();
    printProcess.columnWidth.add(1);
    printProcess.column.add(
        PrintColumn(text: "${global.language("doc_no")} : ${bill.doc_number}"));
    await printProcess.lineFeed(printer, const PosStyles(bold: false));
    //
    printProcess.column.clear();
    printProcess.columnWidth.clear();
    printProcess.columnWidth.add(1);
    printProcess.column.add(PrintColumn(
        text: "${global.language("doc_date")} : 10/10/2564 16:30",
        align: PrintColumnAlign.left));
    await printProcess.lineFeed(printer, const PosStyles(bold: false));
    //
    //
    List<BillDetailObjectBoxStruct> billDetails =
        global.billDetailHelper.selectByDocNumber(docNumber: docNo);
    //
    List<BillPayObjectBoxStruct> payDetails =
        global.billPayHelper.selectByDocNumber(docNumber: docNo);
    //
    int widthCharDescription = 0;
    int widthCharPrice = 0;
    int widthCharAmount = 0;
    int widthCharQty = 0;

    printProcess.columnWidth.clear();
    double sumWidth = global.posTicket.descriptionWidth +
        global.posTicket.priceWidth +
        global.posTicket.amountWidth;
    if (global.posTicket.qty) {
      sumWidth += global.posTicket.qtyWidth;
    }
    double calcWidth = charPerLine / sumWidth;
    widthCharDescription =
        (global.posTicket.descriptionWidth * calcWidth).toInt();
    widthCharPrice = (global.posTicket.priceWidth * calcWidth).toInt();
    widthCharAmount = (global.posTicket.amountWidth * calcWidth).toInt();
    if (global.posTicket.qty) {
      widthCharQty = (global.posTicket.qtyWidth * calcWidth).toInt();
    }
    if (widthCharQty <= 5) {
      global.posTicket.qty = false;
    }
    printProcess.columnWidth.add(widthCharDescription.toDouble());
    if (global.posTicket.qty) {
      printProcess.columnWidth.add(widthCharQty.toDouble());
    }
    printProcess.columnWidth.add(widthCharPrice.toDouble());
    printProcess.columnWidth.add(widthCharAmount.toDouble());
    //
    await printProcess.drawLine(printer);
    printProcess.column.clear();
    printProcess.column.add(PrintColumn(text: global.language("description")));
    if (global.posTicket.qty) {
      printProcess.column.add(PrintColumn(
          text: global.language("qty"), align: PrintColumnAlign.right));
    }
    printProcess.column.add(PrintColumn(
        text: global.language("price"), align: PrintColumnAlign.right));
    printProcess.column.add(PrintColumn(
        text: global.language("total"), align: PrintColumnAlign.right));
    await printProcess.lineFeed(printer, const PosStyles(bold: true));
    await printProcess.drawLine(printer);

    /// ส่วนของการแสดงรายการสินค้า
    for (var detail in billDetails) {
      /// สินค้าทั่วไป
      printProcess.column.clear();
      String desc =
          (global.posTicket.lineNumber) ? "${detail.line_number}." : "";
      desc += "${detail.item_name} ${detail.unit_name}";
      if (detail.discount_text.isNotEmpty) {
        desc = "$desc ${global.language("discount")}";
        if (detail.discount_text.contains("%") ||
            detail.discount_text.contains(",")) {
          desc = "$desc ${detail.discount_text}=";
        }
        desc = "$desc ${global.moneyFormat.format(detail.discount)}";
        desc = "$desc ${global.language("money_symbol")}/${detail.unit_name}";
      }
      if (global.posTicket.qty == false && detail.qty > 1) {
        desc = "$desc x ${global.moneyFormat.format(detail.qty)}";
      }
      printProcess.column.add(PrintColumn(text: desc));
      if (global.posTicket.qty) {
        printProcess.column.add(PrintColumn(
            text:
                (detail.qty == 0) ? "" : global.moneyFormat.format(detail.qty),
            align: PrintColumnAlign.right));
      }
      printProcess.column.add(PrintColumn(
          text: (detail.price == 0)
              ? ""
              : global.moneyFormat.format(detail.price),
          align: PrintColumnAlign.right));
      printProcess.column.add(PrintColumn(
          text: (detail.total_amount == 0)
              ? ""
              : global.moneyFormat.format(detail.total_amount),
          align: PrintColumnAlign.right));
      await printProcess.lineFeed(printer, const PosStyles());

      /// สินค้าเพิ่ม (Extra)
      List<BillDetailExtraObjectBoxStruct> extras = global.billDetailExtraHelper
          .selectByDocNumberAndLineNumber(
              docNumber: detail.doc_number, lineNumber: detail.line_number);
      for (var extra in extras) {
        printProcess.column.clear();
        String desc = "* ${extra.item_name} ${extra.unit_name}";
        printProcess.column.add(PrintColumn(text: desc));
        printProcess.column.add(PrintColumn(
            text: (extra.total_amount == 0)
                ? ""
                : global.moneyFormat.format(extra.total_amount),
            align: PrintColumnAlign.right));
        printProcess.column
            .add(PrintColumn(text: "", align: PrintColumnAlign.right));
        await printProcess.lineFeed(printer, const PosStyles());
      }
    }

    // พิมพ์ยอดรวม
    await printProcess.drawLine(printer);
    printProcess.columnWidth.clear();
    printProcess.columnWidth.add(25);
    printProcess.columnWidth.add(8);
    printProcess.column.clear();
    printProcess.column.add(PrintColumn(text: global.language("total_amount")));
    printProcess.column.add(PrintColumn(
        text: global.moneyFormat.format(bill.total_amount),
        align: PrintColumnAlign.right));
    await printProcess.lineFeed(printer, const PosStyles(bold: true));
    await printProcess.drawLine(printer);
    // พิมพ์ Promotion
    /*if (_havePromotion) {
      _print.columnWidth.clear();
      _print.columnWidth.add(1);
      _print.column.clear();
      _print.column
          .add(PrintColumn(text: "pos".tr(gender: "discount_and_promoiton")));
      await _print.lineFeed(printer, PosStyles(bold: true));
      //
      _print.columnWidth.clear();
      _print.columnWidth.add(25);
      _print.columnWidth.add(8);
      for (var _data in _billDetail) {
        if (_data.is_promotion == 1) {
          _totalDiscountAndPromotion += _data.total_amount;
          _print.column.clear();
          _print.column.add(PrintColumn(text: _data.item_name));
          _print.column.add(PrintColumn(
              text: global.moneyFormat.format(_data.total_amount),
              align: PrintColumnAlign.right));
          await _print.lineFeed(printer, PosStyles());
        }
      }
    }*/
    if (totalDiscountAndPromotion != 0) {
      int oldLength = printProcess.length;
      printProcess.length = printProcess.length ~/ 2;
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(1);
      printProcess.column.clear();
      printProcess.column.add(PrintColumn(
          text:
              "${global.language("bill_discount_save")} ${global.moneyFormat.format(totalDiscountAndPromotion * -1)} ${global.language("money_symbol")}"));
      await printProcess.lineFeed(printer,
          const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2));
      printProcess.length = oldLength;
      await printProcess.drawLine(printer);
      // ยอดรวม
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(25);
      printProcess.columnWidth.add(8);
      printProcess.column.clear();
      printProcess.column.add(PrintColumn(
          text: global.language("total_after_discount_and_promoiton")));
      printProcess.column.add(PrintColumn(
          text: global.moneyFormat.format(bill.total_amount),
          align: PrintColumnAlign.right));
      await printProcess.lineFeed(printer, const PosStyles(bold: true));
      await printProcess.drawLine(printer);
    }
    printProcess.columnWidth.clear();
    printProcess.columnWidth.add(1);
    printProcess.column.clear();
    printProcess.column
        .add(PrintColumn(text: global.language("bill_pay_list")));
    await printProcess.lineFeed(printer, const PosStyles(bold: true));
    // ชำระเงินสด
    /*List<BillPayStruct> _billPayDetail = await global.billPayHelper.select(
      where: " doc_number = '" + docNo + "' order by trans_flag asc ",
    );

    double __cashAmount = 0;
    List<PayCreditCardStruct> creditCardList = []; // บัตรเครดิต
    List<PayTransferStruct> transferList = []; // เงินโอน
    List<PayChequeStruct> chequeList = []; // เช็ค
    List<PayDiscountStruct> discountList = []; // ส่วนลด
    List<PayCouponStruct> couponList = []; // คูปอง
    List<PayWalletStruct> walletList = []; // Wallet
    if (_billPayDetail.length > 0) {
      for (var _billpayObj in _billPayDetail) {
        if (_billpayObj.trans_flag == 0) {
          __cashAmount = _billpayObj.amount;
        } else if (_billpayObj.trans_flag == 1) {
          PayCreditCardStruct creditCardObj = PayCreditCardStruct(
              bank_code: _billpayObj.bank_code,
              card_number: _billpayObj.card_number,
              approved_code: _billpayObj.approved_code,
              amount: _billpayObj.amount); // บัตรเครดิต
          creditCardList.add(creditCardObj);
        } else if (_billpayObj.trans_flag == 2) {
          PayTransferStruct transferObj = PayTransferStruct(
              date_time: _billpayObj.doc_date_time,
              bank_code: _billpayObj.bank_code,
              bank_name: _billpayObj.bank_name,
              branch_name: _billpayObj.branch_name,
              bank_referance: _billpayObj.bank_referance,
              amount: _billpayObj.amount);
          transferList.add(transferObj);
        } else if (_billpayObj.trans_flag == 3) {
          PayChequeStruct chequeObj = PayChequeStruct(
              date_time: _billpayObj.doc_date_time,
              due_date: _billpayObj.due_date,
              bank_code: _billpayObj.bank_code,
              bank_name: _billpayObj.bank_name,
              branch_name: _billpayObj.branch_name,
              cheque_number: _billpayObj.cheque_number,
              amount: _billpayObj.amount);
          chequeList.add(chequeObj);
        } else if (_billpayObj.trans_flag == 4) {
          PayDiscountStruct discountObj = PayDiscountStruct(
              code: _billpayObj.code,
              description: _billpayObj.description,
              formula: _billpayObj.formula,
              amount: _billpayObj.amount);
          discountList.add(discountObj);
        } else if (_billpayObj.trans_flag == 5) {
          PayCouponStruct couponObj = PayCouponStruct(
              code: _billpayObj.code,
              description: _billpayObj.description,
              number: _billpayObj.number,
              amount: _billpayObj.amount);
          couponList.add(couponObj);
        } else if (_billpayObj.trans_flag == 6) {
          PayWalletStruct walletObj = PayWalletStruct(
              coin_type: _billpayObj.coin_type,
              bank_code: _billpayObj.bank_code,
              bank_referance: _billpayObj.bank_referance,
              referance_one: _billpayObj.referance_one,
              referance_two: _billpayObj.referance_two,
              transactionID: _billpayObj.transaction_id,
              provider_code: _billpayObj.provider_code,
              description: _billpayObj.description,
              amount: _billpayObj.amount);
          walletList.add(walletObj);
        }
      }
    }
    // บัตรเครดิต

    if (creditCardList.length > 0) {
      _print.columnWidth.clear();
      _print.columnWidth.add(1);
      _print.column.clear();
      _print.column.add(PrintColumn(text: "pos".tr(gender: "credit_card")));
      await _print.lineFeed(printer, PosStyles(bold: true));
      for (var _payCreditObj in creditCardList) {
        _sumCreditCard += _payCreditObj.amount;
        _print.columnWidth.clear();
        _print.columnWidth.add(25);
        _print.columnWidth.add(8);
        _print.column.clear();
        _print.column.add(PrintColumn(text: _payCreditObj.card_number));
        _print.column.add(PrintColumn(
            text: global.moneyFormat.format(_payCreditObj.amount),
            align: PrintColumnAlign.right));
        await _print.lineFeed(printer, PosStyles());
      }
    }
    // ชำระเงินโอน
    if (transferList.length > 0) {
      _print.columnWidth.clear();
      _print.columnWidth.add(1);
      _print.column.clear();
      _print.column.add(PrintColumn(text: "pos".tr(gender: "transfer")));
      await _print.lineFeed(printer, PosStyles(bold: true));
      for (var _payTransferObj in transferList) {
        _sumTransfer += _payTransferObj.amount;
        _print.columnWidth.clear();
        _print.columnWidth.add(25);
        _print.columnWidth.add(8);
        _print.column.clear();
        _print.column.add(PrintColumn(text: _payTransferObj.bank_referance));
        _print.column.add(PrintColumn(
            text: global.moneyFormat.format(_payTransferObj.amount),
            align: PrintColumnAlign.right));
        await _print.lineFeed(printer, PosStyles());
      }
    }*/
    // เช็ค
    // if (chequeList.length > 0) {
    //   _print.columnWidth.clear();
    //   _print.columnWidth.add(1);
    //   _print.column.clear();
    //   _print.column.add(PrintColumn(text: "pos".tr(gender: "cheque")));
    //   await _print.lineFeed(printer, PosStyles(bold: true));
    //   for (var _payChequeObj in chequeList) {
    //     _sumCheque += _payChequeObj.amount;
    //     _print.columnWidth.clear();
    //     _print.columnWidth.add(25);
    //     _print.columnWidth.add(8);
    //     _print.column.clear();
    //     _print.column.add(PrintColumn(text: _payChequeObj.cheque_number));
    //     _print.column.add(PrintColumn(
    //         text: global.moneyFormat.format(_payChequeObj.amount),
    //         align: PrintColumnAlign.right));
    //     await _print.lineFeed(printer, PosStyles());
    //   }
    // }
    // // ส่วนลด
    // if (discountList.length > 0) {
    //   _print.columnWidth.clear();
    //   _print.columnWidth.add(1);
    //   _print.column.clear();
    //   _print.column.add(PrintColumn(text: "pos".tr(gender: "discount")));
    //   await _print.lineFeed(printer, PosStyles(bold: true));
    //   for (var _payDiscountObj in discountList) {
    //     _sumDiscount += _payDiscountObj.amount;
    //     _print.columnWidth.clear();
    //     _print.columnWidth.add(25);
    //     _print.columnWidth.add(8);
    //     _print.column.clear();
    //     _print.column.add(PrintColumn(text: _payDiscountObj.description));
    //     _print.column.add(PrintColumn(
    //         text: global.moneyFormat.format(_payDiscountObj.amount),
    //         align: PrintColumnAlign.right));
    //     await _print.lineFeed(printer, PosStyles());
    //   }
    // }
    // // คูปอง
    // if (couponList.length > 0) {
    //   _print.columnWidth.clear();
    //   _print.columnWidth.add(1);
    //   _print.column.clear();
    //   _print.column.add(PrintColumn(text: "pos".tr(gender: "coupon")));
    //   await _print.lineFeed(printer, PosStyles(bold: true));
    //   for (var _payCouponObj in couponList) {
    //     _sumCoupon += _payCouponObj.amount;
    //     _print.columnWidth.clear();
    //     _print.columnWidth.add(25);
    //     _print.columnWidth.add(8);
    //     _print.column.clear();
    //     _print.column.add(PrintColumn(text: _payCouponObj.code));
    //     _print.column.add(PrintColumn(
    //         text: global.moneyFormat.format(_payCouponObj.amount),
    //         align: PrintColumnAlign.right));
    //     await _print.lineFeed(printer, PosStyles());
    //   }
    // }
    // Wallet
    // if (walletList.length > 0) {
    //   _print.columnWidth.clear();
    //   _print.columnWidth.add(1);
    //   _print.column.clear();
    //   _print.column.add(PrintColumn(text: "pos".tr(gender: "wallet")));
    //   await _print.lineFeed(printer, PosStyles(bold: true));
    //   for (var _payWalletObj in walletList) {
    //     _sumWallet += _payWalletObj.amount;
    //     _print.columnWidth.clear();
    //     _print.columnWidth.add(25);
    //     _print.columnWidth.add(8);
    //     _print.column.clear();
    //     _print.column.add(PrintColumn(text: _payWalletObj.bank_code));
    //     _print.column.add(PrintColumn(
    //         text: global.moneyFormat.format(_payWalletObj.amount),
    //         align: PrintColumnAlign.right));
    //     await _print.lineFeed(printer, PosStyles());
    //   }
    // }

    if (bill.pay_cash_amount > 0) {
      // รวมเงินสด
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(25);
      printProcess.columnWidth.add(8);
      printProcess.column.clear();
      printProcess.column.add(PrintColumn(text: global.language("cash")));
      printProcess.column.add(PrintColumn(
          text: global.moneyFormat.format(bill.pay_cash_amount),
          align: PrintColumnAlign.right));
      await printProcess.lineFeed(printer, const PosStyles());
    }
    if (bill.sum_discount > 0) {
      // รวมส่วนลด
      printProcess.columnWidth.clear();
      printProcess.columnWidth.add(25);
      printProcess.columnWidth.add(8);
      printProcess.column.clear();
      String discountFormula = global.language("discount");
      if (bill.discount_formula.isNotEmpty) {
        discountFormula += " : ${bill.discount_formula}";
      }
      printProcess.column.add(PrintColumn(text: discountFormula));
      printProcess.column.add(PrintColumn(
          text: global.moneyFormat.format(bill.sum_discount),
          align: PrintColumnAlign.right));
      await printProcess.lineFeed(printer, const PosStyles());
    }
    if (payDetails.isNotEmpty) {
      for (int payType in [1, 2, 3, 4, 5]) {
        bool headPrinted = false;
        for (int _i = 0; _i < payDetails.length; _i++) {
          if (payDetails[_i].trans_flag == payType) {
            if (headPrinted == false) {
              String header = "";
              switch (payDetails[_i].trans_flag) {
                case 1:
                  header = global.language("credit_card");
                  break;
                case 2:
                  header = global.language("transfer");
                  break;
                case 3:
                  header = global.language("cheque");
                  break;
                case 4:
                  header = global.language("coupon");
                  break;
                case 5:
                  header = global.language("wallet");
                  break;
              }
              printProcess.columnWidth.clear();
              printProcess.columnWidth.add(1);
              printProcess.column.clear();
              printProcess.column.add(PrintColumn(text: header));
              await printProcess.lineFeed(printer, const PosStyles(bold: true));
              headPrinted = true;
            }
            String detailText = "";
            switch (payDetails[_i].trans_flag) {
              case 1:
                detailText =
                    "${payDetails[_i].bank_code} : ${payDetails[_i].bank_name} : ${payDetails[_i].card_number}";
                break;
              case 2:
                detailText =
                    "${payDetails[_i].bank_code} : ${payDetails[_i].bank_name}";
                if (payDetails[_i].bank_account_no.isNotEmpty) {
                  detailText += " : ${payDetails[_i].bank_account_no}";
                }
                break;
              case 3:
                detailText =
                    "${payDetails[_i].bank_code} : ${payDetails[_i].bank_name} : ${payDetails[_i].approved_code} : ${payDetails[_i].cheque_number}";
                break;
              case 4:
                detailText =
                    "${payDetails[_i].number} : ${payDetails[_i].description}";
                break;
              case 5:
                detailText = payDetails[_i].provider_name;
                if (payDetails[_i].description.isNotEmpty) {
                  detailText += " ${payDetails[_i].description}";
                }
                break;
            }
            printProcess.columnWidth.clear();
            printProcess.columnWidth.add(25);
            printProcess.columnWidth.add(8);
            printProcess.column.clear();
            printProcess.column.add(PrintColumn(text: detailText));
            printProcess.column.add(PrintColumn(
                text: global.moneyFormat.format(payDetails[_i].amount),
                align: PrintColumnAlign.right));
            await printProcess.lineFeed(printer, const PosStyles());
          }
        }
      }

      //   _print.columnWidth.clear();
      //   _print.columnWidth.add(1);
      //   _print.column.clear();
      //   _print.column.add(PrintColumn(text: "pos".tr(gender: "wallet")));
      //   await _print.lineFeed(printer, PosStyles(bold: true));
      //   for (var _payWalletObj in walletList) {
      //     _sumWallet += _payWalletObj.amount;
      //     _print.columnWidth.clear();
      //     _print.columnWidth.add(25);
      //     _print.columnWidth.add(8);
      //     _print.column.clear();
      //     _print.column.add(PrintColumn(text: _payWalletObj.bank_code));
      //     _print.column.add(PrintColumn(
      //         text: global.moneyFormat.format(_payWalletObj.amount),
      //         align: PrintColumnAlign.right));
      //     await _print.lineFeed(printer, PosStyles());
      //   }
      // }
    }
    double sumTotalPayAmount = bill.pay_cash_amount +
        bill.sum_discount +
        bill.sum_coupon +
        bill.sum_credit_card +
        bill.sum_money_transfer +
        bill.sum_cheque +
        bill.sum_qr_code;
    double diffAmount = bill.total_amount - sumTotalPayAmount;
    // ยอดรวมจ่าย
    printProcess.columnWidth.clear();
    printProcess.columnWidth.add(25);
    printProcess.columnWidth.add(8);
    printProcess.column.clear();
    printProcess.column
        .add(PrintColumn(text: global.language("total_pay_bill")));
    printProcess.column.add(PrintColumn(
        text: global.moneyFormat.format(sumTotalPayAmount),
        align: PrintColumnAlign.right));
    await printProcess.lineFeed(printer, const PosStyles(bold: true));
    await printProcess.drawLine(printer);
    printProcess.columnWidth.clear();
    printProcess.columnWidth.add(25);
    printProcess.columnWidth.add(8);

    if (diffAmount > 0) {
      printProcess.column.clear();
      printProcess.column
          .add(PrintColumn(text: global.language("total_more_diff")));
      printProcess.column.add(PrintColumn(
          text: global.moneyFormat.format(diffAmount),
          align: PrintColumnAlign.right));
      await printProcess.lineFeed(printer, const PosStyles(bold: true));
      await printProcess.drawLine(printer);
    } else {
      double diffAmountplus = sumTotalPayAmount - bill.total_amount;
      printProcess.column.clear();
      printProcess.column.add(PrintColumn(text: global.language("total_diff")));
      printProcess.column.add(PrintColumn(
          text: global.moneyFormat.format(diffAmountplus),
          align: PrintColumnAlign.right));
      await printProcess.lineFeed(printer, const PosStyles(bold: true));
      await printProcess.drawLine(printer);
    }

    //printer.feed(2);
    {
      /// ส่วนของการพิมพ์ส QRCODE (Promotpay)
      /*String _qrcodePromptpay =
          PromptPay.generateQRData("0899223131", amount: _bill.total_amount);
      printer.qrcode(_qrcodePromptpay, size: QRSize.Size8);
      _print.columnWidth.clear();
      _print.columnWidth.add(1);
      _print.column.clear();
      _print.column.add(PrintColumn(
          text: "Promptpay : 0899223131 : นายจตุรพรชัย รัตนปัญญา",
          align: PrintColumnAlign.center));
      await _print.lineFeed(printer, PosStyles(bold: true));
      await _print.drawLine(printer);*/
      if (global.posTicket.saleDetail && bill.sale_code.isNotEmpty) {
        printProcess.columnWidth.clear();
        printProcess.columnWidth.add(1);
        printProcess.column.clear();
        printProcess.column.add(PrintColumn(
            text:
                "${global.language("sale_code")} : ${bill.sale_name} (${bill.sale_code})",
            align: PrintColumnAlign.center));
        await printProcess.lineFeed(printer, const PosStyles(bold: true));
      }
      if (global.posTicket.cashierDetail && bill.cashier_code.isNotEmpty) {
        printProcess.columnWidth.clear();
        printProcess.columnWidth.add(1);
        printProcess.column.clear();
        printProcess.column.add(PrintColumn(
            text:
                "${global.language("cashier")} : ${bill.cashier_name} (${bill.cashier_code})",
            align: PrintColumnAlign.center));
        await printProcess.lineFeed(printer, const PosStyles(bold: true));
      }
    }
    if (global.posTicket.docNoQrCode) {
      printer.qrcode(bill.doc_number, size: QRSize.Size8);
    }
    printer.cut();
    printer.disconnect();
    print("Printer Connect Sucess.");
  } else {
    print("Printer Connect fail." +
        global.printerCashierIpAddress +
        ":" +
        global.printerCashierIpPort.toString());
  }
}
