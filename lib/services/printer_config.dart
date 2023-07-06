import 'package:auto_route/auto_route.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
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
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                padding: const EdgeInsets.all(4),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: context.width ~/ 150),
                  itemCount: global.printerLocalStrongData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                            child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: Column(
                                  children: [
                                    Text(global
                                        .printerLocalStrongData[index].name),
                                    if (global.printerLocalStrongData[index]
                                        .ipAddress.isNotEmpty)
                                      Text(
                                          "${global.printerLocalStrongData[index].ipAddress}:${global.printerLocalStrongData[index].ipPort}"),
                                    if (global.printerLocalStrongData[index]
                                        .deviceId.isNotEmpty)
                                      Text(global.printerLocalStrongData[index]
                                          .deviceId),
                                    if (global.printerLocalStrongData[index]
                                        .deviceName.isNotEmpty)
                                      Text(global.printerLocalStrongData[index]
                                          .deviceName),
                                    if (global.printerLocalStrongData[index]
                                        .manufacturer.isNotEmpty)
                                      Text(global.printerLocalStrongData[index]
                                          .manufacturer)
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: global
                                          .printerLocalStrongData[index]
                                          .isConfigConnectSuccess
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                onPressed: () async {
                                  if (global.printerLocalStrongData[index]
                                      .isConfigConnectSuccess) {
                                    // ลบข้อมูลเครื่องพิมพ์
                                    global.appStorage.remove(global
                                        .printerLocalStrongData[index].code);
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
                                                      .printerLocalStrongData[
                                                          index]
                                                      .code,
                                                  printerName: global
                                                      .printerLocalStrongData[
                                                          index]
                                                      .name))).then(
                                      (value) async {
                                    setState(() {});
                                  });
                                },
                                child: (global.printerLocalStrongData[index]
                                        .isConfigConnectSuccess)
                                    ? Text("Remove")
                                    : Text("Connect")))
                      ],
                    );
                  },
                ),
              );
            },
          ),
        )));
  }
}
