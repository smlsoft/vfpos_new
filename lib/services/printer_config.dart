import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/services/printer_config_select_form.dart';
import 'package:dedepos/services/printer_config_select_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

@RoutePage()
class PrinterConfigScreen extends StatefulWidget {
  const PrinterConfigScreen({Key? key}) : super(key: key);

  @override
  State<PrinterConfigScreen> createState() => _PrinterConfigScreenState();
}

class _PrinterConfigScreenState extends State<PrinterConfigScreen> {
  Widget printer(int index) {
    return Container(
      width: 175,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Column(
        children: [
          Text(
            global.printerLocalStrongData[index].name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: global.printerLocalStrongData[index]
                            .isConfigConnectSuccess
                        ? Colors.green
                        : Colors.red,
                  ),
                  onPressed: () async {
                    if (global
                        .printerLocalStrongData[index].isConfigConnectSuccess) {
                      // ยกเลิกข้อมูลเครื่องพิมพ์
                      global.printerLocalStrongData[index]
                          .isConfigConnectSuccess = false;
                      await global.appStorage
                          .remove(global.printerLocalStrongData[index].code);
                      var jsonString = const JsonEncoder().convert(
                          global.printerLocalStrongData[index].toJson());
                      await global.appStorage.write(
                          global.printerLocalStrongData[index].code,
                          jsonString);
                      await global.loadPrinter();
                      setState(() {});
                      return;
                    }
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PrinterConfigSelectPrinterScreen(
                                    printerCode: global
                                        .printerLocalStrongData[index].code,
                                    printerName: global
                                        .printerLocalStrongData[index]
                                        .name))).then((value) async {
                      await global.loadPrinter();
                      setState(() {});
                    });
                  },
                  child: (global
                          .printerLocalStrongData[index].isConfigConnectSuccess)
                      ? Text(global.language("printer_remove"))
                      : Text(global.language("printer_connect")))),
          const SizedBox(
            height: 5,
          ),
          if (index == 0)
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrinterConfigSelectFormPage(
                                  printer: global
                                      .printerLocalStrongData[index]))).then(
                          (value) async {
                        await global.loadPrinter();
                        setState(() {});
                      });
                    },
                    child: Text(global.language('printer_select_form')))),
          const SizedBox(
            height: 10,
          ),
          if (global.printerLocalStrongData[index].isConfigConnectSuccess)
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    if (global
                        .printerLocalStrongData[index].ipAddress.isNotEmpty)
                      Text(
                          "${global.printerLocalStrongData[index].ipAddress}:${global.printerLocalStrongData[index].ipPort}"),
                    if (global
                        .printerLocalStrongData[index].deviceId.isNotEmpty)
                      Text(global.printerLocalStrongData[index].deviceId),
                    if (global
                        .printerLocalStrongData[index].deviceName.isNotEmpty)
                      Text(global.printerLocalStrongData[index].deviceName),
                    if (global
                        .printerLocalStrongData[index].manufacturer.isNotEmpty)
                      Text(global.printerLocalStrongData[index].manufacturer)
                  ],
                ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(global.language('printer_config')),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int index = 0;
                        index < global.printerLocalStrongData.length;
                        index++)
                      printer(index)
                  ],
                ))));
  }
}
