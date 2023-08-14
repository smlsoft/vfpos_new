import 'dart:io';
import 'package:dedepos/api/clickhouse/clickhouse_api.dart';
import 'package:dedepos/db/shift_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/form_design_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:image/image.dart' as im;
import 'dart:ui' as ui;
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrinterClass {
  int printerIndex;
  String qrCode;

  PrinterClass({
    required this.printerIndex,
    required this.qrCode,
  });

  double paperMaxWidth() {
    return (global.printerLocalStrongData[printerIndex].paperType == 1) ? 378.0 : 575.0;
  }

  List<PosPrintBillCommandModel> commandList = [];

  void addCommand(PosPrintBillCommandModel command) {
    commandList.add(command);
  }

  void printByIpImageMode() async {
    PaperSize paper = (global.printerLocalStrongData[printerIndex].paperType == 1) ? PaperSize.mm58 : PaperSize.mm80;
    CapabilityProfile profile = await CapabilityProfile.load();
    NetworkPrinter printer = NetworkPrinter(paper, profile);
    String ipAddress = global.printerLocalStrongData[printerIndex].ipAddress;
    int ipPort = global.printerLocalStrongData[printerIndex].ipPort;
    PosPrintResult res = await printer.connect(ipAddress, port: ipPort);

    if (res == PosPrintResult.success) {
      double maxHeight = 0;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final backgroundPaint = ui.Paint()
        ..color = const ui.Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(ui.Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(printerIndex), 20000.0), backgroundPaint);

      PrintProcess printProcess = PrintProcess(printerIndex: printerIndex);
      for (var command in commandList) {
        // 0=Reset,1=Logo Image,2=Text,3=Line,9=Cut
        switch (command.mode) {
          case 0: // Reset
            break;
          case 1: // Logo Image
            ui.Image result = await printProcess.lineFeedImage(command.posStyles ?? const PosStyles());
            canvas.drawImage(result, ui.Offset(0, maxHeight), ui.Paint());
            break;
          case 2: // Text
            printProcess.columnWidth.clear();
            printProcess.column.clear();
            for (int index = 0; index < command.columns.length; index++) {
              printProcess.columnWidth.add(command.columns[index].width);
              printProcess.column.add(PrintColumn(
                text: command.columns[index].text,
                align: command.columns[index].text_align,
                fontSize: command.columns[index].font_size,
              ));
            }
            ui.Image result = await printProcess.lineFeedImage(command.posStyles ?? const PosStyles());
            canvas.drawImage(result, ui.Offset(0, maxHeight), ui.Paint());
            maxHeight += result.height.toDouble();
            break;
          case 3: // Line
            canvas.drawLine(ui.Offset(0, maxHeight), ui.Offset(0 + global.printerWidthByPixel(printerIndex), maxHeight), ui.Paint());
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
        ).toImage(paperMaxWidth() / 2);
        canvas.drawImage(result, ui.Offset(result.width / 2, maxHeight), ui.Paint());
        maxHeight += result.height.toDouble() + 100;
      }
      final picture = recorder.endRecording();
      final imageBuffer = picture.toImage(global.printerWidthByPixel(printerIndex).toInt(), maxHeight.toInt());
      final pngBytes = await imageBuffer.then((value) => value.toByteData(format: ui.ImageByteFormat.png));
      im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
      int printMaxHeight = 200;
      int calcLoop = imageDecode!.height ~/ printMaxHeight;
      for (int i = 0; i <= calcLoop; i++) {
        try {
          im.Image croppedImage = im.copyCrop(imageDecode, 0, i * printMaxHeight, imageDecode.width, printMaxHeight);
          printer.imageRaster(croppedImage);
          sleep(const Duration(milliseconds: 100));
        } catch (e) {
          print(e);
        }
      }
      sleep(const Duration(milliseconds: 100));
      printer.cut();
      printer.disconnect();
      sleep(const Duration(milliseconds: 100));
      print(qrCode);
    }
  }

  void printByBluetoothImageMode() async {
    String macAddress = global.printerLocalStrongData[printerIndex].ipAddress;
    await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
    bool connectStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectStatus) {
      final profile = await CapabilityProfile.load();
      final generator = Generator((global.printerLocalStrongData[0].paperType == 1) ? PaperSize.mm58 : PaperSize.mm80, profile);
      List<int> bytes = [];

      double maxHeight = 0;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final backgroundPaint = ui.Paint()
        ..color = const ui.Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.fill;

      canvas.drawRect(ui.Rect.fromLTWH(0.0, 0.0, global.printerWidthByPixel(0), 20000.0), backgroundPaint);

      PrintProcess printProcess = PrintProcess(printerIndex: printerIndex);
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
                align: command.columns[index].text_align,
                fontSize: command.columns[index].font_size,
              ));
            }
            ui.Image result = await printProcess.lineFeedImage(command.posStyles ?? const PosStyles());
            canvas.drawImage(result, ui.Offset(0, maxHeight), ui.Paint());
            maxHeight += result.height.toDouble();
            break;
          case 3: // Line
            canvas.drawLine(ui.Offset(0, maxHeight), ui.Offset(0 + global.printerWidthByPixel(printerIndex), maxHeight), ui.Paint());
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
        ).toImage(paperMaxWidth() / 2);
        canvas.drawImage(result, ui.Offset(result.width / 2, maxHeight), ui.Paint());
        maxHeight += result.height.toDouble() + 100;
      }
      final picture = recorder.endRecording();
      final imageBuffer = picture.toImage(global.printerWidthByPixel(printerIndex).toInt(), maxHeight.toInt());
      final pngBytes = await imageBuffer.then((value) => value.toByteData(format: ui.ImageByteFormat.png));
      im.Image? imageDecode = im.decodeImage(pngBytes!.buffer.asUint8List());
      int printMaxHeight = 200;
      int calcLoop = imageDecode!.height ~/ printMaxHeight;
      for (int i = 0; i <= calcLoop; i++) {
        try {
          im.Image croppedImage = im.copyCrop(imageDecode, 0, i * printMaxHeight, imageDecode.width, printMaxHeight);
          bytes += generator.imageRaster(croppedImage);
        } catch (e) {
          print(e);
        }
      }
      bytes += generator.cut();
      bytes += generator.drawer();
      await PrintBluetoothThermal.writeBytes(bytes);
    }
  }

  void sendToPrinter() {
    switch (global.printerLocalStrongData[printerIndex].printerConnectType) {
      case global.PrinterConnectEnum.ip:
        printByIpImageMode();
        break;
      case global.PrinterConnectEnum.bluetooth:
        printByBluetoothImageMode();
        break;
      case global.PrinterConnectEnum.usb:
        // TODO: Handle this case.
        break;
      case global.PrinterConnectEnum.windows:
        break;
      case global.PrinterConnectEnum.sunmi1:
        break;
    }
  }
}

