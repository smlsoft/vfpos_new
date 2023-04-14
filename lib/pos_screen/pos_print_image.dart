import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:collection/collection.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:promptpay/promptpay.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

import 'dart:async';
import 'dart:ui' as ui;

Future<void> printBillImage(String docNo) async {
  PaperSize paper = PaperSize.mm80;
  CapabilityProfile profile = await CapabilityProfile.load();
  NetworkPrinter printer = NetworkPrinter(paper, profile);
  PosPrintResult res = await printer.connect(global.printerCashierIpAddress,
      port: global.printerCashierIpPort);

  if (res == PosPrintResult.success) {
    int maxHeight = 0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final backgoundpaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        const Rect.fromLTWH(0.0, 0.0, 640.0, 10000.0), backgoundpaint);

    ByteData data = await rootBundle.load('assets/images/logo.jpg');
    ui.Image logo = await decodeImageFromList(data.buffer.asUint8List());
    for (int index = 0; index < 100; index++) {
      canvas.drawImage(logo, Offset(0, maxHeight.toDouble()), Paint());
      maxHeight += logo.height;
    }

    final stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    var xx = canvas.drawRect(
        Rect.fromLTWH(0.0, maxHeight.toDouble(), 100.0, 100.0), stroke);

    maxHeight += 100;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        const Offset(
          100.0,
          100.0,
        ),
        20.0,
        paint);
    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.blue[800]),
        text: "สวัสดีประัเทศทไย");
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(5.0, 5.0));
    final picture = recorder.endRecording();
    final img = picture.toImage(640, maxHeight);
    final pngBytes = await img
        .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
    File file = File('test.jpg');
    file.writeAsBytesSync(pngBytes!.buffer.asUint8List());

    ByteData xdata = file.readAsBytesSync().buffer.asByteData();
    Uint8List bytes = xdata.buffer.asUint8List();
    im.Image? ximage = im.decodeImage(bytes);
    printer.image(ximage!);
    printer.cut();
    printer.disconnect();
  }
}
