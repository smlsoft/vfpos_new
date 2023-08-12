import 'dart:convert';
import 'dart:io' as io;
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/core/core.dart';
import 'package:dedepos/model/objectbox/form_design_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:image/image.dart' as im;
import 'dart:ui' as ui;

Future<void> printBill({
  required DateTime docDate,
  required String docNo,
  required String languageCode,
}) async {
  if (global.posTicket.print_mode == 0) {
    PosPrintBillClass posPrintBill = PosPrintBillClass(
      docDate: docDate,
      docNo: docNo,
      languageCode: languageCode,
    );
    posPrintBill.printBill();
  } else {
    //printBillImage(docNo);
  }
}

class PosPrintBillCommandModel {
  int? mode; // 0=Reset,1=Logo Image,2=Text,3=Line
  String? text;
  Uint8List? image;
  PosStyles? posStyles;
  PosTextSize? posTextSize;
  List<FormDesignColumnModel> columns;
  double value;

  PosPrintBillCommandModel(
      {required this.mode,
      this.text,
      this.image,
      this.value = 0,
      this.posStyles = const PosStyles(bold: false),
      this.columns = const [],
      this.posTextSize = PosTextSize.size1});
}

class PosPrintBillClass {
  DateTime docDate;
  String docNo;
  String languageCode;
  double billWidth =
      global.paperWidth(global.printerLocalStrongData[0].paperType);

  PosPrintBillClass({
    required this.docDate,
    required this.docNo,
    required this.languageCode,
  });

  String findValueBillDetail(BillDetailObjectBoxStruct detail, String source) {
    String result = source;
    result =
        result.replaceAll("&item_qty&", global.moneyFormat.format(detail.qty));
    result = result.replaceAll("&item_name&",
        global.getNameFromJsonLanguage(detail.item_name, languageCode));
    result = result.replaceAll("&item_unit_name&",
        global.getNameFromJsonLanguage(detail.unit_name, languageCode));
    {
      // ส่วนลด
      String discountValue = "";
      if (detail.discount_text.isNotEmpty) {
        discountValue = global.language("discount");
        if (detail.discount_text.contains("%") ||
            detail.discount_text.contains(",")) {
          discountValue = "$discountValue ${detail.discount_text}=";
        }
        discountValue =
            "$discountValue ${global.moneyFormat.format(detail.discount)}";
        discountValue =
            "$discountValue ${global.language("money_symbol")}/${global.getNameFromJsonLanguage(detail.unit_name, global.userScreenLanguage)}";
      }
      result = result.replaceAll("&item_discount&", discountValue);
    }
    {
      // ราคา
      String priceValue = "";
      if (detail.price != detail.total_amount) {
        if (detail.price != 0) {
          priceValue = global.moneyFormat.format(detail.price);
        }
      }
      result = result.replaceAll("&item_price&", priceValue);
    }
    {
      // ราคา+สัญลักษณ์
      String priceValue = "";
      if (detail.price != detail.total_amount) {
        if (detail.price != 0) {
          priceValue = "@${global.moneyFormat.format(detail.price)}";
        }
      }
      result = result.replaceAll("&item_price_and_symbol&", priceValue);
    }
    {
      // มูลค่าทั้งหมด
      result = result.replaceAll("&item_total_amount&",
          global.moneyFormat.format(detail.total_amount));
    }
    return result.trim().replaceAll("  ", " ").replaceAll("  ", " ");
  }

  String findValueBillDetailExtra(
      BillDetailExtraObjectBoxStruct detailExtra, String source) {
    String result = source;
    result = result.replaceAll(
        "&item_extra_qty&",
        (detailExtra.qty == 0)
            ? ""
            : global.moneyFormat.format(detailExtra.qty));
    result = result.replaceAll("&item_extra_name&",
        global.getNameFromJsonLanguage(detailExtra.item_name, languageCode));
    result = result.replaceAll("&item_extra_unit_name&",
        global.getNameFromJsonLanguage(detailExtra.unit_name, languageCode));
    // ราคา
    String priceValue = "";
    if (detailExtra.price != detailExtra.total_amount) {
      if (detailExtra.price != 0) {
        priceValue = "@${global.moneyFormat.format(detailExtra.price)}";
      }
    }
    result = result.replaceAll("&item_extra_price&", priceValue);

    result = result.replaceAll(
        "&item_extra_total_amount&",
        (detailExtra.total_amount == 0)
            ? ""
            : global.moneyFormat.format(detailExtra.total_amount));

    return result.trim().replaceAll("  ", " ").replaceAll("  ", " ");
  }

