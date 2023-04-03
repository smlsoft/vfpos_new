import 'dart:math';
import "dart:developer" as dev;
import 'package:dedepos/api/network/sync_model.dart';
import 'package:dedepos/bloc/pos_process_bloc.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/db/printer_helper.dart';
import 'package:dedepos/model/system/printer_model.dart';
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
  if (global.ipAddress.isNotEmpty) {
    var server =
        await HttpServer.bind(global.ipAddress, global.targetDeviceIpPort);
    dev.log(
        "Server running on IP : ${server.address} On Port : ${server.port}");
    await for (HttpRequest request in server) {
      if (global.loginSuccess || 1 == 1) {
        var contentType = request.headers.contentType;
        var response = request.response;
        if (request.method == 'GET') {
          String json = request.uri.query.split("json=")[1];
          HttpGetDataModel httpGetData = HttpGetDataModel.fromJson(
              jsonDecode(utf8.decode(base64Decode(json))));
          if (httpGetData.code == "selectByCategoryParentGuid") {
            HttpParameterModel jsonCategory =
                HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
            String parentGuid = jsonCategory.parentGuid;
            final box =
                global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
            final result = box
                .query(ProductCategoryObjectBoxStruct_.parent_guid_fixed
                    .equals(parentGuid))
                .order(ProductCategoryObjectBoxStruct_.xorder)
                .build()
                .find();
            response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
          } else if (httpGetData.code ==
              "selectByParentCategoryGuidOrderByXorder") {
            HttpParameterModel jsonCategory =
                HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
            String parentGuid = jsonCategory.parentGuid;
            final box =
                global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
            final result = (box.query(ProductCategoryObjectBoxStruct_
                    .parent_guid_fixed
                    .equals(parentGuid))
                  ..order(ProductCategoryObjectBoxStruct_.xorder))
                .build()
                .find();
            response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
          } else if (httpGetData.code == "selectByCategoryGuidFindFirst") {
            HttpParameterModel jsonCategory =
                HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
            String guid = jsonCategory.guid;
            final box =
                global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
            ProductCategoryObjectBoxStruct? result = box
                .query(ProductCategoryObjectBoxStruct_.guid_fixed.equals(guid))
                .build()
                .findFirst();
            response.write(jsonEncode(result?.toJson()));
          }
        } else if (request.method == 'POST') {
          if (request.uri.path == '/scan') {
            bool isTerminal =
                (global.appMode == global.AppModeEnum.posCashierTerminal);

            bool isClient = (global.appMode == global.AppModeEnum.posClient);
            SyncDeviceModel resultData = SyncDeviceModel(
                device: global.deviceName,
                ip: global.ipAddress,
                connected: true,
                isCashierTerminal: isTerminal,
                isClient: isClient);
            response.write(jsonEncode(resultData.toJson()));
          } else if (contentType?.mimeType == 'application/json') {
            try {
              var data = await utf8.decoder.bind(request).join();
              var jsonDecodeStr = jsonDecode(data);
              var httpPost = HttpPost.fromJson(jsonDecodeStr);
              switch (httpPost.command) {
                case "get_device_name":
                  // Return ชื่อเครื่อง server , ip server
                  response.write(jsonEncode(
                      jsonDecode('{"device": "${global.deviceName}"}') as Map));
                  break;
                case "register_client_device":
                  // ลงทะเบียนเครื่องช่วยขาย
                  SyncDeviceModel posClientDevice =
                      SyncDeviceModel.fromJson(jsonDecode(httpPost.data));
                  bool found = false;
                  for (var device in global.posClientDeviceList) {
                    if (device.device == posClientDevice.device) {
                      found = true;
                      break;
                    }
                  }
                  if (!found) {
                    global.posClientDeviceList.add(posClientDevice);
                    print("register_client_device : " +
                        posClientDevice.device +
                        " : " +
                        global.posClientDeviceList.length.toString());
                  }
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
                    print("register_customer_display_device : " +
                        customerDisplayDevice.device +
                        " : " +
                        global.customerDisplayDeviceList.length.toString());
                  }
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
                    global.posScreenRefresh = true;
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
