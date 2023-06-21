import 'dart:io';

import 'package:dedepos/services/print_process.dart';
import 'package:image/image.dart' as im;
import 'dart:ui' as ui;
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrinterClass {
  String qrCode = "";
  double paperMaxWidth =
      (global.printerLocalStrongData.paperSize == 1) ? 378.0 : 575.0;

  List<PosPrintBillCommandModel> commandList = [];

  void addCommand(PosPrintBillCommandModel command) {
    commandList.add(command);
  }

  void printByIpImageMode() async {
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
        ..color = const ui.Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(
          ui.Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(), 20000.0),
          backgroundPaint);

      PrintProcess printProcess = PrintProcess();
      for (var command in commandList) {
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
                align: command.columns[index].align,
                fontSize: command.columns[index].fontSize,
              ));
            }
            ui.Image result = await printProcess
                .lineFeedImage(command.posStyles ?? const PosStyles());
            canvas.drawImage(result, ui.Offset(0, maxHeight), ui.Paint());
            maxHeight += result.height.toDouble();
            break;
          case 3: // Line
            canvas.drawLine(
                ui.Offset(0, maxHeight),
                ui.Offset(0 + global.printerWidthByPixel(), maxHeight),
                ui.Paint());
            maxHeight += 1;
            break;
          case 4: // Line Feed
            maxHeight += command.value;
            break;
        }
      }
      if (qrCode.isNotEmpty) {
        ui.Image result = await QrPainter(
          data: qrCode,
          version: QrVersions.auto,
          gapless: false,
        ).toImage(paperMaxWidth / 2);
        canvas.drawImage(
            result, ui.Offset(result.width / 2, maxHeight), ui.Paint());
        maxHeight += result.height.toDouble();
      }
      final picture = recorder.endRecording();
      final imageBuffer = picture.toImage(
          global.printerWidthByPixel().toInt(), maxHeight.toInt());
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
          sleep(const Duration(milliseconds: 100));
        } catch (e) {
          print(e);
        }
      }
      sleep(const Duration(milliseconds: 100));
      printer.cut();
      printer.disconnect();
    }
  }

  void sendToPrinter() {
    switch (global.printerCashierConnect) {
      case global.PrinterCashierConnectEnum.ip:
        printByIpImageMode();
        break;
      case global.PrinterCashierConnectEnum.bluetooth:
        break;
      case global.PrinterCashierConnectEnum.usb:
        // TODO: Handle this case.
        break;
      case global.PrinterCashierConnectEnum.windows:
        break;
      case global.PrinterCashierConnectEnum.sunmi1:
        break;
    }
  }
}