  String findValueBillTotal(BillObjectBoxStruct value, String source) {
    String result = source;
    // จำนวนชิ้น
    result = result.replaceAll("&total_piece_name&", "จำนวนชิ้น");
    result = result.replaceAll(
        "&total_piece&", global.moneyFormatAndDot.format(value.total_qty));
    // ยอดรวมสินค้ามีภาษี
    result =
        result.replaceAll("&total_item_vat_amount_name&", "มูลค่าสินค้ามีภาษี");
    result = result.replaceAll("&total_item_vat_amount&",
        global.moneyFormatAndDot.format(value.total_item_vat_amount));
    // ยอดรวมสินค้ายกเว้นภาษี
    result = result.replaceAll(
        "&total_itm_except_vat_amount_name&", "มูลค่าสินค้ายกเว้นภาษี");
    result = result.replaceAll("&total_itm_except_vat_amount&",
        global.moneyFormatAndDot.format(value.total_item_except_vat_amount));
    // ส่วนลดสินค้ามีภาษี
    result =
        result.replaceAll("&total_discount_vat_name&", "ส่วนลดสินค้ามีภาษี");
    result = result.replaceAll("&total_discount_vat_amount&",
        global.moneyFormatAndDot.format(value.total_discount_vat_amount));
    // ส่วนลดสินค้ายกเว้นภาษี
    result = result.replaceAll(
        "&total_discount_vat_except_name&", "ส่วนลดสินค้ายกเว้นภาษี");
    result = result.replaceAll(
        "&total_discount_vat_except_amount&",
        global.moneyFormatAndDot
            .format(value.total_discount_except_vat_amount));
    // ส่วนลดทั้งหมด
    result = result.replaceAll("&total_discount_name&", "ส่วนลดทั้งหมด");
    result = result.replaceAll("&total_discount_amount&",
        global.moneyFormatAndDot.format(value.total_discount));
    // มูลค่าสินค้าหลังคิดภาษี (หลังหักส่วนลด)
    result = result.replaceAll(
        "&total_item_vat_amount_after_discount_name&", "มูลค่าหลังคิดภาษี");
    result = result.replaceAll("&total_item_vat_amount_after_discount&",
        global.moneyFormatAndDot.format(value.amount_after_calc_vat));
    // มูลค่าสินค้ายกเว้นภาษี (หลังหักส่วนลด)
    result = result.replaceAll(
        "&total_item_except_vat_amount_after_discount_name&",
        "มูลค่ายกเว้นภาษี");
    result = result.replaceAll("&total_item_except_vat_amount_after_discount&",
        global.moneyFormatAndDot.format(value.amount_except_vat));
    // รวมทั้งสิ้น
    result = result.replaceAll("&total_amount_name&", "ยอดรวมสุทธิ");
    result = result.replaceAll(
        "&total_amount&", global.moneyFormatAndDot.format(value.total_amount));
    // ยอดก่อนภาษีมูลค่าเพิ่ม สินค้ายกเว้นภาษี
    result = result.replaceAll(
        "&total_before_except_vat_name&", "มูลค่าสินค้ายกเว้นภาษี");
    result = result.replaceAll("&total_before_except_vat&",
        global.moneyFormatAndDot.format(value.amount_except_vat));
    // ยอดก่อนภาษีมูลค่าเพิ่ม
    result = result.replaceAll("&total_before_vat_name&", "มูลค่าก่อนภาษี");
    result = result.replaceAll("&total_before_vat&",
        global.moneyFormatAndDot.format(value.amount_before_calc_vat));
    // ภาษี
    result = result.replaceAll("&total_vat_name&",
        "ภาษีมูลค่าเพิ่ม : ${global.moneyFormat.format(value.vat_rate)}%");
    result = result.replaceAll(
        "&total_vat&", global.moneyFormatAndDot.format(value.total_vat_amount));
    // รับเงินสด
    result = result.replaceAll("&total_pay_cash_name&", "ชำระเงินสด");
    result = result.replaceAll("&total_pay_cash&",
        global.moneyFormatAndDot.format(value.pay_cash_amount));
    // เงินทอน
    result = result.replaceAll("&total_pay_cash_change_name&", "เงินทอน");
    result = result.replaceAll("&total_pay_cash_change&",
        global.moneyFormatAndDot.format(value.pay_cash_change));
    return result.trim().replaceAll("  ", " ").replaceAll("  ", " ");
  }

