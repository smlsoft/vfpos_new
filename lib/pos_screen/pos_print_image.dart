import 'dart:io';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:dedepos/global.dart' as global;
import 'dart:async';
import 'dart:ui' as ui;

Future<void> printBillImage(String docNo) async {
  PaperSize paper = PaperSize.mm80;
  CapabilityProfile profile = await CapabilityProfile.load();
  NetworkPrinter printer = NetworkPrinter(paper, profile);
  PosPrintResult res = await printer.connect(global.printerCashierIpAddress,
      port: global.printerCashierIpPort);
  if (res == PosPrintResult.success) {
    double maxHeight = 0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final backgoundpaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        const Rect.fromLTWH(0.0, 0.0, 640.0, 10000.0), backgoundpaint);

    for (int loop = 0; loop < 10; loop++) {
      ByteData data = await rootBundle.load('assets/images/logo.jpg');
      ui.Image logo = await decodeImageFromList(data.buffer.asUint8List());
      canvas.drawImage(logo, Offset(0, maxHeight.toDouble()), Paint());

      final stroke = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke;

      var xx = canvas.drawRect(
          Rect.fromLTWH(0.0, maxHeight.toDouble(), 100.0, 100.0), stroke);

      final paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          Offset(
            100.0,
            maxHeight + 100.0,
          ),
          20.0,
          paint);
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 24),
          text: "$loop สวัสดีประศทไย");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(5.0, maxHeight.toDouble()));

      maxHeight += logo.height;
    }
    final picture = recorder.endRecording();
    final img = picture.toImage(640, maxHeight.toInt());
    final pngBytes = await img
        .then((value) => value.toByteData(format: ui.ImageByteFormat.png));
    //File file = File('test.jpg');
    //file.writeAsBytesSync(pngBytes!.buffer.asUint8List());

    //ByteData xdata = file.readAsBytesSync().buffer.asByteData();
    //Uint8List bytes = xdata.buffer.asUint8List();
    im.Image? ximage = im.decodeImage(pngBytes!.buffer.asUint8List());
    // crop image with height
    int printMaxHeight = 200;
    int calcLoop = ximage!.height ~/ printMaxHeight;
    for (int i = 0; i <= calcLoop; i++) {
      try {
        var xximage = im.copyCrop(
            ximage, 0, i * printMaxHeight, ximage.width, printMaxHeight);
        printer.imageRaster(xximage);
        sleep(const Duration(milliseconds: 1000));
      } catch (e) {
        print(e);
      }
    }
    printer.feed(1);
    printer.cut();
    printer.disconnect();
  }
}
