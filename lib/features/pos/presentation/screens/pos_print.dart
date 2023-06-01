import 'dart:io';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/core/core.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:image/image.dart' as im;
import 'dart:ui' as ui;

Future<void> printBill(DateTime docDate, String docNo) async {
  if (global.posTicket.printMode == 0) {
    PosPrintBillClass posPrintBill =
        PosPrintBillClass(docDate: docDate, docNo: docNo);
    posPrintBill.printBill();
  } else {
    //printBillImage(docNo);
  }
}

class PosPrintBillCommandColumnModel {
  double width;
  String text;
  PrintColumnAlign align;

  PosPrintBillCommandColumnModel(
      {this.width = 0, this.text = "", this.align = PrintColumnAlign.left});
}

class PosPrintBillCommandModel {
  int? mode; // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
  String? text;
  Uint8List? image;
  PosStyles? posStyles;
  PosTextSize? posTextSize;
  List<PosPrintBillCommandColumnModel> columns;

  PosPrintBillCommandModel(
      {required this.mode,
      this.text,
      this.image,
      this.posStyles = const PosStyles(bold: false),
      this.columns = const [],
      this.posTextSize = PosTextSize.size1});
}

class PosPrintBillClass {
  DateTime docDate;
  String docNo;
  double billWidth =
      (global.printerLocalStrongData.paperSize == 1) ? 378.0 : 575.0;

  PosPrintBillClass({required this.docDate, required this.docNo});

