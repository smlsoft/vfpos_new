import 'dart:typed_data';
import 'package:dedepos/api/clickhouse/clickhouse_api.dart';
import 'package:dedepos/api/network/sync_model.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/core/core.dart';
import 'package:dedepos/db/pos_log_helper.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/db/product_barcode_status_helper.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_util.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/product_option_model.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_status_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/staff_client_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_process.dart';
import 'package:dedepos/util/pos_compile_process.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/util/printer.dart' as printer;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

double orderCalcSumAmount(OrderTempObjectBoxStruct order) {
  double amount = order.qty * order.price;
  if (order.optionSelected.isNotEmpty) {
    List<OrderProductOptionModel> options = jsonDecode(order.optionSelected).map<OrderProductOptionModel>((e) => OrderProductOptionModel.fromJson(e)).toList();
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

Future<void> rebuildOrderToHoldBill(String holdCode, String tableNumber) async {
  var data = global.objectBoxStore.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals(holdCode)).build().find();
  if (data.isNotEmpty) {
    for (var item in data) {
      global.objectBoxStore.box<PosLogObjectBoxStruct>().remove(item.id);
    }
  }
  // ดึงรายการที่สั่งไปแล้ว มาสร้างรายการ Hold Bill
  var dataTemp = global.objectBoxStore
      .box<OrderTempObjectBoxStruct>()
      .query(OrderTempObjectBoxStruct_.orderId.equals(tableNumber).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)))
      .build()
      .find();
  if (dataTemp.isNotEmpty) {
    await saveOrderToHoldBill(dataTemp);
  }
}

Future<void> saveOrderToHoldBill(List<OrderTempObjectBoxStruct> orders) async {
  if (orders.isNotEmpty) {
    for (var order in orders) {
      String holdCode = "T-${order.orderId}";
      ProductBarcodeObjectBoxStruct? productSelect = await ProductBarcodeHelper().selectByBarcodeFirst(order.barcode);
      if (productSelect != null) {
        double price = global.getProductPrice(productSelect.prices, 1);
        PosLogObjectBoxStruct data = PosLogObjectBoxStruct(
            log_date_time: DateTime.now(),
            doc_mode: global.posScreenToInt(global.PosScreenModeEnum.posSale),
            hold_code: holdCode,
            command_code: 1,
            barcode: order.barcode,
            name: productSelect.names,
            unit_code: productSelect.unit_code,
            unit_name: productSelect.unit_names,
            qty: order.qty,
            price: price);
        String insertGuid = data.guid_auto_fixed;
        await PosLogHelper().insert(data);
        // เพิ่มส่วนขยาย (option)
        if (order.optionSelected.isNotEmpty) {
          List<OrderProductOptionModel> options = jsonDecode(order.optionSelected).map<OrderProductOptionModel>((e) => OrderProductOptionModel.fromJson(e)).toList();
          for (var option in options) {
            for (var choice in option.choices) {
              if (choice.selected) {
                List<PosLogObjectBoxStruct> posLogSelect = await PosLogHelper().selectByGuidFixed(insertGuid);
                if (posLogSelect.isNotEmpty) {
                  await PosLogHelper().insert(PosLogObjectBoxStruct(
                      guid_code_ref: "",
                      doc_mode: global.posScreenToInt(global.PosScreenModeEnum.posSale),
                      guid_ref: insertGuid,
                      log_date_time: DateTime.now(),
                      hold_code: holdCode,
                      command_code: 101,
                      extra_code: "",
                      code: choice.guid,
                      price: choice.priceValue,
                      name: jsonEncode(choice.names),
                      qty_fixed: choice.qty,
                      qty: choice.qty,
                      selected: true));
                }
              }
            }
          }
        }
      }
    }
  }
}

