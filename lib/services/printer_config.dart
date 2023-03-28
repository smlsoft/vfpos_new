import 'dart:async';
import 'dart:io';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/util/network.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/bloc/pos_process_bloc.dart';
import 'package:dedepos/model/json/print_queue_struct.dart';
import 'package:dedepos/model/json/receive_money_struct.dart';
import 'package:dedepos/pos_screen/pos_screen.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

class PrinterConfigScreen extends StatefulWidget {
  const PrinterConfigScreen({Key? key}) : super(key: key);

  @override
  _PrinterConfigScreenState createState() => _PrinterConfigScreenState();
}

class _PrinterConfigScreenState extends State<PrinterConfigScreen> {
  List<Map<String, dynamic>> devices = [];
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;
  bool printBinder = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  TextEditingController ipAddressController = TextEditingController();
  TextEditingController portController = TextEditingController();
  int printerConnectType = global.appLocalStrongData.printerCashierConnectType;
  List<PrinterModel> thermalPrinterIpList = [];
  late Timer screenTimer;

  @override
  void initState() {
    ipAddressController.text = global.printerCashierIpAddress;
    portController.text = global.printerCashierIpPort.toString();
    getDeviceList();
    screenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    screenTimer.cancel();
    super.dispose();
  }

  void scanNetworkPrinter() async {
    CapabilityProfile profile = await CapabilityProfile.load();
    NetworkPrinter printer = NetworkPrinter(PaperSize.mm80, profile);
    String appIpAddress = await ipAddress();
    String subNet = appIpAddress.substring(0, appIpAddress.lastIndexOf('.'));
    for (int i = 1; i < 255; i++) {
      String ip = "$subNet.$i";
      printer.connect(ip, port: 9100).then((value) {
        if (value == PosPrintResult.success) {
          if (!thermalPrinterIpList.contains(ip)) {
            thermalPrinterIpList.add(PrinterModel(
              name: "",
              ipAddress: ip,
              ipPort: 9100,
              connectType: global.PrinterCashierConnectEnum.ip,
            ));
          }
          printer.disconnect();
        }
      });
    }
  }

  void getDeviceList() async {
    setState(() {
      printerConnectType = 0;
      thermalPrinterIpList.clear();
    });
    List<Map<String, dynamic>> results = [];
    results = await FlutterUsbPrinter.getUSBDeviceList();

    print(" length: ${results.length}");
    setState(() {
      devices = results;
    });
    scanNetworkPrinter();
  }

  void connect(int vendorId, int productId) async {
    bool? returned = false;
    try {
      returned = await flutterUsbPrinter.connect(vendorId, productId);
    } on PlatformException {
      //response = 'Failed to get platform version.';192
    }
    if (returned!) {
      setState(() {
        connected = true;
      });
    }
  }

  Future<void> printTest() async {
    try {
      var data = Uint8List.fromList(
          utf8.encode(" Hello world Testing ESC POS printer..."));
      await flutterUsbPrinter.write(data);
      // await FlutterUsbPrinter.printRawData("text");
      // await FlutterUsbPrinter.printText("Testing ESC POS printer...");
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
  }

  Future<void> printTestByIpAddress(
      {required String ipAddress, required int port}) async {
    PaperSize paper = PaperSize.mm80;
    CapabilityProfile profile = await CapabilityProfile.load();
    NetworkPrinter printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(ipAddress, port: port);
      if (res == PosPrintResult.success) {
        printer.printCodeTable();
        printer.feed(3);
        printer.emptyLines(0);
        printer.text("--------------------------------------");
        printer.text("Hello world");
        printer.text("Testing ESC POS printer...");
        printer.text("--------------------------------------");
        printer.text("Font size: 100%",
            styles:
                PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
        printer.text("Font size: 200%",
            styles:
                PosStyles(height: PosTextSize.size2, width: PosTextSize.size2));
        printer.text("Font size: 400%",
            styles:
                PosStyles(height: PosTextSize.size3, width: PosTextSize.size3));
        printer.text("--------------------------------------");
        printer.feed(1);
        printer.qrcode("www.dedepos.com", size: QRSize.Size8);
        printer.feed(1);
        printer.barcode(Barcode.upcA([1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4]));
        printer.feed(3);
        printer.cut();
        printer.drawer();
        printer.disconnect();
      }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> buildList(List<Map<String, dynamic>> devices) {
    return devices
        .map((device) => ListTile(
              onTap: () {
                connect(int.parse(device['vendorId']),
                    int.parse(device['productId']));
              },
              leading: const Icon(Icons.usb),
              title: Text(device['manufacturer'] + " " + device['productName']),
              subtitle: Text(device['vendorId'] + " " + device['productId']),
            ))
        .toList();
  }

  Widget printerListWidget() {
    return Container(
        padding: const EdgeInsets.all(2),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: (thermalPrinterIpList.isEmpty)
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 100,
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  String connectName = "";
                  if (thermalPrinterIpList[index].connectType ==
                      global.PrinterCashierConnectEnum.ip) {
                    connectName = "IP Printer";
                  }
                  return Padding(
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ipAddressController.text =
                                  thermalPrinterIpList[index].ipAddress;
                              portController.text = "9100";
                              switch (thermalPrinterIpList[index].connectType) {
                                case global.PrinterCashierConnectEnum.usb:
                                  printerConnectType = 1;
                                  break;
                                case global.PrinterCashierConnectEnum.ip:
                                  printerConnectType = 2;
                                  break;
                                case global.PrinterCashierConnectEnum.bluetooth:
                                  printerConnectType = 3;
                                  break;
                                case global.PrinterCashierConnectEnum.serial:
                                  printerConnectType = 4;
                                  break;
                              }
                            });
                          },
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.print),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      "$connectName : ${thermalPrinterIpList[index].ipAddress}"),
                                ],
                              ))));
                },
                itemCount: thermalPrinterIpList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ));
  }

  Widget printerConnect() {
    Widget displayWidget = Container();
    if (printerConnectType == 2) {
      // IP Printer
      displayWidget = Column(
        children: [
          TextField(
            controller: ipAddressController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: global.language("printer_ip_address"),
                hintText: "xxx.xxx.xxx.xxx"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: portController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: global.language("printer_ip_port"),
                hintText: "xxxx"),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                printTestByIpAddress(
                    ipAddress: ipAddressController.text,
                    port: int.tryParse(portController.text) ?? 0);
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(global.language("printer_connect_test")),
                          content: Text(
                              global.language("printer_connect_test_success")),
                          actions: [
                            TextButton(
                              child: Text(global.language("success")),
                              onPressed: () async {
                                var data = LocalStrongDataModel(
                                  printerCashierConnectType: printerConnectType,
                                  printerCashierType: 0,
                                  printerCashierIpAddress:
                                      ipAddressController.text,
                                  printerCashierIpPort:
                                      int.tryParse(portController.text) ?? 0,
                                );
                                global.appLocalStore
                                    .collection("dedepos")
                                    .doc("device")
                                    .set(data.toJson())
                                    .then((value) {
                                  global.loadConfig();
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            TextButton(
                              child: Text(global.language("fail")),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ));
              },
              child: AutoSizeText(
                global.language("printer_connect_test_and_save"),
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
              ))
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Column(
        children: [
          printerListWidget(),
          const SizedBox(
            height: 15,
          ),
          displayWidget,
          const SizedBox(
            height: 10,
          ),
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
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => getDeviceList()),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: printerConnect(),
        ));
  }
}