  Future<List<PosPrintBillCommandModel>> buildCommand() async {
    List<PosPrintBillCommandModel> commandList = [];

    // Reset Printer
    commandList.add(PosPrintBillCommandModel(mode: 0));

    double totalDiscountAndPromotion = 0;

    if (global.posTicket.logo) {
      // พิมพ์ Logo
      ByteData data = await rootBundle.load('assets/logo.jpg');
      Uint8List bytes = data.buffer.asUint8List();
      commandList.add(PosPrintBillCommandModel(mode: 1, image: bytes));
    }
    if (global.posTicket.shopName) {
      // พิมพ์ชื่อร้าน
      commandList.add(PosPrintBillCommandModel(
          mode: 2,
          columns: [
            PosPrintBillCommandColumnModel(
                width: 1, text: "ร้านโซลาว", align: PrintColumnAlign.center)
          ],
          posTextSize: PosTextSize.size2));
    }
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      PosPrintBillCommandColumnModel(
          width: 1, text: "(สำนักงานใหญ่)", align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      PosPrintBillCommandColumnModel(
          width: 1, text: "(Vat Included)", align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      PosPrintBillCommandColumnModel(
          width: 1,
          text: "ใบเสร็จรับเงิน/ใบกำกับภาษีแบบย่อ",
          align: PrintColumnAlign.center)
    ]));
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      PosPrintBillCommandColumnModel(
          width: 1,
          text:
              "141/469 หมู่ที่ 2 ต.ต้นเปา อ.สันกำแพง จ.เชียงใหม่ 50130, อาคารซอฟท์แวร์พาร์ค ชั้น 7 ถ.แจ้งวัฒนะ ต.คลองเกลือ อ.ปากเกร็ด จ.นนทบุรี 11120",
          align: PrintColumnAlign.center)
    ]));
    //
    if (global.posTicket.shopTaxId) {
      // พิมพ์ เลขที่ผู้เสียภาษี
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
        PosPrintBillCommandColumnModel(
            width: 1,
            text: "เลขประจำตัวผู้เสียภาษี : 0135549000236",
            align: PrintColumnAlign.center)
      ]));
    }
    //
    if (global.posTicket.shopTel) {
      // พิมพ์ เลขที่ผู้เสียภาษี
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
        PosPrintBillCommandColumnModel(
            width: 1,
            text: "โทรศัพท์ : 0899223131",
            align: PrintColumnAlign.center)
      ]));
    }
    commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
      PosPrintBillCommandColumnModel(
          width: 1,
          text: "หมายเลขเครื่อง POS : 11231220899223131",
          align: PrintColumnAlign.center)
    ]));
    BillObjectBoxStruct? bill = global.billHelper.selectByDocNumber(
        docNumber: docNo, posScreenMode: global.posScreenToInt());
    if (bill != null) {
      List<BillDetailObjectBoxStruct> billDetails =
          global.billDetailHelper.selectByDocNumber(docNumber: docNo);
      //
      List<BillPayObjectBoxStruct> payDetails =
          global.billPayHelper.selectByDocNumber(docNumber: docNo);
      //
      double sumWidth =
          global.posTicket.descriptionWidth + global.posTicket.amountWidth;
      double calcWidth = global.printerWidthByCharacter() / sumWidth;
      int widthCharDescription =
          (global.posTicket.descriptionWidth * calcWidth).toInt();
      int widthCharAmount = (global.posTicket.amountWidth * calcWidth).toInt();

      // Line
      commandList.add(PosPrintBillCommandModel(mode: 3));

      /// ส่วนของการแสดงรายการสินค้า
      for (var detail in billDetails) {
        /// สินค้าทั่วไป
        String desc =
            "${global.moneyFormat.format(detail.qty)} ${detail.item_name}/${detail.unit_name}";
        if (detail.discount_text.isNotEmpty) {
          desc = "$desc ${global.language("discount")}";
          if (detail.discount_text.contains("%") ||
              detail.discount_text.contains(",")) {
            desc = "$desc ${detail.discount_text}=";
          }
          desc = "$desc ${global.moneyFormat.format(detail.discount)}";
          desc = "$desc ${global.language("money_symbol")}/${detail.unit_name}";
        }
        if (detail.price != detail.total_amount) {
          if (detail.price != 0) {
            desc = "$desc @${global.moneyFormat.format(detail.price)}";
          }
        }
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
          PosPrintBillCommandColumnModel(
              width: widthCharDescription.toDouble(), text: desc),
          PosPrintBillCommandColumnModel(
              width: widthCharAmount.toDouble(),
              text: (detail.total_amount == 0)
                  ? ""
                  : global.moneyFormat.format(detail.total_amount),
              align: PrintColumnAlign.right),
        ]));

        /// สินค้าเพิ่ม (Extra)
        List<BillDetailExtraObjectBoxStruct> extras =
            global.billDetailExtraHelper.selectByDocNumberAndLineNumber(
                docNumber: detail.doc_number, lineNumber: detail.line_number);
        for (var extra in extras) {
          commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
            PosPrintBillCommandColumnModel(
                width: widthCharDescription.toDouble(), text: desc),
            PosPrintBillCommandColumnModel(
                width: widthCharAmount.toDouble(),
                text: (extra.total_amount == 0)
                    ? ""
                    : global.moneyFormat.format(extra.total_amount),
                align: PrintColumnAlign.right),
          ]));
        }
      }

      // Line
      commandList.add(PosPrintBillCommandModel(mode: 3));
      // พิมพ์ยอดรวม
      commandList.add(PosPrintBillCommandModel(
          mode: 2,
          columns: [
            PosPrintBillCommandColumnModel(
                width: widthCharDescription.toDouble(),
                text: global.language("total_amount")),
            PosPrintBillCommandColumnModel(
                width: widthCharAmount.toDouble(),
                text: global.moneyFormat.format(bill.total_amount),
                align: PrintColumnAlign.right),
          ],
          posStyles: const PosStyles(bold: true)));
      // Line
      commandList.add(PosPrintBillCommandModel(mode: 3));

      if (bill.pay_cash_amount > 0) {
        // รวมเงินสด
        commandList.add(PosPrintBillCommandModel(
            mode: 2,
            columns: [
              PosPrintBillCommandColumnModel(
                  width: widthCharDescription.toDouble(),
                  text: global.language("cash")),
              PosPrintBillCommandColumnModel(
                  width: widthCharAmount.toDouble(),
                  text: global.moneyFormat.format(bill.pay_cash_amount),
                  align: PrintColumnAlign.right),
            ],
            posStyles: const PosStyles(bold: true)));
      }
      double sumTotalPayAmount = bill.pay_cash_amount +
          bill.sum_discount +
          bill.sum_coupon +
          bill.sum_credit_card +
          bill.sum_money_transfer +
          bill.sum_cheque +
          bill.sum_qr_code;
      // ยอดรวมจ่าย
      commandList.add(PosPrintBillCommandModel(
          mode: 2,
          columns: [
            PosPrintBillCommandColumnModel(
                width: widthCharDescription.toDouble(),
                text: global.language("total_pay_bill")),
            PosPrintBillCommandColumnModel(
                width: widthCharAmount.toDouble(),
                text: global.moneyFormat.format(sumTotalPayAmount),
                align: PrintColumnAlign.right),
          ],
          posStyles: const PosStyles(bold: true)));

      // Line
      commandList.add(PosPrintBillCommandModel(mode: 3));

      if (global.posTicket.saleDetail && bill.sale_code.isNotEmpty) {
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
          PosPrintBillCommandColumnModel(
              width: 1,
              text:
                  "${global.language("sale_code")} : ${bill.sale_name} (${bill.sale_code})"),
        ]));
      }
      commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
        PosPrintBillCommandColumnModel(width: 1, text: "#${bill.doc_number}"),
        PosPrintBillCommandColumnModel(
            width: 1, text: "10/10/2564 16:30", align: PrintColumnAlign.right),
      ]));

      //
      if (global.posTicket.cashierDetail && bill.cashier_code.isNotEmpty) {
        commandList.add(PosPrintBillCommandModel(mode: 2, columns: [
          PosPrintBillCommandColumnModel(
              width: 1,
              text: "${global.language("cashier")} ${bill.cashier_name}"),
          PosPrintBillCommandColumnModel(
              width: 1,
              text: "${global.language("sale")} ${bill.cashier_name}",
              align: PrintColumnAlign.right),
        ]));
      }
      // Cut
      commandList.add(PosPrintBillCommandModel(mode: 9));
    } else {
      serviceLocator<Log>().error(
          "Printer Connect fail.${global.printerLocalStrongData.ipAddress}:${global.printerLocalStrongData.ipPort}");
    }
    return commandList;
  }

  void printBillByBluetoothImageMode() async {
    await PrintBluetoothThermal.connect(
        macPrinterAddress: global.printerLocalStrongData.deviceName);
    bool connectStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectStatus) {
      final profile = await CapabilityProfile.load();
      final generator = Generator(
          (global.printerLocalStrongData.paperSize == 1)
              ? PaperSize.mm58
              : PaperSize.mm80,
          profile);
      List<int> xbytes = [];

      double maxHeight = 0;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final backgroundPaint = ui.Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(
          Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(), 20000.0),
          backgroundPaint);

      await buildCommand().then((value) async {
        PrintProcess printProcess = PrintProcess();
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
                    align: command.columns[index].align));
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
            global.printerWidthByPixel().toInt(), maxHeight.toInt());
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
            xbytes += generator.imageRaster(croppedImage);
          } catch (e) {
            serviceLocator<Log>().error(e);
          }
        }
      });
      xbytes += generator.cut();
      xbytes += generator.drawer();
      await PrintBluetoothThermal.writeBytes(xbytes);
    }
  }

  void printBillByIpImageMode() async {
    PaperSize paper = (global.printerLocalStrongData.paperSize == 1)
        ? PaperSize.mm58
        : PaperSize.mm80;
    CapabilityProfile profile = await CapabilityProfile.load();
    NetworkPrinter printer = NetworkPrinter(paper, profile);
    PosPrintResult res = await printer.connect(
        global.printerLocalStrongData.ipAddress,
        port: global.printerLocalStrongData.ipPort);

    if (res == PosPrintResult.success) {
      double maxHeight = 0;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final backgroundPaint = ui.Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(
          Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(), 20000.0),
          backgroundPaint);

      await buildCommand().then((value) async {
        PrintProcess printProcess = PrintProcess();
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
                    align: command.columns[index].align));
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
            global.printerWidthByPixel().toInt(), maxHeight.toInt());
        final pngBytes = await imageBuffer
            .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
        im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
        int printMaxHeight = 100;
        int calcLoop = imageDecode!.height ~/ printMaxHeight;
        for (int i = 0; i <= calcLoop; i++) {
          try {
            if (i != 0) {
              sleep(const Duration(milliseconds: 100));
            }
            im.Image croppedImage = im.copyCrop(imageDecode, 0,
                i * printMaxHeight, imageDecode.width, printMaxHeight);
            printer.imageRaster(croppedImage);
          } catch (e) {
            serviceLocator<Log>().error(e);
          }
        }
      });
      printer.cut();
      printer.drawer();
      printer.disconnect();
    }
  }

  void printBillByWindowsImageMode() async {
    try {
      await PrinterManager.instance.connect(
          type: PrinterType.usb,
          model:
              UsbPrinterInput(name: global.printerLocalStrongData.deviceName));
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
            (global.printerLocalStrongData.paperSize == 1)
                ? PaperSize.mm58
                : PaperSize.mm80,
            profile);
        PrintProcess printProcess = PrintProcess();
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
                    align: command.columns[index].align));
              }
              ui.Image result = await printProcess
                  .lineFeedImage(command.posStyles ?? const PosStyles());
              canvas.drawImage(result, Offset(0, maxHeight), ui.Paint());
              maxHeight += result.height.toDouble();
              break;
            case 3: // Line
              canvas.drawLine(
                  Offset(0, maxHeight),
                  Offset(0 + global.printerWidthByPixel(), maxHeight),
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
            if (i != 0) {
              sleep(const Duration(milliseconds: 100));
            }
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
    // Request storage permission.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      String mainPath = "posbill";
      final directory = await getApplicationDocumentsDirectory();

      // Format date as YYYYMMDD
      final dateFormatter = DateFormat('yyyyMMdd');
      String formattedDate = dateFormatter.format(docDate);

      // Create a new directory for the main path
      final mainDirectory = Directory('${directory.path}/$mainPath');
      if (!await mainDirectory.exists()) {
        await mainDirectory.create();
      }

      // Create a new directory for the date
      final dateDirectory =
          Directory('${directory.path}/$mainPath/$formattedDate');
      if (!await dateDirectory.exists()) {
        await dateDirectory.create();
      }

      // Save the image to the new directory
      final path = '${dateDirectory.path}/$docNo.jpg';
      print(path);

      final img = await image; // Resolve the Future<ui.Image> here.

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      final decodedImage = im.decodeImage(pngBytes!);

      final jpg = im.encodeJpg(decodedImage!,
          quality: 25); // Control the quality of the image.

      final file = File(path);
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
        Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(), 20000.0),
        backgroundPaint);

    await buildCommand().then((value) async {
      PrintProcess printProcess = PrintProcess();
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
                  align: command.columns[index].align));
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
          global.printerWidthByPixel().toInt(), maxHeight.toInt());
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
    switch (global.printerCashierConnect) {
      case global.PrinterCashierConnectEnum.ip:
        printBillByIpImageMode();
        break;
      case global.PrinterCashierConnectEnum.bluetooth:
        printBillByBluetoothImageMode();
        break;
      case global.PrinterCashierConnectEnum.usb:
        // TODO: Handle this case.
        break;
      case global.PrinterCashierConnectEnum.windows:
        printBillByWindowsImageMode();
        break;
      case global.PrinterCashierConnectEnum.sunmi1:
        await printBillBySunmi();
        break;
    }
  }
}
