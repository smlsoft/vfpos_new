import "dart:developer" as dev;
import 'package:dedepos/api/network/sync_model.dart';
import 'package:dedepos/core/core.dart';
import 'package:dedepos/db/pos_log_helper.dart';
import 'package:dedepos/db/product_barcode_status_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/product_option_model.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/kitchen_struct.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_status_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/model/objectbox/staff_client_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_process.dart';
import 'package:dedepos/util/pos_compile_process.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/util/network.dart' as network;
import 'package:dedepos/util/printer.dart' as printer;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

double orderCalcSumAmount(OrderTempObjectBoxStruct order) {
  double amount = order.qty * order.price;
  if (order.optionSelected.isNotEmpty) {
    List<OrderProductOptionModel> options = jsonDecode(order.optionSelected)
        .map<OrderProductOptionModel>(
            (e) => OrderProductOptionModel.fromJson(e))
        .toList();
    for (var option in options) {
      for (var choice in option.choices) {
        if (choice.selected) {
          amount += order.qty * choice.priceValue;
        }
      }
    }
  }
  return amount;
}

Future<void> startServer() async {
  global.ipAddress = await network.ipAddress();
  if (global.ipAddress.isNotEmpty) {
    network.connectivity();
    global.targetDeviceIpAddress = global.ipAddress;
    var server =
        await HttpServer.bind(global.ipAddress, global.targetDeviceIpPort);
    dev.log(
        "Server running on IP : ${server.address} On Port : ${server.port}");
    await for (HttpRequest request in server) {
      try {
        if (global.loginSuccess) {
          var contentType = request.headers.contentType;
          var response = request.response;
          if (request.method == 'GET') {
            if (request.uri.path == '/scan') {
              bool isTerminal =
                  (global.appMode == global.AppModeEnum.posTerminal);
              bool isClient = (global.appMode == global.AppModeEnum.posRemote);
              SyncDeviceModel resultData = SyncDeviceModel(
                  deviceId: global.deviceId,
                  deviceName: global.deviceName,
                  ip: global.ipAddress,
                  connected: true,
                  isCashierTerminal: isTerminal,
                  holdCodeActive: "",
                  docModeActive: 0,
                  isClient: isClient);
              response.write(jsonEncode(resultData.toJson()));
            } else {
              String json = request.uri.query.split("json=")[1];
              HttpGetDataModel httpGetData = HttpGetDataModel.fromJson(
                  jsonDecode(utf8.decode(base64Decode(json))));
              switch (httpGetData.code) {
                case "get_connect":
                  response.write("connected");
                  break;
                case "staff.get_product_barcode_status":
                  response
                      .write(jsonEncode(ProductBarcodeStatusHelper().getAll()));
                  break;
                case "kds.order_temp_get_data_from_kitchen":
                  var jsonData = jsonDecode(httpGetData.json);
                  String kitchenId = jsonData["kitchenId"];
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  int duration = DateTime.now()
                      .subtract(const Duration(minutes: 5))
                      .millisecondsSinceEpoch;
                  final result = box
                      .query(OrderTempObjectBoxStruct_.kdsId
                          .equals(kitchenId)
                          .and(OrderTempObjectBoxStruct_.isOrder.equals(false))
                          .and((OrderTempObjectBoxStruct_.isOrderSendKdsSuccess
                              .equals(true)))
                          .and((OrderTempObjectBoxStruct_.kdsSuccess
                                  .equals(false))
                              .or(OrderTempObjectBoxStruct_.kdsSuccessTime
                                  .greaterThan(duration))))
                      .order(OrderTempObjectBoxStruct_.kdsSuccess)
                      .order(OrderTempObjectBoxStruct_.orderDateTime)
                      .build()
                      .find();
                  response.write(
                      jsonEncode(result.map((e) => e.toJson()).toList()));
                  break;
                case "staff.order_temp_get_data_from_orderid_and_barcode":
                  var jsonData = jsonDecode(httpGetData.json);
                  String orderId = jsonData["orderId"];
                  String barcode = jsonData["barcode"];
                  bool isOrder = jsonData["isOrder"];
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  final result = (barcode.isNotEmpty)
                      ? box
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(orderId)
                              .and(OrderTempObjectBoxStruct_.barcode
                                  .equals(barcode)
                                  .and(OrderTempObjectBoxStruct_.isPaySuccess
                                      .equals(false))
                                  .and(OrderTempObjectBoxStruct_.isOrder
                                      .equals(isOrder))))
                          .build()
                          .find()
                      : box
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(orderId)
                              .and(
                                  OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
                              .and(OrderTempObjectBoxStruct_.isOrder.equals(isOrder)))
                          .build()
                          .find();
                  response.write(
                      jsonEncode(result.map((e) => e.toJson()).toList()));
                  break;
                case "staff.order_temp_get_data_from_orderid":
                  var jsonData = jsonDecode(httpGetData.json);
                  String orderId = jsonData["orderId"];
                  bool isOrder = jsonData["isOrder"];
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  final result = box
                      .query(OrderTempObjectBoxStruct_.orderId
                          .equals(orderId)
                          .and(OrderTempObjectBoxStruct_.isOrder
                              .equals(isOrder)))
                      .build()
                      .find();
                  double orderQty = 0;
                  for (var item in result) {
                    orderQty += item.qty;
                  }
                  OrderTempStruct orderTemp =
                      OrderTempStruct(orderQty: orderQty, orderTemp: result);
                  response.write(jsonEncode(orderTemp.toJson()));
                  break;
                case "staff.order_temp_get_data_from_order_main_id":
                  var jsonData = jsonDecode(httpGetData.json);
                  String orderMainId = jsonData["orderMainId"];
                  bool isOrder = jsonData["isOrder"];
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  final result = box
                      .query(OrderTempObjectBoxStruct_.orderIdMain
                          .equals(orderMainId)
                          .and(OrderTempObjectBoxStruct_.isOrder
                              .equals(isOrder)))
                      .build()
                      .find();
                  double orderQty = 0;
                  for (var item in result) {
                    orderQty += item.qty;
                  }
                  OrderTempStruct orderTemp =
                      OrderTempStruct(orderQty: orderQty, orderTemp: result);
                  response.write(jsonEncode(orderTemp.toJson()));
                  break;
                case "staff.order_temp_get_data_from_order_guid":
                  String orderGuid = httpGetData.json;
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  final result = box
                      .query(
                          OrderTempObjectBoxStruct_.orderGuid.equals(orderGuid))
                      .build()
                      .findFirst();
                  if (result != null) {
                    response.write(jsonEncode(result.toJson()));
                  } else {
                    response.write(jsonEncode({}));
                  }
                  break;
                case "staff.get_all_delivery_ticket":
                  var jsonData = jsonDecode(httpGetData.json);
                  bool sendSuccess = jsonData["sendSuccess"];
                  print("sendSuccess : $sendSuccess");
                  List<TableProcessObjectBoxStruct> boxData = global
                      .objectBoxStore
                      .box<TableProcessObjectBoxStruct>()
                      .query(TableProcessObjectBoxStruct_.is_delivery
                          .equals(true)
                          .and(TableProcessObjectBoxStruct_
                              .delivery_send_success
                              .equals(sendSuccess)))
                      .order(TableProcessObjectBoxStruct_.table_open_datetime,
                          flags: Order.descending)
                      .build()
                      .find();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "get_all_buffet_mode":
                  List<BuffetModeObjectBoxStruct> boxData = global
                      .objectBoxStore
                      .box<BuffetModeObjectBoxStruct>()
                      .getAll();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "get_all_table":
                  List<TableProcessObjectBoxStruct> tableData = global
                      .objectBoxStore
                      .box<TableProcessObjectBoxStruct>()
                      .query(TableProcessObjectBoxStruct_.is_delivery
                          .equals(false))
                      .build()
                      .find();
                  // หาโต๊ะลูก
                  for (var table in tableData) {
                    table.table_child_count = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.number_main
                            .equals(table.number))
                        .build()
                        .count();
                  }
                  response.write(
                      jsonEncode(tableData.map((e) => e.toJson()).toList()));
                  break;
                case "get_all_category":
                  List<ProductCategoryObjectBoxStruct> boxData = global
                      .objectBoxStore
                      .box<ProductCategoryObjectBoxStruct>()
                      .getAll();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "get_all_kitchen":
                  List<KitchenObjectBoxStruct> boxData = global.objectBoxStore
                      .box<KitchenObjectBoxStruct>()
                      .getAll();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "get_all_barcode":
                  List<ProductBarcodeObjectBoxStruct> boxData = global
                      .objectBoxStore
                      .box<ProductBarcodeObjectBoxStruct>()
                      .getAll();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "PosLogHelper.selectByGuidFixed":
                  final box =
                      global.objectBoxStore.box<PosLogObjectBoxStruct>();
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  List<PosLogObjectBoxStruct> boxData = (box.query(
                          PosLogObjectBoxStruct_.guid_auto_fixed
                              .equals(jsonCategory.guid))
                        ..order(PosLogObjectBoxStruct_.log_date_time))
                      .build()
                      .find();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "get_process":
                  HttpParameterModel jsonParameter =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  String holdCode = jsonParameter.holdCode;
                  int docMode = jsonParameter.docMode;
                  global
                          .posHoldProcessResult[
                              global.findPosHoldProcessResultIndex(holdCode)]
                          .posProcess =
                      await PosProcess()
                          .process(holdCode: holdCode, docMode: docMode);
                  response.write(jsonEncode(global.posHoldProcessResult[
                          global.findPosHoldProcessResultIndex(holdCode)]
                      .toJson()));
                  break;
                case "PosLogHelper.holdCount":
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  int result =
                      await PosLogHelper().holdCount(jsonCategory.holdCode);
                  response.write(result.toString());
                  break;
                case "selectByBarcodeFirst":
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  ProductBarcodeObjectBoxStruct? result =
                      await ProductBarcodeHelper()
                          .selectByBarcodeFirst(jsonCategory.barcode);
                  response.write(jsonEncode(result?.toJson()));
                  break;
                case "selectByBarcodeList":
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  List<String> barcodeList = jsonCategory.barcode.split(",");
                  List<ProductBarcodeObjectBoxStruct> result =
                      await ProductBarcodeHelper()
                          .selectByBarcodeList(barcodeList);
                  response.write(
                      jsonEncode(result.map((e) => e.toJson()).toList()));
                  break;
                case "selectByCategoryParentGuid":
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  String parentGuid = jsonCategory.parentGuid;
                  final box = global.objectBoxStore
                      .box<ProductCategoryObjectBoxStruct>();
                  final result = box
                      .query(ProductCategoryObjectBoxStruct_.parent_guid_fixed
                          .equals(parentGuid))
                      .order(ProductCategoryObjectBoxStruct_.xorder)
                      .build()
                      .find();
                  response.write(
                      jsonEncode(result.map((e) => e.toJson()).toList()));
                  break;
                case "selectByParentCategoryGuidOrderByXorder":
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  String parentGuid = jsonCategory.parentGuid;
                  final box = global.objectBoxStore
                      .box<ProductCategoryObjectBoxStruct>();
                  final result = (box.query(ProductCategoryObjectBoxStruct_
                          .parent_guid_fixed
                          .equals(parentGuid))
                        ..order(ProductCategoryObjectBoxStruct_.xorder))
                      .build()
                      .find();
                  response.write(
                      jsonEncode(result.map((e) => e.toJson()).toList()));
                  break;
                case "selectByCategoryGuidFindFirst":
                  HttpParameterModel jsonCategory =
                      HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
                  String guid = jsonCategory.guid;
                  final box = global.objectBoxStore
                      .box<ProductCategoryObjectBoxStruct>();
                  ProductCategoryObjectBoxStruct? result = box
                      .query(ProductCategoryObjectBoxStruct_.guid_fixed
                          .equals(guid))
                      .build()
                      .findFirst();
                  response.write(jsonEncode(result?.toJson()));
                  break;
              }
            }
          } else if (request.method == 'POST') {
            if (contentType?.mimeType == 'application/json') {
              try {
                var data = await utf8.decoder.bind(request).join();
                var jsonDecodeStr = jsonDecode(data);
                var httpPost = HttpPost.fromJson(jsonDecodeStr);
                switch (httpPost.command) {
                  case "register_staff_device":
                    SyncStaffDeviceModel jsonCategory =
                        SyncStaffDeviceModel.fromJson(
                            jsonDecode(httpPost.data));
                    bool found = false;
                    int foundIndex = -1;
                    for (int index = 0;
                        index < global.staffClientList.length;
                        index++) {
                      if (global.staffClientList[index].guid ==
                          jsonCategory.clientGuid) {
                        found = true;
                        foundIndex = index;
                        break;
                      }
                    }
                    if (found) {
                      global.staffClientList.removeAt(foundIndex);
                    }
                    global.staffClientList.add(StaffClientObjectBoxStruct(
                        guid: jsonCategory.clientGuid,
                        name: jsonCategory.clientName,
                        device_guid: jsonCategory.clientGuid,
                        device_ip: jsonCategory.clientIp));
                    response.write("success");
                    break;
                  case "staff.set_kds_start_cooking":
                    // เริ่มทำอาหารได้
                    var jsonData = jsonDecode(httpPost.data);
                    String orderNumber = jsonData["orderNumber"];

                    // update Ticket ให้เป็น ทำอาหารทันที
                    var dataTicket = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.delivery_number
                            .equals(orderNumber))
                        .build()
                        .findFirst();
                    if (dataTicket != null) {
                      dataTicket.make_food_immediately = true;
                      global.objectBoxStore
                          .box<TableProcessObjectBoxStruct>()
                          .put(dataTicket, mode: PutMode.update);
                      // update สถานะ รายการย่อย ให้พร้อมส่งเข้าครัว
                      var dataTicketDetail = global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(dataTicket.number)
                              .and(OrderTempObjectBoxStruct_.isOrderReadySendKds
                                  .equals(false)))
                          .build()
                          .find();
                      for (var item in dataTicketDetail) {
                        item.isOrderReadySendKds = true;
                      }
                      global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .putMany(dataTicketDetail, mode: PutMode.update);
                    }
                    response.write(true);
                    break;
                  case "staff.insert_delivery_ticket":
                    late int runningNo;
                    String runningStart =
                        DateFormat("yyMMdd").format(DateTime.now());
                    var dataRunning = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.delivery_number
                            .notEquals("")
                            .and(TableProcessObjectBoxStruct_.delivery_number
                                .lessThan("$runningStart-9999")))
                        .order(TableProcessObjectBoxStruct_.delivery_number,
                            flags: Order.descending)
                        .build()
                        .findFirst();
                    if (dataRunning != null) {
                      runningNo = int.parse(dataRunning.delivery_number
                              .substring(runningStart.length + 1)) +
                          1;
                    } else {
                      runningNo = 1;
                    }
                    String runningNumber =
                        "$runningStart-${runningNo.toString().padLeft(4, "0")}";
                    // สร้าง Ticket Delivery ใหม่
                    var data = TableProcessObjectBoxStruct.fromJson(
                        jsonDecode(httpPost.data));
                    data.delivery_number = runningNumber;
                    global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .put(data, mode: PutMode.insert);
                    response.write(runningNumber);
                    break;
                  case "staff.update_product_barcode_status_qty":
                    var jsonData = jsonDecode(httpPost.data);
                    String barcode = jsonData["barcode"];
                    double qty = jsonData["qty"];
                    var productStatus = global.objectBoxStore
                        .box<ProductBarcodeStatusObjectBoxStruct>()
                        .query(ProductBarcodeStatusObjectBoxStruct_.barcode
                            .equals(barcode))
                        .build()
                        .findFirst();
                    if (productStatus != null) {
                      productStatus.qtyBalance += qty;
                      global.objectBoxStore
                          .box<ProductBarcodeStatusObjectBoxStruct>()
                          .put(productStatus, mode: PutMode.update);
                    }
                    break;
                  case "kds.order_temp_update_kds_success_status":
                    var jsonData = jsonDecode(httpPost.data);
                    String guid = jsonData["guid"];
                    var order = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderGuid.equals(guid))
                        .build()
                        .findFirst();
                    if (order != null) {
                      order.kdsSuccess = !order.kdsSuccess;
                      order.kdsSuccessTime = DateTime.now();
                      global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .put(order, mode: PutMode.update);
                    }
                    break;
                  case "staff.product_barcode_status_update":
                    var data = ProductBarcodeStatusObjectBoxStruct.fromJson(
                        jsonDecode(httpPost.data));
                    var productBarcode = global.objectBoxStore
                        .box<ProductBarcodeStatusObjectBoxStruct>()
                        .query(ProductBarcodeStatusObjectBoxStruct_.barcode
                            .equals(data.barcode))
                        .build()
                        .findFirst();
                    if (productBarcode != null) {
                      global.objectBoxStore
                          .box<ProductBarcodeStatusObjectBoxStruct>()
                          .put(data, mode: PutMode.update);
                    }
                    break;
                  case "staff.order_temp_cancel_by_guid":
                    // ยกเลิก Order
                    var jsonData = jsonDecode(httpPost.data);
                    String guid = jsonData["guid"];
                    double qty = jsonData["qty"];
                    var oldOrder = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderGuid.equals(guid))
                        .build()
                        .findFirst();
                    if (oldOrder != null) {
                      if (oldOrder.qty - qty >= 0) {
                        oldOrder.qty = oldOrder.qty - qty;
                        oldOrder.cancelQty = oldOrder.cancelQty + qty;
                        oldOrder.lastUpdateDateTime = DateTime.now();
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(oldOrder, mode: PutMode.update);
                        // ลบ Hold แล้วสร้างใหม่
                        String holdId = "T-${oldOrder.orderId}";
                        global.objectBoxStore
                            .box<PosLogObjectBoxStruct>()
                            .query(
                                PosLogObjectBoxStruct_.hold_code.equals(holdId))
                            .build()
                            .remove();
                        var orderList = global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .query(OrderTempObjectBoxStruct_.orderId
                                .equals(oldOrder.orderId))
                            .build()
                            .find();
                        if (orderList.isNotEmpty) {
                          for (var order in orderList) {
                            // เพิ่มรายการ
                            PosLogObjectBoxStruct dataPosLog =
                                PosLogObjectBoxStruct(
                                    log_date_time: DateTime.now(),
                                    doc_mode: 1,
                                    hold_code: holdId,
                                    command_code: 1,
                                    barcode: order.barcode,
                                    name: order.names,
                                    unit_code: order.unitCode,
                                    unit_name: order.unitName,
                                    qty: order.qty,
                                    price: order.price);
                            await PosLogHelper().insert(dataPosLog);
                            if (order.optionSelected.isNotEmpty) {
                              var optionJson = jsonDecode(order.optionSelected);
                              List<ProductOptionModel> optionList = (optionJson
                                      as List)
                                  .map((e) => ProductOptionModel.fromJson(e))
                                  .toList();
                              for (var option in optionList) {
                                for (var choice in option.choices) {
                                  if (choice.selected == true) {
                                    // เพิ่มรายการ
                                    PosLogObjectBoxStruct data =
                                        PosLogObjectBoxStruct(
                                            log_date_time: DateTime.now(),
                                            guid_ref:
                                                dataPosLog.guid_auto_fixed,
                                            doc_mode: 1,
                                            hold_code: holdId,
                                            command_code: 101,
                                            barcode: choice.barcode ?? "",
                                            name: jsonEncode(choice.names),
                                            unit_code: choice.refunitcode ?? "",
                                            unit_name: "",
                                            qty: choice.qty,
                                            price:
                                                double.tryParse(choice.price) ??
                                                    0);
                                    await PosLogHelper().insert(data);
                                  }
                                }
                              }
                            }
                          }
                        }
                        global.orderSumAndUpdateTable(oldOrder.orderId);
                      }
                    }
                    break;
                  case "staff.order_temp_delete_by_barcode":
                    var jsonData = jsonDecode(httpPost.data);
                    String orderId = jsonData["orderId"];
                    String barcode = jsonData["barcode"];
                    // กรณีมีการคุมสต๊อก คืนค่าสต๊อก
                    var productBarcodeStatus =
                        await ProductBarcodeStatusHelper()
                            .selectByBarcodeFirst(barcode);
                    if (productBarcodeStatus != null &&
                        productBarcodeStatus.orderAutoStock) {
                      var orderTemp = global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(orderId)
                              .and(OrderTempObjectBoxStruct_.barcode
                                  .equals(barcode)))
                          .build()
                          .find();
                      if (orderTemp.isNotEmpty) {
                        for (var order in orderTemp) {
                          productBarcodeStatus.qtyBalance += order.qty;
                          global.objectBoxStore
                              .box<ProductBarcodeStatusObjectBoxStruct>()
                              .put(productBarcodeStatus, mode: PutMode.update);
                        }
                      }
                    }
                    // ลบรายการ
                    global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.isOrder.equals(true))
                            .and(OrderTempObjectBoxStruct_.barcode
                                .equals(barcode)))
                        .build()
                        .remove();
                    global.orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_delete_by_orderid":
                    String orderId = httpPost.data;
                    // กรณีมีการคุมสต๊อก คืนค่าสต๊อก
                    var orderTemp = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.orderId
                                .equals(orderId)))
                        .build()
                        .find();
                    if (orderTemp.isNotEmpty) {
                      for (var order in orderTemp) {
                        var productBarcodeStatus =
                            await ProductBarcodeStatusHelper()
                                .selectByBarcodeFirst(order.barcode);
                        if (productBarcodeStatus != null &&
                            productBarcodeStatus.orderAutoStock) {
                          productBarcodeStatus.qtyBalance += order.qty;
                          global.objectBoxStore
                              .box<ProductBarcodeStatusObjectBoxStruct>()
                              .put(productBarcodeStatus, mode: PutMode.update);
                        }
                      }
                    }
                    global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.orderId
                                .equals(orderId)))
                        .build()
                        .remove();
                    global.orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_send_order_by_orderid":
                    String orderId = httpPost.data;
                    final box =
                        global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                    final result = box
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(
                                OrderTempObjectBoxStruct_.isOrder.equals(true)))
                        .build()
                        .find();
                    for (var order in result) {
                      // ปรับปรุงว่าส่ง Order ได้
                      order.isOrder = false;
                    }
                    box.putMany(result, mode: PutMode.update);
                    global.orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_delete_by_guid":
                    // ลบเฉพาะกรณียังไม่ส่ง Order
                    var jsonData = jsonDecode(httpPost.data);
                    String orderId = jsonData["orderId"];
                    String orderGuid = jsonData["guid"];
                    // กรณีมีการคุมสต๊อก คืนค่าสต๊อก
                    var orderTempOld = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.isOrder.equals(true))
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(orderGuid)))
                        .build()
                        .findFirst();
                    if (orderTempOld != null) {
                      var productBarcodeStatus =
                          await ProductBarcodeStatusHelper()
                              .selectByBarcodeFirst(orderTempOld.barcode);
                      if (productBarcodeStatus != null &&
                          productBarcodeStatus.orderAutoStock) {
                        productBarcodeStatus.qtyBalance += orderTempOld.qty;
                        global.objectBoxStore
                            .box<ProductBarcodeStatusObjectBoxStruct>()
                            .put(productBarcodeStatus, mode: PutMode.update);
                      }
                    }
                    global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.isOrder.equals(true))
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(orderGuid)))
                        .build()
                        .remove();
                    global.orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_insert":
                    // เพิ่มรายการ (orderTemp) ยังไม่ส่ง Order
                    int result = 0;
                    bool isInsertOrUpdate = false;
                    OrderTempObjectBoxStruct jsonData =
                        OrderTempObjectBoxStruct.fromJson(
                            jsonDecode(httpPost.data));
                    // ตรวจสอบยอดคงเหลือ (กรณีสินค้าคุมยอดคงเหลือ)
                    var productBarcodeStatus =
                        await ProductBarcodeStatusHelper()
                            .selectByBarcodeFirst(jsonData.barcode);
                    if (productBarcodeStatus != null &&
                        productBarcodeStatus.orderAutoStock) {
                      if (productBarcodeStatus.qtyBalance - jsonData.qty < 0) {
                        // สินค้าคุมยอดคงเหลือ และ ยอดคงเหลือไม่พอ
                        result = 1;
                        isInsertOrUpdate = false;
                      } else {
                        productBarcodeStatus.qtyBalance -= jsonData.qty;
                        global.objectBoxStore
                            .box<ProductBarcodeStatusObjectBoxStruct>()
                            .put(productBarcodeStatus);
                        result = 0;
                        isInsertOrUpdate = true;
                      }
                    } else {
                      result = 0;
                      isInsertOrUpdate = true;
                    }
                    if (isInsertOrUpdate) {
                      final box =
                          global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                      // ตรวจสอบว่าไม่มี Option และเคยสั่งไปแล้ว จะได้เพิ่ม Qty
                      final findResult = box
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(jsonData.orderId)
                              .and(OrderTempObjectBoxStruct_.barcode
                                  .equals(jsonData.barcode)
                                  .and(OrderTempObjectBoxStruct_.remark
                                      .equals(jsonData.remark)
                                      .and(OrderTempObjectBoxStruct_
                                          .optionSelected
                                          .equals(jsonData.optionSelected))))
                              .and(OrderTempObjectBoxStruct_.isOrder
                                  .equals(true)
                                  .and(OrderTempObjectBoxStruct_.takeAway
                                      .equals(jsonData.takeAway))))
                          .build()
                          .findFirst();
                      if (findResult != null) {
                        findResult.qty += jsonData.qty;
                        findResult.orderQty += jsonData.orderQty;
                        findResult.amount = orderCalcSumAmount(findResult);
                        box.put(findResult, mode: PutMode.update);
                      } else {
                        jsonData.amount = orderCalcSumAmount(jsonData);
                        box.put(jsonData, mode: PutMode.insert);
                      }
                      global.orderSumAndUpdateTable(jsonData.orderId);
                    }
                    response.write(result);
                    break;
                  case "staff.order_temp_update_for_split":
                    bool insertNewOrderData = true;
                    // 0=ต้นทาง, 1=ปลายทางม ,2=orderGuid (ได้ครั้งละ 1 qty)
                    OrderTempUpdateForSplitModel jsonData =
                        OrderTempUpdateForSplitModel.fromJson(
                            jsonDecode(httpPost.data));
                    // รายการเดิม ถ้ามีให้ update ถ้าไม่มีให้เพิ่ม
                    print(
                        "ย้ายจาก ${jsonData.sourceTable} ไป ${jsonData.targetTable}");
                    final findSourceTempResult = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(jsonData.sourceTable)
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(jsonData.sourceGuid)
                                .and(OrderTempObjectBoxStruct_.isPaySuccess
                                    .equals(false))))
                        .build()
                        .findFirst();
                    final findTargetTempResult = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(jsonData.targetTable)
                            .and(OrderTempObjectBoxStruct_.isPaySuccess
                                .equals(false)))
                        .build()
                        .find();
                    if (findSourceTempResult != null &&
                        findSourceTempResult.qty > 0) {
                      for (var target in findTargetTempResult) {
                        if (target.barcode == findSourceTempResult.barcode &&
                            target.remark == findSourceTempResult.remark &&
                            target.optionSelected ==
                                findSourceTempResult.optionSelected) {
                          // กรณีพบข้อมูลเดิมในโต๊ะปลายทาง
                          target.qty += 1;
                          target.orderQty += 1;
                          target.amount = orderCalcSumAmount(target);
                          global.objectBoxStore
                              .box<OrderTempObjectBoxStruct>()
                              .put(target, mode: PutMode.update);
                          findSourceTempResult.qty -= 1;
                          findSourceTempResult.orderQty -= 1;
                          findSourceTempResult.amount =
                              orderCalcSumAmount(findSourceTempResult);
                          global.objectBoxStore
                              .box<OrderTempObjectBoxStruct>()
                              .put(findSourceTempResult, mode: PutMode.update);
                          insertNewOrderData = false;
                          break;
                        }
                      }
                      if (insertNewOrderData) {
                        // กรณีไม่พบข้อมูลเดิมในโต๊ะปลายทาง
                        // ลดจำนวนของเก่า
                        findSourceTempResult.qty -= 1;
                        findSourceTempResult.orderQty -= 1;
                        findSourceTempResult.amount =
                            orderCalcSumAmount(findSourceTempResult);
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(findSourceTempResult, mode: PutMode.update);
                        // เพิ่มข้อมูลใหม่
                        final newOrderTemp = OrderTempObjectBoxStruct(
                          id: 0,
                          orderId: jsonData.targetTable,
                          orderIdMain: findSourceTempResult.orderIdMain,
                          orderGuid: Uuid().v4(),
                          machineId: findSourceTempResult.machineId,
                          orderDateTime: findSourceTempResult.orderDateTime,
                          barcode: findSourceTempResult.barcode,
                          qty: 1,
                          price: findSourceTempResult.price,
                          amount: findSourceTempResult.price,
                          isOrder: findSourceTempResult.isOrder,
                          isPaySuccess: findSourceTempResult.isPaySuccess,
                          optionSelected: findSourceTempResult.optionSelected,
                          remark: findSourceTempResult.remark,
                          names: findSourceTempResult.names,
                          takeAway: findSourceTempResult.takeAway,
                          unitCode: findSourceTempResult.unitCode,
                          unitName: findSourceTempResult.unitName,
                          imageUri: findSourceTempResult.imageUri,
                          kdsSuccessTime: findSourceTempResult.kdsSuccessTime,
                          kdsSuccess: findSourceTempResult.kdsSuccess,
                          isOrderSuccess: findSourceTempResult.isOrderSuccess,
                          isOrderSendKdsSuccess:
                              findSourceTempResult.isOrderSendKdsSuccess,
                          kdsId: findSourceTempResult.kdsId,
                          cancelQty: findSourceTempResult.cancelQty,
                          orderQty: 1,
                          deliveryNumber: findSourceTempResult.deliveryNumber,
                          deliveryCode: findSourceTempResult.deliveryCode,
                          isOrderReadySendKds:
                              findSourceTempResult.isOrderReadySendKds,
                          deliveryName: findSourceTempResult.deliveryName,
                          lastUpdateDateTime:
                              findSourceTempResult.lastUpdateDateTime,
                        );
                        newOrderTemp.orderId = jsonData.targetTable;
                        newOrderTemp.orderGuid = Uuid().v4();
                        newOrderTemp.qty = 1;
                        newOrderTemp.orderQty = 1;
                        newOrderTemp.amount = orderCalcSumAmount(newOrderTemp);
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(newOrderTemp, mode: PutMode.insert);
                      }
                      {
                        // เพิ่มโต๊ะปลายทาง
                        final findSourceTableResult = global.objectBoxStore
                            .box<TableProcessObjectBoxStruct>()
                            .query(TableProcessObjectBoxStruct_.number
                                .equals(jsonData.sourceTable))
                            .build()
                            .findFirst();
                        final findTargetTableResult = global.objectBoxStore
                            .box<TableProcessObjectBoxStruct>()
                            .query(TableProcessObjectBoxStruct_.number
                                .equals(jsonData.targetTable))
                            .build()
                            .findFirst();
                        if (findTargetTableResult == null) {
                          print("findTargetTableResult ; " +
                              jsonData.targetTable);
                          final newTable = TableProcessObjectBoxStruct(
                            number: jsonData.targetTable,
                            guidfixed: Uuid().v4(),
                            number_main: findSourceTableResult!.number_main,
                            names: findSourceTableResult.names,
                            zone: findSourceTableResult.zone,
                            table_child_count: 0,
                            table_al_la_crate_mode:
                                findSourceTableResult.table_al_la_crate_mode,
                            table_open_datetime:
                                findSourceTableResult.table_open_datetime,
                            table_status: findSourceTableResult.table_status,
                            delivery_ticket_number:
                                findSourceTableResult.delivery_ticket_number,
                            remark: findSourceTableResult.remark,
                            order_count: findSourceTableResult.order_count,
                            amount: findSourceTableResult.amount,
                            order_success: findSourceTableResult.order_success,
                            qr_code: findSourceTableResult.qr_code,
                            man_count: findSourceTableResult.man_count,
                            woman_count: findSourceTableResult.woman_count,
                            child_count: findSourceTableResult.child_count,
                            buffet_code: findSourceTableResult.buffet_code,
                            customer_address:
                                findSourceTableResult.customer_address,
                            customer_code_or_telephone: findSourceTableResult
                                .customer_code_or_telephone,
                            customer_name: findSourceTableResult.customer_name,
                            delivery_cook_success:
                                findSourceTableResult.delivery_cook_success,
                            delivery_cook_success_datetime:
                                findSourceTableResult
                                    .delivery_cook_success_datetime,
                            delivery_code: findSourceTableResult.delivery_code,
                            delivery_number:
                                findSourceTableResult.delivery_number,
                            delivery_status:
                                findSourceTableResult.delivery_status,
                            delivery_send_success:
                                findSourceTableResult.delivery_send_success,
                            delivery_send_success_datetime:
                                findSourceTableResult
                                    .delivery_send_success_datetime,
                            is_delivery: findSourceTableResult.is_delivery,
                            open_by_staff_code:
                                findSourceTableResult.open_by_staff_code,
                            make_food_immediately:
                                findSourceTableResult.make_food_immediately,
                          );
                          global.objectBoxStore
                              .box<TableProcessObjectBoxStruct>()
                              .put(newTable, mode: PutMode.insert);
                        }
                      }
                    }
                    {
                      // ลบรายการ Qty = 0 ออก
                      final findSourceTempResultDelete = global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(jsonData.sourceTable)
                              .or(OrderTempObjectBoxStruct_.orderId
                                  .equals(jsonData.targetTable)))
                          .build()
                          .find();
                      for (var item in findSourceTempResultDelete) {
                        if (item.orderQty == 0) {
                          global.objectBoxStore
                              .box<OrderTempObjectBoxStruct>()
                              .remove(item.id);
                        }
                      }
                    }
                    // ลบบิลเดิม / สร้างใหม่
                    await global.rebuildOrderToHoldBill(jsonData.sourceTable);
                    await global.rebuildOrderToHoldBill(jsonData.targetTable);
                    // คำนวณใหม่
                    await global.orderSumAndUpdateTable(jsonData.sourceTable);
                    await global.orderSumAndUpdateTable(jsonData.targetTable);
                    response.write(true);
                    break;
                  case "staff.order_temp_update":
                    int result = 0;
                    bool isUpdate = false;
                    OrderTempObjectBoxStruct jsonData =
                        OrderTempObjectBoxStruct.fromJson(
                            jsonDecode(httpPost.data));
                    // รายการเดิม
                    final findOldTempResult = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(jsonData.orderId)
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(jsonData.orderGuid))
                            .and(
                                OrderTempObjectBoxStruct_.isOrder.equals(true)))
                        .build()
                        .findFirst();
                    // ตรวจสอบยอดคงเหลือ (กรณีสินค้าคุมยอดคงเหลือ)
                    var productBarcodeStatus =
                        await ProductBarcodeStatusHelper()
                            .selectByBarcodeFirst(jsonData.barcode);
                    if (productBarcodeStatus != null &&
                        productBarcodeStatus.orderAutoStock) {
                      if (productBarcodeStatus.qtyBalance -
                              (jsonData.qty - findOldTempResult!.qty) <
                          0) {
                        // สินค้าคุมยอดคงเหลือ และ ยอดคงเหลือไม่พอ
                        result = 1;
                      } else {
                        isUpdate = true;
                        productBarcodeStatus.qtyBalance -=
                            (jsonData.qty - findOldTempResult.qty);
                        global.objectBoxStore
                            .box<ProductBarcodeStatusObjectBoxStruct>()
                            .put(productBarcodeStatus, mode: PutMode.update);
                        result = 0;
                      }
                    } else {
                      isUpdate = true;
                    }
                    if (isUpdate == true) {
                      if (findOldTempResult != null) {
                        jsonData.amount = orderCalcSumAmount(jsonData);
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(jsonData, mode: PutMode.update);
                        result = 0;
                      } else {
                        result = 2;
                      }
                      global.orderSumAndUpdateTable(jsonData.orderId);
                    }
                    /*final test = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(jsonData.orderId)
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(jsonData.orderGuid))
                            .and(
                                OrderTempObjectBoxStruct_.isOrder.equals(true)))
                        .build()
                        .find();
                    for (var x in test) {
                      print(x.qty.toString());
                    }*/
                    response.write(result);
                    break;
                  case "staff.update_table":
                    var jsonObject = jsonDecode(httpPost.data);
                    TableProcessObjectBoxStruct getTable =
                        TableProcessObjectBoxStruct.fromJson(jsonObject);
                    final box = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>();
                    final result = box
                        .query(TableProcessObjectBoxStruct_.number
                            .equals(getTable.number))
                        .build()
                        .findFirst();
                    if (result != null) {
                      box.put(getTable);
                      switch (getTable.table_status) {
                        case 1:
                          // พิมพ์ใบเปิดโต๊ะ
                          printer.printTableQrCode(
                              tableManagerMode:
                                  global.TableManagerEnum.openTable,
                              table: getTable,
                              qrCode: getTable.qr_code);
                          print(getTable.qr_code);
                          break;
                      }
                    }
                    break;
                  case "staff.move_table":
                    // ย้ายโต๊ะ
                    var jsonObject = jsonDecode(httpPost.data);
                    String fromTableNumber = jsonObject["from_table"];
                    String toTableNumber = jsonObject["to_table"];
                    final fromTableResult = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.number
                            .equals(fromTableNumber))
                        .build()
                        .findFirst();
                    final toTableResult = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.number
                            .equals(toTableNumber))
                        .build()
                        .findFirst();
                    if (fromTableResult != null && toTableResult != null) {
                      // Update เปิดโต๊ะ ปลายทาง
                      toTableResult.number_main = toTableResult.number;
                      toTableResult.table_status = 1;
                      toTableResult.man_count = fromTableResult.man_count;
                      toTableResult.woman_count = fromTableResult.woman_count;
                      toTableResult.child_count = fromTableResult.child_count;
                      toTableResult.table_al_la_crate_mode =
                          fromTableResult.table_al_la_crate_mode;
                      toTableResult.buffet_code = fromTableResult.buffet_code;
                      toTableResult.amount = fromTableResult.amount;
                      toTableResult.order_count = fromTableResult.order_count;
                      toTableResult.table_open_datetime =
                          fromTableResult.table_open_datetime;
                      global.objectBoxStore
                          .box<TableProcessObjectBoxStruct>()
                          .put(toTableResult, mode: PutMode.update);
                      // Update ปิดโต๊ะ ต้นทาง
                      fromTableResult.table_status = 0;
                      fromTableResult.order_count = 0;
                      fromTableResult.amount = 0;
                      fromTableResult.man_count = 0;
                      fromTableResult.woman_count = 0;
                      fromTableResult.child_count = 0;
                      global.objectBoxStore
                          .box<TableProcessObjectBoxStruct>()
                          .put(fromTableResult);
                      // ย้าย Order (Hold Bill)
                      final posLogs = global.objectBoxStore
                          .box<PosLogObjectBoxStruct>()
                          .query(PosLogObjectBoxStruct_.hold_code
                              .equals("T-$fromTableNumber"))
                          .build()
                          .find();
                      for (int index = 0; index < posLogs.length; index++) {
                        posLogs[index].hold_code = "T-$toTableNumber";
                        global.objectBoxStore
                            .box<PosLogObjectBoxStruct>()
                            .put(posLogs[index]);
                      }
                      // ย้าย Order (Order Temp)
                      final orderTemps = global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(fromTableNumber)
                              .and(OrderTempObjectBoxStruct_.isPaySuccess
                                  .equals(false)))
                          .build()
                          .find();
                      for (int index = 0; index < orderTemps.length; index++) {
                        orderTemps[index].orderId = toTableNumber;
                        orderTemps[index].orderIdMain = toTableNumber;
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(orderTemps[index], mode: PutMode.update);
                      }
                    }
                    break;
                  case "staff.merge_table":
                    // รวมโต๊ะ
                    var jsonObject = jsonDecode(httpPost.data);
                    String fromTableNumber = jsonObject["from_table"];
                    String toTableNumber = jsonObject["to_table"];
                    final fromTableResult = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.number
                            .equals(fromTableNumber))
                        .build()
                        .findFirst();
                    final toTableResult = global.objectBoxStore
                        .box<TableProcessObjectBoxStruct>()
                        .query(TableProcessObjectBoxStruct_.number
                            .equals(toTableNumber))
                        .build()
                        .findFirst();
                    if (fromTableResult != null && toTableResult != null) {
                      // Update โต๊ะ ปลายทาง
                      toTableResult.table_status = 1;
                      toTableResult.man_count += fromTableResult.man_count;
                      toTableResult.woman_count += fromTableResult.woman_count;
                      toTableResult.child_count += fromTableResult.child_count;
                      toTableResult.table_al_la_crate_mode =
                          fromTableResult.table_al_la_crate_mode;
                      toTableResult.buffet_code = fromTableResult.buffet_code;
                      toTableResult.amount = fromTableResult.amount;
                      toTableResult.order_count = fromTableResult.order_count;
                      toTableResult.table_open_datetime =
                          fromTableResult.table_open_datetime;
                      global.objectBoxStore
                          .box<TableProcessObjectBoxStruct>()
                          .put(toTableResult, mode: PutMode.update);
                      // Update ปิดโต๊ะ ต้นทาง
                      fromTableResult.table_status = 0;
                      fromTableResult.order_count = 0;
                      fromTableResult.amount = 0;
                      fromTableResult.man_count = 0;
                      fromTableResult.woman_count = 0;
                      fromTableResult.child_count = 0;
                      global.objectBoxStore
                          .box<TableProcessObjectBoxStruct>()
                          .put(fromTableResult);
                      // ย้าย Order (Hold Bill)
                      final posLogs = global.objectBoxStore
                          .box<PosLogObjectBoxStruct>()
                          .query(PosLogObjectBoxStruct_.hold_code
                              .equals("T-$fromTableNumber"))
                          .build()
                          .find();
                      for (int index = 0; index < posLogs.length; index++) {
                        posLogs[index].hold_code = "T-$toTableNumber";
                        global.objectBoxStore
                            .box<PosLogObjectBoxStruct>()
                            .put(posLogs[index]);
                      }
                      // ย้าย Order (Order Temp)
                      final orderTemps = global.objectBoxStore
                          .box<OrderTempObjectBoxStruct>()
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(fromTableNumber)
                              .and(OrderTempObjectBoxStruct_.isPaySuccess
                                  .equals(false)))
                          .build()
                          .find();
                      for (int index = 0; index < orderTemps.length; index++) {
                        orderTemps[index].orderId = toTableNumber;
                        orderTemps[index].orderIdMain = toTableNumber;
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(orderTemps[index], mode: PutMode.update);
                      }
                    }
                    break;
                  case "process_result":
                    PosHoldProcessModel result =
                        PosHoldProcessModel.fromJson(jsonDecode(httpPost.data));
                    global.posHoldProcessResult[global
                        .findPosHoldProcessResultIndex(result.code)] = result;
                    PosProcess().sumCategoryCount(
                        value: global
                            .posHoldProcessResult[global
                                .findPosHoldProcessResultIndex(result.code)]
                            .posProcess);
                    if (global.functionPosScreenRefresh != null) {
                      global.functionPosScreenRefresh!(result.code);
                    }
                    break;
                  case "PosLogHelper.insert":
                    PosLogObjectBoxStruct jsonData =
                        PosLogObjectBoxStruct.fromJson(
                            jsonDecode(httpPost.data));
                    final box =
                        global.objectBoxStore.box<PosLogObjectBoxStruct>();
                    response.write(box.put(jsonData));
                    for (int index = 0;
                        index < global.posRemoteDeviceList.length;
                        index++) {
                      if (global.posRemoteDeviceList[index].holdCodeActive ==
                          jsonData.hold_code) {
                        global.posRemoteDeviceList[index].processSuccess =
                            false;
                      }
                    }
                    posCompileProcess(
                            holdCode: jsonData.hold_code,
                            docMode: jsonData.doc_mode)
                        .then((_) {
                      PosProcess().sumCategoryCount(
                          value: global
                              .posHoldProcessResult[
                                  global.findPosHoldProcessResultIndex(
                                      global.posHoldActiveCode)]
                              .posProcess);
                      if (global.functionPosScreenRefresh != null) {
                        global.functionPosScreenRefresh!(
                            global.posHoldActiveCode);
                      }
                    });
                    break;
                  case "PosLogHelper.deleteByHoldCode":
                    String holdCode = httpPost.data;
                    int docMode = 0; //********* Dummy
                    final box =
                        global.objectBoxStore.box<PosLogObjectBoxStruct>();
                    final ids = box
                        .query(
                            PosLogObjectBoxStruct_.hold_code.equals(holdCode))
                        .build()
                        .findIds();
                    box.removeMany(ids);
                    posCompileProcess(holdCode: holdCode, docMode: docMode)
                        .then((_) {
                      PosProcess().sumCategoryCount(
                          value: global
                              .posHoldProcessResult[global
                                  .findPosHoldProcessResultIndex(holdCode)]
                              .posProcess);
                      if (global.functionPosScreenRefresh != null) {
                        global.functionPosScreenRefresh!(
                            global.posHoldActiveCode);
                      }
                    });
                    break;
                  case "get_device_name":
                    // Return ชื่อเครื่อง server , ip server
                    response.write(jsonEncode(
                        jsonDecode('{"device": "${global.deviceName}"}')
                            as Map));
                    break;
                  case "register_remote_device":
                    // ลงทะเบียนเครื่องช่วยขาย
                    SyncDeviceModel posClientDevice =
                        SyncDeviceModel.fromJson(jsonDecode(httpPost.data));
                    int indexFound = -1;
                    for (int index = 0;
                        index < global.posRemoteDeviceList.length;
                        index++) {
                      if (global.posRemoteDeviceList[index].deviceId ==
                          posClientDevice.deviceId) {
                        indexFound = index;
                        break;
                      }
                    }
                    if (indexFound != -1) {
                      global.posRemoteDeviceList[indexFound].ip =
                          posClientDevice.ip;
                      global.posRemoteDeviceList[indexFound].holdCodeActive =
                          posClientDevice.holdCodeActive;
                      serviceLocator<Log>().debug(
                          "register_remote_device : ${posClientDevice.ip},hold_number : ${global.posRemoteDeviceList[indexFound].holdCodeActive}");
                    } else {
                      global.posRemoteDeviceList.add(posClientDevice);
                      serviceLocator<Log>().debug(
                          "register_remote_device : ${posClientDevice.deviceId} : ${global.posRemoteDeviceList.length}");
                    }
                    break;
                  case "register_customer_display_device":
                    // ลงทะเบียนเครื่องแสดงผลลูกค้า
                    SyncDeviceModel customerDisplayDevice =
                        SyncDeviceModel.fromJson(jsonDecode(httpPost.data));
                    bool found = false;
                    for (var device in global.customerDisplayDeviceList) {
                      if (device.deviceId == customerDisplayDevice.deviceId) {
                        found = true;
                        break;
                      }
                    }
                    if (!found) {
                      global.customerDisplayDeviceList
                          .add(customerDisplayDevice);
                      serviceLocator<Log>().debug(
                          "register_customer_display_device : ${customerDisplayDevice.deviceId} : ${global.customerDisplayDeviceList.length}");
                    }
                    break;
                  case "change_customer_by_phone":
                    // รับข้อมูลหมายเลขโทรศัพท์ แล้วมาค้นหาชื่อ และประมวลผล
                    SyncCustomerDisplayModel postCustomer =
                        SyncCustomerDisplayModel.fromJson(
                            jsonDecode(httpPost.data));
                    String customerCode = postCustomer.phone;
                    String customerName = "";
                    String customerPhone = postCustomer.phone;
                    SyncCustomerDisplayModel result = SyncCustomerDisplayModel(
                        code: customerCode,
                        phone: customerPhone,
                        name: customerName);
                    response.write(jsonEncode(result.toJson()));
                    try {
                      global
                          .posHoldProcessResult[
                              global.findPosHoldProcessResultIndex(
                                  global.posHoldActiveCode)]
                          .customerCode = customerCode;
                      global
                          .posHoldProcessResult[
                              global.findPosHoldProcessResultIndex(
                                  global.posHoldActiveCode)]
                          .customerName = customerName;
                      global
                          .posHoldProcessResult[
                              global.findPosHoldProcessResultIndex(
                                  global.posHoldActiveCode)]
                          .customerPhone = customerPhone;
                      // ประมวลผลหน้าจอขายใหม่
                      PosProcess().sumCategoryCount(
                          value: global
                              .posHoldProcessResult[
                                  global.findPosHoldProcessResultIndex(
                                      global.posHoldActiveCode)]
                              .posProcess);
                      if (global.functionPosScreenRefresh != null) {
                        global.functionPosScreenRefresh!(
                            global.posHoldActiveCode);
                      }
                    } catch (e) {
                      serviceLocator<Log>().error(e);
                    }
                    break;
                }
              } catch (e) {
                stderr.writeln(e.toString());
              }
            }
          }
          await response.flush();
          await response.close();
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
