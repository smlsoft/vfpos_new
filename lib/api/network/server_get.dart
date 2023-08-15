import 'dart:typed_data';
import 'package:dedepos/api/network/sync_model.dart';
import 'package:dedepos/db/pos_log_helper.dart';
import 'package:dedepos/db/product_barcode_status_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/kitchen_struct.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_process.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/global.dart' as global;
import 'package:uuid/uuid.dart';

Future<void> serverGet(HttpRequest request, HttpResponse response) async {
  if (request.uri.path == '/scan') {
    bool isTerminal = (global.appMode == global.AppModeEnum.posTerminal);
    bool isClient = (global.appMode == global.AppModeEnum.posRemote);
    SyncDeviceModel resultData = SyncDeviceModel(deviceId: global.deviceId, deviceName: global.deviceName, ip: global.ipAddress, connected: true, isCashierTerminal: isTerminal, holdCodeActive: "", docModeActive: 0, isClient: isClient);
    response.write(jsonEncode(resultData.toJson()));
  } else {
    String json = request.uri.query.split("json=")[1];
    HttpGetDataModel httpGetData = HttpGetDataModel.fromJson(jsonDecode(utf8.decode(base64Decode(json))));
    switch (httpGetData.code) {
      case "get_connect":
        response.write("connected");
        break;
      case "get_pay_slip":
        var docNumber = httpGetData.json;
        var bill = global.objectBoxStore.box<BillObjectBoxStruct>().query(BillObjectBoxStruct_.doc_number.equals(docNumber)).build().findFirst();
        if (bill != null) {
          Directory dir = await global.createPath("posbill", bill.date_time);
          File file = File("${dir.path}/${bill.doc_number}.jpg");
          if (file.existsSync()) {
            Uint8List bytes = file.readAsBytesSync();
            response.headers.contentType = ContentType("image", "jpeg");
            String base64 = base64Encode(bytes);
            response.write(base64);
          } else {
            response.write("");
          }
        } else {
          response.write("");
        }
        break;
      case "pos_information":
        PosInformationModel data = PosInformationModel(shop_id: global.shopId, shop_name: global.getNameFromLanguage(global.profileSetting.company.names, global.userScreenLanguage));
        response.write(jsonEncode(data.toJson()));
        break;
      case "staff.get_product_barcode_status":
        response.write(jsonEncode(ProductBarcodeStatusHelper().getAll()));
        break;
      case "kds.order_temp_get_data_from_kitchen":
        var jsonData = jsonDecode(httpGetData.json);
        String kitchenId = jsonData["kitchenId"];
        final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
        int duration = DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch;
        final result = box.query(OrderTempObjectBoxStruct_.kdsId.equals(kitchenId).and(OrderTempObjectBoxStruct_.isOrder.equals(false)).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)).and((OrderTempObjectBoxStruct_.isOrderSendKdsSuccess.equals(true))).and((OrderTempObjectBoxStruct_.kdsSuccess.equals(false)).or(OrderTempObjectBoxStruct_.kdsSuccessTime.greaterThan(duration)))).order(OrderTempObjectBoxStruct_.kdsSuccess).order(OrderTempObjectBoxStruct_.orderDateTime).build().find();
        response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
        break;
      case "staff.order_temp_get_data_from_orderid_and_barcode":
        var jsonData = jsonDecode(httpGetData.json);
        String orderId = jsonData["orderId"];
        String barcode = jsonData["barcode"];
        bool isOrder = jsonData["isOrder"];
        final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
        final result = (barcode.isNotEmpty) ? box.query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.barcode.equals(barcode).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)).and(OrderTempObjectBoxStruct_.isOrder.equals(isOrder)))).build().find() : box.query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)).and(OrderTempObjectBoxStruct_.isOrder.equals(isOrder))).build().find();
        response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
        break;
      case "staff.order_temp_get_data_from_orderid":
        var jsonData = jsonDecode(httpGetData.json);
        String orderId = jsonData["orderId"];
        bool isOrder = jsonData["isOrder"];
        final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
        final result = box.query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)).and(OrderTempObjectBoxStruct_.isOrder.equals(isOrder))).build().find();
        double orderQty = 0;
        for (var item in result) {
          orderQty += item.qty;
        }
        OrderTempStruct orderTemp = OrderTempStruct(orderQty: orderQty, orderTemp: result);
        response.write(jsonEncode(orderTemp.toJson()));
        break;
      case "staff.order_temp_get_data_from_order_main_id":
        var jsonData = jsonDecode(httpGetData.json);
        String orderMainId = jsonData["orderMainId"];
        bool isOrder = jsonData["isOrder"];
        final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
        final result = box.query(OrderTempObjectBoxStruct_.orderIdMain.equals(orderMainId).and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)).and(OrderTempObjectBoxStruct_.isOrder.equals(isOrder))).build().find();
        double orderQty = 0;
        for (var item in result) {
          orderQty += item.qty;
        }
        OrderTempStruct orderTemp = OrderTempStruct(orderQty: orderQty, orderTemp: result);
        response.write(jsonEncode(orderTemp.toJson()));
        break;
      case "staff.order_temp_get_data_from_order_guid":
        String orderGuid = httpGetData.json;
        final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();
        final result = box.query(OrderTempObjectBoxStruct_.orderGuid.equals(orderGuid)).build().findFirst();
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
        List<TableProcessObjectBoxStruct> boxData = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.is_delivery.equals(true).and(TableProcessObjectBoxStruct_.delivery_send_success.equals(sendSuccess))).order(TableProcessObjectBoxStruct_.table_open_datetime, flags: Order.descending).build().find();
        response.write(jsonEncode(boxData.map((e) => e.toJson()).toList()));
        break;
      case "get_all_buffet_mode":
        List<BuffetModeObjectBoxStruct> boxData = global.objectBoxStore.box<BuffetModeObjectBoxStruct>().getAll();
        response.write(jsonEncode(boxData.map((e) => e.toJson()).toList()));
        break;
      case "get_table":
        var jsonData = jsonDecode(httpGetData.json);
        String mainNumber = jsonData["mainNumber"];
        String tableNumber = jsonData["number"];
        TableProcessObjectBoxStruct? tableData = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(tableNumber).and(TableProcessObjectBoxStruct_.is_delivery.equals(false))).build().findFirst();
        if (tableData == null) {
          // เพิ่มโต๊ะ
          final findSourceTableResult = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number.equals(mainNumber)).build().findFirst();
          final newTable = TableProcessObjectBoxStruct(
            number: tableNumber,
            guidfixed: Uuid().v4(),
            number_main: findSourceTableResult!.number,
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
            qr_code: const Uuid().v4().replaceAll("-", ""),
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
          response.write(jsonEncode(newTable.toJson()));
        } else {
          response.write(jsonEncode(tableData.toJson()));
        }
        break;
      case "get_all_table":
        List<TableProcessObjectBoxStruct> tableData = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.is_delivery.equals(false)).build().find();
        // หาโต๊ะลูก
        for (var table in tableData) {
          table.table_child_count = 0;
          var data = global.objectBoxStore.box<TableProcessObjectBoxStruct>().query(TableProcessObjectBoxStruct_.number_main.equals(table.number)).build().find();
          for (var item in data) {
            if (item.number.contains("#")) {
              table.table_child_count++;
            }
          }
        }
        response.write(jsonEncode(tableData.map((e) => e.toJson()).toList()));
        break;
      case "get_all_category":
        List<ProductCategoryObjectBoxStruct> boxData = global.objectBoxStore.box<ProductCategoryObjectBoxStruct>().getAll();
        response.write(jsonEncode(boxData.map((e) => e.toJson()).toList()));
        break;
      case "get_all_kitchen":
        List<KitchenObjectBoxStruct> boxData = global.objectBoxStore.box<KitchenObjectBoxStruct>().getAll();
        response.write(jsonEncode(boxData.map((e) => e.toJson()).toList()));
        break;
      case "get_all_barcode":
        List<ProductBarcodeObjectBoxStruct> boxData = global.objectBoxStore.box<ProductBarcodeObjectBoxStruct>().getAll();
        response.write(jsonEncode(boxData.map((e) => e.toJson()).toList()));
        break;
      case "PosLogHelper.selectByGuidFixed":
        final box = global.objectBoxStore.box<PosLogObjectBoxStruct>();
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        List<PosLogObjectBoxStruct> boxData = (box.query(PosLogObjectBoxStruct_.guid_auto_fixed.equals(jsonCategory.guid))..order(PosLogObjectBoxStruct_.log_date_time)).build().find();
        response.write(jsonEncode(boxData.map((e) => e.toJson()).toList()));
        break;
      case "get_process":
        var json = jsonDecode(httpGetData.json);
        String holdCode = json["holdCode"];
        int docMode = json["docMode"];
        String discountFormula = json["discountFormula"];
        String detailDiscountFormula = json["detailDiscountFormula"];
        PosProcessModel posProcess = await PosProcess().process(holdCode: holdCode, docMode: docMode, detailDiscountFormula: detailDiscountFormula, discountFormula: discountFormula);
        response.write(jsonEncode(posProcess.toJson()));
        break;
      case "PosLogHelper.holdCount":
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        int result = await PosLogHelper().holdCount(jsonCategory.holdCode);
        response.write(result.toString());
        break;
      case "selectByBarcodeFirst":
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        ProductBarcodeObjectBoxStruct? result = await ProductBarcodeHelper().selectByBarcodeFirst(jsonCategory.barcode);
        response.write(jsonEncode(result?.toJson()));
        break;
      case "selectByBarcodeList":
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        List<String> barcodeList = jsonCategory.barcode.split(",");
        List<ProductBarcodeObjectBoxStruct> result = await ProductBarcodeHelper().selectByBarcodeList(barcodeList);
        response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
        break;
      case "selectByCategoryParentGuid":
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        String parentGuid = jsonCategory.parentGuid;
        final box = global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
        final result = box.query(ProductCategoryObjectBoxStruct_.parent_guid_fixed.equals(parentGuid)).order(ProductCategoryObjectBoxStruct_.xorder).build().find();
        response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
        break;
      case "selectByParentCategoryGuidOrderByXorder":
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        String parentGuid = jsonCategory.parentGuid;
        final box = global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
        final result = (box.query(ProductCategoryObjectBoxStruct_.parent_guid_fixed.equals(parentGuid))..order(ProductCategoryObjectBoxStruct_.xorder)).build().find();
        response.write(jsonEncode(result.map((e) => e.toJson()).toList()));
        break;
      case "selectByCategoryGuidFindFirst":
        HttpParameterModel jsonCategory = HttpParameterModel.fromJson(jsonDecode(httpGetData.json));
        String guid = jsonCategory.guid;
        final box = global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
        ProductCategoryObjectBoxStruct? result = box.query(ProductCategoryObjectBoxStruct_.guid_fixed.equals(guid)).build().findFirst();
        response.write(jsonEncode(result?.toJson()));
        break;
    }
  }
}
