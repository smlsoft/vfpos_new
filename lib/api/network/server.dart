import 'dart:math';
import "dart:developer" as dev;
import 'package:dedepos/api/network/sync_model.dart';
import 'package:dedepos/bloc/pos_process_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/db/printer_helper.dart';
import 'package:dedepos/model/json/printer_struct.dart';
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:dedepos/util/network.dart' as network;

class HttpPost {
  late String command;
  late String data;

  HttpPost({required this.command, this.data = ""});

  Map toJson() => {
        'command': command,
        'data': data,
      };

  factory HttpPost.fromJson(Map<String, dynamic> json) {
    return HttpPost(
      command: json['command'],
      data: json['data'],
    );
  }
}

Future<void> startServer() async {
  List<PrinterObjectBoxStruct> printers = (PrinterHelper()).selectAll();
  global.printerList.clear();
  for (var printer in printers) {
    PrinterStruct newPrinter = PrinterStruct(
        guidfixed: printer.guid_fixed,
        printer_ip_address: printer.print_ip_address,
        printer_port: printer.printer_port,
        code: printer.code,
        name: printer.name1,
        printer_type: printer.type);
    global.printerList.add(newPrinter);
  }
  if (global.ipAddress.isNotEmpty) {
    var server = await HttpServer.bind(global.ipAddress, global.serverPort);
    dev.log(
        "Server running on IP : ${server.address} On Port : ${server.port}");
    await for (HttpRequest request in server) {
      if (global.loginSuccess) {
        var contentType = request.headers.contentType;
        var response = request.response;

        if (request.method == 'POST' && request.uri.path == '/scan') {
          SyncDeviceModel resultData = SyncDeviceModel(
              device: global.deviceName, ip: global.serverIp, connected: true);
          response.write(jsonEncode(resultData.toJson()));
        } else if (request.method == 'POST' &&
            contentType?.mimeType == 'application/json') {
          try {
            var data = await utf8.decoder.bind(request).join();
            var jsonDecodeStr = jsonDecode(data);
            var httpPost = HttpPost.fromJson(jsonDecodeStr);
            switch (httpPost.command) {
              case "get_device_name":
                // Return ชื่อเครื่อง server , ip server
                var result =
                    jsonDecode('{"device": "${global.deviceName}"}') as Map;
                response.write(jsonEncode(result));
                break;
              case "register_customer_display_device":
                // ลงทะเบียนเครื่องแสดงผลลูกค้า
                SyncDeviceModel customerDisplayDevice =
                    SyncDeviceModel.fromJson(jsonDecode(httpPost.data));
                bool found = false;
                for (var device in global.customerDisplayDeviceList) {
                  if (device.device == customerDisplayDevice.device) {
                    found = true;
                    break;
                  }
                }
                if (!found) {
                  global.customerDisplayDeviceList.add(customerDisplayDevice);
                }
                print("register_customer_display_device : " +
                    global.customerDisplayDeviceList.length.toString());
                break;
              case "change_customer_by_phone":
                // รับข้อมูลหมายเลขโทรศัพท์ แล้วมาค้นหาชื่อ และประมวลผล
                SyncCustomerModel postCustomer =
                    SyncCustomerModel.fromJson(jsonDecode(httpPost.data));
                String customerCode = postCustomer.phone;
                String customerName = "";
                String customerPhone = postCustomer.phone;
                SyncCustomerModel result = SyncCustomerModel(
                    code: customerCode,
                    phone: customerPhone,
                    name: customerName);
                response.write(jsonEncode(result.toJson()));
                try {
                  global.customerCode = customerCode;
                  global.customerName = customerName;
                  global.customerPhone = customerPhone;
                  // ประมวลผลหน้าจอขายใหม่
                  BlocProvider.of<PosProcessBloc>(global.globalContext)
                      .add(ProcessEvent());
                } catch (e) {
                  print(e);
                }
                break;
              /*case "get_table_group":
              List<TableGroupStruct> _groupList =
                  await global.tableGroupHelper.select(order: "idx");
              var _data = jsonEncode(_groupList.map((i) => i.toJson()).toList())
                  .toString();
              _res..write(_data);
              break;
            case "get_table_and_sum":
              List<TableStruct> _groupList = await global.tableHelper
                  .selectAndSumOrderAmount(where: httpPost.where);
              var _data = jsonEncode(_groupList.map((i) => i.toJson()).toList())
                  .toString();
              _res..write(_data);
              break;
            case "update_table":
              TableStruct _data =
                  TableStruct.fromJson(jsonDecode(httpPost.value));
              bool _result = await global.tableHelper.update(_data);
              _res..write(_result);
              break;
            case "insert_table_log":
              TableLogStruct _data =
                  TableLogStruct.fromJson(jsonDecode(httpPost.value));
              int _result = await global.tableLogHelper.insert(_data);
              _res..write(_result);
              break;*/
              /*case "insert_print_queue":
              PrintQueueStruct _data =
                  PrintQueueStruct.fromJson(jsonDecode(httpPost.value));
              int _result = await global.printQueueHelper.insert(_data);
              _res..write(_result);
              break;*/
              /*case "insert_order":
              OrderSummeryStruct _data =
                  OrderSummeryStruct.fromJson(jsonDecode(httpPost.value));
              String _result = await global.orderHelper.saveOrder(_data);
              _res..write(_result);
              break;*/
              /*case "print_queue":
              global.printQueueStart();
              break;*/
              /*case "select":
              List<List<Map>> _result = [];
              for (var _query in httpPost.query) {
                _result.add(await global.clientDb!.rawQuery(_query));
              }
              _res..write(jsonEncode(_result));
              break;*/
            }
          } catch (e) {
            stderr.writeln(e.toString());
          }
        }
        await response.flush();
        await response.close();
      }
    }
  }
}

/*Future<String> getDeviceName(String ip) async {
  var _url = "http://" + ip + ":" + global.serverDevicePort.toString();
  var _uri = Uri.parse(_url);
  try {
    http.Response _response = await http
        .post(_uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'command': 'device', 'wifi_ip': ''}))
        .timeout(const Duration(seconds: 2));
    if (_response.statusCode == 200) {
      var _fromJson = jsonDecode(_response.body.toString());
      return _fromJson["device"];
      ;
    } else {}
  } catch (e) {
    print('failed');
  }
  return "";
}*/

Future<void> sendProcessToCustomerDisplay() async {
  for (int index = 0;
      index < global.customerDisplayDeviceList.length;
      index++) {
    var url = "http://${global.customerDisplayDeviceList[index].ip}:5041";
    var jsonData = HttpPost(
        command: "process", data: jsonEncode(global.posProcessResult.toJson()));
    dev.log("sendProcessToCustomerDisplay : " + url);
    global.sendToServer(url, jsonEncode(jsonData.toJson())).then((value) {
      if (value == "fail") {
        global.customerDisplayDeviceList.removeAt(index);
      }
    });
  }
}

void testPrinterConnect() async {
  /*stderr.writeln('Test Printer Connect Start');
  if (global.isServer) {
    for (var printer in global.printerList) {
      try {
        final Socket socket = await Socket.connect(
            printer.printer_ip_address, printer.printer_port,
            timeout: const Duration(seconds: 5));
        printer.is_ready = true;
        socket.destroy();
      } catch (e) {
        stderr.writeln(e.toString());
        printer.is_ready = false;
        global.errorMessage.add(
            "${global.language("printer")} : ${printer.name}/${printer.printer_ip_address}:${printer.printer_port} ${global.language("not_ready")} $e");
      }
    }
  }
  stderr.writeln('Test Printer Connect Stop');*/
}