Future<void> printTableQrCode({required global.TableManagerEnum tableManagerMode, required TableProcessObjectBoxStruct table, bool fullDetail = true, String qrCode = "", String fromTable = "", String toTable = ""}) async {
  // printerIndex 1 = Ticket Printer
  PrinterClass printer = PrinterClass(printerIndex: 1, qrCode: qrCode);
  print(printer.qrCode);
  // Reset Printer
  printer.addCommand(PosPrintBillCommandModel(mode: 0));
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 40, width: 1, text: global.profileSetting.company.names[0].name, text_align: PrintColumnAlign.center)
  ]));
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 24, width: 1, text: "Printing time : ${DateFormat("dd/MM/yyyy - HH:mm").format(DateTime.now())}", text_align: PrintColumnAlign.center)
  ]));
  String tableTitle = "";
  switch (tableManagerMode) {
    case global.TableManagerEnum.openTable:
      tableTitle = "เปิดโต๊ะ : ${table.number}";
      break;
    case global.TableManagerEnum.closeTable:
      tableTitle = "ปิดโต๊ะ : ${table.number}";
      break;
    case global.TableManagerEnum.moveTable:
      tableTitle += "ย้ายโต๊ะ จาก $fromTable ไปยัง : $toTable";
      break;
    case global.TableManagerEnum.mergeTable:
      break;
    case global.TableManagerEnum.informationTable:
      break;
    case global.TableManagerEnum.splitTable:
      break;
  }
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 40, width: 1, text: tableTitle, text_align: PrintColumnAlign.center)
  ]));

  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 30, width: 1, text: "เวลาเปิดโต๊ะ : ${DateFormat("HH:mm").format(table.table_open_datetime)}", text_align: PrintColumnAlign.center)
  ]));
  if (table.table_al_la_crate_mode == false) {
    printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
      FormDesignColumnModel(font_size: 30, width: 1, text: "จำนวนนาที : ${global.moneyFormat.format(global.buffetMaxMinute)} นาที", text_align: PrintColumnAlign.center)
    ]));
    String endTime = DateFormat("HH:mm").format(table.table_open_datetime.add(Duration(minutes: global.buffetMaxMinute)));
    printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
      FormDesignColumnModel(font_size: 30, width: 1, text: "เวลาปิดโต๊ะ : $endTime", text_align: PrintColumnAlign.center)
    ]));
  }
  if (fullDetail) {
    String countPeople = "";
    int sumPeople = table.man_count + table.woman_count;
    if (sumPeople > 1) {
      countPeople = "ผู้ใหญ่ $sumPeople คน";
    }
    if (table.child_count > 0) {
      if (countPeople.isNotEmpty) {
        countPeople += " : ";
      }
      countPeople += "เด็ก ${table.child_count} คน";
    }
    if (countPeople.isNotEmpty) {
      printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
        FormDesignColumnModel(font_size: 30, width: 1, text: "$countPeople", text_align: PrintColumnAlign.center)
      ]));
    }
  }
  String orderType = "";
  if (table.table_al_la_crate_mode) {
    orderType = "อาราคัส";
  } else {
    int buffetIndex = global.buffetModeLists.indexWhere((element) => element.code == table.buffet_code);
    if (buffetIndex != -1) {
      orderType = global.buffetModeLists[buffetIndex].names[0];
    }
  }
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 30, width: 1, text: "เงื่อนไข : $orderType", text_align: PrintColumnAlign.center)
  ]));
  printer.addCommand(PosPrintBillCommandModel(
    mode: 4,
    value: 80,
  ));
  printer.sendToPrinter();
  {
    // update clickhouse โต๊ะ
    String query = "select tablenumber from dedeorder.tableinfo where tablenumber='${table.number}' and shopid='${global.shopId}'";
    var value = await clickHouseSelect(query);
    ResponseDataModel responseData = ResponseDataModel.fromJson(value);
    if (responseData.data.isNotEmpty) {
      // ถ้ามีโต๊ะแล้ว ให้ update qr code
      query = "alter table dedeorder.tableinfo update qrcode='${printer.qrCode}',tablestatus=1 where tablenumber='${table.number}' and shopid='${global.shopId}'";
      clickHouseUpdate(query);
    }
  }
}

