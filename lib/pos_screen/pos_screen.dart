import 'package:dedepos/bloc/product_category_bloc.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/model/json/product_option_model.dart';
import 'package:dedepos/pos_screen/pos_num_pad.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:dedepos/util/pos_compile_process.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:split_view/split_view.dart';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dedepos/api/app_const.dart';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/model/credit_card_payment_model.dart';
import 'package:dedepos/model/find/find_member_model.dart';
import 'package:dedepos/api/sync/model/sync_inventory_model.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/model/json/payment_model.dart';
import 'package:dedepos/model/json/sale_invoice_model.dart';
import 'package:dedepos/model/json/sale_invoice_item_model.dart';
import 'package:dedepos/model/json/transfer_payment_model.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/services/find_employee.dart';
import 'package:dedepos/services/find_member.dart';
import 'package:dedepos/pos_screen/pos_hold_bill.dart';
import 'package:dedepos/widgets/button_bill.dart';
import 'package:dedepos/widgets/roundmenu.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dedepos/db/product_category_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/model/json/receive_money_model.dart';
import 'package:dedepos/api/sync/model/promotion_model.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/widgets/discount_pad.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dedepos/services/find_item.dart';
import 'pay/pay_screen.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:dedepos/db/pos_log_helper.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/model/objectbox/config_struct.dart';
import 'pos_process.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/api/network/server.dart' as network;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:dedepos/model/find/find_item_model.dart';
import 'package:dedepos/model/json/print_queue_model.dart';
import 'package:dedepos/bloc/find_item_by_code_name_barcode_bloc.dart';
import 'pos_util.dart' as posUtil;

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen>
    with SingleTickerProviderStateMixin {
  late Timer posScreenTimer;
  late Timer messageTimer;
  late Timer deviceTimer;
  final ScrollController groupSelectListScrollController = ScrollController();
  late bool isVisible;
  //late QRViewController _scanController;
  late AutoScrollController autoScrollController;
  FocusNode mainFocusNode = FocusNode();
  final String barcodeScanResult = "";
  bool _barcodeScanActive = true;
  String textInput = "";
  late bool scannerStart = false;
  bool showButtonMenu = true;
  String categoryGuidSelected = "";
  final TextEditingController empCode = TextEditingController();
  final TextEditingController receiveAmount = TextEditingController();
  final FindItem findItemScreen = const FindItem();
  final FindMember findMemberScreen = const FindMember();
  bool displayDetailByBarcode = false;
  final debounce = global.Debounce(500);
  final List<FindItemModel> findByCodeNameLastResult = [];
  final TextEditingController textFindByTextController =
      TextEditingController();
  FocusNode? textFindByTextFocus;
  int activeLineNumber = -1;
  final bool isListen = false;
  final double confidence = 1.0;
  late TabController tabletTabController;
  SplitViewController splitViewController = SplitViewController(
      weights: [0.6, 0.4], limits: [WeightLimit(min: 0.1, max: 0.9)]);
  bool showNumericPad = false;
  double showNumericPadTop = 100;
  double showNumericPadLeft = 100;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? scanController;
  int splitViewMode = 1;
  double gridItemSize = 1;
  String findActiveLineByGuid = "";
  late PosNumPad desktopNumPad;
  GlobalKey<PosNumPadState> posNumPadGlobalKey = GlobalKey();
  List<Widget> widgetMessage = [];

  void refresh(int holdNumber) {
    processEventRefresh(holdNumber);
  }

  ProductBarcodeObjectBoxStruct product = ProductBarcodeObjectBoxStruct(
      barcode: "",
      color_select: "",
      image_or_color: true,
      color_select_hex: "",
      names: [],
      name_all: "",
      prices: [],
      images_url: "",
      unit_code: "",
      unit_names: [],
      new_line: 0,
      guid_fixed: "",
      item_code: "",
      item_guid: "",
      descriptions: [],
      item_unit_code: "",
      options_json: "",
      product_count: 0);
  List<ProductOptionModel> productOptions = [];

  Future<void> checkSync() async {
    if (global.syncRefreshProductCategory) {
      dev.log("syncRefreshProductCategory");
      global.syncRefreshProductCategory = false;
      context.read<ProductCategoryBloc>().add(
          ProductCategoryLoadStart(parentCategoryGuid: categoryGuidSelected));
    }
    if (global.syncRefreshProductBarcode) {
      dev.log("syncRefreshProductBarcode");
      global.syncRefreshProductBarcode = false;
      await loadProductByCategory(categoryGuidSelected);
      processEvent(holdNumber: global.posHoldActiveNumber);
    }
  }

  @override
  void initState() {
    super.initState();
    context
        .read<ProductCategoryBloc>()
        .add(ProductCategoryLoadStart(parentCategoryGuid: ''));

    dev.log("initState PosScreen 1");
    checkOnline();
    dev.log("initState PosScreen 2");
    // เรียกรายการประกอบการขายจาก Hold
    global.payScreenData =
        global.posHoldProcessResult[global.posHoldActiveNumber].payScreenData;
    //
    global.productCategoryCodeSelected.clear();
    global.themeSelect(2);
    autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    //processPromotionTemp();
    loadCategory();
    loadProductByCategory(categoryGuidSelected);
    if (global.isWideScreen()) {
      tabletTabController = TabController(length: 5, vsync: this);
      tabletTabController.addListener(() {
        if (!tabletTabController.indexIsChanging) {
          if (tabletTabController.index == 3 ||
              tabletTabController.index == 4) {
            SystemChannels.textInput.invokeMethod('TextInput.show');
          } else {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
        }
      });
    }
    dev.log("initState PosScreen 3");
    deviceTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      network.testPrinterConnect();
    });
    posScreenTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      // checkSync();
    });
    messageTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      /*if (global.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(global.errorMessage.join("\n")),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ));
        global.errorMessage.clear();
        global.playSound(sound: global.SoundEnum.beep);
      }*/
    });
    global.syncRefreshProductCategory = true;
    processEvent(holdNumber: global.posHoldActiveNumber);
    checkSync();
    global.functionPosScreenRefresh = refresh;
    Timer(const Duration(seconds: 1), () async {
      await getProcessFromTerminal();
    });
    desktopNumPad = PosNumPad(
      key: posNumPadGlobalKey,
      onChange: (String number) {
        setState(() {
          textInput = number;
        });
      },
      onSubmit: (String number) {
        onSubmit(number);
      },
    );
  }

  void onSubmit(String number) {
    String qty = "1.0";

    if (number.trim().isNotEmpty) {
      if (number.indexOf("X") > 0) {
        List<String> numberList = number.split("X");
        qty = numberList[0].trim();
        number = numberList[1].trim();
      }
      logInsert(commandCode: 1, barcode: number, qty: qty);
    }
  }

  Future<void> getProcessFromTerminal() async {
    if (global.appMode == global.AppModeEnum.posRemote) {
      HttpParameterModel jsonParameter =
          HttpParameterModel(holdNumber: global.posHoldActiveNumber);
      HttpGetDataModel json = HttpGetDataModel(
          code: "get_process", json: jsonEncode(jsonParameter.toJson()));
      global.posHoldProcessResult[global.posHoldActiveNumber] =
          PosHoldProcessModel.fromJson(jsonDecode(
              await global.getFromServer(json: jsonEncode(json.toJson()))));
      PosProcess().sumCategoryCount(
          global.posHoldProcessResult[global.posHoldActiveNumber].posProcess);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    global.functionPosScreenRefresh = null;
    deviceTimer.cancel();
    posScreenTimer.cancel();
    messageTimer.cancel();
    if (global.isWideScreen()) {
      tabletTabController.dispose();
    }
    global.sendProcessToCustomerDisplay();
  }

  void loadCategory() {
    String categoryGuid = (global.productCategoryCodeSelected.isEmpty)
        ? ""
        : global
            .productCategoryCodeSelected[
                global.productCategoryCodeSelected.length - 1]
            .guid_fixed;
  }

  Future<void> loadProductByCategory(String categoryGuid) async {
    // ดึงรายการ Category ย่อย และ รายการสินค้า
    if (categoryGuid.isNotEmpty) {
      global.productCategoryChildList = await ProductCategoryHelper()
          .selectByParentCategoryGuidOrderByXorder(parentGuid: categoryGuid);
      var selectCodeList = await ProductCategoryHelper()
          .selectByCategoryGuidFindFirst(categoryGuid);
      global.productListByCategory = [];
      if (selectCodeList != null) {
        List<String> barcodeList = [];
        ProductCategoryObjectBoxStruct category = selectCodeList;
        for (var item in jsonDecode(category.codelist)) {
          SyncCategoryCodeListModel code =
              SyncCategoryCodeListModel.fromJson(item);
          barcodeList.add(code.barcode);
        }
        var selectProductByBarcodeList =
            await ProductBarcodeHelper().selectByBarcodeList(barcodeList);
        for (var item in jsonDecode(category.codelist)) {
          SyncCategoryCodeListModel codeList =
              SyncCategoryCodeListModel.fromJson(item);
          for (var product in selectProductByBarcodeList) {
            if (product.barcode == codeList.barcode) {
              global.productListByCategory.add(product);
              break;
            }
          }
        }
      }
    }
  }

  void logInsert(
      {
      /**  
      -- command
      1=เพิ่มสินค้า
      2=เพิ่มจำนวน + 1
      3=ลดจำนวน - 1
      4=แก้จำนวน
      5=แก้ราคา
      6=แก้ส่วนลด
      8=หมายเหตุ
      9=ลบรายการสินค้า
      80=เปิดลิ้นชัก
      99=เริ่มใหม่
      101=Check Box Extra
      **/
      required int commandCode,

      /// GUID ในระบบ ป้องกันการซ้ำกัน
      String guid = "",

      /// รหัสอ้างอิงที่ถูกสร้างอัตโนมัติ
      String guidCodeRef = "",

      /// GUID Ref อ้างอิง (ส่วนหัวของรายการ)
      String guidRef = "",

      /// จำนวน
      String qty = "",

      /// ราคา
      double price = 0,

      /// ส่วนลด (Text)
      String discount = "",

      /// รหัสพิเศษ
      String extraCode = "",

      /// ?
      bool closeExtra = true,

      /// Barcode (กรณีมีการตัดสต๊อก)
      String barcode = "",

      /// รหัสสินค้า (กรณีมีการตัดสต๊อก)
      String code = "",

      /// ชื่อสินค้า
      String name = "",

      /// ?
      bool selected = false,

      /// ?
      String codeDefault = "",

      /// หมายเหตุ (อธิบายรายการ)
      String remark = "",

      /// รหัสหน่วยนับ
      String unitCode = "",

      /// ชื่อหน่วยนับ
      String unitName = ""}) async {
    double qtyForCalc = 0;
    double priceForCalc = price;
    // print("Log Insert Barcode : " + barcode);
    if (closeExtra) {
      //selectProductExtraList.clear();
    }
    posNumPadGlobalKey.currentState?.clear();
    if (qty.isNotEmpty) {
      qtyForCalc = global.calcTextToNumber(qty);
    }
    PosLogHelper logHelper = PosLogHelper();
    switch (commandCode) {
      case 101:
        {
          // 101=ส่วนขยาย (Check Box)
          // เพิ่มรายการใหม่ (Extra Check Box)
          List<PosLogObjectBoxStruct> posLogSelect =
              await logHelper.selectByGuidFixed(findActiveLineByGuid);
          if (posLogSelect.isNotEmpty) {
            await logHelper.insert(PosLogObjectBoxStruct(
                guid_code_ref: guidCodeRef,
                guid_ref: guidRef,
                log_date_time: DateTime.now(),
                hold_number: global.posHoldActiveNumber,
                command_code: commandCode,
                extra_code: extraCode,
                code: code,
                price: price,
                name: name,
                qty_fixed: qtyForCalc,
                qty: qtyForCalc,
                selected: selected));
          }
        }
        break;
      case 1:
        {
          // 1=เพิ่มสินค้า
          // Get Item Name
          ProductBarcodeObjectBoxStruct? productSelect =
              await ProductBarcodeHelper().selectByBarcodeFirst(barcode);
          String productNameStr = '';
          String unitCodeStr = "";
          String unitNameStr = "";
          if (productSelect != null) {
            productNameStr = productSelect.names[0];
            unitCodeStr = productSelect.unit_code;
            unitNameStr = productSelect.unit_names[0];
            double price = double.tryParse(productSelect.prices[0]) ?? 0.0;
            PosLogObjectBoxStruct data = PosLogObjectBoxStruct(
                log_date_time: DateTime.now(),
                hold_number: global.posHoldActiveNumber,
                command_code: commandCode,
                barcode: barcode,
                name: productNameStr,
                unit_code: unitCodeStr,
                unit_name: unitNameStr,
                qty: qtyForCalc,
                price: price);
            findActiveLineByGuid = data.guid_auto_fixed;
            await logHelper.insert(data);
            global.playSound(
                sound: global.SoundEnum.beep, word: productNameStr);
            widgetMessage = [
              Text(productNameStr,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(
                  "${global.language("qty")} ${global.moneyFormat.format(qtyForCalc)} $unitNameStr",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              Text(
                  "${global.language("price")} ${global.moneyFormat.format(price)} ${global.language(global.language("money_symbol"))}",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              Text("Barcode : $barcode",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ];
          } else {
            widgetMessage = [
              Center(
                  child: Text("${global.language("item_not_found")} $barcode",
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.red))),
            ];
            global.playSound(
                sound: global.SoundEnum.fail,
                word: global.language("item_not_found"));
          }
        }
        break;
      case 2:
        // 2=เพิ่มจำนวน + 1
        List<PosLogObjectBoxStruct> posLogSelect =
            await logHelper.selectByGuidFixed(findActiveLineByGuid);
        if (posLogSelect.isNotEmpty) {
          await logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: findActiveLineByGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldActiveNumber,
            command_code: commandCode,
          ));
          global.playSound(
              sound: global.SoundEnum.beep,
              word:
                  global.language("plus") + global.language("one") + unitName);
        } else {
          global.playSound(
              sound: global.SoundEnum.fail,
              word: global.language("item_not_found"));
        }
        break;
      case 3:
        // 3=ลดจำนวน - 1
        List<PosLogObjectBoxStruct> posLogSelect =
            await logHelper.selectByGuidFixed(findActiveLineByGuid);
        if (posLogSelect.isNotEmpty) {
          await logHelper.insert(PosLogObjectBoxStruct(
              guid_ref: findActiveLineByGuid,
              log_date_time: DateTime.now(),
              hold_number: global.posHoldActiveNumber,
              command_code: commandCode,
              qty: qtyForCalc));
          global.playSound(
              sound: global.SoundEnum.beep,
              word:
                  global.language("minus") + global.language("one") + unitName);
        } else {
          global.playSound(
              sound: global.SoundEnum.fail,
              word: global.language("item_not_found"));
        }
        break;
      case 4:
        // 4=แก้จำนวน
        await logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: findActiveLineByGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldActiveNumber,
            command_code: commandCode,
            qty: qtyForCalc));
        break;
      case 5:
        // 5=แก้ราคา
        await logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: findActiveLineByGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldActiveNumber,
            command_code: commandCode,
            price: priceForCalc));
        break;
      case 6:
        // 6=แก้ส่วนลด
        await logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: findActiveLineByGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldActiveNumber,
            command_code: commandCode,
            discount_text: discount));
        break;
      case 8:
        // 8=แก้หมายเหตุ
        await logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: findActiveLineByGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldActiveNumber,
            command_code: commandCode,
            remark: remark));
        break;
      case 9:
        // 9=ลบรายการ
        await logHelper.insert(PosLogObjectBoxStruct(
            log_date_time: DateTime.now(),
            hold_number: global.posHoldActiveNumber,
            command_code: commandCode,
            guid_ref: findActiveLineByGuid));
        global.playSound(
            sound: global.SoundEnum.beep,
            word: global.language("delete") + global.language("line"));
        productOptions.clear();
        break;
      case 99:
        // เริ่มใหม่
        await logHelper.deleteByHoldNumber(
            holdNumber: global.posHoldActiveNumber);
        global.playSound(
            sound: global.SoundEnum.beep, word: global.language("restart"));
        productOptions.clear();
        findActiveLineByGuid = "";
        break;
      default:
        dev.log("commandCode=$commandCode");
        break;
    }
    for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
      if (global.posRemoteDeviceList[index].holdNumberActive ==
          global.posHoldActiveNumber) {
        global.posRemoteDeviceList[index].processSuccess = false;
      }
    }
    processEvent(holdNumber: global.posHoldActiveNumber);
  }

  Widget findByText() {
    return BlocBuilder<FindItemByCodeNameBarcodeBloc,
        FindItemByCodeNameBarcodeState>(builder: (context, state) {
      if (state is FindItemByCodeNameBarcodeLoadSuccess) {
        findByCodeNameLastResult.addAll(state.result);
        context
            .read<FindItemByCodeNameBarcodeBloc>()
            .add(FindItemByCodeNameBarcodeLoadFinish());
      }
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //       color: const Color.fromARGB(255, 51, 204, 255), width: 1),
          //   borderRadius: BorderRadius.circular(5),
          //   shape: BoxShape.rectangle,
          // ),
          child: Column(
            children: <Widget>[
              TextField(
                  autofocus: true,
                  focusNode: textFindByTextFocus,
                  controller: textFindByTextController,
                  onChanged: (string) {
                    debounce.run(() {
                      findByCodeNameLastResult.clear();
                      context.read<FindItemByCodeNameBarcodeBloc>().add(
                          FindItemByCodeNameBarcodeLoadStart(
                              words: textFindByTextController.text,
                              offset: 0,
                              limit: 50));
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "ข้อความบางส่วน (ชื่อ,รหัส)",
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        findByCodeNameLastResult.clear();
                        textFindByTextController.clear();
                      }),
                      icon: const Icon(Icons.clear),
                    ),
                  )),
              Row(children: [
                Expanded(flex: 3, child: Text(global.language("item_name"))),
                Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(global.language("price")))),
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(global.language("minus")))),
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(global.language("qty")))),
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(global.language("plus")))),
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(global.language("save"))))
              ]),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: findByCodeNameLastResult.map((value) {
                  var index = findByCodeNameLastResult.indexOf(value);
                  var detail = findByCodeNameLastResult[index];
                  return Row(children: [
                    Expanded(
                        flex: 5,
                        // ignore: prefer_interpolation_to_compose_strings
                        child: Text(detail.item_names[0] +
                            "/" +
                            detail.unit_names[0] +
                            '/' +
                            detail.item_code +
                            "/" +
                            detail.barcode)),
                    Expanded(
                        flex: 2,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                global.moneyFormat.format(detail.prices[0])))),
                    Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (detail.qty > 0.0) detail.qty -= 1.0;
                                  });
                                },
                                child: const Icon(Icons.remove)))),
                    Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(2),
                                ),
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0))),
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            content: SizedBox(
                                                height: 500,
                                                child: NumberPad(
                                                    header:
                                                        global.language("qty"),
                                                    title: Text(
                                                        '${detail.item_names[0]} ${global.language("qty")} ${global.moneyFormat.format(detail.qty)} ${detail.unit_names[0]}',
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    onChange: (qtyStr) => {
                                                          if (qtyStr
                                                                  .isNotEmpty &&
                                                              double.parse(
                                                                      qtyStr) >
                                                                  0)
                                                            {
                                                              detail.qty =
                                                                  double.parse(
                                                                      qtyStr),
                                                            }
                                                        })),
                                          );
                                        });
                                      });
                                },
                                child: Text(global.qtyShortFormat
                                    .format(detail.qty))))),
                    Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    detail.qty += 1.0;
                                  });
                                },
                                child: const Icon(Icons.add)))),
                    Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(2),
                                ),
                                onPressed: () async {
                                  logInsert(
                                      commandCode: 1,
                                      barcode: detail.barcode,
                                      qty: detail.qty.toString());
                                  processEvent(
                                      barcode: detail.barcode,
                                      holdNumber: global.posHoldActiveNumber);
                                  detail.qty = 1;
                                  //Navigator.pop(context, SelectItemConditionModel(command: 1, qty: _detail.qty, price: _detail.price, data: BarcodeStruct(barcode: _detail.barcode, itemCode: _detail.itemCode, itemName: _detail.itemName, unitCode: _detail.unitCode, unitName: _detail.unitName)));
                                },
                                child: const Icon(Icons.save))))
                  ]);
                }).toList(),
              )))
            ],
          ),
        ),
      );
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    /*try {
      if (Platform.isAndroid) {
        _scanController.pauseCamera();
      } else if (Platform.isIOS) {
        _scanController.resumeCamera();
      }
    } catch (e) {}*/
  }

  Future<void> processEvent(
      {String barcode = "", required int holdNumber}) async {
    if (barcode.isNotEmpty) {
      product = await ProductBarcodeHelper().selectByBarcodeFirst(barcode) ??
          ProductBarcodeObjectBoxStruct(
              barcode: "",
              names: [],
              name_all: "",
              prices: [],
              unit_code: "",
              unit_names: [],
              new_line: 0,
              images_url: "",
              guid_fixed: "",
              item_code: "",
              item_guid: "",
              descriptions: [],
              item_unit_code: "",
              color_select: "",
              image_or_color: true,
              color_select_hex: "",
              options_json: "",
              product_count: 0);
      productOptions = product.options();
    }
    posCompileProcess(holdNumber: global.posHoldActiveNumber).then((value) {
      if (value.lineGuid.isNotEmpty && value.lastCommandCode == 1) {
        findActiveLineByGuid = value.lineGuid;
      }
      processEventRefresh(global.posHoldActiveNumber);
    });
  }

  void processEventRefresh(int holdNumber) {
    /*if (global.posHoldProcessResult[global.posHoldActiveNumber].posProcess
        .details.isNotEmpty) {
      activeLineNumber = global.posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess.active_line_number;
      if (activeLineNumber != -1) {
        activeGuid = global.posHoldProcessResult[global.posHoldActiveNumber]
            .posProcess.details[activeLineNumber].guid;
      }
    } else {
      activeLineNumber = -1;
      activeGuid = "";
    }*/
    if (findActiveLineByGuid.isNotEmpty) {
      for (int i = 0;
          i < global.posHoldProcessResult[holdNumber].posProcess.details.length;
          i++) {
        PosProcessDetailModel detail =
            global.posHoldProcessResult[holdNumber].posProcess.details[i];
        if (detail.guid == findActiveLineByGuid) {
          activeLineNumber = i;
          break;
        }
      }
    }
    Future.delayed(const Duration(milliseconds: 50), () {
      autoScrollController.scrollToIndex(
          (activeLineNumber < 0) ? 0 : activeLineNumber,
          preferPosition: AutoScrollPosition.begin);
    });
    for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
      if (global.posRemoteDeviceList[index].holdNumberActive ==
          global.posHoldActiveNumber) {
        global.posRemoteDeviceList[index].processSuccess = false;
      }
    }
    setState(() {});
  }

  void numPadChangeQty(String qty, String unitName) async {
    if (qty.isNotEmpty && double.parse(qty) > 0) {
      global.playSound(
          sound: global.SoundEnum.buttonTing,
          word: global.language("qty_update") +
              global.language("is") +
              qty.toString() +
              unitName);
      logInsert(
          commandCode: 4,
          guid: findActiveLineByGuid,
          qty: qty,
          closeExtra: false);
      processEvent(holdNumber: global.posHoldActiveNumber);
    }
  }

  void numPadChangePrice(String priceStr) async {
    double price = double.tryParse(priceStr) ?? 0.0;
    if (price > 0) {
      global.playSound(
          sound: global.SoundEnum.buttonTing,
          word: global.language("price_update") +
              global.language("is") +
              price.toString() +
              global.language("money_symbol"));
      logInsert(
          commandCode: 5,
          guid: findActiveLineByGuid,
          price: price,
          closeExtra: false);
    }
  }

  Future<void> selectProductLevelExtraListCheck(
      int groupIndex, int detailIndex, bool value) async {
    if (value == true) {
      // ถ้าเลือกแล้ว ให้ทำการลบข้อมูลที่มีอยู่แล้วออก (ลบของเก่า)
      PosLogHelper().deleteByGuidCodeRefHoldNumberCommandCode(
          guidCode: productOptions[groupIndex].choices[detailIndex].guid_fixed,
          commandCode: 101,
          holdNumber: global.posHoldActiveNumber);
      global.playSound(sound: global.SoundEnum.beep);
    } else {
      /// ถ้าไม่ได้เลือก เพิ่มข้อมูลเพื่อให้ระบบประมวลผล
      /// ตรวจสอบว่ามีการเลือกมากกว่าที่กำหนดหรือไม่ (เช่น ไม่เกิน 2 รายการ)
      int count = 0;
      for (int index = 0;
          index < productOptions[groupIndex].choices.length;
          index++) {
        if (productOptions[groupIndex].choices[index].selected) {
          count++;
        }
      }
      if (count < productOptions[groupIndex].max_select) {
        productOptions[groupIndex].choices[detailIndex].selected = value;
        ProductChoiceModel detail =
            productOptions[groupIndex].choices[detailIndex];
        // เพิ่ม Log รายการที่เลือก
        logInsert(
            guidCodeRef: detail.guid_fixed,
            commandCode: 101,
            guidRef: findActiveLineByGuid,
            barcode: detail.barcode,
            price: detail.price,
            qty: detail.qty.toString(),
            extraCode: "",
            closeExtra: false,
            name: detail.names[0],
            codeDefault: "",
            selected: detail.selected);
        global.playSound(sound: global.SoundEnum.beep, word: detail.names[0]);
        processEvent(holdNumber: global.posHoldActiveNumber);
      } else {
        global.playSound(sound: global.SoundEnum.fail);
      }
    }
  }

  void discountPadChange(String discount) async {
    if (discount.isNotEmpty) {
      if (double.tryParse(discount) != null) {
        global.playSound(
            word: global.language("discount") +
                discount +
                global.language("money_symbol"));
      } else {
        List<String> discountList = discount.split(",");
        StringBuffer discountSpeech = StringBuffer();
        for (var index = 0; index < discountList.length; index++) {
          if (discountSpeech.isNotEmpty) {
            discountSpeech.write(global.language("discount_plus"));
          }
          if (double.tryParse(discountList[index]) != null) {
            discountSpeech
                .write(discountList[index] + global.language("money_symbol"));
          } else {
            discountSpeech.write(discountList[index]);
          }
        }
        global.playSound(
            word: global.language("discount") + discountSpeech.toString());
      }
      logInsert(
          commandCode: 6,
          guid: findActiveLineByGuid,
          discount: discount,
          closeExtra: false);
    } else {
      global.playSound(word: global.language("discount_cancel"));
      logInsert(
          commandCode: 6,
          guid: findActiveLineByGuid,
          discount: '',
          closeExtra: false);
    }
  }

  void checkOnline() async {
    global.isOnline = await global.hasNetwork();
  }

  void onQRViewCreated(QRViewController controller) {
    scanController = controller;

    controller.scannedDataStream.listen((scanData) async {
      textInput = "";
      String barcodeScanResult = scanData.code.toString();
      logInsert(
          commandCode: 1,
          barcode: barcodeScanResult,
          qty: (textInput.isEmpty) ? "1.0" : textInput);
      processEvent(
          barcode: barcodeScanResult, holdNumber: global.posHoldActiveNumber);

      await controller.pauseCamera();
      await Future.delayed(const Duration(seconds: 1));
      await controller.resumeCamera();
    });
  }

  Widget productLevelLabelWidget({
    required String name,
    String imageUrl = "",
    String unitName = "",
    double price = 0,
    bool withOpacity = true,
  }) {
    double fontSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: (imageUrl.trim().isNotEmpty)
              ? Center(
                  child: Image(
                      image: CachedNetworkImageProvider(
                  imageUrl,
                )))
              : Container(),
        ),
        Container(
          width: double.infinity,
          decoration: (withOpacity)
              ? const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)))
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: fontSize - 2.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                            child: Text(
                          unitName,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.indigo[900],
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        Positioned(
                          right: 0,
                          child: Container(
                              color: Colors.white,
                              child: Text(global.moneyFormat.format(price),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: fontSize + 2,
                                    color: Colors.indigo[900],
                                    fontWeight: FontWeight.bold,
                                    shadows: const [
                                      Shadow(
                                          offset: Offset(-0.5, -0.5),
                                          color: Colors.grey),
                                      Shadow(
                                          offset: Offset(0.5, -0.5),
                                          color: Colors.grey),
                                      Shadow(
                                          offset: Offset(0.5, 0.5),
                                          color: Colors.grey),
                                      Shadow(
                                          offset: Offset(-0.5, 0.5),
                                          color: Colors.grey),
                                    ],
                                  ))),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget productLevelWidget(ProductBarcodeObjectBoxStruct product) {
    BoxDecoration boxDecoration = (product.image_or_color == false)
        ? BoxDecoration(
            color: global
                .colorFromHex(product.color_select_hex.replaceAll("#", "")),
          )
        : const BoxDecoration();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        minimumSize: const Size(0, 0),
        elevation: 4,
      ),
      onPressed: () async {
        displayDetailByBarcode = false;
        logInsert(
            commandCode: 1,
            barcode: product.barcode,
            closeExtra: false,
            qty: "1.0");
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: boxDecoration,
            child: productLevelLabelWidget(
                imageUrl: product.images_url,
                name: product.names[0],
                unitName: product.unit_names[0],
                price: (product.prices.isEmpty)
                    ? 0
                    : double.tryParse(product.prices[0]) ?? 0.0),
          ),
          if (product.product_count != 0)
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  //selectProductExtraList.clear();
                  displayDetailByBarcode = false;
                  for (int index = 0;
                      index <
                              global
                                  .posHoldProcessResult[
                                      global.posHoldActiveNumber]
                                  .posProcess
                                  .details
                                  .length &&
                          displayDetailByBarcode == false;
                      index++) {
                    if (product.barcode ==
                        global.posHoldProcessResult[global.posHoldActiveNumber]
                            .posProcess.details[index].barcode) {
                      displayDetailByBarcode = true;
                      activeLineNumber = index;
                      findActiveLineByGuid = global
                          .posHoldProcessResult[global.posHoldActiveNumber]
                          .posProcess
                          .details[index]
                          .guid;
                    }
                  }
                  setState(() {});
                  autoScrollController.scrollToIndex(
                      (activeLineNumber < 0) ? 0 : activeLineNumber,
                      preferPosition: AutoScrollPosition.begin);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: FittedBox(
                      child: Text(
                        global.formatDoubleTrailingZero(product.product_count),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget selectProductLevelListScreenWidget(BoxConstraints constraints) {
    double menuMinWidth = (global.isWideScreen())
        ? (gridItemSize * 25) + 80
        : (gridItemSize * 50) + 50;
    int widgetPerLine =
        int.parse((constraints.maxWidth / menuMinWidth).toStringAsFixed(0));
    return (global.productListByCategory.isEmpty)
        ? const Center(
            child: Icon(Icons.select_all, color: Colors.grey, size: 200))
        : GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: widgetPerLine,
            children: [
              for (final detail in global.productListByCategory)
                Container(
                  margin: const EdgeInsets.all(4),
                  child: productLevelWidget(detail),
                ),
            ],
          );
  }

  Widget selectProductLevelExtraListCheckWidget(int groupIndex) {
    if (activeLineNumber != -1) {
      PosProcessDetailModel data = global
          .posHoldProcessResult[global.posHoldActiveNumber]
          .posProcess
          .details[activeLineNumber];
      for (var checkBoxIndex = 0;
          checkBoxIndex < productOptions[groupIndex].choices.length;
          checkBoxIndex++) {
        productOptions[groupIndex].choices[checkBoxIndex].selected = false;
      }
      for (var detailIndex0 = 0;
          detailIndex0 < data.extra.length;
          detailIndex0++) {
        for (var checkBoxIndex = 0;
            checkBoxIndex < productOptions[groupIndex].choices.length;
            checkBoxIndex++) {
          if (data.extra[detailIndex0].guid_code_or_ref ==
              productOptions[groupIndex].choices[checkBoxIndex].guid_fixed) {
            productOptions[groupIndex].choices[checkBoxIndex].selected = true;
          }
        }
      }
    }
    return Column(children: [
      for (var detailIndex = 0;
          detailIndex < productOptions[groupIndex].choices.length;
          detailIndex++)
        Material(
            // color: global.posTheme.background,
            child: InkWell(
                onTap: () async {
                  var value =
                      productOptions[groupIndex].choices[detailIndex].selected;
                  await selectProductLevelExtraListCheck(
                      groupIndex, detailIndex, value);
                  processEvent(holdNumber: global.posHoldActiveNumber);
                },
                child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            SizedBox(
                                height: 20,
                                width: 20,
                                child: Theme(
                                    data: ThemeData(primarySwatch: Colors.blue),
                                    child: Checkbox(
                                      onChanged: null,
                                      fillColor: MaterialStateProperty.all(
                                          (productOptions[groupIndex]
                                                  .choices[detailIndex]
                                                  .selected)
                                              ? Colors.blue
                                              : Colors.grey),
                                      value: productOptions[groupIndex]
                                          .choices[detailIndex]
                                          .selected,
                                    ))),
                            const SizedBox(width: 5),
                            Flexible(
                                child: Text(
                                    productOptions[groupIndex]
                                        .choices[detailIndex]
                                        .names[0],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black)))
                          ],
                        )),
                        (productOptions[groupIndex]
                                    .choices[detailIndex]
                                    .price ==
                                0)
                            ? const Text("")
                            : Text(
                                "+${productOptions[groupIndex].choices[detailIndex].price}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ))))
    ]);
  }

  Widget selectProductLevelExtraWidget() {
    return (productOptions.isEmpty)
        ? Container()
        : SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  // color: global.posTheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                width: 200,
                child: Column(
                  children: [
                    if (activeLineNumber != -1)
                      Row(
                        children: [
                          if (product.images_url.isNotEmpty && global.isOnline)
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CachedNetworkImage(
                                      width: 80,
                                      height: 60,
                                      imageUrl: product.images_url,
                                      fit: BoxFit.fill,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )),
                                const SizedBox(width: 5),
                              ],
                            ),
                          Flexible(
                              child: Text(
                                  "${product.names[0]}/${product.unit_names[0]}",
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)))
                        ],
                      ),
                    for (var groupIndex = 0;
                        groupIndex < productOptions.length;
                        groupIndex++)
                      Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Text(
                                      productOptions[groupIndex].names[0],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(width: 10, height: 10),
                              (productOptions[groupIndex].max_select > 1)
                                  ? Flexible(
                                      child: Text(
                                          "${global.language("max")} ${productOptions[groupIndex].max_select} ${global.language("list")}",
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.red)))
                                  : Container()
                            ]),
                        selectProductLevelExtraListCheckWidget(groupIndex)
                      ])
                  ],
                )));
  }

  void productCategorySelectedAdd(ProductCategoryObjectBoxStruct value) {
    bool found = false;
    for (var find in global.productCategoryCodeSelected) {
      if (find.guid_fixed == categoryGuidSelected) {
        found = true;
      }
    }
    if (found == false) {
      global.productCategoryCodeSelected.add(value);
    }
  }

  Widget selectProductLevelCardWidget(
      ProductCategoryObjectBoxStruct value, double boxSize, bool append) {
    double round = 5;
    return SizedBox(
        width: (global.isWideScreen()) ? 80 : 50,
        height: (global.isWideScreen()) ? 80 : 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(round),
            ),
          ),
          onPressed: () async {
            categoryGuidSelected = value.guid_fixed;
            if (append == true) {
              // กรณีมีลูกให้เพิ่มการเลือก
              if (value.category_count > 0) {
                productCategorySelectedAdd(value);
              } else {
                // กรณีเลือกกลุ่มลูกให้เพิ่มการเลือก
                if (value.parent_guid_fixed.isNotEmpty) {
                  productCategorySelectedAdd(value);
                }
              }
            }
            await loadProductByCategory(categoryGuidSelected);
            productOptions.clear();
            setState(() {
              PosProcess().sumCategoryCount(global
                  .posHoldProcessResult[global.posHoldActiveNumber].posProcess);
            });
          },
          child: Stack(
            children: [
              if (value.use_image_or_color == true &&
                  value.image_url.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: value.image_url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(round),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(),
                ),
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(4),
                color: ((value.use_image_or_color == false)
                    ? global
                        .colorFromHex(value.colorselecthex.replaceAll("#", ""))
                    : Colors.transparent),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                  child: Text(value.names[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                              offset: Offset(-0.5, -0.5), color: Colors.white),
                          Shadow(
                              offset: Offset(0.5, -0.5), color: Colors.white),
                          Shadow(offset: Offset(0.5, 0.5), color: Colors.white),
                          Shadow(
                              offset: Offset(-0.5, 0.5), color: Colors.white),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Widget selectProductLevelSelectWidget() {
    List<Widget> categorySelectedList = [];
    //print("selectProductLevelSelectWidget");

    if (global.productCategoryCodeSelected.isNotEmpty) {
      categorySelectedList.add(
        SizedBox(
          width: 80,
          height: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(gridItemSize, gridItemSize),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () {
              global.productCategoryChildList.clear();
              global.productCategoryCodeSelected.clear();
              categoryGuidSelected = "";
              productOptions.clear();
              loadCategory();
              setState(() {
                PosProcess().sumCategoryCount(global
                    .posHoldProcessResult[global.posHoldActiveNumber]
                    .posProcess);
              });
            },
            child: Text(
              global.language("restart"),
            ),
          ),
        ),
      );
      for (var categoryList in global.productCategoryCodeSelected) {
        categorySelectedList.add(
            selectProductLevelCardWidget(categoryList, gridItemSize, false));
      }
    } else {
      categorySelectedList.add(Container());
    }
    List<ProductCategoryObjectBoxStruct> categoryList =
        (global.productCategoryChildList.isEmpty)
            ? global.productCategoryList
            : global.productCategoryChildList;

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
          color: Colors.cyan.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (global.productCategoryCodeSelected.isEmpty)
                ? Container()
                : Column(children: [
                    Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: categorySelectedList),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final value in categoryList)
                selectProductLevelCardWidget(value, gridItemSize, true)
            ])
          ],
        ));
  }

  Widget selectProductLevelWidget(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(2),
        child: Column(children: [
          Expanded(
            child: selectProductLevelListScreenWidget(constraints),
          ),
          if (displayDetailByBarcode && activeLineNumber > -1)
            SizedBox(
              height: 250,
              width: double.infinity,
              child: transScreen(
                  mode: 1,
                  barcode: global
                      .posHoldProcessResult[global.posHoldActiveNumber]
                      .posProcess
                      .details[activeLineNumber]
                      .barcode),
            ),
          selectProductLevelSelectWidget()
        ]),
      ),
    );
  }

  Widget selectProductExtraListWidget() {
    return Align(
        alignment: Alignment.topLeft,
        child: Card(
          child: Container(
              margin: const EdgeInsets.all(2),
              height: double.infinity,
              // decoration: BoxDecoration(
              //   color: global.posTheme.background,
              //   border: Border.all(color: Colors.black, width: 1.0),
              //   borderRadius: BorderRadius.all(Radius.circular(4)),
              // ),
              child: selectProductLevelExtraWidget()),
        ));
  }

  Widget selectProduct() {
    return Scaffold(
        floatingActionButton: Wrap(children: [
          Visibility(
              visible: !scannerStart,
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: FittedBox(
                      child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        showButtonMenu = !showButtonMenu;
                      });
                    },
                    child: const Icon(Icons.menu),
                  )))),
          Visibility(
              visible: scannerStart,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    scannerStart = false;
                  });
                },
                child: const Icon(Icons.close),
              ))
        ]),
        body: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: (scannerStart)
                ? Column(children: [
                    Expanded(
                        child: QRView(
                      key: qrKey,
                      onQRViewCreated: onQRViewCreated,
                    )),
                  ])
                : Container()));
  }

  Widget detailWidget(
      {required String productName,
      bool fullDetail = false,
      required bool isExtra,
      int line = 0,
      double qty = 0,
      double price = 0.0,
      double priceOriginal = 0.0,
      required double totalAmount,
      required TextStyle textStyle,
      required String barcode,
      required String unitName,
      required imageUrl}) {
    String description = "";
    Widget rowSpace = const SizedBox(
      width: 4,
    );
    List<Widget> productDetail = [];
    if (line != 0) {
      productDetail.add(
        Text(line.toString(),
            style: textStyle.copyWith(color: Colors.blue, fontSize: 10)),
      );
      productDetail.add(rowSpace);
    }
    productDetail.add(Text(productName, style: textStyle));
    if (qty > 1) {
      productDetail.add(rowSpace);
      productDetail.add(Text(" X ${global.moneyFormat.format(qty)} $unitName",
          style: textStyle.copyWith(color: Colors.red, fontSize: 12)));
      productDetail.add(rowSpace);
      productDetail.add(Text(
          "${global.language("price")} $unitName ${global.moneyFormat.format(price)} ${global.language("money_symbol")}",
          style: textStyle.copyWith(color: Colors.blue, fontSize: 12)));
    }
    if (fullDetail) {
      if (price != priceOriginal) {
        productDetail.add(rowSpace);
        productDetail.add(Text(
            "${global.language("original_price")}  ${global.moneyFormat.format(priceOriginal)} ${global.language("money_symbol")}/$unitName ${global.language("new_price")} ${global.moneyFormat.format(price)} ${global.language("money_symbol")}/$unitName",
            style: textStyle.copyWith(color: Colors.orange, fontSize: 10)));
      }
      if (barcode.isNotEmpty) {
        productDetail.add(rowSpace);
        productDetail.add(Text(barcode,
            style: textStyle.copyWith(color: Colors.green, fontSize: 10)));
      }
    }
    if (imageUrl != "0" && imageUrl != "" && global.isOnline) {
      productDetail.add(rowSpace);
      productDetail.add(Padding(
          padding: const EdgeInsets.only(right: 5),
          child: CachedNetworkImage(
            width: 25,
            height: 25,
            fit: BoxFit.fill,
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )));
    }

    return Column(children: [
      Row(
        children: [
          Expanded(
            flex: 6,
            child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: productDetail)),
          ),
          const SizedBox(
            width: 2,
            height: 0,
          ),
          Expanded(
              flex: 3,
              child: Align(
                  alignment: Alignment.topRight,
                  child: (totalAmount == 0.0)
                      ? Container()
                      : Text(global.moneyFormat.format(totalAmount),
                          style: textStyle))),
        ],
      ),
      if (description.isNotEmpty)
        SizedBox(
            width: double.infinity,
            child: Text(description,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 10, color: Colors.black)))
    ]);
  }

  Widget detailRow(
      {required int index,
      required PosProcessDetailModel detail,
      required TextStyle textStyle}) {
    double extraAmount = 0.0;
    TextStyle extraTextStyle = TextStyle(
        fontSize: 10, fontWeight: textStyle.fontWeight, color: Colors.grey);
    String description =
        "${detail.item_name}/${detail.unit_name}${(detail.remark.isNotEmpty) ? " (${detail.remark})" : ""}";
    for (final extra in detail.extra) {
      extraAmount += extra.total_amount;
    }

    List<Widget> columnList = [];
    columnList.add(detailWidget(
        line: index + 1,
        fullDetail: true,
        isExtra: false,
        productName: description,
        qty: detail.qty,
        price: detail.price,
        priceOriginal: detail.price_original,
        totalAmount: detail.total_amount,
        textStyle: textStyle,
        barcode: detail.barcode,
        unitName: detail.unit_name,
        imageUrl: detail.image_url));
    for (final extra in detail.extra) {
      columnList.add(detailWidget(
          isExtra: true,
          productName: extra.item_name,
          qty: (extra.qty == 0) ? 0 : extra.qty,
          price: extra.price,
          priceOriginal: detail.price_original,
          totalAmount: (extra.price == 0) ? 0 : extra.total_amount,
          unitName: "",
          barcode: "",
          textStyle: extraTextStyle,
          imageUrl: ""));
    }
    if (extraAmount != 0) {
      columnList.add(detailWidget(
          isExtra: false,
          productName:
              "${global.language("total")} : ${detail.item_name}/${detail.unit_name}",
          qty: 0,
          price: 0,
          priceOriginal: detail.price_original,
          unitName: "",
          totalAmount: detail.total_amount + extraAmount,
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: textStyle.fontWeight,
              color: Colors.black),
          barcode: detail.barcode,
          imageUrl: ""));
    }
    if (detail.discount != 0) {
      columnList.add(detailWidget(
          isExtra: false,
          productName:
              "${global.language("discount")} : ${detail.discount_text}",
          qty: 0,
          price: 0,
          priceOriginal: detail.price_original,
          unitName: "",
          totalAmount: detail.discount * -1,
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: textStyle.fontWeight,
              color: Colors.red),
          barcode: detail.barcode,
          imageUrl: ""));
      columnList.add(detailWidget(
          isExtra: false,
          productName:
              "${global.language("after_discount")} : ${detail.discount_text}",
          qty: 0,
          price: 0,
          priceOriginal: detail.price_original,
          unitName: "",
          totalAmount: (detail.total_amount + extraAmount) - detail.discount,
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: textStyle.fontWeight,
              color: Colors.blue),
          barcode: detail.barcode,
          imageUrl: ""));
    }
    return Column(children: columnList);
  }

  Widget detailData(
      {required int index,
      required PosProcessDetailModel detail,
      required bool active,
      required TextStyle textStyle}) {
    Widget widget = Container(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
      width: MediaQuery.of(context).size.width,
      child: detailRow(index: index, detail: detail, textStyle: textStyle),
    );
    return Material(
        color: Colors.white.withOpacity(0),
        child: (detail.is_void)
            ? Container(
                decoration: BoxDecoration(color: Colors.red.shade100),
                child: widget)
            : InkWell(
                onTap: () async {
                  activeLineNumber = index;
                  findActiveLineByGuid = global
                      .posHoldProcessResult[global.posHoldActiveNumber]
                      .posProcess
                      .details[index]
                      .guid;
                  global.posHoldProcessResult[global.posHoldActiveNumber]
                      .posProcess.select_promotion_temp_list
                      .clear();
                  print(global.posHoldProcessResult[global.posHoldActiveNumber]
                      .posProcess.details[index].barcode);
                  product = await ProductBarcodeHelper().selectByBarcodeFirst(
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .posProcess
                              .details[index]
                              .barcode) ??
                      ProductBarcodeObjectBoxStruct(
                          barcode: "",
                          color_select: "",
                          image_or_color: true,
                          color_select_hex: "",
                          names: [],
                          name_all: "",
                          images_url: "",
                          prices: [],
                          unit_code: "",
                          unit_names: [],
                          new_line: 0,
                          guid_fixed: "",
                          item_code: "",
                          item_guid: "",
                          descriptions: [],
                          item_unit_code: "",
                          options_json: "",
                          product_count: 0);
                  setState(() {
                    productOptions = product.options();
                  });
                },
                child: widget));
  }

  Widget detailButton(
      {required int index,
      required PosProcessDetailModel detail,
      required bool active,
      required TextStyle textStyle}) {
    TextEditingController textFieldRemarkController =
        TextEditingController(text: detail.remark);

    return Padding(
        padding: const EdgeInsets.all(4),
        child: IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            commandButton(
              onPressed: () {
                if (detail.qty > 1) {
                  logInsert(
                      commandCode: 3,
                      guid: findActiveLineByGuid,
                      closeExtra: false);
                }
              },
              label: '-1 ${detail.unit_name}',
              //icon: Icons.exposure_minus_1,
            ),
            const SizedBox(
              width: 2,
            ),
            commandButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          contentPadding: const EdgeInsets.all(10),
                          content: SizedBox(
                              height: 500,
                              child: NumberPad(
                                  header: global.language("qty"),
                                  title: Text(
                                      '${detail.item_name} ${global.language('qty')} ${global.moneyFormat.format(detail.qty)} ${detail.unit_name}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  unitName: detail.unit_name,
                                  onChange: numPadChangeQty)),
                        );
                      });
                    });
              },
              label: global.language('qty'),
            ),
            const SizedBox(
              width: 2,
            ),
            commandButton(
              onPressed: () {
                logInsert(
                    commandCode: 2,
                    guid: findActiveLineByGuid,
                    closeExtra: false);
              },
              label: '+1 ${detail.unit_name}',
              // icon: Icons.exposure_plus_1,
            ),
            const SizedBox(
              width: 2,
            ),
            commandButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            contentPadding: const EdgeInsets.all(10),
                            content: SizedBox(
                                width: double.infinity,
                                height: 500,
                                child: NumberPad(
                                    header: global.language("price"),
                                    title: Text(
                                      '${detail.item_name} ${global.language('price')} ${global.moneyFormat.format(detail.price)} ${global.language('money_symbol')}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onChange: numPadChangePrice)),
                          );
                        });
                      });
                },
                //icon: Icons.price_change,
                label: global.language('price')),
            const SizedBox(
              width: 2,
            ),
            commandButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            contentPadding: const EdgeInsets.all(10),
                            content: SizedBox(
                                height: 500,
                                child: DiscountPad(
                                    header: global.language("discount"),
                                    title: Text(
                                        '${detail.item_name} ${global.language('qty')} ${global.moneyFormat.format(detail.qty)} ${detail.unit_name} ${global.language('price')} ${global.moneyFormat.format(detail.price)} ${global.language('money_symbol')}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    onChange: discountPadChange)),
                          );
                        });
                      });
                },
                label: global.language('discount')),
            const SizedBox(
              width: 2,
            ),
            commandButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                              title: Text(global.language('remark')),
                              content: TextFormField(
                                controller: textFieldRemarkController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: global.language("remark"),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      textFieldRemarkController.clear();
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text(global.language('save')),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    logInsert(
                                        commandCode: 8,
                                        guid: findActiveLineByGuid,
                                        remark: textFieldRemarkController.text,
                                        closeExtra: false);
                                    global.playSound(
                                        sound: global.SoundEnum.buttonTing);
                                  },
                                ),
                                ElevatedButton(
                                  child: Text(global.language('cancel')),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ]);
                        },
                      );
                    });
              },
              label: global.language('remark'),
            ),
            const SizedBox(
              width: 2,
            ),
            commandButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                              title: Text(global.language('delete')),
                              content: Text(
                                  '${detail.item_name} ${global.language('qty')} ${global.moneyFormat.format(detail.qty)} ${detail.unit_name} ${global.language('price')} ${global.moneyFormat.format(detail.price)} ${global.language('money_symbol')} ${global.language('delete_confirm')}'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text(global.language('delete')),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    logInsert(
                                        commandCode: 9,
                                        guid: findActiveLineByGuid);
                                    global.playSound(
                                        sound: global.SoundEnum.buttonTing);
                                    //selectProductExtraList.clear();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text(global.language('cancel')),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ]);
                        },
                      );
                    });
              },
              label: global.language('delete'),
            ),
          ],
        )));
  }

  Widget detail(PosProcessDetailModel detail, int index) {
    bool active = (activeLineNumber == -1)
        ? false
        : ((activeLineNumber == index) ? true : false);
    TextStyle textStyle = TextStyle(
        fontSize: 14,
        fontWeight: (active) ? FontWeight.bold : FontWeight.normal);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        color: (active)
            ? global.posTheme.transSelectedBackground
            : global.posTheme.transBackground,
      ),
      child: (active == false || detail.is_void)
          ? detailData(
              index: index,
              detail: detail,
              active: active,
              textStyle: textStyle)
          : Column(
              children: [
                detailButton(
                    index: index,
                    detail: detail,
                    active: active,
                    textStyle: textStyle),
                detailData(
                    index: index,
                    detail: detail,
                    active: active,
                    textStyle: textStyle),
              ],
            ),
    );
  }

  void textInputAdd(String word) {
    setState(() {
      textInput = textInput + word;
    });
  }

  Widget textBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(5),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(textInput,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget numericPadWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          textBar(),
          SizedBox(
            height: 240,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: '7',
                                    callBack: () => {textInputAdd("7")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: '8',
                                    callBack: () => {textInputAdd("8")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: '9',
                                    callBack: () => {textInputAdd("9")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    icon: Icons.backspace,
                                    textAndIconColor: Colors.black,
                                    callBack: () => {
                                      if (textInput.isNotEmpty)
                                        {
                                          setState(() {
                                            textInput = textInput.substring(
                                                0, textInput.length - 1);
                                          })
                                        }
                                    },
                                  )),
                            ]),
                      ),
                      Expanded(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '4',
                                  callBack: () => {textInputAdd("4")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '5',
                                  callBack: () => {textInputAdd("5")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '6',
                                  callBack: () => {textInputAdd("6")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  icon: Icons.add,
                                  textAndIconColor: Colors.black,
                                  callBack: () => {textInputAdd("+")},
                                )),
                          ])),
                      Expanded(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '1',
                                  callBack: () => {textInputAdd("1")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '2',
                                  callBack: () => {textInputAdd("2")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '3',
                                  callBack: () => {textInputAdd("3")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumPadButton(
                                  text: '?',
                                  callBack: () => {},
                                )),
                          ])),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: '.',
                                    callBack: () => {textInputAdd(".")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: '0',
                                    callBack: () => {textInputAdd("0")},
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: NumPadButton(
                                    text: 'C',
                                    color: Colors.red[100],
                                    callBack: () => {
                                      setState(() {
                                        textInput = "";
                                      })
                                    },
                                  )),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: 'D',
                                    color: Colors.cyan[100],
                                    callBack: () => {textInputAdd("D")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: '%',
                                    color: Colors.cyan[100],
                                    callBack: () => {textInputAdd("%")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumPadButton(
                                    text: 'P',
                                    color: Colors.green[100],
                                    callBack: () => {textInputAdd("P")},
                                  )),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget totalAndPayScreen() {
    // แสดงยอดรวมทั้งสิ้น

    return SizedBox(
      width: double.infinity,
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        (global.posHoldActiveNumber != 0)
            ? Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child:
                    Center(child: Text(global.posHoldActiveNumber.toString())))
            : Container(),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () async {
              dynamic result = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: PayScreen(
                    posProcess: global
                        .posHoldProcessResult[global.posHoldActiveNumber]
                        .posProcess,
                  ),
                ),
              );
              if (result != null) {
                if (result == true) {
                  setState(() {
                    restartClearData();
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Row(
                  children: [
                    Text(global.language("total"),
                        style: const TextStyle(
                          fontSize: 20.0,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        global.moneyFormat.format(global
                            .posHoldProcessResult[global.posHoldActiveNumber]
                            .posProcess
                            .total_amount),
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(global.language("money_symbol"),
                        style: const TextStyle(
                          fontSize: 20.0,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void restartClearData() {
    findActiveLineByGuid = "";
    activeLineNumber = -1;
    textInput = "";
    processEvent(holdNumber: global.posHoldActiveNumber);
  }

  void restart() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  title: Text(global.language("restart")),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  actions: <Widget>[
                    ElevatedButton(
                      /// เริ่มใหม่ (ทั้งหมด)
                      child: Text(global.language('restart')),
                      onPressed: () async {
                        logInsert(commandCode: 99);
                        Navigator.pop(context);
                        restartClearData();
                      },
                    ),
                    ElevatedButton(
                      child: Text(global.language('cancel')),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]);
            },
          );
        });
  }

  void openCashDrawer() {
    //logInsert(commandCode: 98);
    //global.openCashDrawer();
  }

  Widget commandButton(
      {required Function onPressed, String label = "", IconData? icon}) {
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 0, bottom: 0)),
            onPressed: () {
              onPressed();
            },
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: const TextStyle(fontSize: 12),
            )));
  }

  Widget commandWidget() {
    List<Widget> commandList = [
      commandButton(
        label: global.language("hold_bill"),
        onPressed: () {
          holdBill();
        },
      ),
      const SizedBox(
        width: 4,
      ),
      commandButton(
        label: global.language('open_cash_drawer'),
        onPressed: () {
          openCashDrawer();
        },
      ),
      const SizedBox(
        width: 4,
      ),
      commandButton(
        label: global.language('select_employee'),
        onPressed: () {
          findEmployee();
        },
      ),
      const SizedBox(
        width: 4,
      ),
      commandButton(
        label: (global.speechToTextVisible)
            ? global.language("speech_to_text_on")
            : global.language("speech_to_text_off"),
        onPressed: () {
          setState(() {
            if (global.speechToTextVisible) {
              global.playSound(word: global.language('speech_to_text_off'));
              global.speechToTextVisible = false;
            } else {
              global.speechToTextVisible = true;
              global.playSound(word: global.language('speech_to_text_on'));
            }
          });
          processEvent(holdNumber: global.posHoldActiveNumber);
        },
      ),
      const SizedBox(
        width: 4,
      ),
      commandButton(
          label: global.language('restart'),
          onPressed: () {
            restart();
          }),
      const SizedBox(
        width: 4,
      ),
      commandButton(
        label: global.language('main_screen'),
        //icon: Icons.web,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];

    return IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: commandList));
  }

  Widget transScreenScanBarcodeQrCode() {
    return (scannerStart)
        ? Container(
            color: Colors.white,
            width: double.infinity,
            height: 120,
            child: Row(children: [
              /*Expanded(
                  child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
              )),*/
              Column(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        scannerStart = !scannerStart;
                      });
                    },
                    child: Text(
                      global.language('close'),
                    ),
                  )),
                ],
              )
            ]))
        : Container();
  }

  Widget transScreenSummery() {
    TextStyle textStyleTotal =
        const TextStyle(color: Colors.black, fontSize: 16);
    return SingleChildScrollView(
        child: Column(children: [
      Text(
          "${global.language("total_amount")} ${global.moneyFormat.format(global.posHoldProcessResult[global.posHoldActiveNumber].posProcess.total_amount)} ${global.language("money_symbol")}",
          style: textStyleTotal),
      Text(
          "${global.language("total_qty")} ${global.moneyFormat.format(global.posHoldProcessResult[global.posHoldActiveNumber].posProcess.total_piece)} ${global.language("piece")}",
          style: textStyleTotal),
      if (global.posHoldProcessResult[global.posHoldActiveNumber].posProcess
          .promotion_list.isNotEmpty)
        for (var detail in global
            .posHoldProcessResult[global.posHoldActiveNumber]
            .posProcess
            .promotion_list)
          Row(
            children: [
              Expanded(
                  flex: 12,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(detail.promotion_name,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black)))),
              Expanded(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text(global.moneyFormat.format(detail.discount),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.red)))),
            ],
          ),
    ]));
  }

  Widget transScreen({required int mode, String barcode = ""}) {
    return (global.posHoldProcessResult[global.posHoldActiveNumber].posProcess
            .details.isEmpty)
        ? const Center(
            child: Icon(Icons.barcode_reader, color: Colors.grey, size: 200))
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Container(
                decoration: const BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.black, width: 1))),
                child: (mode == 0)
                    ? ListView(
                        scrollDirection: Axis.vertical,
                        controller: autoScrollController,
                        children: <Widget>[
                            for (int index = 0;
                                index <
                                    global
                                        .posHoldProcessResult[
                                            global.posHoldActiveNumber]
                                        .posProcess
                                        .details
                                        .length;
                                index++)
                              AutoScrollTag(
                                key: ValueKey(index),
                                controller: autoScrollController,
                                index: index,
                                highlightColor: Colors.black.withOpacity(0.1),
                                child: Container(
                                  child: detail(
                                      global
                                          .posHoldProcessResult[
                                              global.posHoldActiveNumber]
                                          .posProcess
                                          .details[index],
                                      index),
                                ),
                              )
                          ])
                    : ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                            for (int index = 0;
                                index <
                                    global
                                        .posHoldProcessResult[
                                            global.posHoldActiveNumber]
                                        .posProcess
                                        .details
                                        .length;
                                index++)
                              Container(
                                child: (barcode !=
                                        global
                                            .posHoldProcessResult[
                                                global.posHoldActiveNumber]
                                            .posProcess
                                            .details[index]
                                            .barcode)
                                    ? Container()
                                    : detail(
                                        global
                                            .posHoldProcessResult[
                                                global.posHoldActiveNumber]
                                            .posProcess
                                            .details[index],
                                        index),
                              )
                          ])));
  }

  void receiveMoneyDialog() {
    receiveAmount.text = "";
    empCode.text = global.userLoginCode;
    showDialog(
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(2),
                              constraints: const BoxConstraints(maxWidth: 250),
                              width: (MediaQuery.of(context).size.width / 100) *
                                  40,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      global.language("receive_money"),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: empCode,
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.person),
                                        hintText: global.language('emp_code'),
                                        labelText: global.language('emp_name'),
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: receiveAmount,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.money),
                                        hintText: global.language('จำนวนเงิน'),
                                        labelText: global.language('เงินทอน'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          child:
                                              Text(global.language("cancel")),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.amber.shade600),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          child: Text(global.language("save")),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green.shade600),
                                          onPressed: () {
                                            /*ReceiveMoneyHelper
                                                _receiveMoneyHelper =
                                                ReceiveMoneyHelper();
                                            _receiveMoneyHelper.insert(
                                                ReceiveMoneyStruct(
                                                    doc_number:
                                                        const Uuid().v4(),
                                                    person_code: emp_code.text,
                                                    create_date_time:
                                                        DateTime.now(),
                                                    receive_money: double.parse(
                                                        receiveAmount.text)));*/
                                            Navigator.of(context).pop();

                                            global.playSound(
                                                word:
                                                    "รับเงินทอน จำนวน ${receiveAmount.text} ${global.language("money_symbol")}");

                                            showMessageDialog(
                                                header: "บันทึกสำเร็จ",
                                                msg:
                                                    "รับเงินทอน จำนวน ${receiveAmount.text} ${global.language("money_symbol")}",
                                                type: "success");
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 250),
                              width: (MediaQuery.of(context).size.width / 100) *
                                  50,
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(children: [
                                      Container(
                                          height: 60,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '7',
                                                      callBack: () => {
                                                        textInputChanged("7")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '8',
                                                      callBack: () => {
                                                        textInputChanged("8")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '9',
                                                      callBack: () => {
                                                        textInputChanged("9")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: 'x',
                                                      callBack: () => {},
                                                    )),
                                              ])),
                                      Container(
                                          height: 60,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '4',
                                                      callBack: () => {
                                                        textInputChanged("4")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '5',
                                                      callBack: () => {
                                                        textInputChanged("5")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '6',
                                                      callBack: () => {
                                                        textInputChanged("6")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '+',
                                                      callBack: () => {},
                                                    )),
                                              ])),
                                      Container(
                                          height: 60,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '1',
                                                      callBack: () => {
                                                        textInputChanged("1")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '2',
                                                      callBack: () => {
                                                        textInputChanged("2")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '3',
                                                      callBack: () => {
                                                        textInputChanged("3")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: 'C',
                                                      callBack: () =>
                                                          {clearText()},
                                                    )),
                                              ])),
                                      Container(
                                          height: 60,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '0',
                                                      callBack: () => {
                                                        textInputChanged("0")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      text: '.',
                                                      callBack: () => {
                                                        textInputChanged(".")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      icon: Icons.backspace,
                                                      callBack: () =>
                                                          {backSpace()},
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumPadButton(
                                                      icon: Icons.expand,
                                                      callBack: () => {},
                                                    )),
                                              ])),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void textInputChanged(String value) {
    receiveAmount.text += value;
  }

  void clearText() {
    receiveAmount.text = "";
  }

  void backSpace() {
    if (receiveAmount.text.isNotEmpty) {
      receiveAmount.text =
          receiveAmount.text.substring(0, receiveAmount.text.length - 1);
    }
  }

  void showMessageDialog(
      {required String header,
      required String msg,
      required String type}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(global.language('ok')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void findItemByCodeNameBarcode() async {
    _barcodeScanActive = false;
    await Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: findItemScreen))
        .then((value) async {
      if (value != null)
        logInsert(
            commandCode: value.command,
            barcode: value.data.barcode,
            qty: value.qty.toString(),
            price: value.priceOrPersent);
    });
    _barcodeScanActive = true;
  }

  void findMemberByCodeName() async {
    await Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: findMemberScreen),
    );
  }

  void findEmployee() async {
    await Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: const FindEmployee()),
    ).then((value) {
      setState(() {
        global.posHoldProcessResult[global.posHoldActiveNumber].saleCode =
            value[0];
        global.posHoldProcessResult[global.posHoldActiveNumber].saleName =
            value[1];
      });
    });
  }

  void holdBill() async {
    // พักบิล
    var result = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const PosHoldBill(),
      ),
    );

    if (result != null) {
      global.posHoldActiveNumber = result;
      processEvent(holdNumber: global.posHoldActiveNumber);
      global.playSound(sound: global.SoundEnum.beep);
      findActiveLineByGuid = "";
      activeLineNumber = -1;
      if (global.appMode == global.AppModeEnum.posTerminal) {
        posCompileProcess(holdNumber: global.posHoldActiveNumber).then((_) {
          PosProcess().sumCategoryCount(global
              .posHoldProcessResult[global.posHoldActiveNumber].posProcess);
        });
      } else {
        await getProcessFromTerminal();
      }
      global.payScreenData =
          global.posHoldProcessResult[global.posHoldActiveNumber].payScreenData;
      setState(() {});
    }
  }

  Widget promotionWidget() {
    return Container(
        decoration: BoxDecoration(
          color: global.posTheme.transBackground,
        ),
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(children: [
          for (var detail in global
              .posHoldProcessResult[global.posHoldActiveNumber]
              .posProcess
              .promotion_list)
            Row(
              children: [
                Expanded(
                    flex: 12,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(detail.promotion_name,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)))),
                Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Text(global.moneyFormat.format(detail.discount),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red)))),
              ],
            )
        ]));
  }

  Widget posLayoutBottom() {
    late Widget menu;
    if (global.isWideScreen()) {
      menu = Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          width: double.infinity,
          child: Row(
            children: [
              if (tabletTabController.index == 1)
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const Icon(
                        Icons.grid_on,
                      ),
                      onPressed: () {
                        setState(() {
                          tabletTabController.index = 0;
                        });
                      }),
                ),
              if (tabletTabController.index == 0)
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        setState(() {
                          tabletTabController.index = 1;
                        });
                      }),
                ),
              if (Platform.isAndroid || Platform.isIOS)
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const FaIcon(FontAwesomeIcons.barcode),
                      onPressed: () {
                        setState(() {
                          scannerStart = !scannerStart;
                        });
                      }),
                ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const FaIcon(FontAwesomeIcons.addressBook),
                    onPressed: () {}),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          (showNumericPad) ? Colors.amber : Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const FaIcon(FontAwesomeIcons.calculator),
                    onPressed: () {
                      setState(() {
                        showNumericPad = !showNumericPad;
                      });
                    }),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: Icon(
                      (showButtonMenu)
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                    onPressed: () {
                      setState(() {
                        showButtonMenu = !showButtonMenu;
                      });
                    }),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const FaIcon(FontAwesomeIcons.rotate),
                    onPressed: () {
                      setState(() {
                        if (splitViewMode == 1) {
                          splitViewMode = 2;
                          splitViewController = SplitViewController(
                              weights: [0.4, 0.6],
                              limits: [WeightLimit(min: 0.2, max: 0.8)]);
                        } else {
                          splitViewMode = 1;
                          splitViewController = SplitViewController(
                              weights: [0.6, 0.4],
                              limits: [WeightLimit(min: 0.2, max: 0.8)]);
                        }
                      });
                    }),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          (showNumericPad) ? Colors.amber : Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const FaIcon(FontAwesomeIcons.searchengin),
                    onPressed: () {
                      setState(() {
                        gridItemSize += 1;
                        if (gridItemSize > 6) {
                          gridItemSize = 1;
                        }
                      });
                    }),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          (showNumericPad) ? Colors.amber : Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: (global.posScreenStyle ==
                            global.PosScreenStyleEnum.desktop)
                        ? const Icon(Icons.tablet)
                        : const FaIcon(FontAwesomeIcons.desktop),
                    onPressed: () {
                      setState(() {
                        if (global.posScreenStyle ==
                            global.PosScreenStyleEnum.tablet) {
                          global.posScreenStyle =
                              global.PosScreenStyleEnum.desktop;
                        } else {
                          global.posScreenStyle =
                              global.PosScreenStyleEnum.tablet;
                        }
                      });
                    }),
              ),
            ],
          ));
    } else {
      menu = Row(children: [
        if (Platform.isAndroid || Platform.isIOS)
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: const FaIcon(FontAwesomeIcons.barcode),
                onPressed: () {
                  setState(() {
                    scannerStart = !scannerStart;
                  });
                }),
          ),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              child: const FaIcon(FontAwesomeIcons.calculator),
              onPressed: () {
                setState(() {});
              }),
        ),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              child: Icon(
                (showButtonMenu) ? Icons.arrow_downward : Icons.arrow_upward,
              ),
              onPressed: () {
                setState(() {
                  showButtonMenu = !showButtonMenu;
                });
              }),
        ),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: (showNumericPad) ? Colors.amber : Colors.white,
                backgroundColor: Colors.black,
              ),
              child: const FaIcon(FontAwesomeIcons.searchengin),
              onPressed: () {
                setState(() {
                  gridItemSize += 1;
                  if (gridItemSize > 3) {
                    gridItemSize = 1;
                  }
                });
              }),
        ),
      ]);
    }

    return Column(children: [
      Container(
          height: 40,
          margin: const EdgeInsets.only(top: 5),
          child: totalAndPayScreen()),
      menu,
      if (showButtonMenu)
        Padding(
            padding: const EdgeInsets.only(bottom: 4), child: commandWidget())
    ]);
  }

  Widget posLayoutWideScreen() {
    Size size = MediaQuery.of(context).size;
    Widget selectProduct = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          width: 0,
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(children: [
        Expanded(
            child: Row(children: [
          Expanded(
              child: DefaultTabController(
                  length: 5,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabletTabController,
                      children: [
                        selectProductLevelWidget(constraints),
                        findByText(),
                        Container(
                          width: double.infinity,
                        ),
                        Container(
                          width: double.infinity,
                        ),
                        Container(
                          width: double.infinity,
                        ),
                      ],
                    );
                  }))),
          if (productOptions.isNotEmpty) selectProductExtraListWidget()
        ])),
      ]),
    );
    Widget screenSale = Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(width: 0, color: Colors.white),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8, right: 4),
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(width: 0, color: Colors.blue)),
              child: Column(children: [
                if (global.posHoldProcessResult[global.posHoldActiveNumber]
                    .customerCode.isNotEmpty)
                  Row(children: [
                    Expanded(
                        child: Row(children: [
                      Text(
                        '${global.language('ลูกค้า')} :',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${global.posHoldProcessResult[global.posHoldActiveNumber].customerName} (${global.posHoldProcessResult[global.posHoldActiveNumber].customerCode})",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleCode = "";
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleName = "";
                        });
                      },
                    )
                  ]),
                if (global
                    .posHoldProcessResult[global.posHoldActiveNumber].saleCode
                    .trim()
                    .isNotEmpty)
                  Row(children: [
                    Expanded(
                        child: Row(children: [
                      Text(
                        '${global.language('sale')} : ',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${global.posHoldProcessResult[global.posHoldActiveNumber].saleName} (${global.posHoldProcessResult[global.posHoldActiveNumber].saleCode})",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      padding: const EdgeInsets.all(2),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleCode = "";
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleName = "";
                        });
                      },
                    )
                  ]),
              ])),
          Expanded(
            child: transScreen(mode: 0),
          ),
          posLayoutBottom(),
        ],
      ),
    );

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
            color: Colors.white,
            width: size.width,
            child: SplitView(
              gripColor: Colors.blueGrey.shade100,
              controller: splitViewController,
              //onWeightChanged: (w) => print("Horizontal $w"),
              indicator:
                  const SplitIndicator(viewMode: SplitViewMode.Horizontal),
              viewMode: SplitViewMode.Horizontal,
              activeIndicator: const SplitIndicator(
                viewMode: SplitViewMode.Horizontal,
                isActive: true,
              ),
              children: (splitViewMode == 1)
                  ? [
                      selectProduct,
                      screenSale,
                    ]
                  : [
                      screenSale,
                      selectProduct,
                    ],
            )),
        if (showNumericPad)
          Positioned(
              left: showNumericPadLeft,
              top: showNumericPadTop,
              child: LongPressDraggable(
                feedback: SizedBox(
                  width: 250,
                  height: 310,
                  child: Center(child: numericPadWidget()),
                ),
                childWhenDragging: Container(),
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  setState(() {
                    showNumericPadLeft = offset.dx;
                    showNumericPadTop = offset.dy;
                  });
                },
                child: SizedBox(
                    width: 250, height: 310, child: numericPadWidget()),
              )),
      ]),
    ));
  }

  Widget posLayoutPhoneScreen() {
    return SafeArea(
        child: DefaultTabController(
            length: 4,
            child: Builder(builder: (BuildContext context) {
              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  if (tabController.index == 2) {
                    SystemChannels.textInput.invokeMethod('TextInput.show');
                  } else {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  }
                }
              });
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                  color: Colors.blue,
                                  child: const TabBar(
                                    tabs: [
                                      Tab(
                                        icon: Icon(Icons.list),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.group_work),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.search),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.menu),
                                      ),
                                    ],
                                  )),
                              Expanded(child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return Column(children: [
                                  Expanded(
                                      child: TabBarView(children: [
                                    transScreen(mode: 0),
                                    selectProductLevelWidget(constraints),
                                    findByText(),
                                    Container()
                                    //commandScreen(),
                                  ])),
                                  posLayoutBottom(),
                                ]);
                              })),
                            ],
                          ))));
            })));
  }

  Widget posLayoutDesktop() {
    Size size = MediaQuery.of(context).size;
    Widget selectProduct = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          width: 0,
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(children: [
        Expanded(
            child: Row(children: [
          Expanded(child: transScreen(mode: 0)),
          if (productOptions.isNotEmpty) selectProductExtraListWidget()
        ])),
      ]),
    );
    Widget screenSale = Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(width: 0, color: Colors.white),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8, right: 4),
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(width: 0, color: Colors.blue)),
              child: Column(children: [
                if (global.posHoldProcessResult[global.posHoldActiveNumber]
                    .customerCode.isNotEmpty)
                  Row(children: [
                    Expanded(
                        child: Row(children: [
                      Text(
                        '${global.language('ลูกค้า')} :',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${global.posHoldProcessResult[global.posHoldActiveNumber].customerName} (${global.posHoldProcessResult[global.posHoldActiveNumber].customerCode})",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleCode = "";
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleName = "";
                        });
                      },
                    )
                  ]),
                if (global
                    .posHoldProcessResult[global.posHoldActiveNumber].saleCode
                    .trim()
                    .isNotEmpty)
                  Row(children: [
                    Expanded(
                        child: Row(children: [
                      Text(
                        '${global.language('sale')} : ',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${global.posHoldProcessResult[global.posHoldActiveNumber].saleName} (${global.posHoldProcessResult[global.posHoldActiveNumber].saleCode})",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      padding: const EdgeInsets.all(2),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleCode = "";
                          global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .saleName = "";
                        });
                      },
                    )
                  ]),
              ])),
          Expanded(
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 0, color: Colors.blue),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ]),
                child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 4,
                    runSpacing: 4,
                    children: widgetMessage),
              ),
              Expanded(child: desktopNumPad),
            ]),
          ),
          posLayoutBottom(),
        ],
      ),
    );

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: RawKeyboardListener(
              autofocus: true,
              includeSemantics: true,
              focusNode: mainFocusNode,
              onKey: (RawKeyEvent key) {
                if (key.runtimeType.toString() == 'RawKeyDownEvent') {
                  String keyLabel = key.logicalKey.keyLabel.toUpperCase();
                  if (keyLabel == "BACKSPACE") {
                    if (posNumPadGlobalKey.currentState != null) {
                      posNumPadGlobalKey.currentState!.backspace();
                    }
                  }
                  if (keyLabel.contains("NUMPAD") ||
                      keyLabel.contains("MULTIPLY")) {
                    keyLabel =
                        keyLabel.removeAllWhitespace.replaceAll("NUMPAD", "");
                    if (keyLabel.contains("DECIMAL")) {
                      keyLabel = ".";
                    }
                    if (keyLabel == "MULTIPLY") {
                      keyLabel = "*";
                    }
                    if ("01234567890*.".contains(keyLabel)) {
                      posNumPadGlobalKey.currentState?.addValue(keyLabel);
                    }
                  }
                }
              },
              child: Stack(children: [
                Container(
                    color: Colors.white,
                    width: size.width,
                    child: SplitView(
                      gripColor: Colors.blueGrey.shade100,
                      controller: splitViewController,
                      //onWeightChanged: (w) => print("Horizontal $w"),
                      indicator: const SplitIndicator(
                          viewMode: SplitViewMode.Horizontal),
                      viewMode: SplitViewMode.Horizontal,
                      activeIndicator: const SplitIndicator(
                        viewMode: SplitViewMode.Horizontal,
                        isActive: true,
                      ),
                      children: (splitViewMode == 1)
                          ? [
                              selectProduct,
                              screenSale,
                            ]
                          : [
                              screenSale,
                              selectProduct,
                            ],
                    )),
                if (showNumericPad)
                  Positioned(
                      left: showNumericPadLeft,
                      top: showNumericPadTop,
                      child: LongPressDraggable(
                        feedback: SizedBox(
                          width: 250,
                          height: 310,
                          child: Center(child: numericPadWidget()),
                        ),
                        childWhenDragging: Container(),
                        onDraggableCanceled:
                            (Velocity velocity, Offset offset) {
                          setState(() {
                            showNumericPadLeft = offset.dx;
                            showNumericPadTop = offset.dy;
                          });
                        },
                        child: SizedBox(
                            width: 250, height: 310, child: numericPadWidget()),
                      )),
              ]),
            )));
  }

  Widget appLayoutPos() {
    return (global.isWideScreen() &&
            global.posScreenStyle == global.PosScreenStyleEnum.desktop)
        ? posLayoutDesktop()
        : (global.isWideScreen())
            ? posLayoutWideScreen()
            : posLayoutPhoneScreen();
  }

  Widget appLayoutRestaurant() {
    return (global.isWideScreen())
        ? SafeArea(
            child: Scaffold(
            body: Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(child: selectProduct()),
                            if (showButtonMenu)
                              SizedBox(
                                  height: 190,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Expanded(child: commandScreen()),
                                        numericPadWidget()
                                      ])),
                          ],
                        )),
                        Column(
                          children: [/*commandScreen(),*/ numericPadWidget()],
                        ),
                      ],
                    ))),
          ))
        : SafeArea(
            child: DefaultTabController(
                length: 4,
                child: Builder(builder: (BuildContext context) {
                  final TabController tabController =
                      DefaultTabController.of(context);
                  tabController.addListener(() {
                    if (!tabController.indexIsChanging) {
                      if (tabController.index == 2) {
                        SystemChannels.textInput.invokeMethod('TextInput.show');
                      } else {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      }
                    }
                  });
                  return Scaffold(
                      body: Container(
                          decoration: const BoxDecoration(color: Colors.black),
                          child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                      color: Colors.blue,
                                      child: TabBar(
                                        tabs: [
                                          Tab(
                                            icon: const Icon(Icons.list),
                                            text: global.language('list'),
                                          ),
                                          Tab(
                                            icon: const Icon(Icons.group_work),
                                            text: global.language('group'),
                                          ),
                                          Tab(
                                            icon: const Icon(Icons.search),
                                            text: global.language('search'),
                                          ),
                                          Tab(
                                            icon: const Icon(Icons.menu),
                                            text: global.language('menu'),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      child: TabBarView(
                                    children: [
                                      transScreen(mode: 0),
                                      Container(),
                                      /*selectProductLevelWidget()*/
                                      findByText(),
                                      //commandScreen(),
                                    ],
                                  )),
                                ],
                              ))));
                })));
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Card(
        elevation: 1,
        color: Colors.grey.shade100,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Center(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$buttonText",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void productCategoryLoadFinish() {
    PosProcess().sumCategoryCount(
        global.posHoldProcessResult[global.posHoldActiveNumber].posProcess);
    context.read<ProductCategoryBloc>().add(ProductCategoryLoadFinish());
  }

  @override
  Widget build(BuildContext context) {
    global.globalContext = context;
    print("Build : ${DateTime.now()}");
    return MultiBlocListener(
        listeners: [
          BlocListener<ProductCategoryBloc, ProductCategoryState>(
            listener: (context, state) async {
              if (state is ProductCategoryLoadSuccess) {
                dev.log('xxxxxx Category');
                loadCategory();
                await loadProductByCategory(categoryGuidSelected);
                PosProcess().sumCategoryCount(global
                    .posHoldProcessResult[global.posHoldActiveNumber]
                    .posProcess);
                processEvent(holdNumber: global.posHoldActiveNumber);
                productCategoryLoadFinish();
              }
            },
          ),
          /*BlocListener<PosProcessBloc, PosProcessState>(
            listener: (context, state) {
              if (state is PosProcessFinish) {
                setState(() {});
                Future.delayed(const Duration(milliseconds: 50), () {
                  autoScrollController.scrollToIndex(
                      (global.posHoldProcessResult[global.posHoldActiveNumber]
                                  .posProcess.active_line_number <
                              0)
                          ? 0
                          : global
                              .posHoldProcessResult[global.posHoldActiveNumber]
                              .posProcess
                              .active_line_number,
                      preferPosition: AutoScrollPosition.begin);
                });
                global.posClientDeviceList[global.posHoldActiveNumber].processSuccess = false;
                global.sendProcessToCustomerDisplay();
                global.sendProcessToClient();
              }
              if (state is PosProcessSuccess) {
                print('PosProcessSuccess');
                global.posHoldProcessResult[global.posHoldActiveNumber]
                    .posProcess = state.result;
                if (global.posHoldProcessResult[global.posHoldActiveNumber]
                    .posProcess.details.isNotEmpty) {
                  activeLineNumber = global
                      .posHoldProcessResult[global.posHoldActiveNumber]
                      .posProcess
                      .active_line_number;
                  if (activeLineNumber != -1) {
                    activeGuid = global
                        .posHoldProcessResult[global.posHoldActiveNumber]
                        .posProcess
                        .details[activeLineNumber]
                        .guid;
                  }
                } else {
                  activeLineNumber = -1;
                  activeGuid = "";
                }
                context.read<PosProcessBloc>().add(
                    PosProcessFinish(holdNumber: global.posHoldActiveNumber));
              }
            },
          )*/
        ],
        child: VisibilityDetector(
            onVisibilityChanged: (VisibilityInfo info) {
              isVisible = info.visibleFraction > 0;
            },
            key: const Key('visible-detector-key'),
            child: BarcodeKeyboardListener(
                useKeyDownEvent: true,
                bufferDuration: const Duration(milliseconds: 200),
                onBarcodeScanned: (barcode) async {
                  if (barcode.trim().isEmpty) {
                    if (posNumPadGlobalKey.currentState != null) {
                      barcode = posNumPadGlobalKey.currentState!.number;
                      posNumPadGlobalKey.currentState!.clear();
                    }
                  }
                  print('------------------------ Scan Barcode : $barcode');
                  if (!isVisible || _barcodeScanActive == false) return;
                  logInsert(
                      commandCode: 1,
                      barcode: barcode,
                      qty: (textInput.isEmpty) ? "1.0" : textInput);
                  textInput = "";
                },
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.black,
                    body: (global.appMode == global.AppModeEnum.posTerminal ||
                            global.appMode == global.AppModeEnum.posRemote)
                        ? appLayoutPos()
                        : appLayoutRestaurant()))));
  }
}