  Future<List<PosPrintBillCommandModel>> buildCommand() async {
    late FormDesignObjectBoxStruct formDesign;
    List<PosPrintBillCommandModel> commandList = [];

    BillObjectBoxStruct? bill = global.billHelper.selectByDocNumber(
        docNumber: docNo, posScreenMode: global.posScreenToInt());

    if (bill!.is_vat_register) {
      // 1=แบบย่อ,2=แบบเต็ม
      formDesign = (bill.bill_tax_type == 1)
          ? global.formDesignList[global.findFormByCode(global.formS02)]
          : global.formDesignList[global.findFormByCode(global.formS03)];
    } else {
      // ไม่จดทะเบียนภาษีมูลค่าเพิ่ม
      formDesign = global.formDesignList[global.findFormByCode(global.formS04)];
    }

    // Reset Printer
    commandList.add(PosPrintBillCommandModel(mode: 0));

    if (global.posTicket.logo) {
      // พิมพ์ Logo
      io.File file = io.File(global.getPosLogoPathName());
      if (file.existsSync()) {
        Uint8List bytes = file.readAsBytesSync();
        /*ui.Image getImage = await decodeImageFromList(bytes);
        final codec = await ui.instantiateImageCodec(
          bytes.buffer.asUint8List(),
          targetHeight: (getImage.height).toInt(),
          targetWidth: (getImage.width).toInt(),
        );
        final frame = await codec.getNextFrame();
        final image =
            await frame.image.toByteData(format: ui.ImageByteFormat.png);
        bytes = image!.buffer.asUint8List();*/
        commandList.add(PosPrintBillCommandModel(mode: 1, image: bytes));
      }
    }

    if (global.posTicket.shop_name) {
      // พิมพ์ชื่อร้าน
      commandList.add(PosPrintBillCommandModel(
          mode: 2,
          columns: [
            FormDesignColumnModel(
                width: 1,
                text: global.getNameFromLanguage(
                    global.profileSetting.company.names, languageCode),
                font_weight_bold: true,
                font_size: 32,
                text_align: PrintColumnAlign.center)
          ],
          posTextSize: PosTextSize.size2));
    }
    // ที่อยู่ร้าน
    String address = global.getNameFromLanguage(
        global.profileSetting.branch[0].names, languageCode);
    if (global.posTicket.shop_address) {
      address =
          "$address ${global.getNameFromLanguage(global.profileSetting.company.addresses, languageCode)}";
    }
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: address,
          font_weight_bold: false,
          font_size: 18,
          text_align: PrintColumnAlign.center)
    ]));
    //
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: global.getNameFromJsonLanguage(
              formDesign.names_json, languageCode),
          font_size: 30,
          font_weight_bold: true,
          text_align: PrintColumnAlign.center)
    ]));
    //
    if (global.posTicket.shop_tax_id && bill.is_vat_register) {
      // พิมพ์ เลขที่ผู้เสียภาษี
      if (global.profileSetting.company.taxID.trim().isNotEmpty) {
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
          FormDesignColumnModel(
              width: 1,
              text:
                  "เลขประจำตัวผู้เสียภาษี : ${global.profileSetting.company.taxID}",
              text_align: PrintColumnAlign.center)
        ]));
      }
    }
    //
    if (global.posTicket.shop_tel) {
      // พิมพ์ เบอร์โทรศัพท์
      String phone = "";
      for (var item in global.profileSetting.company.phones) {
        if (item.trim().isEmpty) {
          if (phone.isNotEmpty) {
            phone += ",";
          }
          phone += item;
        }
      }
      if (phone.isNotEmpty) {
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
          FormDesignColumnModel(
              width: 1,
              text: "โทรศัพท์ : $phone",
              text_align: PrintColumnAlign.center)
        ]));
      }
    }
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "หมายเลขเครื่อง POS : ${global.posConfig.devicenumber}",
          text_align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1, text: bill!.doc_number, text_align: PrintColumnAlign.left),
      FormDesignColumnModel(
          width: 1,
          text: global.dateTimeFormatShort(bill.date_time),
          text_align: PrintColumnAlign.right)
    ]));
    if (bill.is_vat_register) {
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
        FormDesignColumnModel(
            width: 1,
            text: (bill.vat_type == 0)
                ? "(ราคารวมภาษีมูลค่าเพิ่มแล้ว)"
                : "(ราคาไม่รวมภาษีมูลค่าเพิ่ม)",
            text_align: PrintColumnAlign.center)
      ]));
    }
    // Header
    String headerDescription = global
        .getNameFromLanguage(
            global.posConfig.billheader, global.userScreenLanguage)
        .trim();
    if (headerDescription.isNotEmpty) {
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
        FormDesignColumnModel(
            width: 1,
            text: headerDescription,
            text_align: PrintColumnAlign.center)
      ]));
    }
    // Detail
    List<BillDetailObjectBoxStruct> billDetails = global.objectBoxStore
        .box<BillDetailObjectBoxStruct>()
        .query(BillDetailObjectBoxStruct_.doc_number.equals(bill.doc_number))
        .order(BillDetailObjectBoxStruct_.line_number)
        .build()
        .find();

    if (formDesign.sum_by_barcode) {
      // กรณีพิมพ์บิลแบบรวมรายการ
      List<BillDetailObjectBoxStruct> billDetailSum = [];
      for (var billDetail in billDetails) {
        bool isFound = false;
        for (var billDetailSumItem in billDetailSum) {
          if (billDetailSumItem.barcode == billDetail.barcode &&
              billDetailSumItem.extra_json == billDetail.extra_json) {
            billDetailSumItem.qty += billDetail.qty;
            billDetailSumItem.total_amount += billDetail.total_amount;
            isFound = true;
            break;
          }
        }
        if (!isFound) {
          billDetailSum.add(billDetail);
        }
      }
      billDetails = billDetailSum;
    }

    List<FormDesignColumnModel> formDetailList =
        (jsonDecode(formDesign.detail_json) as List)
            .map((e) => FormDesignColumnModel.fromJson(e))
            .toList();
    List<FormDesignColumnModel> formDetailExtraList =
        (jsonDecode(formDesign.detail_extra_json) as List)
            .map((e) => FormDesignColumnModel.fromJson(e))
            .toList();
    List<List<FormDesignColumnModel>> formTotalColumnList =
        (jsonDecode(formDesign.detail_total_json) as List)
            .map((e) => (e as List)
                .map((e) => FormDesignColumnModel.fromJson(e))
                .toList())
            .toList();
    // พิมพ์ หัว Column
    // Line
    commandList.add(PosPrintBillCommandModel(mode: 3));
    {
      List<FormDesignColumnModel> columns = [];
      for (var formDetail in formDetailList) {
        columns.add(
          FormDesignColumnModel(
              width: formDetail.width,
              text: global.getNameFromLanguage(
                  formDetail.header_names, languageCode),
              text_align: formDetail.text_align,
              font_weight_bold: true,
              font_size: formDetail.font_size),
        );
      }
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: columns));
    }
    // Line
    commandList.add(PosPrintBillCommandModel(mode: 3));
    for (var detail in billDetails) {
      {
        // รายละเอียดสินค้า
        List<FormDesignColumnModel> columns = [];
        for (var formDetail in formDetailList) {
          {
            columns.add(
              FormDesignColumnModel(
                  width: formDetail.width,
                  text: findValueBillDetail(detail, formDetail.command_text),
                  text_align: formDetail.text_align,
                  font_weight_bold: false,
                  font_size: formDetail.font_size),
            );
          }
        }
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: columns));
      }
      {
        // ส่วนเพิ่มเติม
        List<BillDetailExtraObjectBoxStruct> extraList =
            (jsonDecode(detail.extra_json) as List)
                .map((e) => BillDetailExtraObjectBoxStruct.fromJson(e))
                .toList();
        for (var extra in extraList) {
          List<FormDesignColumnModel> columns = [];
          for (var formDetailExtra in formDetailExtraList) {
            columns.add(
              FormDesignColumnModel(
                  width: formDetailExtra.width,
                  text: findValueBillDetailExtra(
                      extra, formDetailExtra.command_text),
                  text_align: formDetailExtra.text_align,
                  font_weight_bold: formDetailExtra.font_weight_bold,
                  font_size: formDetailExtra.font_size),
            );
          }
          commandList.add(PosPrintBillCommandModel(mode: 2, columns: columns));
        }
      }
    }
    // Line
    commandList.add(PosPrintBillCommandModel(mode: 3));
    {
      // ยอดรวม
      for (var formTotalColumns in formTotalColumnList) {
        bool isZero = true;
        List<FormDesignColumnModel> columns = [];
        for (int index = 0; index < formTotalColumns.length; index++) {
          FormDesignColumnModel formTotalColumn = formTotalColumns[index];
          double value = (double.tryParse(
                  findValueBillTotal(bill, formTotalColumn.command_text)
                      .replaceAll(",", "")) ??
              0);
          if (value != 0) {
            isZero = false;
          }
          // พิมพ์ยอดรวม
          columns.add(
            FormDesignColumnModel(
                width: formTotalColumn.width,
                text: findValueBillTotal(bill, formTotalColumn.command_text),
                text_align: formTotalColumn.text_align,
                font_weight_bold: formTotalColumn.font_weight_bold,
                font_size: formTotalColumn.font_size),
          );
          // ถ้าไม่มีภาษี (1=ถ้าแบบฟอร์มไม่มีภาษีไม่ต้องพิมพ์)
          if (formTotalColumn.condition_join_is_vat_register == 1 &&
              bill.is_vat_register == false) {
            isZero = true;
          }
        }
        if (isZero == false) {
          commandList.add(PosPrintBillCommandModel(mode: 2, columns: columns));
        }
      }
    }
    // Line
    commandList.add(PosPrintBillCommandModel(mode: 3));
    // Footer
    String footerDescription = global
        .getNameFromLanguage(
            global.posConfig.billfooter, global.userScreenLanguage)
        .trim();
    if (footerDescription.isNotEmpty) {
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
        FormDesignColumnModel(
            width: 1,
            text: footerDescription,
            text_align: PrintColumnAlign.center)
      ]));
    }
    // Line
    commandList.add(PosPrintBillCommandModel(mode: 3));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "${bill.cashier_code} ${bill.cashier_name}",
          text_align: PrintColumnAlign.left),
      FormDesignColumnModel(
          width: 1,
          text: global.dateTimeFormatShort(bill.date_time, showTime: true),
          text_align: PrintColumnAlign.right)
    ]));
    return commandList;
  }

  void printBillByBluetoothImageMode() async {
    await PrintBluetoothThermal.connect(
        macPrinterAddress: global.printerLocalStrongData[0].deviceName);
    bool connectStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectStatus) {
      final profile = await CapabilityProfile.load();
      final generator = Generator(
          (global.printerLocalStrongData[0].paperType == 1)
              ? PaperSize.mm58
              : PaperSize.mm80,
          profile);
      List<int> bytes = [];

      double maxHeight = 0;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final backgroundPaint = ui.Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(
          Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(0), 20000.0),
          backgroundPaint);

      await buildCommand().then((value) async {
        PrintProcess printProcess = PrintProcess(printerIndex: 0);
        for (var command in value) {
          // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
          switch (command.mode) {
            case 0: // Reset
              break;
            case 1: // Logo Image
              break;
            case 2: // Text
              printProcess.columnWidth.clear();
              printProcess.column.clear();
              for (int index = 0; index < command.columns.length; index++) {
                printProcess.columnWidth.add(command.columns[index].width);
                printProcess.column.add(PrintColumn(
                    text: command.columns[index].text,
                    align: command.columns[index].text_align,
                    bold: command.columns[index].font_weight_bold,
                    fontSize: command.columns[index].font_size));
              }
              ui.Image result = await printProcess
                  .lineFeedImage(command.posStyles ?? const PosStyles());
              canvas.drawImage(result, Offset(0, maxHeight), ui.Paint());
              maxHeight += result.height.toDouble();
              break;
            case 3: // Line
              //await SunmiPrinter.line(len: global.posTicket.charPerLine);
              break;
          }
        }
        final picture = recorder.endRecording();
        final imageBuffer = picture.toImage(
            global.printerWidthByPixel(0).toInt(), maxHeight.toInt());
        final pngBytes = await imageBuffer
            .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
        im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
        int printMaxHeight = 1000;
        int calcLoop = imageDecode!.height ~/ printMaxHeight;
        for (int i = 0; i <= calcLoop; i++) {
          try {
            if (i != 0) {
              // sleep(const Duration(milliseconds: 100));
            }
            im.Image croppedImage = im.copyCrop(imageDecode, 0,
                i * printMaxHeight, imageDecode.width, printMaxHeight);
            bytes += generator.imageRaster(croppedImage);
          } catch (e) {
            serviceLocator<Log>().error(e);
          }
        }
        saveImageToJpgFile(docDate, docNo, imageBuffer);
      });
      bytes += generator.cut();
      bytes += generator.drawer();
      await PrintBluetoothThermal.writeBytes(bytes);
    }
  }

  void printBillByIpImageMode() async {
    PaperSize paper = (global.printerLocalStrongData[0].paperType == 1)
        ? PaperSize.mm58
        : PaperSize.mm80;
    CapabilityProfile profile = await CapabilityProfile.load();
    NetworkPrinter printer = NetworkPrinter(paper, profile);
    double maxHeight = 0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final backgroundPaint = ui.Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = ui.PaintingStyle.fill;
    final double width = global.printerWidthByPixel(0);

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width, 20000.0), backgroundPaint);

    await buildCommand().then((value) async {
      PrintProcess printProcess = PrintProcess(printerIndex: 0);
      for (var command in value) {
        // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
        print("Command : ${command.mode}");
        switch (command.mode) {
          case 0: // Reset
            break;
          case 1: // Logo Image
            if (command.image != null) {
              ui.Image? logo;
              ui.decodeImageFromList(command.image!, (result) {
                logo = result;
              });
              while (logo == null) {
                await Future.delayed(const Duration(milliseconds: 100));
              }
              canvas.drawImage(logo!,
                  Offset((width - logo!.width) / 2, maxHeight), ui.Paint());
              maxHeight += logo!.height.toDouble();
            }
            break;
          case 2: // Text
            printProcess.columnWidth.clear();
            printProcess.column.clear();
            for (int index = 0; index < command.columns.length; index++) {
              printProcess.columnWidth.add(command.columns[index].width);
              printProcess.column.add(PrintColumn(
                  text: command.columns[index].text,
                  align: command.columns[index].text_align,
                  bold: command.columns[index].font_weight_bold,
                  fontSize: command.columns[index].font_size));
            }
            ui.Image result = await printProcess
                .lineFeedImage(command.posStyles ?? const PosStyles());
            canvas.drawImage(result, Offset(0, maxHeight), ui.Paint());
            maxHeight += result.height.toDouble();
            break;
          case 3: // Line
            canvas.drawLine(
                Offset(0, maxHeight),
                Offset(0 + global.printerWidthByPixel(0), maxHeight),
                ui.Paint());
            maxHeight += 1;
            break;
        }
      }
      /*if (slipImage.isNotEmpty) {
        Uint8List imageBytes = base64Decode(slipImage);
        ui.Image? slip;
        ui.decodeImageFromList(imageBytes, (result) {
          slip = result;
        });
        while (slip == null) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        canvas.drawImage(
            slip!, Offset((width - slip!.width) / 2, maxHeight), ui.Paint());
        maxHeight += slip!.height.toDouble() + 50;
      }*/
      final picture = recorder.endRecording();
      final imageBuffer = picture.toImage(
          global.printerWidthByPixel(0).toInt(), maxHeight.toInt());
      // Print to printer
      String printerIp = global.printerLocalStrongData[0].ipAddress;
      int printerPort = global.printerLocalStrongData[0].ipPort;
      PosPrintResult res = await printer.connect(printerIp, port: printerPort);

      if (res == PosPrintResult.success) {
        final pngBytes = await imageBuffer
            .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
        im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
        int printMaxHeight = 200;
        int calcLoop = imageDecode!.height ~/ printMaxHeight;
        for (int i = 0; i <= calcLoop; i++) {
          try {
            im.Image croppedImage = im.copyCrop(imageDecode, 0,
                i * printMaxHeight, imageDecode.width, printMaxHeight);
            printer.imageRaster(croppedImage);
            io.sleep(const Duration(milliseconds: 100));
          } catch (e) {
            serviceLocator<Log>().error(e);
          }
        }
        io.sleep(const Duration(milliseconds: 100));
        printer.cut();
        io.sleep(const Duration(milliseconds: 100));
        printer.drawer();
        io.sleep(const Duration(milliseconds: 100));
        printer.disconnect();
        io.sleep(const Duration(milliseconds: 100));
        printer.reset();
      } else {
        global.errorMessage.add(
            "${global.language("error_connect_printer")} : IP Printer -> $printerIp:$printerPort");
      }
      // Save e-Journal
      saveImageToJpgFile(docDate, docNo, imageBuffer);
    });
  }

  void printBillByWindowsImageMode() async {
    try {
      await PrinterManager.instance.connect(
          type: PrinterType.usb,
          model: UsbPrinterInput(
              name: global.printerLocalStrongData[0].deviceName));
      double maxHeight = 0;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final backgroundPaint = ui.Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(
          Rect.fromLTWH(0.0, 0.0, billWidth, 20000.0), backgroundPaint);

      await buildCommand().then((value) async {
        final profile = await CapabilityProfile.load();
        final generator = Generator(
            (global.printerLocalStrongData[0].paperType == 1)
                ? PaperSize.mm58
                : PaperSize.mm80,
            profile);
        PrintProcess printProcess = PrintProcess(printerIndex: 0);
        for (var command in value) {
          // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
          switch (command.mode) {
            case 0: // Reset
              break;
            case 1: // Logo Image
              /*im.Image? imageLogo =
                 ui.decodeImageFromList (command.image!.toList());
              canvas.drawImage(
                  imageLogo, Offset(0, maxHeight), ui.Paint());
              maxHeight += imageLogo.height.toDouble();*/
              break;
            case 2: // Text
              printProcess.columnWidth.clear();
              printProcess.column.clear();
              for (int index = 0; index < command.columns.length; index++) {
                printProcess.columnWidth.add(command.columns[index].width);
                printProcess.column.add(PrintColumn(
                    text: command.columns[index].text,
                    align: command.columns[index].text_align,
                    bold: command.columns[index].font_weight_bold,
                    fontSize: command.columns[index].font_size));
              }
              ui.Image result = await printProcess
                  .lineFeedImage(command.posStyles ?? const PosStyles());
              canvas.drawImage(result, Offset(0, maxHeight), ui.Paint());
              maxHeight += result.height.toDouble();
              break;
            case 3: // Line
              canvas.drawLine(
                  Offset(0, maxHeight),
                  Offset(0 + global.printerWidthByPixel(0), maxHeight),
                  ui.Paint());
              maxHeight += 1;
              break;
          }
        }
        final picture = recorder.endRecording();
        final imageBuffer =
            picture.toImage(billWidth.toInt(), maxHeight.toInt());
        final pngBytes = await imageBuffer
            .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
        im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
        int printMaxHeight = 1000;
        int calcLoop = imageDecode!.height ~/ printMaxHeight;
        var bytes = generator.reset();
        for (int i = 0; i <= calcLoop; i++) {
          try {
            im.Image croppedImage = im.copyCrop(imageDecode, 0,
                i * printMaxHeight, imageDecode.width, printMaxHeight);
            bytes += generator.imageRaster(croppedImage);
          } catch (e) {
            serviceLocator<Log>().error(e);
          }
        }
        bytes += generator.cut();
        bytes += generator.drawer();
        PrinterManager.instance.send(type: PrinterType.usb, bytes: bytes);
        saveImageToJpgFile(docDate, docNo, imageBuffer);
      });
    } catch (e) {
      serviceLocator<Log>().error(e);
    }
  }

  Future<void> saveImageToJpgFile(
      DateTime docDate, String docNo, Future<ui.Image> image) async {
    try {
      // Request storage permission.
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    } catch (e) {
      serviceLocator<Log>().error(e);
    }

    try {
      String mainPath = "posbill";
      final dateDirectory = await global.createPath(mainPath, docDate);
      // Save the image to the new directory
      final path = '${dateDirectory.path}/$docNo.jpg';
      print(path);

      final img = await image; // Resolve the Future<ui.Image> here.

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      final decodedImage = im.decodeImage(pngBytes!);

      final jpg = im.encodeJpg(decodedImage!,
          quality: 25); // Control the quality of the image.

      final file = io.File(path);
      await file.writeAsBytes(jpg);
    } catch (e) {
      print('Error saving image to file: $e');
    }
  }

  /*Future<void> printBillByIpTextMode() async {
    PaperSize paper = (global.printerLocalStrongData.paperSize == 1)
        ? PaperSize.mm58
        : PaperSize.mm80;
    CapabilityProfile profile = await CapabilityProfile.load();
    NetworkPrinter printer = NetworkPrinter(paper, profile);
    PosPrintResult res = await printer.connect(
        global.printerLocalStrongData.ipAddress,
        port: global.printerLocalStrongData.ipPort);

    if (res == PosPrintResult.success) {
      await buildCommand().then((value) async {
        PrintProcess printProcess = PrintProcess();
        for (var command in value) {
          // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
          switch (command.mode) {
            case 0: // Reset
              printer.reset();
              break;
            case 1: // Logo Image
              printer.image(command.image!);
              break;
            case 2: // Text
              printProcess.columnWidth.clear();
              printProcess.column.clear();
              for (int index = 0; index < command.columns.length; index++) {
                printProcess.columnWidth.add(command.columns[index].width);
                printProcess.column.add(PrintColumn(
                    text: command.columns[index].text,
                    align: command.columns[index].align));
              }
              await printProcess.lineFeedText(
                  printer, command.posStyles ?? const PosStyles());
              break;
            case 3: // Line
              await printProcess.drawLine(printer);
              break;
            case 9: // Cut
              printer.cut();
              break;
          }
        }
      });
      printer.disconnect();
    }
  }*/

  Future<void> printBillBySunmi() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    double maxHeight = 0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final backgroundPaint = ui.Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = ui.PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(0), 20000.0),
        backgroundPaint);

    await buildCommand().then((value) async {
      PrintProcess printProcess = PrintProcess(printerIndex: 0);
      for (var command in value) {
        // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
        switch (command.mode) {
          case 0: // Reset
            break;
          case 1: // Logo Image
            break;
          case 2: // Text
            printProcess.columnWidth.clear();
            printProcess.column.clear();
            for (int index = 0; index < command.columns.length; index++) {
              printProcess.columnWidth.add(command.columns[index].width);
              printProcess.column.add(PrintColumn(
                  text: command.columns[index].text,
                  align: command.columns[index].text_align,
                  bold: command.columns[index].font_weight_bold,
                  fontSize: command.columns[index].font_size));
            }
            ui.Image result = await printProcess
                .lineFeedImage(command.posStyles ?? const PosStyles());
            canvas.drawImage(result, Offset(0, maxHeight), ui.Paint());
            maxHeight += result.height.toDouble();
            break;
          case 3: // Line
            //await SunmiPrinter.line(len: global.posTicket.charPerLine);
            break;
        }
      }
      final picture = recorder.endRecording();
      final imageBuffer = picture.toImage(
          global.printerWidthByPixel(0).toInt(), maxHeight.toInt());
      final pngBytes = await imageBuffer
          .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
      im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
      int printMaxHeight = 500;
      int calcLoop = imageDecode!.height ~/ printMaxHeight;
      for (int i = 0; i <= calcLoop; i++) {
        try {
          if (i != 0) {
            await SunmiPrinter.submitTransactionPrint();
            //sleep(const Duration(milliseconds: 200));
            await SunmiPrinter.startTransactionPrint(true);
          }
          im.Image croppedImage = im.copyCrop(imageDecode, 0,
              i * printMaxHeight, imageDecode.width, printMaxHeight);
          List<int> croppedImageBytes = im.encodePng(croppedImage);
          Uint8List imageCopy = Uint8List.fromList(croppedImageBytes);
          await SunmiPrinter.printImage(imageCopy);
        } catch (e) {
          serviceLocator<Log>().error(e);
        }
      }
    });
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printQRCode('https://www.dedepos.com');
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  Future<void> printBill() async {
    switch (global.printerLocalStrongData[0].printerConnectType) {
      case global.PrinterConnectEnum.ip:
        printBillByIpImageMode();
        break;
      case global.PrinterConnectEnum.bluetooth:
        printBillByBluetoothImageMode();
        break;
      case global.PrinterConnectEnum.usb:
        // TODO: Handle this case.
        break;
      case global.PrinterConnectEnum.windows:
        printBillByWindowsImageMode();
        break;
      case global.PrinterConnectEnum.sunmi1:
        await printBillBySunmi();
        break;
    }
  }
}