void shiftAndMoneyPrint(String guid) {
  var data = ShiftHelper().getByGuid(guid);
  PrinterClass printer = PrinterClass(printerIndex: 1, qrCode: "");
  print(printer.qrCode);
  // Reset Printer
  printer.addCommand(PosPrintBillCommandModel(mode: 0));
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 40, width: 1, text: global.profileSetting.company.names[0].name, text_align: PrintColumnAlign.center)
  ]));
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 24, width: 1, text: "Printing time : ${DateFormat("dd/MM/yyyy - HH:mm").format(DateTime.now())}", text_align: PrintColumnAlign.center)
  ]));
  String tableTitle = "";
  switch (data.doctype) {
    case 1:
      tableTitle = "เปิดกะ/รับเงินทอน";
      break;
    case 2:
      tableTitle = "ปิดกะ/รับเงิน";
      break;
    case 3:
      tableTitle = "รับเงินทอนเพิ่ม";
      break;
    case 4:
      tableTitle = "นำเงินออก";
      break;
  }
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 40, width: 1, text: tableTitle, text_align: PrintColumnAlign.center)
  ]));

  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: false), columns: [
    FormDesignColumnModel(font_size: 32, width: 1, text: "วันเวลา : ${DateFormat("HH:mm").format(data.docdate)}", text_align: PrintColumnAlign.center)
  ]));
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: false), columns: [
    FormDesignColumnModel(font_size: 32, width: 1, text: "พนักงาน : ${data.username} (${data.usercode})", text_align: PrintColumnAlign.center)
  ]));
  if (data.remark.isNotEmpty) {
    printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: false), columns: [
      FormDesignColumnModel(font_size: 32, width: 1, text: "หมายเหตุ : ${data.remark}", text_align: PrintColumnAlign.center)
    ]));
  }
  printer.addCommand(PosPrintBillCommandModel(mode: 2, posStyles: const PosStyles(bold: true), columns: [
    FormDesignColumnModel(font_size: 32, width: 1, text: "จำนวนเงิน ${global.moneyFormat.format(data.amount)} บาท", text_align: PrintColumnAlign.center)
  ]));
  printer.addCommand(PosPrintBillCommandModel(
    mode: 4,
    value: 80,
  ));
  printer.sendToPrinter();
}
