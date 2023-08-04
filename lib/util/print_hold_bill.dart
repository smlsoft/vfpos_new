import 'dart:convert';
import 'dart:io' as io;
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_process.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/core/core.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
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

Future<void> printHoldBill(
    {required BuildContext context, required String holdNumber}) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("พิมพ์ใบสรุปรายการ"),
          content: Text("คุณต้องการพิมพ์ใบสรุปรายการหรือไม่"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ยกเลิก")),
            TextButton(
                onPressed: () async {
                  await PosPrintHoldBillClass(
                          holdNumber: holdNumber,
                          languageCode: global.userScreenLanguage)
                      .printHoldBill();
                  Navigator.pop(context);
                },
                child: Text("พิมพ์"))
          ],
        );
      });
}

class PosPrintHoldBillClass {
  String languageCode;
  String holdNumber;

  PosPrintHoldBillClass({required this.holdNumber, required this.languageCode});

  String findValueBillDetail(PosProcessDetailModel detail, String source) {
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
      PosProcessDetailExtraModel detailExtra, String source) {
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

  String findValueBillTotal(PosProcessModel value, String source) {
    String result = source;
    // จำนวนชิ้น
    result = result.replaceAll("&total_piece_name&", "จำนวนชิ้น");
    result = result.replaceAll(
        "&total_piece&", global.moneyFormatAndDot.format(value.total_piece));
    // ยอดรวมสินค้ามีภาษี
    result =
        result.replaceAll("&total_item_vat_amount_name&", "รวมสินค้ามีภาษี");
    result = result.replaceAll("&total_item_vat_amount&",
        global.moneyFormatAndDot.format(value.total_item_vat_amount));
    // ยอดรวมสินค้ายกเว้นภาษี
    result = result.replaceAll(
        "&total_itm_except_vat_amount_name&", "รวมสินค้ายกเว้นภาษี");
    result = result.replaceAll("&total_itm_except_vat_amount&",
        global.moneyFormatAndDot.format(value.total_item_except_vat_amount));
    // ภาษี
    result = result.replaceAll("&total_vat_name&",
        "ภาษีมูลค่าเพิ่ม : ${global.moneyFormat.format(value.vat_rate)}%");
    result = result.replaceAll(
        "&total_vat&", global.moneyFormatAndDot.format(value.total_vat_amount));
    // รวมทั้งสิ้น
    result = result.replaceAll("&total_amount_name&", "ยอดรวมสุทธิ");
    result = result.replaceAll(
        "&total_amount&", global.moneyFormatAndDot.format(value.total_amount));
    return result.trim().replaceAll("  ", " ").replaceAll("  ", " ");
  }

  Future<List<PosPrintBillCommandModel>> buildCommand(
      PosProcessModel processResult) async {
    FormDesignObjectBoxStruct formDesign = global.formDesignList[2];
    List<PosPrintBillCommandModel> commandList = [];

    // Reset Printer
    commandList.add(PosPrintBillCommandModel(mode: 0));

    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "พักบิลเลขที่ : $holdNumber",
          font_size: 30,
          font_weight_bold: true,
          text_align: PrintColumnAlign.center)
    ]));

    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: global.getNameFromJsonLanguage(
              formDesign.names_json, languageCode),
          font_size: 30,
          font_weight_bold: true,
          text_align: PrintColumnAlign.center)
    ]));

    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: (1 == 1)
              ? "(ราคารวมภาษีมูลค่าเพิ่มแล้ว)"
              : "(ราคาไม่รวมภาษีมูลค่าเพิ่ม)",
          text_align: PrintColumnAlign.center)
    ]));
    List<PosProcessDetailModel> details = processResult.details;
    if (formDesign.sum_by_barcode) {
      // กรณีพิมพ์บิลแบบรวมรายการ
      List<PosProcessDetailModel> detailSum = [];
      for (var detail in details) {
        bool isFound = false;
        for (var billDetailSumItem in detailSum) {
          if (billDetailSumItem.barcode == detail.barcode &&
              jsonEncode(billDetailSumItem.extra) == jsonEncode(detail.extra)) {
            billDetailSumItem.qty += detail.qty;
            billDetailSumItem.total_amount += detail.total_amount;
            isFound = true;
            break;
          }
        }
        if (!isFound) {
          detailSum.add(detail);
        }
      }
      details = detailSum;
    }

    List<FormDesignColumnModel> formDetailList =
        (jsonDecode(formDesign.detail_json) as List)
            .map((e) => FormDesignColumnModel.fromJson(e))
            .toList();
    List<FormDesignColumnModel> formDetailExtraList =
        (jsonDecode(formDesign.detail_extra_json) as List)
            .map((e) => FormDesignColumnModel.fromJson(e))
            .toList();
    List<List<FormDesignColumnModel>> formDetailColumnList =
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
    for (var detail in details) {
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
        for (var extra in detail.extra) {
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
      double sumQty = 0;
      for (var detail in details) {
        sumQty += detail.qty;
      }
      for (var formDetailColumns in formDetailColumnList) {
        List<FormDesignColumnModel> columns = [];
        for (FormDesignColumnModel column in formDetailColumns) {
          // พิมพ์ยอดรวม (รายการ
          columns.add(
            FormDesignColumnModel(
                width: column.width,
                text: findValueBillTotal(processResult, column.command_text),
                text_align: column.text_align,
                font_weight_bold: column.font_weight_bold,
                font_size: column.font_size),
          );
        }
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: columns));
      }
    }
    // Line
    commandList.add(PosPrintBillCommandModel(mode: 3));
    // Footer
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "ใบสรุปยอดเพื่อตรวจสอบ",
          text_align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "ไม่ใช่ใบเสร็จรับเงิน",
          text_align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "ยอดภาษี และยอดรวม อาจเปลี่ยนแปลง",
          text_align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      FormDesignColumnModel(
          width: 1,
          text: "เมื่อถึงขึ้นตอนการชำระเงิน",
          text_align: PrintColumnAlign.center)
    ]));
    return commandList;
  }

  void printBillByIpImageMode(PosProcessModel processResult) async {
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

    await buildCommand(processResult).then((value) async {
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
    });
  }

  Future<void> printHoldBill() async {
    PosProcessModel processResult = await PosProcess()
        .process(holdCode: holdNumber, docMode: 1, discountFormula: "");
    switch (global.printerLocalStrongData[0].printerConnectType) {
      case global.PrinterConnectEnum.ip:
        printBillByIpImageMode(processResult);
        break;
      case global.PrinterConnectEnum.bluetooth:
        //printBillByBluetoothImageMode();
        break;
      case global.PrinterConnectEnum.usb:
        // TODO: Handle this case.
        break;
      case global.PrinterConnectEnum.windows:
        //printBillByWindowsImageMode();
        break;
      case global.PrinterConnectEnum.sunmi1:
        //await printBillBySunmi();
        break;
    }
  }
}
