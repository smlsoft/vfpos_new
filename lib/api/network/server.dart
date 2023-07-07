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

Future<void> orderSumAndUpdateTable(String tableNumber) async {
  double orderCount = 0;
  double amount = 0.0;
  {
    // รวมจาก OrderTemp ยังไม่กดส่งรายการ
    final result = global.objectBoxStore
        .box<OrderTempObjectBoxStruct>()
        .query(OrderTempObjectBoxStruct_.orderId
            .equals(tableNumber)
            .and(OrderTempObjectBoxStruct_.isClose.equals(1)))
        .build()
        .find();
    for (var order in result) {
      orderCount += order.qty;
      amount += orderCalcSumAmount(order);
    }
  }
  {
    // รวมจาก Hold ที่กดส่งรายการแล้ว
    PosProcess processHold = PosProcess();
    var result =
        await processHold.process(holdCode: "T-" + tableNumber, docMode: 1);
    orderCount += result.total_piece;
    amount += result.total_amount;
  }
  final boxTable = global.objectBoxStore.box<TableProcessObjectBoxStruct>();
  final resultTable = boxTable
      .query(TableProcessObjectBoxStruct_.number.equals(tableNumber))
      .build()
      .findFirst();
  if (resultTable != null) {
    print(
        " orderTempSumAndUpdateTable : $tableNumber Order Count : $orderCount Amount : $amount");
    resultTable.order_count = orderCount;
    resultTable.amount = amount;
    boxTable.put(resultTable, mode: PutMode.update);
  }
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
                      .subtract(Duration(minutes: 1))
                      .millisecondsSinceEpoch;
                  final result = box
                      .query(OrderTempObjectBoxStruct_.kdsId
                          .equals(kitchenId)
                          .and(OrderTempObjectBoxStruct_.isClose.equals(2))
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
                  int isClose = jsonData["isClose"];
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  final result = (barcode.isNotEmpty)
                      ? box
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(orderId)
                              .and(OrderTempObjectBoxStruct_.barcode
                                  .equals(barcode)
                                  .and(OrderTempObjectBoxStruct_.isClose
                                      .equals(isClose))))
                          .build()
                          .find()
                      : box
                          .query(OrderTempObjectBoxStruct_.orderId
                              .equals(orderId)
                              .and(OrderTempObjectBoxStruct_.isClose
                                  .equals(isClose)))
                          .build()
                          .find();
                  response.write(
                      jsonEncode(result.map((e) => e.toJson()).toList()));
                  break;
                case "staff.order_temp_get_data_from_orderid":
                  var jsonData = jsonDecode(httpGetData.json);
                  String orderId = jsonData["orderId"];
                  int isClose = jsonData["isClose"];
                  final box =
                      global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                  final result = box
                      .query(OrderTempObjectBoxStruct_.orderId
                          .equals(orderId)
                          .and(OrderTempObjectBoxStruct_.isClose
                              .equals(isClose)))
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
                case "get_all_buffet_mode":
                  List<BuffetModeObjectBoxStruct> boxData = global
                      .objectBoxStore
                      .box<BuffetModeObjectBoxStruct>()
                      .getAll();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
                  break;
                case "get_all_table":
                  List<TableProcessObjectBoxStruct> boxData = global
                      .objectBoxStore
                      .box<TableProcessObjectBoxStruct>()
                      .getAll();
                  response.write(
                      jsonEncode(boxData.map((e) => e.toJson()).toList()));
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
                      if (oldOrder.qty - qty != 0) {
                        oldOrder.qty = oldOrder.qty - qty;
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(oldOrder, mode: PutMode.update);
                      } else {
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .remove(oldOrder.id);
                      }
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
                            List<ProductOptionModel> optionList =
                                (optionJson as List)
                                    .map((e) => ProductOptionModel.fromJson(e))
                                    .toList();
                            for (var option in optionList) {
                              for (var choice in option.choices) {
                                if (choice.selected == true) {
                                  // เพิ่มรายการ
                                  PosLogObjectBoxStruct data =
                                      PosLogObjectBoxStruct(
                                          log_date_time: DateTime.now(),
                                          guid_ref: dataPosLog.guid_auto_fixed,
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
                        orderSumAndUpdateTable(oldOrder.orderId);
                      }
                    }
                    break;
                  case "staff.order_temp_init":
                    var jsonData = jsonDecode(httpPost.data);
                    String orderId = jsonData["orderId"];
                    final box =
                        global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                    // ตรวจสอบว่าไม่มี Option และเคยสั่งไปแล้ว จะได้เพิ่ม Qty
                    box
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.isClose.equals(0)))
                        .build()
                        .remove();
                    orderSumAndUpdateTable(orderId);
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
                            .and(OrderTempObjectBoxStruct_.barcode
                                .equals(barcode)))
                        .build()
                        .remove();
                    orderSumAndUpdateTable(orderId);
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
                    orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_send_order_by_orderid":
                    String orderId = httpPost.data;
                    final box =
                        global.objectBoxStore.box<OrderTempObjectBoxStruct>();
                    final result = box
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
                            .and(OrderTempObjectBoxStruct_.isClose.equals(0)))
                        .build()
                        .find();
                    for (var order in result) {
                      // ปรับปรุงว่าส่ง Order ได้
                      order.isClose = 1;
                    }
                    box.putMany(result, mode: PutMode.update);
                    orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_delete_by_guid":
                    var jsonData = jsonDecode(httpPost.data);
                    String orderId = jsonData["orderId"];
                    String orderGuid = jsonData["guid"];
                    // กรณีมีการคุมสต๊อก คืนค่าสต๊อก
                    var orderTempOld = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(orderId)
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
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(orderGuid)))
                        .build()
                        .remove();
                    orderSumAndUpdateTable(orderId);
                    break;
                  case "staff.order_temp_insert":
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
                              .and(OrderTempObjectBoxStruct_.isClose.equals(0)))
                          .build()
                          .findFirst();
                      if (findResult != null) {
                        findResult.qty += jsonData.qty;
                        findResult.amount = orderCalcSumAmount(findResult);
                        box.put(findResult, mode: PutMode.update);
                      } else {
                        jsonData.amount = orderCalcSumAmount(jsonData);
                        box.put(jsonData, mode: PutMode.insert);
                      }
                    }
                    response.write(result);
                    break;
                  case "staff.order_temp_update":
                    int result = 0;
                    bool isUpdate = false;
                    OrderTempObjectBoxStruct jsonData =
                        OrderTempObjectBoxStruct.fromJson(
                            jsonDecode(httpPost.data));
                    // รายการเดิม
                    final findOtherTempResult = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(jsonData.orderId)
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(jsonData.orderGuid))
                            .and(OrderTempObjectBoxStruct_.isClose.equals(0)))
                        .build()
                        .findFirst();
                    // ตรวจสอบยอดคงเหลือ (กรณีสินค้าคุมยอดคงเหลือ)
                    var productBarcodeStatus =
                        await ProductBarcodeStatusHelper()
                            .selectByBarcodeFirst(jsonData.barcode);
                    if (productBarcodeStatus != null &&
                        productBarcodeStatus.orderAutoStock) {
                      if (productBarcodeStatus.qtyBalance -
                              (jsonData.qty - findOtherTempResult!.qty) <
                          0) {
                        // สินค้าคุมยอดคงเหลือ และ ยอดคงเหลือไม่พอ
                        result = 1;
                      } else {
                        isUpdate = true;
                        productBarcodeStatus.qtyBalance -=
                            (jsonData.qty - findOtherTempResult.qty);
                        global.objectBoxStore
                            .box<ProductBarcodeStatusObjectBoxStruct>()
                            .put(productBarcodeStatus, mode: PutMode.update);
                        result = 0;
                      }
                    } else {
                      isUpdate = true;
                    }
                    if (isUpdate == true) {
                      if (findOtherTempResult != null) {
                        jsonData.amount = orderCalcSumAmount(jsonData);
                        global.objectBoxStore
                            .box<OrderTempObjectBoxStruct>()
                            .put(jsonData, mode: PutMode.update);
                        result = 0;
                      } else {
                        result = 2;
                      }
                      orderSumAndUpdateTable(jsonData.orderId);
                    }
                    final test = global.objectBoxStore
                        .box<OrderTempObjectBoxStruct>()
                        .query(OrderTempObjectBoxStruct_.orderId
                            .equals(jsonData.orderId)
                            .and(OrderTempObjectBoxStruct_.orderGuid
                                .equals(jsonData.orderGuid))
                            .and(OrderTempObjectBoxStruct_.isClose.equals(0)))
                        .build()
                        .find();
                    for (var x in test) {
                      print(x.qty.toString());
                    }
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
                              .equals("T-" + fromTableNumber))
                          .build()
                          .find();
                      for (int index = 0; index < posLogs.length; index++) {
                        posLogs[index].hold_code = "T-" + toTableNumber;
                        global.objectBoxStore
                            .box<PosLogObjectBoxStruct>()
                            .put(posLogs[index]);
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
