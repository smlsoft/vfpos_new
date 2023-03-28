import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/model/objectbox/product_option.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullscreen/fullscreen.dart';
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
import 'package:dedepos/api/sync/model/credit_card_payment.dart';
import 'package:dedepos/model/find/find_member_struct.dart';
import 'package:dedepos/api/sync/model/sync_inventory.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/model/json/payment.dart';
import 'package:dedepos/api/sync/model/payment_api.dart';
import 'package:dedepos/model/json/sale_invoice.dart';
import 'package:dedepos/model/sale_invoice_item.dart';
import 'package:dedepos/model/json/transfer_payment.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/services/find_employee.dart';
import 'package:dedepos/services/find_member.dart';
import 'package:dedepos/services/hold_bill.dart';
import 'package:dedepos/widgets/button_bill.dart';
import 'package:dedepos/widgets/roundmenu.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dedepos/db/product_category_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/model/json/receive_money_struct.dart';
import 'package:dedepos/api/sync/model/promotion_struct.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/widgets/discount_pad.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../bloc/product_group_bloc.dart';
import '../services/find_item.dart';
import 'pay/pay_screen.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:dedepos/db/pos_log_helper.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/model/objectbox/config_struct.dart';
import 'pos_process.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'package:dedepos/model/pos_pay_struct.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/api/network/server.dart' as network;
import 'package:dedepos/services/device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dedepos/bloc/pos_process_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:dedepos/model/find/find_item_struct.dart';
import 'package:dedepos/model/json/print_queue_struct.dart';
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
  final String barcodeScanResult = "";
  bool _barcodeScanActive = true;
  String textInput = "";
  late bool scannerStart = false;
  bool showButtonMenu = true;
  String categoryGuidSelected = global.startGroupCode;
  final TextEditingController empCode = TextEditingController();
  final TextEditingController receiveAmount = TextEditingController();
  final FindItem findItemScreen = const FindItem();
  final FindMember findMemberScreen = const FindMember();
  bool _displayDetailByBarcode = false;
  final _debouncer = global.Debounce(500);
  final List<FindItemStruct> findByCodeNameLastResult = [];
  final TextEditingController textFindByTextController =
      TextEditingController();
  FocusNode? textFindByTextFocus;
  String activeGuid = '';
  int activeLineNumber = -1;
  final bool isListen = false;
  final double confidence = 1.0;
  late TabController tabletTabController;
  final SplitViewController splitViewController = SplitViewController(
      weights: [0.7], limits: [WeightLimit(min: 0.4, max: 0.75)]);
  bool showNumericPad = false;
  double showNumericPadTop = 100;
  double showNumericPadLeft = 100;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? scanController;

  void refresh() {
    dev.log("refresh");
    setState(() {});
  }

  ProductBarcodeObjectBoxStruct product = ProductBarcodeObjectBoxStruct(
      barcode: "",
      color_select: "",
      image_or_color: true,
      color_select_hex: "",
      names: [],
      name_all: "",
      group_count: 0,
      prices: [],
      parent_group_guid: "",
      images_url: "",
      unit_code: "",
      unit_names: [],
      new_line: 0,
      group_code: "",
      category_index: 0,
      guid_fixed: "",
      item_code: "",
      item_guid: "",
      descriptions: [],
      item_unit_code: "",
      options_json: "",
      product_count: 0);
  List<ProductOptionStruct> productOptions = [];

  Future<void> checkSync() async {
    if (global.syncRefreshProductCategory) {
      dev.log("syncRefreshProductCategory");
      global.syncRefreshProductCategory = false;
      loadCategory();
      loadProductByCategory(categoryGuidSelected);
      processEvent();
    }
    if (global.syncRefreshProductBarcode) {
      dev.log("syncRefreshProductBarcode");
      global.syncRefreshProductBarcode = false;
      loadProductByCategory(categoryGuidSelected);
      processEvent();
    }
  }

  @override
  void initState() {
    super.initState();
    dev.log("initState PosScreen 1");
    checkOnline();
    dev.log("initState PosScreen 2");
    global.saleActiveName = "";
    global.saleActiveCode = "";
    global.customerActiveName = "";
    global.customerActiveCode = "";
    // เรียกรายการประกอบการขายจาก Hold
    global.payScreenData =
        global.posHoldList[global.posHoldNumber].payScreenData;
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
    if (global.isTablet) {
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
    deviceTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      network.testPrinterConnect();
    });
    posScreenTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      checkSync();
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
    processEvent();
    checkSync();
  }

  @override
  void dispose() {
    super.dispose();
    deviceTimer.cancel();
    posScreenTimer.cancel();
    messageTimer.cancel();
    // เก็บรายละเอียด Hold
    global.posHoldList[global.posHoldNumber].payScreenData =
        global.payScreenData;
  }

  void loadCategory() {
    String categoryGuid = (global.productCategoryCodeSelected.isEmpty)
        ? ""
        : global
            .productCategoryCodeSelected[
                global.productCategoryCodeSelected.length - 1]
            .guid_fixed;
    dev.log('loadCategory : $categoryGuid');
    context
        .read<ProductGroupBloc>()
        .add(ProductGroupLoadStart(parentGroupCode: categoryGuid));
  }

  void loadProductByCategory(String categoryGuid) {
    // ดึงรายการ Category ย่อย และ รายการสินค้า
    if (categoryGuid.isNotEmpty) {
      global.productCategoryChildList = ProductCategoryHelper()
          .selectByParentCategoryGuidOrderByXorder(
              parentCategoryGuid: categoryGuid);
      /*global.productListByCategory =
          ProductBarcodeHelper().selectByGroup(categoryGuid);*/
      var selectCodeList =
          ProductCategoryHelper().selectByCategoryGuidFindFirst(categoryGuid);
      global.productListByCategory = [];
      if (selectCodeList != null) {
        ProductCategoryObjectBoxStruct category = selectCodeList;
        for (var item in jsonDecode(category.codelist)) {
          SyncCategoryCodeList codeList = SyncCategoryCodeList.fromJson(item);
          var selectProductByBarcode =
              ProductBarcodeHelper().selectByBarcodeFirst(codeList.barcode);
          if (selectProductByBarcode != null) {
            ProductBarcodeObjectBoxStruct product = selectProductByBarcode;
            global.productListByCategory.add(product);
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

      /// กลุ่มสินค้า
      String guidGroup = "",

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
              PosLogHelper().selectByGuidFixed(activeGuid);
          if (posLogSelect.isNotEmpty) {
            logHelper.insert(PosLogObjectBoxStruct(
                guid_code_ref: guidCodeRef,
                guid_ref: guidRef,
                log_date_time: DateTime.now(),
                hold_number: global.posHoldNumber,
                command_code: commandCode,
                extra_code: extraCode,
                code: code,
                guid_group: guidGroup,
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
              ProductBarcodeHelper().selectByBarcodeFirst(barcode);
          String productNameStr = '';
          String unitCodeStr = "";
          String unitNameStr = "";
          if (productSelect != null) {
            productNameStr = productSelect.names[0];
            unitCodeStr = productSelect.unit_code;
            unitNameStr = productSelect.unit_names[0];
            logHelper.insert(PosLogObjectBoxStruct(
                log_date_time: DateTime.now(),
                hold_number: global.posHoldNumber,
                command_code: commandCode,
                barcode: barcode,
                name: productNameStr,
                unit_code: unitCodeStr,
                unit_name: unitNameStr,
                qty: qtyForCalc,
                price: double.tryParse(productSelect.prices[0]) ?? 0.0));
            global.playSound(
                sound: global.SoundEnum.beep, word: productNameStr);
          } else {
            global.playSound(
                sound: global.SoundEnum.fail,
                word: global.language("item_not_found"));
          }
        }
        break;
      case 2:
        // 2=เพิ่มจำนวน + 1
        List<PosLogObjectBoxStruct> posLogSelect =
            PosLogHelper().selectByGuidFixed(activeGuid);
        if (posLogSelect.isNotEmpty) {
          logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: activeGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldNumber,
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
            PosLogHelper().selectByGuidFixed(activeGuid);
        if (posLogSelect.isNotEmpty) {
          logHelper.insert(PosLogObjectBoxStruct(
              guid_ref: activeGuid,
              log_date_time: DateTime.now(),
              hold_number: global.posHoldNumber,
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
        logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: activeGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldNumber,
            command_code: commandCode,
            qty: qtyForCalc));
        break;
      case 5:
        // 5=แก้ราคา
        logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: activeGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldNumber,
            command_code: commandCode,
            price: priceForCalc));
        break;
      case 6:
        // 6=แก้ส่วนลด
        logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: activeGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldNumber,
            command_code: commandCode,
            discountText: discount));
        break;
      case 8:
        // 8=แก้หมายเหตุ
        logHelper.insert(PosLogObjectBoxStruct(
            guid_ref: activeGuid,
            log_date_time: DateTime.now(),
            hold_number: global.posHoldNumber,
            command_code: commandCode,
            remark: remark));
        break;
      case 9:
        // 9=ลบรายการ
        logHelper.insert(PosLogObjectBoxStruct(
            log_date_time: DateTime.now(),
            hold_number: global.posHoldNumber,
            command_code: commandCode,
            guid_ref: activeGuid));
        global.playSound(
            sound: global.SoundEnum.beep,
            word: global.language("delete") + global.language("line"));
        productOptions.clear();
        break;
      case 99:
        // เริ่มใหม่
        global.playSound(
            sound: global.SoundEnum.beep, word: global.language("restart"));
        productOptions.clear();
        break;
      default:
        dev.log("commandCode=$commandCode");
        break;
    }
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
                    _debouncer.run(() {
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
                                                child: Numpad(
                                                    header:
                                                        global.language("qty"),
                                                    title: Text(
                                                        '${detail.item_names[0]} ${global.language("qty")} ${global.moneyFormat.format(detail.qty)} ${detail.unit_names[0]}',
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    onChange: (qty) => {
                                                          if (qty.isNotEmpty &&
                                                              double.parse(
                                                                      qty) >
                                                                  0)
                                                            {
                                                              detail.qty =
                                                                  double.parse(
                                                                      qty),
                                                            }
                                                        })),
                                          );
                                        });
                                      });
                                  refresh();
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
                                  processEvent(barcode: detail.barcode);
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

  void processEvent({String barcode = ""}) {
    print("processEvent()");
    if (barcode.isNotEmpty) {
      product = ProductBarcodeHelper().selectByBarcodeFirst(barcode) ??
          ProductBarcodeObjectBoxStruct(
              barcode: "",
              names: [],
              name_all: "",
              prices: [],
              unit_code: "",
              unit_names: [],
              group_count: 0,
              new_line: 0,
              group_code: "",
              images_url: "",
              parent_group_guid: "",
              category_index: 0,
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
    context.read<PosProcessBloc>().add(ProcessEvent());
  }

  void numPadChangeQty(String qty, String unitName) async {
    if (qty.isNotEmpty && double.parse(qty) > 0) {
      global.playSound(
          sound: global.SoundEnum.buttonTing,
          word: "qty_update" + "is" + qty.toString() + unitName);
      logInsert(commandCode: 4, guid: activeGuid, qty: qty, closeExtra: false);
      processEvent();
    }
  }

  void numPadChangePrice(double price) async {
    if (price > 0) {
      global.playSound(
          word: global.language("price_update") +
              global.language("is") +
              price.toString() +
              global.language("money_symbol"));
      logInsert(
          commandCode: 5, guid: activeGuid, price: price, closeExtra: false);
      processEvent();
    }
  }

  Future<void> selectProductLevelExtraListCheck(
      int groupIndex, int detailIndex, bool value) async {
    if (value == true) {
      // ถ้าเลือกแล้ว ให้ทำการลบข้อมูลที่มีอยู่แล้วออก (ลบของเก่า)
      PosLogHelper().deleteByGuidCodeRefHoldNumberGroupCommandCode(
          guidCode: productOptions[groupIndex].choices[detailIndex].guid_fixed,
          group: productOptions[groupIndex].guid_fixed,
          commandCode: 101,
          holdNumber: global.posHoldNumber);
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
        ProductChoiceStruct detail =
            productOptions[groupIndex].choices[detailIndex];
        // เพิ่ม Log รายการที่เลือก
        logInsert(
            guidCodeRef: detail.guid_fixed,
            guidGroup: productOptions[groupIndex].guid_fixed,
            commandCode: 101,
            guidRef: activeGuid,
            barcode: detail.barcode,
            price: detail.price,
            qty: detail.qty.toString(),
            extraCode: "",
            closeExtra: false,
            name: detail.names[0],
            codeDefault: "",
            selected: detail.selected);
        global.playSound(sound: global.SoundEnum.beep, word: detail.names[0]);
        processEvent();
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
          guid: activeGuid,
          discount: discount,
          closeExtra: false);
    } else {
      global.playSound(word: global.language("discount_cancel"));
      logInsert(
          commandCode: 6, guid: activeGuid, discount: '', closeExtra: false);
    }
    processEvent();
    global.posProcessResult.active_line_number = -1;
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
      processEvent(barcode: barcodeScanResult);

      await controller.pauseCamera();
      await Future.delayed(const Duration(seconds: 1));
      await controller.resumeCamera();
    });
  }

  Widget productLevelLabelWidget({
    required String name,
    String unitName = "",
    double price = 0,
    bool withOpacity = true,
  }) {
    double fontSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          width: double.infinity,
          decoration: (withOpacity)
              ? BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: const BorderRadius.all(Radius.circular(2)))
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "$price/$unitName",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(offset: Offset(-1, -1), color: Colors.white),
                          Shadow(offset: Offset(1, -1), color: Colors.white),
                          Shadow(offset: Offset(1, 1), color: Colors.white),
                          Shadow(offset: Offset(-1, 1), color: Colors.white),
                        ],
                      ),
                    )),
                Text(
                  name,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: fontSize - 2.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: const [
                      Shadow(offset: Offset(-1, -1), color: Colors.white),
                      Shadow(offset: Offset(1, -1), color: Colors.white),
                      Shadow(offset: Offset(1, 1), color: Colors.white),
                      Shadow(offset: Offset(-1, 1), color: Colors.white),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget productLevelWidget(ProductBarcodeObjectBoxStruct product) {
    BoxDecoration boxDecoration = (product.image_or_color)
        ? ((product.images_url.isNotEmpty))
            ? BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    product.images_url,
                  ),
                ),
              )
            : const BoxDecoration()
        : BoxDecoration(
            color: global
                .colorFromHex(product.color_select_hex.replaceAll("#", "")),
          );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        minimumSize: const Size(0, 0),
        elevation: 5,
      ),
      onPressed: () async {
        _displayDetailByBarcode = false;
        logInsert(
            commandCode: 1,
            barcode: product.barcode,
            closeExtra: false,
            qty: "1.0");
        processEvent(barcode: product.barcode);
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: boxDecoration,
            child: productLevelLabelWidget(
                name: product.names[0],
                unitName: product.unit_names[0],
                price: (product.prices.isEmpty)
                    ? 0
                    : double.tryParse(product.prices[0]) ?? 0.0),
          ),
          if (product.product_count != 0)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 1.5,
                ),
                color: Colors.blue.withOpacity(0.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        //selectProductExtraList.clear();
                        _displayDetailByBarcode = false;
                        for (int index = 0;
                            index < global.posProcessResult.details.length &&
                                _displayDetailByBarcode == false;
                            index++) {
                          if (product.barcode ==
                              global.posProcessResult.details[index].barcode) {
                            _displayDetailByBarcode = true;
                            global.posProcessResult.active_line_number = index;
                            activeLineNumber = index;
                            activeGuid =
                                global.posProcessResult.details[index].guid;
                          }
                        }
                        refresh();
                        autoScrollController.scrollToIndex(
                            (global.posProcessResult.active_line_number < 0)
                                ? 0
                                : global.posProcessResult.active_line_number,
                            preferPosition: AutoScrollPosition.begin);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
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
                              global.formatDoubleTrailingZero(
                                  product.product_count),
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
            ),
        ],
      ),
    );
  }

  Widget selectProductLevelListScreenWidget(BoxConstraints constraints) {
    double menuMinWidth = 100;
    int widgetPerLine =
        int.parse((constraints.maxWidth / menuMinWidth).toStringAsFixed(0));
    return GridView.count(
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
      PosProcessDetailStruct data =
          global.posProcessResult.details[activeLineNumber];
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
                  processEvent();
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
                    if (global.posProcessResult.active_line_number != -1)
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

  void productGroupSelectedAdd(ProductCategoryObjectBoxStruct value) {
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          categoryGuidSelected = value.guid_fixed;
          if (append == true) {
            // กรณีมีลูกให้เพิ่มการเลือก
            if (value.category_count > 0) {
              productGroupSelectedAdd(value);
            } else {
              // กรณีเลือกกลุ่มลูกให้เพิ่มการเลือก
              if (value.parent_category_guid.isNotEmpty) {
                productGroupSelectedAdd(value);
              }
            }
          }
          loadProductByCategory(categoryGuidSelected);
          productOptions.clear();
          processEvent();
        },
        child: Container(
          height: boxSize,
          child: Stack(
            children: [
              if (value.useimageorcolor == true && value.image_url.isNotEmpty)
                CachedNetworkImage(
                  width: boxSize,
                  height: double.infinity,
                  imageUrl: value.image_url,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => Container(),
                ),
              Container(
                width: boxSize,
                height: double.infinity,
                padding: const EdgeInsets.only(left: 4, right: 4),
                color: ((value.useimageorcolor == false)
                    ? global
                        .colorFromHex(value.colorselecthex.replaceAll("#", ""))
                    : Colors.transparent),
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    value.names[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                            offset: Offset(-0.25, -0.25), color: Colors.white),
                        Shadow(
                            offset: Offset(0.25, -0.25), color: Colors.white),
                        Shadow(offset: Offset(0.25, 0.25), color: Colors.white),
                        Shadow(
                            offset: Offset(-0.25, 0.25), color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              if (value.product_count != 0)
                Container(
                  width: boxSize,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                ),
              if (value.product_count != 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0)),
                        padding: const EdgeInsets.all(4),
                        child: FittedBox(
                            // fit: BoxFit.fill,
                            child: Text(
                          global.formatDoubleTrailingZero(value.product_count),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ))),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectProductLevelSelectWidget() {
    double size = 80;
    List<Widget> groupSelectedList = [];
    //print("selectProductLevelSelectWidget");

    if (global.productCategoryCodeSelected.isNotEmpty) {
      groupSelectedList.add(
        Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size, size),
                elevation: 0,
              ),
              onPressed: () {
                global.productCategoryChildList.clear();
                global.productCategoryCodeSelected.clear();
                categoryGuidSelected = "";
                productOptions.clear();
                loadCategory();
                processEvent();
              },
              child: const Text(
                "restart",
              ),
            ),
          ),
        ),
      );
      for (var _groupList in global.productCategoryCodeSelected) {
        groupSelectedList
            .add(selectProductLevelCardWidget(_groupList, size, false));
      }
    } else {
      groupSelectedList.add(SizedBox());
    }

    return Container(
      width: double.infinity,
      height: size * ((global.productCategoryCodeSelected.isEmpty) ? 1 : 2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          (global.productCategoryCodeSelected.isEmpty)
              ? Container()
              : Container(
                  width: double.infinity,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                        bottomLeft: Radius.circular(2),
                        bottomRight: Radius.circular(2)),
                  ),
                  child: SingleChildScrollView(
                    controller: groupSelectListScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(children: groupSelectedList),
                  ),
                ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final value in (global.productCategoryChildList.isEmpty)
                      ? global.productCategoryList
                      : global.productCategoryChildList)
                    selectProductLevelCardWidget(value, size, true)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectProductLevelWidgetProcess(BoxConstraints constraints) {
    double size = 100;
    List<Widget> groupSelectedList = [];
    if (global.productCategoryCodeSelected.isNotEmpty) {
      groupSelectedList.add(Container(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size, size),
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  global.productCategoryCodeSelected.clear();
                  loadCategory();
                });
              },
              child: Text(global.language("restart")))));
      for (var groupList in global.productCategoryCodeSelected) {
        groupSelectedList
            .add(selectProductLevelCardWidget(groupList, size, false));
      }
    } else {
      groupSelectedList.add(SizedBox());
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(2),
        child: Column(children: [
          Expanded(
            child: selectProductLevelListScreenWidget(constraints),
          ),
          if (_displayDetailByBarcode &&
              global.posProcessResult.active_line_number > -1)
            Container(
              height: 250,
              width: double.infinity,
              child: transScreen(
                  mode: 1,
                  barcode: global
                      .posProcessResult
                      .details[global.posProcessResult.active_line_number]
                      .barcode),
            ),
          selectProductLevelSelectWidget()
        ]),
      ),
    );
  }

  Widget selectProductLevelWidget(BoxConstraints constraints) {
    return BlocBuilder<ProductGroupBloc, ProductGroupState>(
        builder: (context, state) {
      if (state is ProductGroupLoadSuccess) {
        dev.log('xxxxxx ProductGroupLoadSuccess');
        context.read<ProductGroupBloc>().add(ProductGroupLoadFinish());
      }
      return selectProductLevelWidgetProcess(constraints);
    });
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
      required bool isExtra,
      double qty = 0,
      double price = 0.0,
      required double totalAmount,
      required TextStyle textStyle,
      required String barcode,
      required String unitName,
      required imageUrl}) {
    var name = "";
    if (unitName.isNotEmpty && isExtra == false) {
      name = "$productName/$unitName";
    } else {
      name = productName;
    }
    if (qty > 1.0) {
      if (price > 0.0) {
        name =
            "$name ${global.language("price")} : ${global.moneyFormat.format(price)}";
      }
      name = "$name x${global.moneyFormat.format(qty)}";
    }
    var detail = (global.transDisplayImage)
        ? Row(
            children: [
              if (imageUrl != "0" && imageUrl != "" && global.isOnline)
                Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              Expanded(child: Text(name, style: textStyle))
            ],
          )
        : Text(name, style: textStyle);

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Align(alignment: Alignment.topLeft, child: detail),
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
    );
  }

  Widget detailRow(
      {required PosProcessDetailStruct detail, required TextStyle textStyle}) {
    double extraAmount = 0.0;
    TextStyle extraTextStyle = TextStyle(
        fontSize: 10, fontWeight: textStyle.fontWeight, color: Colors.grey);
    String description = detail.item_name +
        ((detail.remark.isNotEmpty) ? " (${detail.remark})" : "");
    for (final extra in detail.extra) {
      extraAmount += extra.total_amount;
    }

    List<Widget> columnList = [];
    columnList.add(detailWidget(
        isExtra: false,
        productName: description,
        qty: detail.qty,
        price: detail.price,
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
      required PosProcessDetailStruct detail,
      required bool active,
      required TextStyle textStyle}) {
    Widget widget = Container(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
      width: MediaQuery.of(context).size.width,
      child: detailRow(detail: detail, textStyle: textStyle),
    );
    return Material(
        color: Colors.white.withOpacity(0),
        child: (detail.is_void)
            ? Container(
                decoration: const BoxDecoration(color: Colors.red),
                child: widget)
            : InkWell(
                onTap: () async {
                  activeLineNumber = index;
                  activeGuid = global.posProcessResult.details[index].guid;
                  global.posProcessResult.select_promotion_temp_list.clear();
                  print(global.posProcessResult.details[index].barcode);
                  product = ProductBarcodeHelper().selectByBarcodeFirst(
                          global.posProcessResult.details[index].barcode) ??
                      ProductBarcodeObjectBoxStruct(
                          barcode: "",
                          color_select: "",
                          image_or_color: true,
                          color_select_hex: "",
                          names: [],
                          name_all: "",
                          images_url: "",
                          parent_group_guid: "",
                          prices: [],
                          group_count: 0,
                          unit_code: "",
                          unit_names: [],
                          new_line: 0,
                          group_code: "",
                          category_index: 0,
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
      required PosProcessDetailStruct detail,
      required bool active,
      required TextStyle textStyle}) {
    double buttonHeight = 35;
    TextEditingController textFieldRemarkController =
        TextEditingController(text: detail.remark);

    return SizedBox(
        height: 30,
        child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: ButtonTheme(
                      child: CommandButton(
                    primaryColor: Colors.grey.shade100,
                    labelColor: Colors.blue.shade600,
                    height: buttonHeight,
                    onPressed: () async {
                      if (detail.qty > 1) {
                        logInsert(
                            commandCode: 3,
                            guid: activeGuid,
                            closeExtra: false);
                        processEvent();
                      }
                    },
                    label: '-1 ${detail.unit_name}',
                    //icon: Icons.exposure_minus_1,
                  )),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: ButtonTheme(
                    child: CommandButton(
                      primaryColor: Colors.grey.shade100,
                      labelColor: Colors.blue.shade600,
                      height: buttonHeight,
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
                                  contentPadding: const EdgeInsets.all(10),
                                  content: SizedBox(
                                      height: 500,
                                      child: Numpad(
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
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ButtonTheme(
                    child: CommandButton(
                      primaryColor: Colors.grey.shade100,
                      labelColor: Colors.blue.shade600,
                      height: buttonHeight,
                      onPressed: () async {
                        logInsert(
                            commandCode: 2,
                            guid: activeGuid,
                            closeExtra: false);
                        processEvent();
                      },
                      label: '+1 ${detail.unit_name}',
                      // icon: Icons.exposure_plus_1,
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ButtonTheme(
                    child: CommandButton(
                        primaryColor: Colors.grey.shade100,
                        labelColor: Colors.blue.shade600,
                        height: buttonHeight,
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
                                    contentPadding: const EdgeInsets.all(10),
                                    content: SizedBox(
                                        width: double.infinity,
                                        height: 500,
                                        child: Numpad(
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
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ButtonTheme(
                    child: CommandButton(
                        primaryColor: Colors.grey.shade100,
                        labelColor: Colors.blue.shade600,
                        height: buttonHeight,
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
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ButtonTheme(
                    child: CommandButton(
                      primaryColor: Colors.grey.shade100,
                      labelColor: Colors.blue.shade600,
                      height: buttonHeight,
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
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text(global.language('save')),
                                          onPressed: () async {
                                            logInsert(
                                                commandCode: 8,
                                                guid: activeGuid,
                                                remark:
                                                    textFieldRemarkController
                                                        .text,
                                                closeExtra: false);
                                            global.playSound(
                                                sound: global
                                                    .SoundEnum.buttonTing);
                                            Navigator.pop(context);
                                            processEvent();
                                          },
                                        ),
                                        ElevatedButton(
                                          child:
                                              Text(global.language('cancel')),
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
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ButtonTheme(
                    child: CommandButton(
                      primaryColor: Colors.grey.shade100,
                      labelColor: Colors.blue.shade600,
                      height: buttonHeight,
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
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child:
                                              Text(global.language('delete')),
                                          onPressed: () async {
                                            logInsert(
                                                commandCode: 9,
                                                guid: activeGuid);
                                            global.playSound(
                                                sound: global
                                                    .SoundEnum.buttonTing);
                                            Navigator.pop(context);
                                            //selectProductExtraList.clear();
                                            processEvent();
                                          },
                                        ),
                                        ElevatedButton(
                                          child:
                                              Text(global.language('cancel')),
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
                  ),
                )),
              ],
            )));
  }

  Widget detail(PosProcessDetailStruct detail, int index) {
    bool active = (activeLineNumber == -1)
        ? false
        : ((activeLineNumber == index) ? true : false);
    TextStyle textStyle = TextStyle(
        fontSize: 18,
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
                detailData(
                    index: index,
                    detail: detail,
                    active: active,
                    textStyle: textStyle),
                detailButton(
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
                                  child: NumpadButton(
                                    text: '7',
                                    callBack: () => {textInputAdd("7")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumpadButton(
                                    text: '8',
                                    callBack: () => {textInputAdd("8")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumpadButton(
                                    text: '9',
                                    callBack: () => {textInputAdd("9")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumpadButton(
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
                                child: NumpadButton(
                                  text: '4',
                                  callBack: () => {textInputAdd("4")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumpadButton(
                                  text: '5',
                                  callBack: () => {textInputAdd("5")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumpadButton(
                                  text: '6',
                                  callBack: () => {textInputAdd("6")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumpadButton(
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
                                child: NumpadButton(
                                  text: '1',
                                  callBack: () => {textInputAdd("1")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumpadButton(
                                  text: '2',
                                  callBack: () => {textInputAdd("2")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumpadButton(
                                  text: '3',
                                  callBack: () => {textInputAdd("3")},
                                )),
                            Expanded(
                                flex: 2,
                                child: NumpadButton(
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
                                  child: NumpadButton(
                                    text: '.',
                                    callBack: () => {textInputAdd(".")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumpadButton(
                                    text: '0',
                                    callBack: () => {textInputAdd("0")},
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: NumpadButton(
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
                                  child: NumpadButton(
                                    text: 'D',
                                    color: Colors.cyan[100],
                                    callBack: () => {textInputAdd("D")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumpadButton(
                                    text: '%',
                                    color: Colors.cyan[100],
                                    callBack: () => {textInputAdd("%")},
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: NumpadButton(
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
                posProcess: global.posProcessResult,
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
            child: Text(
                "${global.language("total")} ${global.moneyFormat.format(global.posProcessResult.total_amount)} ${global.language("money_symbol")}",
                style: const TextStyle(
                  fontSize: 20.0,
                )),
          ),
        ),
      ),
    );
  }

  void restartClearData() {
    global.posLogHelper.restart();
    activeGuid = "";
    activeLineNumber = -1;
    textInput = "";
    processEvent();
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
    logInsert(commandCode: 98);
    global.openCashDrawer();
  }

  Widget commandScreen(BuildContext context, BoxConstraints constraints) {
    double menuMinWidth = 100;
    int countMenuByLine =
        int.parse((constraints.maxWidth / menuMinWidth).toStringAsFixed(0));
    double width = constraints.maxWidth / countMenuByLine;
    double menuMax = 6;
    double newHeight =
        constraints.maxHeight / ((menuMax / countMenuByLine).ceilToDouble());

    return Wrap(
      children: [
        CommandButton(
          primaryColor: Colors.blue.shade300,
          labelColor: Colors.white,
          width: width,
          height: newHeight,
          label: global.language("hold_bill"),
          onPressed: () {
            holdBill();
          },
        ),
        CommandButton(
          primaryColor: Colors.blue.shade300,
          labelColor: Colors.white,
          width: width,
          height: newHeight,
          label: global.language('open_cash_drawer'),
          onPressed: () {
            openCashDrawer();
          },
        ),
        CommandButton(
          primaryColor: Colors.blue.shade300,
          labelColor: Colors.white,
          width: width,
          height: newHeight,
          label: global.language('select_employee'),
          onPressed: () {
            findEmployee();
          },
        ),
        CommandButton(
          primaryColor: Colors.blue.shade300,
          labelColor: Colors.white,
          width: width,
          height: newHeight,
          label: (global.speechToTextVisible)
              ? global.language("speech_to_text_on")
              : global.language("speech_to_text_off"),
          onPressed: () {
            /*setState(() {
              if (global.speechToTextVisible) {
                global.playSound(word: global.language('speech_to_text_off'));
                global.speechToTextVisible = false;
              } else {
                global.speechToTextVisible = true;
                global.playSound(word: global.language('speech_to_text_on'));
              }
            });*/
            List<String> barcodeList = [
              "18851004401367",
              "18851004402128",
              "18851004402364",
              "18851004406126",
              "18851004406362",
              "18851004408137",
              "18851004408366",
              "18851004416125",
              "18851004416361",
              "18851004417115",
              "18851004417122",
              "18851004417368",
              "18851004418112",
              "18851004418143",
              "18851004418150",
              "18851004426155"
            ];
            for (var barcode in barcodeList) {
              logInsert(commandCode: 1, barcode: barcode, qty: "1");
            }
            processEvent();
          },
        ),
        CommandButton(
            primaryColor: Colors.blue.shade300,
            labelColor: Colors.white,
            width: width,
            height: newHeight,
            label: global.language('restart'),
            onPressed: () {
              restart();
            }),
        CommandButton(
          primaryColor: Colors.blue.shade300,
          labelColor: Colors.white,
          width: width,
          height: newHeight,
          label: global.language('main_screen'),
          icon: Icons.web,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
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
          "${global.language("total_amount")} ${global.moneyFormat.format(global.posProcessResult.total_amount)} ${global.language("money_symbol")}",
          style: textStyleTotal),
      Text(
          "${global.language("total_qty")} ${global.moneyFormat.format(global.posProcessResult.total_piece)} ${global.language("piece")}",
          style: textStyleTotal),
      if (global.posProcessResult.promotion_list.isNotEmpty)
        for (var detail in global.posProcessResult.promotion_list)
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
    return (global.posProcessResult.details.isEmpty)
        ? Container()
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: (mode == 0)
                ? ListView(
                    scrollDirection: Axis.vertical,
                    controller: autoScrollController,
                    children: <Widget>[
                        for (int index = 0;
                            index < global.posProcessResult.details.length;
                            index++)
                          AutoScrollTag(
                            key: ValueKey(index),
                            controller: autoScrollController,
                            index: index,
                            highlightColor: Colors.black.withOpacity(0.1),
                            child: Container(
                              child: detail(
                                  global.posProcessResult.details[index],
                                  index),
                            ),
                          )
                      ])
                : ListView(scrollDirection: Axis.vertical, children: <Widget>[
                    for (int index = 0;
                        index < global.posProcessResult.details.length;
                        index++)
                      Container(
                        child: (barcode !=
                                global.posProcessResult.details[index].barcode)
                            ? Container()
                            : detail(
                                global.posProcessResult.details[index], index),
                      )
                  ]));
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
                                                    child: NumpadButton(
                                                      text: '7',
                                                      callBack: () => {
                                                        textInputChanged("7")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '8',
                                                      callBack: () => {
                                                        textInputChanged("8")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '9',
                                                      callBack: () => {
                                                        textInputChanged("9")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
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
                                                    child: NumpadButton(
                                                      text: '4',
                                                      callBack: () => {
                                                        textInputChanged("4")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '5',
                                                      callBack: () => {
                                                        textInputChanged("5")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '6',
                                                      callBack: () => {
                                                        textInputChanged("6")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
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
                                                    child: NumpadButton(
                                                      text: '1',
                                                      callBack: () => {
                                                        textInputChanged("1")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '2',
                                                      callBack: () => {
                                                        textInputChanged("2")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '3',
                                                      callBack: () => {
                                                        textInputChanged("3")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
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
                                                    child: NumpadButton(
                                                      text: '0',
                                                      callBack: () => {
                                                        textInputChanged("0")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      text: '.',
                                                      callBack: () => {
                                                        textInputChanged(".")
                                                      },
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
                                                      icon: Icons.backspace,
                                                      callBack: () =>
                                                          {backSpace()},
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: NumpadButton(
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
      processEvent(barcode: value.data.barcode);
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
        global.saleActiveCode = value[0];
        global.saleActiveName = value[1];
      });
    });
  }

  void holdBill() async {
    // พักบิล
    var result = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const HoldBill(),
      ),
    );

    if (result != null) {
      setState(() {
        global.posHoldNumber = result;
        processEvent();
        global.playSound(sound: global.SoundEnum.beep);
        activeGuid = "";
        activeLineNumber = -1;
        global.payScreenData =
            global.posHoldList[global.posHoldNumber].payScreenData;
      });
    }
  }

  Widget promotionWidget() {
    return Container(
        decoration: BoxDecoration(
          color: global.posTheme.transBackground,
        ),
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(children: [
          for (var _detail in global.posProcessResult.promotion_list)
            Row(
              children: [
                Expanded(
                    flex: 12,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(_detail.promotion_name,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)))),
                Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Text(global.moneyFormat.format(_detail.discount),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red)))),
              ],
            )
        ]));
  }

  Widget posLayoutTablet() {
    Size size = MediaQuery.of(context).size;

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
              children: [
                Container(
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
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return Container(
                                    child: TabBarView(
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
                                ));
                              }))),
                      if (productOptions.length != 0)
                        selectProductExtraListWidget()
                    ])),
                  ]),
                ),
                Container(
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
                            if (global.customerActiveCode.isNotEmpty)
                              Row(children: [
                                Expanded(
                                    child: Row(children: [
                                  Text(
                                    '${global.language('ลูกค้า')} :',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${global.customerActiveName} (${global.customerActiveCode})",
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
                                      global.saleActiveCode = "";
                                      global.saleActiveName = "";
                                    });
                                  },
                                )
                              ]),
                            if (global.saleActiveCode.trim().isNotEmpty)
                              Row(children: [
                                Expanded(
                                    child: Row(children: [
                                  Text(
                                    '${global.language('sale')} : ',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${global.saleActiveName} (${global.saleActiveCode})",
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
                                      global.saleActiveCode = "";
                                      global.saleActiveName = "";
                                    });
                                  },
                                )
                              ]),
                          ])),
                      Expanded(
                        child: transScreen(mode: 0),
                      ),
                      Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 5),
                          child: totalAndPayScreen()),
                      Container(
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
                                      child: const FaIcon(
                                          FontAwesomeIcons.barcode),
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
                                    child: const FaIcon(
                                        FontAwesomeIcons.addressBook),
                                    onPressed: () {}),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: (showNumericPad)
                                          ? Colors.amber
                                          : Colors.white,
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const FaIcon(
                                        FontAwesomeIcons.calculator),
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
                            ],
                          )),
                      if (showButtonMenu)
                        SizedBox(
                            height: 100,
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return commandScreen(context, constraints);
                            })),
                    ],
                  ),
                ),
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

  Widget appLayoutPos() {
    return (global.isTablet)
        ? posLayoutTablet()
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
                                      /* selectProductLevelWidget(),*/
                                      findByText(),
                                      Container()
                                      //commandScreen(),
                                    ],
                                  )),
                                ],
                              ))));
                })));
  }

  Widget appLayoutRestaurant() {
    return (global.isTablet)
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
        : Container(
            child: SafeArea(
                child: DefaultTabController(
                    length: 4,
                    child: Builder(builder: (BuildContext context) {
                      final TabController tabController =
                          DefaultTabController.of(context);
                      tabController.addListener(() {
                        if (!tabController.indexIsChanging) {
                          if (tabController.index == 2) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.show');
                          } else {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          }
                        }
                      });
                      return Scaffold(
                          body: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.black),
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
                                                icon: const Icon(
                                                    Icons.group_work),
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
                    }))));
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

  @override
  Widget build(BuildContext context) {
    global.globalContext = context;
    print("Build : ${DateTime.now()}");
    return BlocBuilder<PosProcessBloc, PosProcessState>(
        builder: (context, state) {
      if (state is PosProcessSuccess) {
        print('PosProcessSuccess');
        global.posProcessResult = state.result;
        if (global.posProcessResult.details.isNotEmpty) {
          activeLineNumber = global.posProcessResult.active_line_number;
          if (activeLineNumber != -1) {
            activeGuid = global.posProcessResult.details[activeLineNumber].guid;
          }
        } else {
          activeLineNumber = -1;
          activeGuid = "";
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          autoScrollController.scrollToIndex(
              (global.posProcessResult.active_line_number < 0)
                  ? 0
                  : global.posProcessResult.active_line_number,
              preferPosition: AutoScrollPosition.begin);
        });
        context.read<PosProcessBloc>().add(PosProcessFinish());
        network.sendProcessToCustomerDisplay();
      }
      return VisibilityDetector(
          onVisibilityChanged: (VisibilityInfo info) {
            isVisible = info.visibleFraction > 0;
          },
          key: const Key('visible-detector-key'),
          child: BarcodeKeyboardListener(
              useKeyDownEvent: true,
              bufferDuration: const Duration(milliseconds: 200),
              onBarcodeScanned: (barcode) async {
                print('------------------------ Scan Barcode : $barcode');
                if (!isVisible || _barcodeScanActive == false) return;
                logInsert(
                    commandCode: 1,
                    barcode: barcode,
                    qty: (textInput.isEmpty) ? "1.0" : textInput);
                textInput = "";
                processEvent();
              },
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: (global.appMode == global.AppModeEnum.pos)
                      ? appLayoutPos()
                      : appLayoutRestaurant())));
    });
  }
}