import 'dart:convert';
import 'package:dedepos/db/kitchen_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/kitchen_struct.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:dedepos/util/printer.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

Future<void> sendToKitchen(
    {required String orderId,
    required List<OrderTempDataModel> orderList}) async {
  // แบ่งครัว ค้นหาจาก Order ว่าอยู่ครัวไหนบ้าง
  List<KitchenObjectBoxStruct> kitchenList = KitchenHelper().getAll();
  List<String> kitchenCodeActiveList = [];
  for (var kitchen in kitchenList) {
    for (var barcode in kitchen.products) {
      if (orderList.indexWhere((element) => element.barcode == barcode) != -1) {
        if (kitchenCodeActiveList
                .indexWhere((element) => element == kitchen.code) ==
            -1) {
          kitchenCodeActiveList.add(kitchen.code);
        }
        break;
      }
    }
  }

  // update KDS
  final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
  for (var kitchenCode in kitchenCodeActiveList) {
    KitchenObjectBoxStruct kitchen = kitchenList[
        kitchenList.indexWhere((element) => element.code == kitchenCode)];
    for (var order in orderList) {
      if (kitchen.products.contains(order.barcode) == true) {
        var orderTempUpdate = box
            .query(OrderTempObjectBoxStruct_.orderGuid.equals(order.orderGuid))
            .build()
            .findFirst();
        if (orderTempUpdate != null) {
          orderTempUpdate.kdsId = kitchen.code;
          orderTempUpdate.kdsSuccess = false;
          orderTempUpdate.kdsCancel = false;
          orderTempUpdate.kdsSuccessTime = DateTime.now();
          box.put(orderTempUpdate, mode: PutMode.update);
        }
      }
    }
  }

  // พิมพ์
  for (var kitchenCode in kitchenCodeActiveList) {
    KitchenObjectBoxStruct kitchen = kitchenList[
        kitchenList.indexWhere((element) => element.code == kitchenCode)];

    int printerIndex = -1;
    for (var printer in global.printerLocalStrongData) {
      if (printer.code == kitchenCode) {
        printerIndex = global.printerLocalStrongData.indexOf(printer);
        break;
      }
    }
    if (printerIndex != -1) {
      PrinterClass printer =
          PrinterClass(printerIndex: printerIndex, qrCode: "");
      // Reset Printer
      printer.addCommand(PosPrintBillCommandModel(mode: 0));
      printer.addCommand(PosPrintBillCommandModel(
          mode: 2,
          posStyles: const PosStyles(bold: true),
          columns: [
            PosPrintBillCommandColumnModel(
                fontSize: 80,
                width: 1,
                text: "โต๊ะ : $orderId",
                align: PrintColumnAlign.center)
          ]));
      for (var order in orderList) {
        if (kitchen.products.contains(order.barcode) == true) {
          // ค้นหาชื่อสินค้า
          ProductBarcodeObjectBoxStruct? findBarcode = await global
              .productBarcodeHelper
              .selectByBarcodeFirst(order.barcode);
          if (findBarcode != null) {
            printer.addCommand(PosPrintBillCommandModel(
                mode: 2,
                posStyles: const PosStyles(bold: true),
                columns: [
                  PosPrintBillCommandColumnModel(
                      fontSize: 24,
                      width: 4,
                      text:
                          "${global.getNameFromJsonLanguage(findBarcode.names, global.userScreenLanguage)}-${global.getNameFromJsonLanguage(findBarcode.unit_names, global.userScreenLanguage)}",
                      align: PrintColumnAlign.left),
                  PosPrintBillCommandColumnModel(
                      fontSize: 24,
                      width: 1,
                      text: global.moneyFormat.format(order.qty),
                      align: PrintColumnAlign.right),
                ]));
            if (order.remark.trim().isNotEmpty) {
              printer.addCommand(PosPrintBillCommandModel(
                  mode: 2,
                  posStyles: const PosStyles(bold: true),
                  columns: [
                    PosPrintBillCommandColumnModel(
                        fontSize: 24,
                        width: 1,
                        text: "x หมายเหตุ x : ${order.remark}",
                        align: PrintColumnAlign.left),
                  ]));
            }
            if (order.optionSelected.isNotEmpty) {
              List<OrderProductOptionModel> options =
                  jsonDecode(order.optionSelected)
                      .map<OrderProductOptionModel>(
                          (item) => OrderProductOptionModel.fromJson(item))
                      .toList();
              for (var option in options) {
                bool optionPrint = false;
                for (var choice in option.choices) {
                  if (choice.selected!) {
                    if (optionPrint == false) {
                      printer.addCommand(PosPrintBillCommandModel(
                          mode: 2,
                          posStyles: const PosStyles(bold: false),
                          columns: [
                            PosPrintBillCommandColumnModel(
                                fontSize: 24,
                                width: 1,
                                text: " * ${option.names[0].name}",
                                align: PrintColumnAlign.left),
                          ]));
                      optionPrint = true;
                    }
                    printer.addCommand(PosPrintBillCommandModel(
                        mode: 2,
                        posStyles: const PosStyles(bold: false),
                        columns: [
                          PosPrintBillCommandColumnModel(
                              fontSize: 24,
                              width: 1,
                              text: "   - ${choice.names[0].name}",
                              align: PrintColumnAlign.left),
                        ]));
                  }
                }
              }
            }
          }
        }
      }
      printer.addCommand(PosPrintBillCommandModel(
          mode: 2,
          posStyles: const PosStyles(bold: true),
          columns: [
            PosPrintBillCommandColumnModel(
                fontSize: 32,
                width: 1,
                text:
                    "${global.getNameFromJsonLanguage(kitchen.names, global.userScreenLanguage)} : เวลา : ${DateFormat("HH:mm").format(DateTime.now())}",
                align: PrintColumnAlign.center)
          ]));
      printer.sendToPrinter();
    }
  }
}