Future<void> serverPost(HttpPost httpPost, HttpResponse response) async {
  switch (httpPost.command) {
    case "register_staff_device":
      SyncStaffDeviceModel jsonCategory = SyncStaffDeviceModel.fromJson(jsonDecode(httpPost.data));
      bool found = false;
      int foundIndex = -1;
      for (int index = 0; index < global.staffClientList.length; index++) {
        if (global.staffClientList[index].guid == jsonCategory.clientGuid) {
          found = true;
          foundIndex = index;
          break;
        }
      }
      if (found) {
        global.staffClientList.removeAt(foundIndex);
      }
      global.staffClientList
          .add(StaffClientObjectBoxStruct(guid: jsonCategory.clientGuid, name: jsonCategory.clientName, device_guid: jsonCategory.clientGuid, device_ip: jsonCategory.clientIp));
      response.write("success");
      break;
    case "staff.print_table_and_qrcode":
      var jsonObject = jsonDecode(httpPost.data);
      String tableNumber = jsonObject["number"];
      final result = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(tableNumber)).build().findFirst();
      if (result != null) {
        printer.printTableQrCode(fullDetail: false, tableManagerMode: global.TableManagerEnum.openTable, table: result, qrCode: global.qrCodeOrderOnline(result.qr_code));
      }
      break;
    case "staff.set_kds_start_cooking":
      // เริ่มทำอาหารได้
      var jsonData = jsonDecode(httpPost.data);
      String orderNumber = jsonData["orderNumber"];

      // update Ticket ให้เป็น ทำอาหารทันที
      var dataTicket = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.delivery_number.equals(orderNumber)).build().findFirst();
      if (dataTicket != null) {
        dataTicket.make_food_immediately = true;
        global.objectBoxStore.box<TableProcessObjectBoxStruct>().put(dataTicket, mode: PutMode.update);
        // update สถานะ รายการย่อย ให้พร้อมส่งเข้าครัว
        var dataTicketDetail = global.objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .query(OrderTempObjectBoxStruct_.orderId
                .equals(dataTicket.number)
                .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
                .and(OrderTempObjectBoxStruct_.isOrderReadySendKds.equals(false)))
            .build()
            .find();
        for (var item in dataTicketDetail) {
          item.isOrderReadySendKds = true;
        }
        global.objectBoxStore.box<OrderTempObjectBoxStruct>().putMany(dataTicketDetail, mode: PutMode.update);
      }
      response.write(true);
      break;
    case "staff.insert_delivery_ticket":
      late int runningNo;
      String runningStart = DateFormat("yyMMdd").format(DateTime.now());
      var dataRunning = global.objectBoxStore
          .box<TableProcessObjectBoxStruct>()
          .query(TableProcessObjectBoxStruct_.delivery_number.notEquals("").and(TableProcessObjectBoxStruct_.delivery_number.lessThan("$runningStart-9999")))
          .order(TableProcessObjectBoxStruct_.delivery_number, flags: Order.descending)
          .build()
          .findFirst();
      if (dataRunning != null) {
        runningNo = int.parse(dataRunning.delivery_number.substring(runningStart.length + 1)) + 1;
      } else {
        runningNo = 1;
      }
      String runningNumber = "$runningStart-${runningNo.toString().padLeft(4, "0")}";
      // สร้าง Ticket Delivery ใหม่
      var data = TableProcessObjectBoxStruct.fromJson(jsonDecode(httpPost.data));
      data.delivery_number = runningNumber;
      global.objectBoxStore.box<TableProcessObjectBoxStruct>().put(data, mode: PutMode.insert);
      response.write(runningNumber);
      break;
    case "staff.update_product_barcode_status_qty":
      var jsonData = jsonDecode(httpPost.data);
      String barcode = jsonData["barcode"];
      double qty = jsonData["qty"];
      var productStatus = global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().query(ProductBarcodeStatusObjectBoxStruct_.barcode.equals(barcode)).build().findFirst();
      if (productStatus != null) {
        productStatus.qtyBalance += qty;
        global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(productStatus, mode: PutMode.update);
      }
      break;
    case "kds.order_temp_update_kds_success_status":
      var jsonData = jsonDecode(httpPost.data);
      String guid = jsonData["guid"];
      var order = global.objectBoxStore.box<OrderTempObjectBoxStruct>().query(OrderTempObjectBoxStruct_.orderGuid.equals(guid)).build().findFirst();
      if (order != null) {
        order.kdsSuccess = !order.kdsSuccess;
        order.kdsSuccessTime = DateTime.now();
        global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(order, mode: PutMode.update);
      }
      break;
    case "staff.product_barcode_status_update":
      var data = ProductBarcodeStatusObjectBoxStruct.fromJson(jsonDecode(httpPost.data));
      var productBarcode =
          global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().query(ProductBarcodeStatusObjectBoxStruct_.barcode.equals(data.barcode)).build().findFirst();
      if (productBarcode != null) {
        global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(data, mode: PutMode.update);
      }
      break;
    case "staff.order_temp_cancel_by_guid":
      // ยกเลิก Order
      var jsonData = jsonDecode(httpPost.data);
      String guid = jsonData["guid"];
      double qty = jsonData["qty"];
      var oldOrder = global.objectBoxStore.box<OrderTempObjectBoxStruct>().query(OrderTempObjectBoxStruct_.orderGuid.equals(guid)).build().findFirst();
      if (oldOrder != null) {
        if (oldOrder.qty - qty >= 0) {
          oldOrder.qty = oldOrder.qty - qty;
          oldOrder.cancelQty = oldOrder.cancelQty + qty;
          oldOrder.lastUpdateDateTime = DateTime.now();
          global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(oldOrder, mode: PutMode.update);
          // ลบ Hold แล้วสร้างใหม่
          String holdId = "T-${oldOrder.orderId}";
          global.objectBoxStore.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals(holdId)).build().remove();
          var orderList = global.objectBoxStore.box<OrderTempObjectBoxStruct>().query(OrderTempObjectBoxStruct_.orderId.equals(oldOrder.orderId)).build().find();
          if (orderList.isNotEmpty) {
            for (var order in orderList) {
              // เพิ่มรายการ
              PosLogObjectBoxStruct dataPosLog = PosLogObjectBoxStruct(
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
                List<ProductOptionModel> optionList = (optionJson as List).map((e) => ProductOptionModel.fromJson(e)).toList();
                for (var option in optionList) {
                  for (var choice in option.choices) {
                    if (choice.selected == true) {
                      // เพิ่มรายการ
                      PosLogObjectBoxStruct data = PosLogObjectBoxStruct(
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
                          price: double.tryParse(choice.price) ?? 0);
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
      var productBarcodeStatus = await ProductBarcodeStatusHelper().selectByBarcodeFirst(barcode);
      if (productBarcodeStatus != null && productBarcodeStatus.orderAutoStock) {
        var orderTemp = global.objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.barcode.equals(barcode)))
            .build()
            .find();
        if (orderTemp.isNotEmpty) {
          for (var order in orderTemp) {
            productBarcodeStatus.qtyBalance += order.qty;
            global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(productBarcodeStatus, mode: PutMode.update);
          }
        }
      }
      // ลบรายการ
      global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId
              .equals(orderId)
              .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
              .and(OrderTempObjectBoxStruct_.isOrder.equals(true))
              .and(OrderTempObjectBoxStruct_.barcode.equals(barcode)))
          .build()
          .remove();
      global.orderSumAndUpdateTable(orderId);
      break;
    case "staff.order_temp_delete_by_orderid":
      String orderId = httpPost.data;
      // กรณีมีการคุมสต๊อก คืนค่าสต๊อก
      var orderTemp = global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.orderId.equals(orderId)))
          .build()
          .find();
      if (orderTemp.isNotEmpty) {
        for (var order in orderTemp) {
          var productBarcodeStatus = await ProductBarcodeStatusHelper().selectByBarcodeFirst(order.barcode);
          if (productBarcodeStatus != null && productBarcodeStatus.orderAutoStock) {
            productBarcodeStatus.qtyBalance += order.qty;
            global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(productBarcodeStatus, mode: PutMode.update);
          }
        }
      }
      global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.orderId.equals(orderId)))
          .build()
          .remove();
      global.orderSumAndUpdateTable(orderId);
      break;
    case "staff.order_temp_send_order_by_orderid":
      // ส่ง Order ไปที่ครัว และ Cashier
      String orderId = httpPost.data;
      final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
      final result = box
          .query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)).and(OrderTempObjectBoxStruct_.isOrder.equals(true)))
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
              .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
              .and(OrderTempObjectBoxStruct_.isOrder.equals(true))
              .and(OrderTempObjectBoxStruct_.orderGuid.equals(orderGuid)))
          .build()
          .findFirst();
      if (orderTempOld != null) {
        var productBarcodeStatus = await ProductBarcodeStatusHelper().selectByBarcodeFirst(orderTempOld.barcode);
        if (productBarcodeStatus != null && productBarcodeStatus.orderAutoStock) {
          productBarcodeStatus.qtyBalance += orderTempOld.qty;
          global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(productBarcodeStatus, mode: PutMode.update);
        }
      }
      global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId
              .equals(orderId)
              .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
              .and(OrderTempObjectBoxStruct_.isOrder.equals(true))
              .and(OrderTempObjectBoxStruct_.orderGuid.equals(orderGuid)))
          .build()
          .remove();
      global.orderSumAndUpdateTable(orderId);
      break;
    case "staff.order_temp_insert":
      // เพิ่มรายการ (orderTemp) ยังไม่ส่ง Order
      int result = 0;
      bool isInsertOrUpdate = false;
      OrderTempObjectBoxStruct jsonData = OrderTempObjectBoxStruct.fromJson(jsonDecode(httpPost.data));
      // ตรวจสอบยอดคงเหลือ (กรณีสินค้าคุมยอดคงเหลือ)
      var productBarcodeStatus = await ProductBarcodeStatusHelper().selectByBarcodeFirst(jsonData.barcode);
      if (productBarcodeStatus != null && productBarcodeStatus.orderAutoStock) {
        if (productBarcodeStatus.qtyBalance - jsonData.qty < 0) {
          // สินค้าคุมยอดคงเหลือ และ ยอดคงเหลือไม่พอ
          result = 1;
          isInsertOrUpdate = false;
        } else {
          productBarcodeStatus.qtyBalance -= jsonData.qty;
          global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(productBarcodeStatus);
          result = 0;
          isInsertOrUpdate = true;
        }
      } else {
        result = 0;
        isInsertOrUpdate = true;
      }
      if (isInsertOrUpdate) {
        final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
        // ตรวจสอบว่าไม่มี Option และเคยสั่งไปแล้ว จะได้เพิ่ม Qty
        final findResult = box
            .query(OrderTempObjectBoxStruct_.orderId
                .equals(jsonData.orderId)
                .and(OrderTempObjectBoxStruct_.barcode
                    .equals(jsonData.barcode)
                    .and(OrderTempObjectBoxStruct_.remark.equals(jsonData.remark).and(OrderTempObjectBoxStruct_.optionSelected.equals(jsonData.optionSelected))))
                .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
                .and(OrderTempObjectBoxStruct_.isOrder.equals(true).and(OrderTempObjectBoxStruct_.takeAway.equals(jsonData.takeAway))))
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
        await global.orderSumAndUpdateTable(jsonData.orderId);
      }
      response.write(result);
      break;
    case "staff.order_temp_update_for_split":
      bool insertNewOrderData = true;
      // 0=ต้นทาง, 1=ปลายทางม ,2=orderGuid (ได้ครั้งละ 1 qty)
      OrderTempUpdateForSplitModel jsonData = OrderTempUpdateForSplitModel.fromJson(jsonDecode(httpPost.data));
      // รายการเดิม ถ้ามีให้ update ถ้าไม่มีให้เพิ่ม
      print("ย้ายจาก ${jsonData.sourceTable} ไป ${jsonData.targetTable}");
      final findSourceTempResult = global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId
              .equals(jsonData.sourceTable)
              .and(OrderTempObjectBoxStruct_.orderGuid.equals(jsonData.sourceGuid).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))))
          .build()
          .findFirst();
      final findTargetTempResult = global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId.equals(jsonData.targetTable).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)))
          .build()
          .find();
      if (findSourceTempResult != null && findSourceTempResult.qty > 0) {
        for (var target in findTargetTempResult) {
          if (target.barcode == findSourceTempResult.barcode && target.remark == findSourceTempResult.remark && target.optionSelected == findSourceTempResult.optionSelected) {
            // กรณีพบข้อมูลเดิมในโต๊ะปลายทาง
            target.qty += 1;
            target.orderQty += 1;
            target.amount = orderCalcSumAmount(target);
            global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(target, mode: PutMode.update);
            findSourceTempResult.qty -= 1;
            findSourceTempResult.orderQty -= 1;
            findSourceTempResult.amount = orderCalcSumAmount(findSourceTempResult);
            global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(findSourceTempResult, mode: PutMode.update);
            insertNewOrderData = false;
            break;
          }
        }
        if (insertNewOrderData) {
          // กรณีไม่พบข้อมูลเดิมในโต๊ะปลายทาง
          // ลดจำนวนของเก่า
          findSourceTempResult.qty -= 1;
          findSourceTempResult.orderQty -= 1;
          findSourceTempResult.amount = orderCalcSumAmount(findSourceTempResult);
          global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(findSourceTempResult, mode: PutMode.update);
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
            isOrderSendKdsSuccess: findSourceTempResult.isOrderSendKdsSuccess,
            kdsId: findSourceTempResult.kdsId,
            cancelQty: findSourceTempResult.cancelQty,
            orderQty: 1,
            deliveryNumber: findSourceTempResult.deliveryNumber,
            deliveryCode: findSourceTempResult.deliveryCode,
            isOrderReadySendKds: findSourceTempResult.isOrderReadySendKds,
            deliveryName: findSourceTempResult.deliveryName,
            lastUpdateDateTime: findSourceTempResult.lastUpdateDateTime,
          );
          newOrderTemp.orderId = jsonData.targetTable;
          newOrderTemp.orderGuid = Uuid().v4();
          newOrderTemp.qty = 1;
          newOrderTemp.orderQty = 1;
          newOrderTemp.amount = orderCalcSumAmount(newOrderTemp);
          global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(newOrderTemp, mode: PutMode.insert);
        }
        {
          // เพิ่มโต๊ะปลายทาง
          final findSourceTableResult =
              global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(jsonData.sourceTable)).build().findFirst();
          final findTargetTableResult =
              global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(jsonData.targetTable)).build().findFirst();
          if (findTargetTableResult == null) {
            final newTable = TableProcessObjectBoxStruct(
              number: jsonData.targetTable,
              guidfixed: Uuid().v4(),
              number_main: findSourceTableResult!.number_main,
              names: findSourceTableResult.names,
              zone: findSourceTableResult.zone,
              table_child_count: 0,
              table_al_la_crate_mode: findSourceTableResult.table_al_la_crate_mode,
              table_open_datetime: findSourceTableResult.table_open_datetime,
              table_status: findSourceTableResult.table_status,
              delivery_ticket_number: findSourceTableResult.delivery_ticket_number,
              remark: findSourceTableResult.remark,
              order_count: findSourceTableResult.order_count,
              amount: findSourceTableResult.amount,
              order_success: findSourceTableResult.order_success,
              qr_code: findSourceTableResult.qr_code,
              man_count: findSourceTableResult.man_count,
              woman_count: findSourceTableResult.woman_count,
              child_count: findSourceTableResult.child_count,
              buffet_code: findSourceTableResult.buffet_code,
              customer_address: findSourceTableResult.customer_address,
              customer_code_or_telephone: findSourceTableResult.customer_code_or_telephone,
              customer_name: findSourceTableResult.customer_name,
              delivery_cook_success: findSourceTableResult.delivery_cook_success,
              delivery_cook_success_datetime: findSourceTableResult.delivery_cook_success_datetime,
              delivery_code: findSourceTableResult.delivery_code,
              delivery_number: findSourceTableResult.delivery_number,
              delivery_status: findSourceTableResult.delivery_status,
              delivery_send_success: findSourceTableResult.delivery_send_success,
              delivery_send_success_datetime: findSourceTableResult.delivery_send_success_datetime,
              is_delivery: findSourceTableResult.is_delivery,
              open_by_staff_code: findSourceTableResult.open_by_staff_code,
              make_food_immediately: findSourceTableResult.make_food_immediately,
            );
            global.objectBoxStore.box<TableProcessObjectBoxStruct>().put(newTable, mode: PutMode.insert);
          }
        }
      }
      {
        // ลบรายการ Qty = 0 ออก
        final findSourceTempResultDelete = global.objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .query(OrderTempObjectBoxStruct_.orderId.equals(jsonData.sourceTable).or(OrderTempObjectBoxStruct_.orderId.equals(jsonData.targetTable)))
            .build()
            .find();
        for (var item in findSourceTempResultDelete) {
          if (item.orderQty == 0) {
            global.objectBoxStore.box<OrderTempObjectBoxStruct>().remove(item.id);
          }
        }
      }
      // สร้างใหม่ (Hold)
      await rebuildOrderToHoldBill("T-${jsonData.sourceTable}", jsonData.sourceTable);
      await rebuildOrderToHoldBill("T-${jsonData.targetTable}", jsonData.targetTable);
      // คำนวณใหม่
      await global.orderSumAndUpdateTable(jsonData.sourceTable);
      await global.orderSumAndUpdateTable(jsonData.targetTable);
      response.write(true);
      break;
    case "staff.order_temp_update":
      int result = 0;
      bool isUpdate = false;
      OrderTempObjectBoxStruct jsonData = OrderTempObjectBoxStruct.fromJson(jsonDecode(httpPost.data));
      // รายการเดิม
      final findOldTempResult = global.objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId
              .equals(jsonData.orderId)
              .and(OrderTempObjectBoxStruct_.orderGuid.equals(jsonData.orderGuid))
              .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false))
              .and(OrderTempObjectBoxStruct_.isOrder.equals(true)))
          .build()
          .findFirst();
      // ตรวจสอบยอดคงเหลือ (กรณีสินค้าคุมยอดคงเหลือ)
      var productBarcodeStatus = await ProductBarcodeStatusHelper().selectByBarcodeFirst(jsonData.barcode);
      if (productBarcodeStatus != null && productBarcodeStatus.orderAutoStock) {
        if (productBarcodeStatus.qtyBalance - (jsonData.qty - findOldTempResult!.qty) < 0) {
          // สินค้าคุมยอดคงเหลือ และ ยอดคงเหลือไม่พอ
          result = 1;
        } else {
          isUpdate = true;
          productBarcodeStatus.qtyBalance -= (jsonData.qty - findOldTempResult.qty);
          global.objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().put(productBarcodeStatus, mode: PutMode.update);
          result = 0;
        }
      } else {
        isUpdate = true;
      }
      if (isUpdate == true) {
        if (findOldTempResult != null) {
          jsonData.amount = orderCalcSumAmount(jsonData);
          global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(jsonData, mode: PutMode.update);
          result = 0;
        } else {
          result = 2;
        }
        global.orderSumAndUpdateTable(jsonData.orderId);
      }
      response.write(result);
      break;
    case "staff.close_table":
      String docNumber = "";
      var jsonObject = jsonDecode(httpPost.data);
      CloseTableModel closeData = CloseTableModel.fromJson(jsonObject);
      final box = global.objectBoxStore.box<TableProcessObjectBoxStruct>();
      final result = box.query(TableProcessObjectBoxStruct_.number.equals(closeData.table.number)).build().findFirst();
      if (result != null) {
        switch (closeData.payMode) {
          case 0: // ชำระที่ Cashier
            result.table_status = 2;
            break;
          case 1: // ชำระที่โต๊ะ
            result.table_status = 3;
            break;
          case 2: // ชำระที่โต๊ะ ด้วย QR Code
            result.table_status = 3;
            break;
        }
        box.put(closeData.table, mode: PutMode.update);
        if (result.table_status == 3) {
          // สร้างบิล และพิมพ์ใบเสร็จ
          await saveBill(docMode: global.posScreenToInt(global.PosScreenModeEnum.posSale), cashAmount: closeData.process.total_amount, discountFormula: closeData.discountFormula)
              .then((value) async {
            if (value.docNumber.isNotEmpty) {
              docNumber = value.docNumber;
              printBill(
                posScreenMode: global.PosScreenModeEnum.posSale,
                docDate: value.docDate,
                docNo: value.docNumber,
                languageCode: global.userScreenLanguage,
              );
              // ร้านอาหาร update โต๊ะ
              final box = global.objectBoxStore.box<TableProcessObjectBoxStruct>();
              final result = box.query(TableProcessObjectBoxStruct_.number.equals(closeData.table.number)).build().findFirst();
              if (result != null) {
                // ถ้าเป็นโต๊ะเสริม ให้ลบออก
                if (result.number.contains("#")) {
                  box.remove(result.id);
                } else {
                  result.table_status = 0;
                  box.put(result);
                }
              }
              if (closeData.slipImage.isNotEmpty) {
                // เก็บ slip base64
                Uint8List imageBytes = base64Decode(closeData.slipImage);
                String mainPath = "payslip";
                final dateDirectory = await global.createPath(mainPath, DateTime.now());
                // Save the image to the new directory
                final path = "${dateDirectory.path}/${value.docNumber}.jpg";
                print(path);
                final file = File(path);
                await file.writeAsBytes(imageBytes);
              }
              syncBillProcess();
            }
          });
          {
            // update สถานะโต๊ะ = 2 รอคิดเงิน (order online)
            String query = "alter table dedeorder.tableinfo update tablestatus=2 where tablenumber='${closeData.table.number}' and shopid='${global.shopId}'";
            clickHouseUpdate(query);
          }
        }
        response.write(docNumber);
      }
      break;
    case "staff.update_table":
      var jsonObject = jsonDecode(httpPost.data);
      TableProcessObjectBoxStruct getTable = TableProcessObjectBoxStruct.fromJson(jsonObject);
      final box = global.objectBoxStore.box<TableProcessObjectBoxStruct>();
      final result = box.query(TableProcessObjectBoxStruct_.number.equals(getTable.number)).build().findFirst();
      if (result != null) {
        box.put(getTable, mode: PutMode.update);
        await global.orderSumAndUpdateTable(getTable.number);
        switch (getTable.table_status) {
          case 1:
            // พิมพ์ใบเปิดโต๊ะ
            printer.printTableQrCode(tableManagerMode: global.TableManagerEnum.openTable, table: getTable, qrCode: global.qrCodeOrderOnline(getTable.qr_code));
            break;
        }
        await rebuildOrderToHoldBill("T-${getTable.number}", getTable.number);
      }
      break;
    case "staff.move_table":
      // ย้ายโต๊ะ
      var jsonObject = jsonDecode(httpPost.data);
      String fromTableNumber = jsonObject["from_table"];
      String toTableNumber = jsonObject["to_table"];
      final fromTableResult = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(fromTableNumber)).build().findFirst();
      final toTableResult = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(toTableNumber)).build().findFirst();
      if (fromTableResult != null && toTableResult != null) {
        // Update เปิดโต๊ะ ปลายทาง
        toTableResult.number_main = toTableResult.number;
        toTableResult.table_status = 1;
        toTableResult.man_count = fromTableResult.man_count;
        toTableResult.woman_count = fromTableResult.woman_count;
        toTableResult.child_count = fromTableResult.child_count;
        toTableResult.table_al_la_crate_mode = fromTableResult.table_al_la_crate_mode;
        toTableResult.buffet_code = fromTableResult.buffet_code;
        toTableResult.amount = fromTableResult.amount;
        toTableResult.order_count = fromTableResult.order_count;
        toTableResult.table_open_datetime = fromTableResult.table_open_datetime;
        global.objectBoxStore.box<TableProcessObjectBoxStruct>().put(toTableResult, mode: PutMode.update);
        // Update ปิดโต๊ะ ต้นทาง
        fromTableResult.table_status = 0;
        fromTableResult.order_count = 0;
        fromTableResult.amount = 0;
        fromTableResult.man_count = 0;
        fromTableResult.woman_count = 0;
        fromTableResult.child_count = 0;
        fromTableResult.number_main = "";
        global.objectBoxStore.box<TableProcessObjectBoxStruct>().put(fromTableResult);
        // ย้าย Order (Hold Bill)
        final posLogs = global.objectBoxStore.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals("T-$fromTableNumber")).build().find();
        for (int index = 0; index < posLogs.length; index++) {
          posLogs[index].hold_code = "T-$toTableNumber";
          global.objectBoxStore.box<PosLogObjectBoxStruct>().put(posLogs[index]);
        }
        // ย้าย Order (Order Temp)
        final orderTemps = global.objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .query(OrderTempObjectBoxStruct_.orderId.equals(fromTableNumber).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)))
            .build()
            .find();
        for (int index = 0; index < orderTemps.length; index++) {
          orderTemps[index].orderId = toTableNumber;
          orderTemps[index].orderIdMain = toTableNumber;
          global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(orderTemps[index], mode: PutMode.update);
        }
        // print ticket to cashier and kitchen station
        printer.printTableQrCode(
            tableManagerMode: global.TableManagerEnum.moveTable,
            table: fromTableResult,
            fromTable: fromTableResult.number,
            toTable: toTableResult.number,
            qrCode: global.qrCodeOrderOnline(toTableResult.qr_code));
        // สร้างใหม่ (Hold)
        await rebuildOrderToHoldBill("T-${fromTableResult.number}", fromTableResult.number);
        await rebuildOrderToHoldBill("T-$toTableNumber", toTableNumber);
        // คำนวณใหม่
        await global.orderSumAndUpdateTable(fromTableResult.number);
        await global.orderSumAndUpdateTable(toTableNumber);
      }
      break;
    case "staff.merge_table":
      // รวมโต๊ะ
      var jsonObject = jsonDecode(httpPost.data);
      String fromTableNumber = jsonObject["from_table"];
      String toTableNumber = jsonObject["to_table"];
      final fromTableResult = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(fromTableNumber)).build().findFirst();
      final toTableResult = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(toTableNumber)).build().findFirst();
      if (fromTableResult != null && toTableResult != null) {
        // Update โต๊ะ ปลายทาง
        toTableResult.table_status = 1;
        toTableResult.man_count += fromTableResult.man_count;
        toTableResult.woman_count += fromTableResult.woman_count;
        toTableResult.child_count += fromTableResult.child_count;
        toTableResult.table_al_la_crate_mode = fromTableResult.table_al_la_crate_mode;
        toTableResult.buffet_code = fromTableResult.buffet_code;
        toTableResult.amount = fromTableResult.amount;
        toTableResult.order_count = fromTableResult.order_count;
        toTableResult.table_open_datetime = fromTableResult.table_open_datetime;
        global.objectBoxStore.box<TableProcessObjectBoxStruct>().put(toTableResult, mode: PutMode.update);
        // ย้าย Order (Hold Bill)
        final posLogs = global.objectBoxStore.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals("T-$fromTableNumber")).build().find();
        for (int index = 0; index < posLogs.length; index++) {
          posLogs[index].hold_code = "T-$toTableNumber";
          global.objectBoxStore.box<PosLogObjectBoxStruct>().put(posLogs[index]);
        }
        // ย้าย Order (Order Temp)
        final orderTemps = global.objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .query(OrderTempObjectBoxStruct_.orderId.equals(fromTableNumber).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)))
            .build()
            .find();
        for (int index = 0; index < orderTemps.length; index++) {
          orderTemps[index].orderId = toTableNumber;
          orderTemps[index].orderIdMain = toTableNumber.split("#")[0];
          global.objectBoxStore.box<OrderTempObjectBoxStruct>().put(orderTemps[index], mode: PutMode.update);
        }
        // ลบโต๊ กรณีเป็นโต๊ะลูก
        if (fromTableNumber.contains("#")) {
          global.objectBoxStore.box<TableProcessObjectBoxStruct>().remove(fromTableResult.id);
        }
        // คำนวณใหม่
        await global.orderSumAndUpdateTable(fromTableNumber);
        await global.orderSumAndUpdateTable(toTableNumber);
      }
      break;
    case "process_result":
      PosHoldProcessModel result = PosHoldProcessModel.fromJson(jsonDecode(httpPost.data));
      global.posHoldProcessResult[global.findPosHoldProcessResultIndex(result.code)] = result;
      PosProcess().sumCategoryCount(value: global.posHoldProcessResult[global.findPosHoldProcessResultIndex(result.code)].posProcess);
      if (global.functionPosScreenRefresh != null) {
        global.functionPosScreenRefresh!(result.code);
      }
      break;
    case "PosLogHelper.insert":
      PosLogObjectBoxStruct jsonData = PosLogObjectBoxStruct.fromJson(jsonDecode(httpPost.data));
      final box = global.objectBoxStore.box<PosLogObjectBoxStruct>();
      response.write(box.put(jsonData));
      for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
        if (global.posRemoteDeviceList[index].holdCodeActive == jsonData.hold_code) {
          global.posRemoteDeviceList[index].processSuccess = false;
        }
      }
      posCompileProcess(holdCode: jsonData.hold_code, docMode: jsonData.doc_mode, detailDiscountFormula: "").then((_) {
        PosProcess().sumCategoryCount(value: global.posHoldProcessResult[global.findPosHoldProcessResultIndex(global.posHoldActiveCode)].posProcess);
        if (global.functionPosScreenRefresh != null) {
          global.functionPosScreenRefresh!(global.posHoldActiveCode);
        }
      });
      break;
    case "PosLogHelper.deleteByHoldCode":
      String holdCode = httpPost.data;
      int docMode = 0; //********* Dummy
      final box = global.objectBoxStore.box<PosLogObjectBoxStruct>();
      final ids = box.query(PosLogObjectBoxStruct_.hold_code.equals(holdCode)).build().findIds();
      box.removeMany(ids);
      posCompileProcess(holdCode: holdCode, docMode: docMode, detailDiscountFormula: "").then((_) {
        PosProcess().sumCategoryCount(value: global.posHoldProcessResult[global.findPosHoldProcessResultIndex(holdCode)].posProcess);
        if (global.functionPosScreenRefresh != null) {
          global.functionPosScreenRefresh!(global.posHoldActiveCode);
        }
      });
      break;
    case "get_device_name":
      // Return ชื่อเครื่อง server , ip server
      response.write(jsonEncode(jsonDecode('{"device": "${global.deviceName}"}') as Map));
      break;
    case "register_remote_device":
      // ลงทะเบียนเครื่องช่วยขาย
      SyncDeviceModel posClientDevice = SyncDeviceModel.fromJson(jsonDecode(httpPost.data));
      int indexFound = -1;
      for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
        if (global.posRemoteDeviceList[index].deviceId == posClientDevice.deviceId) {
          indexFound = index;
          break;
        }
      }
      if (indexFound != -1) {
        global.posRemoteDeviceList[indexFound].ip = posClientDevice.ip;
        global.posRemoteDeviceList[indexFound].holdCodeActive = posClientDevice.holdCodeActive;
        serviceLocator<Log>().debug("register_remote_device : ${posClientDevice.ip},hold_number : ${global.posRemoteDeviceList[indexFound].holdCodeActive}");
      } else {
        global.posRemoteDeviceList.add(posClientDevice);
        serviceLocator<Log>().debug("register_remote_device : ${posClientDevice.deviceId} : ${global.posRemoteDeviceList.length}");
      }
      break;
    case "register_customer_display_device":
      // ลงทะเบียนเครื่องแสดงผลลูกค้า
      SyncDeviceModel customerDisplayDevice = SyncDeviceModel.fromJson(jsonDecode(httpPost.data));
      bool found = false;
      for (var device in global.customerDisplayDeviceList) {
        if (device.deviceId == customerDisplayDevice.deviceId) {
          found = true;
          break;
        }
      }
      if (!found) {
        global.customerDisplayDeviceList.add(customerDisplayDevice);
        serviceLocator<Log>().debug("register_customer_display_device : ${customerDisplayDevice.deviceId} : ${global.customerDisplayDeviceList.length}");
      }
      break;
    case "change_customer_by_phone":
      // รับข้อมูลหมายเลขโทรศัพท์ แล้วมาค้นหาชื่อ และประมวลผล
      SyncCustomerDisplayModel postCustomer = SyncCustomerDisplayModel.fromJson(jsonDecode(httpPost.data));
      String customerCode = postCustomer.phone;
      String customerName = "";
      String customerPhone = postCustomer.phone;
      SyncCustomerDisplayModel result = SyncCustomerDisplayModel(code: customerCode, phone: customerPhone, name: customerName);
      response.write(jsonEncode(result.toJson()));
      try {
        global.posHoldProcessResult[global.findPosHoldProcessResultIndex(global.posHoldActiveCode)].customerCode = "";
        global.posHoldProcessResult[global.findPosHoldProcessResultIndex(global.posHoldActiveCode)].customerName = customerName;
        global.posHoldProcessResult[global.findPosHoldProcessResultIndex(global.posHoldActiveCode)].customerPhone = customerPhone;
        // ประมวลผลหน้าจอขายใหม่
        PosProcess().sumCategoryCount(value: global.posHoldProcessResult[global.findPosHoldProcessResultIndex(global.posHoldActiveCode)].posProcess);
        if (global.functionPosScreenRefresh != null) {
          global.functionPosScreenRefresh!(global.posHoldActiveCode);
          global.sendProcessToCustomerDisplay();
        }
      } catch (e) {
        serviceLocator<Log>().error(e);
      }
      break;
  }
}
