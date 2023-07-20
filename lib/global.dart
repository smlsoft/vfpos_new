import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/clickhouse/clickhouse_api.dart';
import 'package:dedepos/api/network/server.dart';
import 'package:dedepos/api/sync/model/employee_model.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/objectbox.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/kitchen_helper.dart';
import 'package:dedepos/google_sheet.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/model/objectbox/kitchen_struct.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/objectbox/pos_ticket_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_num_pad.dart';
import 'package:dedepos/model/objectbox/staff_client_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/util/load_form_design.dart';
import 'package:dedepos/util/print_kitchen.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dedepos/db/bank_helper.dart';
import 'package:presentation_displays/display.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:dedepos/api/network/sync_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/system/bank_and_wallet_model.dart';
import 'package:dedepos/model/objectbox/bank_struct.dart';
import 'package:dedepos/model/json/payment_model.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/api/sync/master/sync_master.dart' as sync;
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/model/objectbox/config_struct.dart';
import 'dart:async';
import 'db/promotion_helper.dart';
import 'db/promotion_temp_helper.dart';
import 'db/product_category_helper.dart';
import 'db/product_barcode_helper.dart';
import 'package:dedepos/global.dart' as global;
import 'db/pos_log_helper.dart';
import 'db/bill_helper.dart';
import 'db/config_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';
import 'model/objectbox/form_design_struct.dart';

String applicationName = "";
late Directory applicationDocumentsDirectory;
late ProfileSettingModel profileSetting;
List<FormDesignObjectBoxStruct> formDesignList = [];
bool developerMode = true;
List<String> countryNames = [
  "English",
  "Thai",
  "Laos",
  "Chinese",
  "Japan",
  "Korea"
];
List<String> countryCodes = ["en", "th", "lo", "ch", "jp", "kr"];
List<LanguageSystemModel> languageSystemData = [];
List<LanguageSystemCodeModel> languageSystemCode = [];
String userScreenLanguage = "";
DisplayManager displayManager = DisplayManager();
bool isInternalCustomerDisplayConnected = false;
late Display internalCustomerDisplay;
var httpClient = http.Client();
late BuildContext globalContext;
bool tableSelected = false;
String tableNumberSelected = "";
late PosHoldProcessModel tableProcessSelected;
void posProcessRefresh = () {};
String ipAddress = "";
List<String> errorMessage = [];
List<InformationModel> informationList = <InformationModel>[];
bool initSuccess = false;
List<PosHoldProcessModel> posHoldProcessResult = [];
String posHoldActiveCode = "0";
ProductCategoryHelper productCategoryHelper = ProductCategoryHelper();
ProductBarcodeHelper productBarcodeHelper = ProductBarcodeHelper();
EmployeeHelper employeeHelper = EmployeeHelper();
PosLogHelper posLogHelper = PosLogHelper();
BillHelper billHelper = BillHelper();
ConfigHelper configHelper = ConfigHelper();
PromotionHelper promotionHelper = PromotionHelper();
PromotionTempHelper promotionTempHelper = PromotionTempHelper();
int syncTimeIntervalMaxBySecond = 10;
int syncTimeIntervalSecond = 1;
final moneyFormat = NumberFormat("##,##0.##");
final moneyFormatAndDot = NumberFormat("##,##0.00");
final qtyShortFormat = NumberFormat("##,##0");
String deviceId = "";
String deviceName = "";
List<SyncDeviceModel> customerDisplayDeviceList = [];
List<SyncDeviceModel> posRemoteDeviceList = [];
//"http://192.168.1.4:8084";
String webServiceUrl = "http://smltest1.ddnsfree.com:8084";
String webServiceVersion = "/SMLJavaWebService/webresources/rest/";
String providerName = "DATA";
String databaseName = "DEMO"; // "DATA1 or DEMO";
bool speechToTextVisible = false;
bool loginSuccess = false;
late GetStorage appStorage;
List<PrinterLocalStrongDataModel> printerLocalStrongData = [];
bool loginProcess = false;
bool syncDataSuccess = false;
bool syncDataProcess = false;
PosPayModel payScreenData = PosPayModel();
bool lugenPaymentProvider = true;
List<PaymentProviderModel> lugenPaymentProviderList = [];
List<PaymentProviderModel> qrPaymentProviderList = [];
bool payScreenNumberPadIsActive = false;
double payScreenNumberPadLeft = 100;
double payScreenNumberPadTop = 100;
String payScreenNumberPadText = "";
double payScreenNumberPadAmount = 0;
PayScreenNumberPadWidgetEnum payScreenNumberPadWidget =
    PayScreenNumberPadWidgetEnum.number;
VoidCallback numberPadCallBack = () {};
late EmployeeObjectBoxStruct? userLogin;
int machineNumber = 1;
String selectTableCode = "";
String selectTableGroup = "";
ThemeStruct posTheme = ThemeStruct();
GlobalKey<PosNumPadState> posNumPadProductWeightGlobalKey = GlobalKey();
bool transDisplayImage = true;
List<ProductCategoryObjectBoxStruct> productCategoryCodeSelected = [];
List<ProductCategoryObjectBoxStruct> productCategoryList = [];
List<ProductBarcodeObjectBoxStruct> productListByCategory = [];
List<ProductCategoryObjectBoxStruct> productCategoryChildList = [];
AppModeEnum appMode = AppModeEnum.posTerminal;
bool apiConnected = false;
String apiUserName = "";
String apiUserPassword = "";
String apiShopID = "";
bool syncRefreshProductCategory = true;
bool syncRefreshProductBarcode = true;
bool syncRefreshPrinter = true;
String syncDateBegin = "2000-01-01T00:00:00";
String syncCategoryTimeName = "lastSyncCategory";
String syncProductBarcodeTimeName = "lastSyncProductBarcode";
String syncInventoryTimeName = "lastSyncInventory";
String syncMemberTimeName = "lastSyncMember";
String syncBankTimeName = "lastSyncBank";
String syncTableTimeName = "lastSyncTable";
String syncBuffetModeTimeName = "lastSyncBuffetMode";
String syncKitchenTimeName = "lastSyncTableZone";
String syncWalletTimeName = "lastSyncWallet";
bool isOnline = false;
PaymentModel? paymentData;
late Store objectBoxStore;
String dateFormatSync = "yyyy-MM-ddTHH:mm:ss";
PosVersionEnum posVersion = PosVersionEnum.vfpos;
bool customerDisplayDesktopMultiScreen = true;
String targetDeviceIpAddress = "";
int targetDeviceIpPort = 4040;
bool targetDeviceConnected = false;
Function? functionPosScreenRefresh;
DeviceModeEnum deviceMode = DeviceModeEnum.none;
PosScreenNewDataStyleEnum posScreenNewDataStyle =
    PosScreenNewDataStyleEnum.addLastLine;
DisplayMachineEnum displayMachine = DisplayMachineEnum.posTerminal;
PosTicketObjectBoxStruct posTicket = PosTicketObjectBoxStruct();
PosScreenModeEnum posScreenMode = PosScreenModeEnum.posSale;
bool posUseSaleType = true; // ใช้ประเภทการขายหรือไม่
String posSaleChannelCode = "XXX"; // XXX=หน้าร้าน
String posSaleChannelLogoUrl = "";
List<String> googleLanguageCode = [];
List<PosSaleChannelModel> posSaleChannelList = [];
List<StaffClientObjectBoxStruct> staffClientList = [];
String connectGuid = "";
List<BuffetModeObjectBoxStruct> buffetModeLists = [];
int buffetMaxMinute = 120;
String printerConfigCashierCode = "printer_config_cashier";
String printerConfigTicketCode = "printer_config_ticket";
String shopId = "";
bool checkOrderActive = false;
int orderToKitchenPrintMode = 1; // ทำไว้ก่อนค่อยแก้ 0=แยกบิล,1=รวมบิล
String posTerminalPinCode = "";
String posTerminalPinTokenId = "";
String formTaxDefaultCode = "DEDE-01-88"; // ใบเสร็จรับเงิน/ใบกำกับภาษีแบบย่อ
String formFullTaxDefaultCode =
    "DEDE-02-88"; // ใบเสร็จรับเงิน/ใบกำกับภาษีแบบเต็ม
String formSummeryDefaultCode = "DEDE-05-88"; // ใบสรุปยอด
bool posScreenAutoRefresh = false;

enum PrinterTypeEnum { thermal, dot, laser, inkjet }

enum PrinterConnectEnum { ip, bluetooth, usb, windows, sunmi1 }

enum PosVersionEnum { pos, restaurant, vfpos }

enum SoundEnum { beep, fail, buttonTing }

enum DisplayMachineEnum { customerDisplay, posTerminal }

enum PosScreenModeEnum { posSale, posReturn }

enum TableManagerEnum {
  openTable,
  closeTable,
  moveTable,
  mergeTable,
  informationTable,
  splitTable
}

enum AppModeEnum {
  // posTerminal = โปรแกรมที่ใช้งานได้เฉพาะเครื่อง POS เท่านั้น
  // posRemote = โปรแกรมที่ใช้งานได้ทุกเครื่อง และสามารถส่งคำสั่งไปยังเครื่อง POS ได้
  posTerminal,
  posRemote
}

enum PosScreenNewDataStyleEnum {
  // newLineOnly = ขึ้นบรรทัดใหม่เสมอ
  // addLastLine = ถ้า Barcode เดิม ให้เพิ่มในรายการล่าสุด
  // addAllLine = ถ้า Barcode เดิ่ม ให้เพิ่มในรายการทั้งหมด
  newLineOnly,
  addLastLine,
  addAllLine
}

enum DeviceModeEnum {
  none,
  iphone,
  ipad,
  windowsDesktop,
  macosDesktop,
  linuxDesktop,
  androidPhone,
  androidTablet,
}

/*PrinterTypeEnum printerType(int printerType) {
  switch (printerType) {
    case 0:
      return PrinterTypeEnum.thermal;
    case 1:
      return PrinterTypeEnum.dot;
    case 2:
      return PrinterTypeEnum.laser;
    case 3:
      return PrinterTypeEnum.inkjet;
    default:
      return PrinterTypeEnum.thermal;
  }
}

PrinterConnectEnum printerConnectType(int printerConnectType) {
  switch (printerConnectType) {
    case 0:
      return PrinterConnectEnum.ip;
    case 1:
      return PrinterConnectEnum.bluetooth;
    case 2:
      return PrinterConnectEnum.usb;
    case 3:
      return PrinterConnectEnum.windows;
    case 4:
      return PrinterConnectEnum.sunmi1;
    default:
      return PrinterConnectEnum.ip;
  }
}*/

int findPosHoldProcessResultIndex(String code) {
  for (var i = 0; i < posHoldProcessResult.length; i++) {
    if (posHoldProcessResult[i].code == code) {
      return i;
    }
  }
  return 0;
}

Future<void> loadPrinter() async {
  printerLocalStrongData.clear();
  List<String> printerCodes = [
    printerConfigCashierCode,
    printerConfigTicketCode
  ];
  List<String> printerNames = ["Cashier", "Ticket"];
  // Kitchen
  List<KitchenObjectBoxStruct> kitchenList = KitchenHelper().getAll();
  for (var kitchen in kitchenList) {
    printerCodes.add(kitchen.code);
    printerNames
        .add(getNameFromJsonLanguage(kitchen.names, userScreenLanguage));
  }
  for (var printerCode in printerCodes) {
    try {
      // ดึงข้อมูลจาก Local Storage
      String printerJson = await appStorage.read(printerCode);
      printerLocalStrongData
          .add(PrinterLocalStrongDataModel.fromJson(jsonDecode(printerJson)));
    } catch (e) {
      printerLocalStrongData.add(PrinterLocalStrongDataModel(
          code: printerCode,
          name: printerNames[printerCodes.indexOf(printerCode)]));
    }
  }
}

int posScreenToInt() {
  switch (posScreenMode) {
    case PosScreenModeEnum.posSale:
      return 1;
    case PosScreenModeEnum.posReturn:
      return 2;
    default:
      return 0;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

bool isPhoneDevice() {
  return deviceMode == DeviceModeEnum.iphone ||
      deviceMode == DeviceModeEnum.androidPhone;
}

bool isTabletDevice() {
  return deviceMode == DeviceModeEnum.ipad ||
      deviceMode == DeviceModeEnum.androidTablet ||
      deviceMode == DeviceModeEnum.windowsDesktop ||
      deviceMode == DeviceModeEnum.linuxDesktop ||
      deviceMode == DeviceModeEnum.macosDesktop;
}

Future<void> getDeviceModel(BuildContext context) async {
  final deviceInfo = DeviceInfoPlugin();
  String model = '';

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    model = androidInfo.model;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide > 600) {
      deviceMode = DeviceModeEnum.androidTablet;
    } else {
      deviceMode = DeviceModeEnum.androidPhone;
    }
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    model = iosInfo.model!;
    model = model.toLowerCase();
    if (model.contains("iphone")) {
      deviceMode = DeviceModeEnum.iphone;
    } else if (model.contains("ipad")) {
      deviceMode = DeviceModeEnum.ipad;
    }
  } else if (Platform.isMacOS) {
    deviceMode = DeviceModeEnum.macosDesktop;
  } else if (Platform.isLinux) {
    deviceMode = DeviceModeEnum.linuxDesktop;
  } else if (Platform.isWindows) {
    deviceMode = DeviceModeEnum.windowsDesktop;
  }
}

void themeSelect(int mode) {
  switch (mode) {
    case 1:
      posTheme.background = Colors.cyan.shade50;
      posTheme.productLevelBackground = Colors.cyan.shade50;
      posTheme.productBottomBackground = Colors.cyan.shade100;
      posTheme.productLevelRootBackground = Colors.cyan.shade100;
      posTheme.productLevelRootBottomBackground = Colors.cyan.shade200;
      posTheme.transBackground = Colors.white;
      posTheme.transSelectedBackground = Colors.cyan.shade50;
      posTheme.transPayBottomBackground = Colors.cyan.shade500;
      posTheme.transPayBottomDisableBackground = Colors.cyan.shade100;
      break;
    case 2:
      // Colors new layout
      posTheme.background = const Color(0xFF001E40);
      posTheme.orange1 = const Color(0xFFE27D01);
      posTheme.secondary = const Color(0xFFE89100);
      posTheme.transSelectedBackground = Colors.cyan.shade50;
      posTheme.transBackground = Colors.white;
      break;
  }
}

String formatDoubleTrailingZero(double value) {
  return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
}

Future<Uint8List> thaiEncode(String word) async {
  if (Platform.isWindows) {
    try {
      if (word == "") {
        word = " ";
      }
      return await CharsetConverter.encode('windows-874', word);
    } catch (e) {
      return await CharsetConverter.encode('windows-874', " ");
    }
  } else {
    return await CharsetConverter.encode('TIS620', word);
  }
}

void playSound({SoundEnum sound = SoundEnum.beep, String word = ""}) async {
  /*audioPlayer = AudioPlayer();
  try {
    if (speechToTextVisible && word.isNotEmpty) {
      if (Platform.isAndroid || Platform.isIOS) {
        TextToSpeech tts = TextToSpeech();
        tts.setRate(1);
        tts.speak(word);
      }
    } else {
      switch (sound) {
        case SoundEnum.beep:
          if (Platform.isAndroid || Platform.isIOS) {
            FlutterBeep.beep();
          } else {
            if (Platform.isWindows) {
              playSoundForWindows('scan_success.wav');
            }
          }
          break;
        case SoundEnum.fail:
          if (Platform.isAndroid || Platform.isIOS) {
            FlutterBeep.beep();
          } else {
            if (Platform.isWindows) {
              playSoundForWindows('scan_fail.wav');
            }
          } /*audio8851959003374
            
              .setAsset('assets/audios/scan_fail.wav')95509747

              .then((value) => audio.play());*/
          break;
        case SoundEnum.buttonTing:
          if (Platform.isAndroid || Platform.isIOS) {
            FlutterBeep.beep();
          } else {
            if (Platform.isWindows) {
              playSoundForWindows('button_ting.wav');
            }
          }
          break;
      }
    }
  } catch (e) {
    print(e);
  }*/
}

String imageUrl(String guid) {
  return '$webServiceUrl/SMLJavaWebService/webresources/image/$guid?p=$providerName&d=$databaseName';
}

class Debounce {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce(this.milliseconds);

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

List<String> wordSplit(String word) {
  List<String> split = [];
  String firstBreak = "ใโไเแ";
  String endBreak = "าๆฯะ";
  for (int index = 0; index < firstBreak.length; index++) {
    word = word.replaceAll(firstBreak[index], " ${firstBreak[index]}");
  }
  for (int index0 = 0; index0 < endBreak.length; index0++) {
    word = word.replaceAll(endBreak[index0], "${endBreak[index0]} ");
  }
  split = word.split(" ");
  return split;
}

double calcTextToNumber(String text) {
  double result = 0;
  String textTrim = text.trim();
  while (textTrim.contains(" ")) {
    textTrim = textTrim.replaceAll(" ", "");
  }
  if (textTrim.isNotEmpty) {
    textTrim = textTrim
        .replaceAll("X", "")
        .replaceAll("x", "")
        .replaceAll("+", "")
        .replaceAll("-", "");
    result = double.parse(textTrim);
  }
  return result;
}

Future<String> billRunning() async {
  // Type 0=คริสต์ศักราช,1=พุทธศักราช
  // YYYY = ปี
  // MM = เดือน
  // DD = วัน
  // ###### = ลำดับ
  // ตัวอย่าง 001################ สำหรับ Tax ABB เครื่อง POS (001=รหัสเครื่อง POS)
  // ตัวอย่าง 002YYMMDD########## สำหรับ Tax ABB เครื่อง POS (002=รหัสเครื่อง POS)
  // ตัวอย่าง SO-YYMMDD-###### สำหรับขาย
  // ตัวอย่าง PO-YYMMDD-###### สำหรับซื้อ
  String dateNow = DateFormat('yyMMdd').format(DateTime.now());
  String result = "";
  bool success = false;
  while (success == false) {
    int number = 0;
    List<ConfigObjectBoxStruct> configGet = configHelper.select();
    if (configGet.isNotEmpty) {
      ConfigObjectBoxStruct config = configGet[0];
      List<String> split = config.last_doc_number.split(
        "-",
      );
      if (split.isNotEmpty) {
        number = int.tryParse(split[split.length - 1]) ?? 0;
        if (split.length > 1) {
          String date = split[split.length - 2];
          if (date != dateNow) {
            number = 0;
            success = true;
          }
        }
      }
    }
    result =
        "${deviceId}-$dateNow-${(NumberFormat("00000")).format(number + 1)}";

    /// ค้นหาว่ามีเลขที่เอกสารนี้อยู่ในฐานข้อมูลหรือไม่
    var find = billHelper.selectByDocNumber(
        docNumber: result, posScreenMode: posScreenToInt());
    if (find == null) {
      success = true;
    } else {
      configHelper.update(
          ConfigObjectBoxStruct(device_id: deviceId, last_doc_number: result));
    }
  }
  return result;
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    final returnResult = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    return returnResult;
  } on SocketException catch (_) {
    return false;
  }
}

void showAlertDialog(
    {required BuildContext context,
    required String title,
    required String message}) {
  Widget okButton = TextButton(
    child: Text(language("OK")),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/*void printQueue(PrinterStruct printer) async {
  bool _loopPrint = true;
  while (_loopPrint) {
    List<PrintQueueStruct> _queueList = await PrintQueueHelper()
        .select(where: "printer_code='" + printer.code + "'");
    if (_queueList.isNotEmpty) {
      dev.log(printer.ip_address);
      for (var _queue in _queueList) {
        switch (_queue.code) {
          case 1:
            // Print Bill
            await printBill(
                docNo: _queue.doc_number, ipAddress: printer.ip_address);
            break;
          case 2:
            // Print Bill
            await printSendMoney(
                docNo: _queue.doc_number, ipAddress: printer.ip_address);
            break;
          case 3:
            // Receive Money
            await printReceiveMoney(
                docNo: _queue.doc_number, ipAddress: printer.ip_address);
            break;
          case 8:
            // Print Order To Kitchen (สั่งพิมพ์ครัว)
            await printOrderToKitchen(
                docNo: _queue.doc_number,
                lineNumber: _queue.line_number,
                ipAddress: "192.168.2.244");
            break;
          case 9:
            // Print Order Summery (สั่งพิมพ์ใบสรุป)
            await printOrderSummery(
                docNo: _queue.doc_number, ipAddress: printer.ip_address);
            break;
          case 10:
            // ใบเปิดโต๊ะ
            await printTableOpen(
                guid: _queue.doc_number, ipAddress: printer.ip_address);
            break;
        }
        await PrintQueueHelper().deleteById(_queue.guid);
      }
    } else
      _loopPrint = false;
  }
}*/

/*Future<void> printQueueStart() async {
  for (var _printer in printerList) {
    if (_printer.is_run_thread == false) {
      _printer.is_run_thread = true;
      printQueue(_printer);
      _printer.is_run_thread = false;
    }
  }
}*/

Future<void> printQueueStartServer() async {
  var url = "http://$targetDeviceIpAddress:$targetDeviceIpPort";
  var uri = Uri.parse(url);
  try {
    http.Response response = await http
        .post(uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(HttpPost(command: 'print_queue')))
        .timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      dev.log('Success');
    }
  } catch (e) {
    dev.log('failed : $e');
  }
}

String dateTimeFormat(DateTime dateTime, {bool showTime = true}) {
  var formatter = DateFormat.yMMMMEEEEd('th_TH');
  if (showTime) {
    return "${formatter.formatInBuddhistCalendarThai(dateTime)} - ${DateFormat.Hm().format(dateTime)}";
  } else {
    return formatter.formatInBuddhistCalendarThai(dateTime);
  }
}

String dateFormat(DateTime dateTime) {
  var formatter = DateFormat.yMMMMEEEEd('th_TH');
  return formatter.formatInBuddhistCalendarThai(dateTime);
}

String timeFormat(DateTime dateTime) {
  return DateFormat.Hm().format(dateTime);
}

Future<void> systemProcess() async {
  for (int index = 0; index < customerDisplayDeviceList.length; index++) {
    var url = "${customerDisplayDeviceList[index].ip}:5041";
    SyncDeviceModel info = SyncDeviceModel(
        deviceId: deviceId,
        deviceName: deviceName,
        ip: "",
        holdCodeActive: "",
        docModeActive: 0,
        connected: true,
        isClient: false,
        isCashierTerminal: false);
    var jsonData = HttpPost(command: "info", data: jsonEncode(info.toJson()));
    postToServer(
        ip: url,
        jsonData: jsonEncode(jsonData.toJson()),
        callBack: (value) {
          if (value.isNotEmpty) {
            try {
              SyncDeviceModel getInfo =
                  SyncDeviceModel.fromJson(jsonDecode(value));
              customerDisplayDeviceList[index].connected = getInfo.connected;
            } catch (e) {
              serviceLocator<Log>().error(e);
            }
          }
        });
  }
}

Future<void> sendProcessToCustomerDisplay() async {
  for (int index = 0; index < customerDisplayDeviceList.length; index++) {
    if (customerDisplayDeviceList[index].connected) {
      var url = "${customerDisplayDeviceList[index].ip}:5041";
      try {
        var jsonData = HttpPost(
            command: "process",
            data: jsonEncode(posHoldProcessResult[
                    findPosHoldProcessResultIndex(posHoldActiveCode)]
                .toJson()));
        dev.log("sendProcessToCustomerDisplay : $url");
        postToServer(
            ip: url,
            jsonData: jsonEncode(jsonData.toJson()),
            callBack: (value) {});
      } catch (e) {
        serviceLocator<Log>().error("$e : $url");
      }
    }
  }
  if (Platform.isAndroid &&
      displayMachine == DisplayMachineEnum.posTerminal &&
      isInternalCustomerDisplayConnected == true) {
    // Send to จอสอง
    displayManager.transferDataToPresentation(jsonEncode(
        posHoldProcessResult[findPosHoldProcessResultIndex(posHoldActiveCode)]
            .toJson()));
  }
}

Future<void> sendProcessToRemote() async {
  for (int index = 0; index < posRemoteDeviceList.length; index++) {
    if (posRemoteDeviceList[index].connected) {
      var url = "${posRemoteDeviceList[index].ip}:$targetDeviceIpPort";
      try {
        var jsonData = HttpPost(
            command: "process_result",
            data: jsonEncode(posHoldProcessResult[findPosHoldProcessResultIndex(
                    posRemoteDeviceList[index].holdCodeActive)]
                .toJson()));
        postToServer(
            ip: url, jsonData: jsonEncode(jsonData.toJson()), callBack: (_) {});
      } catch (e) {
        serviceLocator<Log>().error("$e : $url");
      }
    }
  }
}

double calcDiscountFormula(
    {required double totalAmount, required String discountText}) {
  double sumDiscount = 0.0;
  List<String> split =
      discountText.trim().replaceAll(" ", "").replaceAll(" ", "").split(",");
  for (int index = 0; index < split.length; index++) {
    String discount = split[index];
    double result = 0.0;
    if (discount.contains("%")) {
      // ลด %
      double? percent = double.tryParse(discount.replaceAll("%", ""));
      if (percent != null) {
        result = totalAmount * (percent / 100);
        sumDiscount += result;
        totalAmount -= result;
      }
    } else {
      // ลด จำนวนเงิน
      double? discountMoney = double.tryParse(discount);
      if (discountMoney != null) {
        sumDiscount += discountMoney;
        totalAmount -= discountMoney;
      }
    }
  }
  return sumDiscount;
}

String language(String code) {
  bool found = false;
  code = code.trim().toLowerCase();
  String result = code;
  for (int i = 0; i < languageSystemData.length; i++) {
    if (languageSystemData[i].code == code) {
      result = languageSystemData[i].text;
      found = true;
      break;
    }
  }
  if (!found) {
    dev.log("language not found: $code");
    if (developerMode && code.trim().isNotEmpty && kIsWeb == false) {
      googleMultiLanguageSheetAppendRow(["pos_client", code]);
    }
  }
  return (result.trim().isEmpty) ? code : result;
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String posScreenListHeightName = "posScreenListHeight";
double posScreenListHeightGet() {
  return appStorage.read(posScreenListHeightName) ?? 1.0;
}

void posScreenListHeightSet(double value) {
  appStorage.write(posScreenListHeightName, value);
}

Future<void> loadConfig() async {
  await loadPrinter();
  await loadFormDesign();
  await loadEmployee();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  posTerminalPinCode =
      sharedPreferences.getString('pos_terminal_pin_code') ?? "";
  posTerminalPinTokenId =
      sharedPreferences.getString('pos_terminal_token') ?? "";
  deviceId = sharedPreferences.getString('pos_device_id') ?? "";
}

Future<void> registerRemoteToTerminal() async {
  if (appMode == AppModeEnum.posRemote) {
    var url =
        "http://$targetDeviceIpAddress:$targetDeviceIpPort?uuid=${const Uuid().v4()}";
    var uri = Uri.parse(url);
    try {
      SyncDeviceModel sendData = SyncDeviceModel(
          deviceId: "XXX",
          deviceName: "XXX",
          ip: ipAddress,
          holdCodeActive: posHoldActiveCode,
          docModeActive: 0,
          connected: true,
          isCashierTerminal: false,
          isClient: true);
      var jsonEncodeStr = jsonEncode(sendData.toJson());
      await http
          .post(uri,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'command': 'register_remote_device',
                'data': jsonEncodeStr,
              }))
          .timeout(const Duration(seconds: 1))
          .then((response) {});
    } catch (_) {}
  }
}

/// Loading System
/// - _global:loadConfig
/// - Add qrPaymentProviderList
/// - register DartPingIOS
/// - setupObjectBox (core/objectbox.dart)
/// - register sync master
/// - สร้าง Process Result ตามจำนวน Hold บิล (generatePosHoldProcess)
Future<void> startLoading() async {
  {
    await loadConfig();
    // Payment
    /*qrPaymentProviderList.add(PaymentProviderModel(
      providercode: "",
      paymentcode: "promptpay",
      bookbankcode: "001",
      paymentlogo: "",
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "Prompt Pay", use: true)
      ],
      countrycode: "TH",
      paymenttype: 1,
      feeRate: 0.0,
      wallettype: 101,
    ));
    // Lugen
    lugenPaymentProviderList.add(PaymentProviderModel(
      providercode: "LUGEN",
      paymentcode: "promptpay",
      bookbankcode: "002",
      paymentlogo: "",
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "Prompt Pay", use: true)
      ],
      countrycode: "TH",
      paymenttype: 20,
      feeRate: 0.0,
      wallettype: 201,
    ));
    lugenPaymentProviderList.add(PaymentProviderModel(
      providercode: "LUGEN",
      paymentcode: "truemoney",
      bookbankcode: "002",
      paymentlogo: "",
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "True Money", use: true)
      ],
      countrycode: "TH",
      paymenttype: 1,
      feeRate: 0.0,
      wallettype: 202,
    ));
    lugenPaymentProviderList.add(PaymentProviderModel(
      providercode: "LUGEN",
      bookbankcode: "002",
      paymentcode: "linepay",
      paymentlogo: "",
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "Line Pay", use: true)
      ],
      countrycode: "TH",
      paymenttype: 1,
      feeRate: 0.0,
      wallettype: 203,
    ));
    lugenPaymentProviderList.add(PaymentProviderModel(
      providercode: "LUGEN",
      bookbankcode: "002",
      paymentcode: "alipay",
      paymentlogo: "",
      names: [
        LanguageModel(
            code: "th", codeTranslator: "th", name: "Alipay", use: true)
      ],
      countrycode: "TH",
      paymenttype: 1,
      feeRate: 0.0,
      wallettype: 204,
    ));*/
  }
  //WidgetsFlutterBinding.ensureInitialized();
  //await GetStorage.init();

  //Widget _defaultHome = new PrinterConfigScreen();

  /*bool result = await appAuth.login();
  if (result) {
    //_defaultHome = new MenuScreen();
  }*/

  DartPingIOS.register();

  // objectbox
  // move to after login & Select shop
  // await setupObjectBox();

  int xxx = ProductBarcodeHelper().count();
  //objectBoxStore =Store(getObjectBoxModel(), directory: value.path + '/xobjectbox');
  //objectBoxStore = await openStore(maxDBSizeInKB: 102400);
  {
    /// Sync Master (ข้อมูลหลัก)
    int syncMasterSecondCount = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (loginSuccess && syncDataProcess == false) {
        //log('Sync Data Master : ' + DateTime.now().toString());
        syncMasterSecondCount++;
        if (syncMasterSecondCount > syncTimeIntervalSecond) {
          sync.syncMasterProcess();
          syncTimeIntervalSecond = syncTimeIntervalSecond * 2;
          if (syncTimeIntervalSecond > syncTimeIntervalMaxBySecond) {
            syncTimeIntervalSecond = syncTimeIntervalMaxBySecond;
          }
          syncMasterSecondCount = 0;
        }
      }
    });
  }
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (loginSuccess) {
      systemProcess();
      registerRemoteToTerminal();
    }
  });

  generatePosHoldProcess();
  initSuccess = true;
}

/// สร้าง Process Result ตามจำนวน Hold บิล
void generatePosHoldProcess() {
  for (int loop = 0; loop < 50; loop++) {
    posHoldProcessResult.add(PosHoldProcessModel(code: loop.toString()));
  }
}

Future<String> getFromServer({required String json}) async {
  final base64String = base64Encode(utf8.encode(json));
  // String url = "$httpServerIp:$httpServerPort?data=$base64String";

  String url = "$targetDeviceIpAddress:$targetDeviceIpPort";
  final response = await httpClient
      .get(Uri.http(url, '/', {'json': base64String}), headers: {
    "Content-Type": "application/json",
    "Cache-Control": "no-cache",
    "Accept": "text/event-stream"
  });
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> postToServer(
    {required String ip,
    required String jsonData,
    required Function callBack}) async {
  String result = "";
  try {
    var request = http.Request("POST", Uri.parse("http://$ip"));
    request.headers["Content-Type"] = "application/json";
    request.headers["Cache-Control"] = "no-cache";
    request.headers["Accept"] = "text/event-stream";
    request.body = jsonData;
    // wait for the response
    httpClient.send(request).then((value) {
      value.stream.listen((data) {
        result = utf8.decode(data);
        callBack(result);
      }, onError: (e, s) {});
    });
  } catch (e) {
    serviceLocator<Log>().error("sendToServer : $e");
  }
}

Future<String> postToServerAndWait(
    {required String ip, required String jsonData}) async {
  String result = "";
  try {
    var request = http.Request("POST", Uri.parse("http://$ip"));
    request.headers["Content-Type"] = "application/json";
    request.headers["Cache-Control"] = "no-cache";
    request.headers["Accept"] = "text/event-stream";
    request.body = jsonData;
    // wait for the response
    var value = await httpClient.send(request);
    if (value.statusCode == 200) {
      result = utf8.decode(await value.stream.toBytes());
    }
  } catch (e) {
    serviceLocator<Log>().error("sendToServer : $e");
  }
  return result;
}

Future<String> getIpAddress() async {
  // Get a list of the network interfaces available on the device
  List<NetworkInterface> interfaces = await NetworkInterface.list();

  // Iterate through the list of interfaces and return the first non-loopback IPv4 address
  for (NetworkInterface interface in interfaces) {
    if (interface.name == 'lo') continue; // Skip the loopback interface
    for (InternetAddress address in interface.addresses) {
      if (address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  }

  // If no non-loopback IPv4 address was found, return null
  return "";
}

Future scanServerById(String name) async {
  List<SyncDeviceModel> ipList = [];
  String ipAddress = await getIpAddress();
  String subNet = ipAddress.substring(0, ipAddress.lastIndexOf("."));
  for (int i = 1; i < 255; i++) {
    String ip = "$subNet.$i";
    ipList.add(SyncDeviceModel(
        deviceId: "",
        deviceName: "",
        ip: ip,
        holdCodeActive: "",
        docModeActive: 0,
        connected: false,
        isClient: false,
        isCashierTerminal: false));
  }
  int countTread = 0;
  bool loopScan = true;
  while (loopScan) {
    await Future.delayed(const Duration(seconds: 1));
    for (int index = 0; index < ipList.length; index++) {
      if (!ipList[index].connected) {
        if (countTread < 10) {
          countTread++;
          String url =
              "http://${ipList[index].ip}:$targetDeviceIpPort/scan?uuid=${const Uuid().v4()}";
          try {
            http
                .post(Uri.parse(url))
                .timeout(const Duration(seconds: 1))
                .then((result) {
              countTread--;
              if (result.statusCode == 200) {
                if (result.body.isNotEmpty) {
                  serviceLocator<Log>()
                      .debug("Connected to ${ipList[index].ip}");
                  SyncDeviceModel server =
                      SyncDeviceModel.fromJson(jsonDecode(result.body));
                  if (server.deviceId == name && server.isCashierTerminal) {
                    ipList[index].connected = true;
                    loopScan = false;
                    targetDeviceIpAddress = ipList[index].ip;
                    targetDeviceConnected = true;
                  }
                }
              }
            }).onError((error, stackTrace) {
              countTread--;
            }).catchError((error) {
              countTread--;
            }).whenComplete(() {
              countTread--;
            });
          } catch (_) {
            countTread--;
          }
        } else {
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }
  }
}

bool isTabletScreen() {
  return (deviceMode == DeviceModeEnum.androidTablet ||
      deviceMode == DeviceModeEnum.ipad);
}

bool isDesktopScreen() {
  return (deviceMode == DeviceModeEnum.macosDesktop ||
      deviceMode == DeviceModeEnum.linuxDesktop ||
      deviceMode == DeviceModeEnum.windowsDesktop);
}

String syncFindLastUpdate(
    List<SyncMasterStatusModel> dataList, String tableName) {
  for (var item in dataList) {
    if (item.tableName == tableName) {
      return DateFormat(dateFormatSync).format(DateTime.parse(item.lastUpdate));
    }
  }
  return DateFormat(dateFormatSync).format(DateTime.parse(syncDateBegin));
}

Future<void> testPrinterConnect() async {
  if (printerLocalStrongData.isNotEmpty) {
    for (var printer in printerLocalStrongData) {
      if (printer.printerConnectType == global.PrinterConnectEnum.ip) {
        if (printer.ipAddress.trim().isNotEmpty) {
          bool oldReady = printer.isReady;
          try {
            final Socket socket = await Socket.connect(
                printer.ipAddress, printer.ipPort,
                timeout: const Duration(seconds: 1));
            printer.isReady = true;
            socket.destroy();
          } catch (e) {
            printer.isReady = false;
            String message =
                "${language("printer")} : ${printer.name}/${printer.ipAddress}:${printer.ipPort} ${language("not_ready")}";
            if (!errorMessage.contains(message)) {
              // errorMessage.add(message);
            }
          }
          if (oldReady != printer.isReady) {
            global.posScreenAutoRefresh = true;
          }
        }
      }
    }
  }
}

int printerWidthByCharacter(int printerIndex) {
  if (printerLocalStrongData[printerIndex].paperType == 1) {
    return 32;
  } else {
    return 48;
  }
}

double printerWidthByPixel(int printerIndex) {
  if (printerLocalStrongData[printerIndex].paperType == 1) {
    return 384;
  } else {
    return 576;
  }
}

void languageSelect(String languageCode) {
  languageSystemData = [];
  for (int i = 0; i < languageSystemCode.length; i++) {
    for (int j = 0; j < languageSystemCode[i].langs.length; j++) {
      if (languageSystemCode[i].langs[j].code == userScreenLanguage) {
        languageSystemData.add(LanguageSystemModel(
            code: languageSystemCode[i].code.trim(),
            text: languageSystemCode[i].langs[j].text.trim()));
      }
    }
  }
  /*languageSystemData.sort((a, b) {
    return a.code.compareTo(b.code);
  });*/
}

int findBuffetModeIndex(String code) {
  for (var item in buffetModeLists) {
    if (item.code == code) {
      return buffetModeLists.indexOf(item);
    }
  }
  return -1;
}

Future<void> rebuildOrderToHoldBill(String tableNumber) async {
  var data = global.objectBoxStore
      .box<PosLogObjectBoxStruct>()
      .query(PosLogObjectBoxStruct_.hold_code.equals("T-$tableNumber"))
      .build()
      .find();
  if (data.isNotEmpty) {
    for (var item in data) {
      global.objectBoxStore.box<PosLogObjectBoxStruct>().remove(item.id);
    }
  }
  // ดึงรายการที่สั่งไปแล้ว มาสร้างรายการ Hold Bill
  var dataTemp = global.objectBoxStore
      .box<OrderTempObjectBoxStruct>()
      .query(OrderTempObjectBoxStruct_.orderId
          .equals(tableNumber)
          .and(OrderTempObjectBoxStruct_.isPaySuccess.equals(false)))
      .build()
      .find();
  if (dataTemp.isNotEmpty) {
    await saveOrderToHoldBill(dataTemp);
  }
}

Future<void> saveOrderToHoldBill(List<OrderTempObjectBoxStruct> orders) async {
  if (orders.isNotEmpty) {
    for (var order in orders) {
      String newOrderId = "T-${order.orderId}";
      ProductBarcodeObjectBoxStruct? productSelect =
          await ProductBarcodeHelper().selectByBarcodeFirst(order.barcode);
      if (productSelect != null) {
        double price = getProductPrice(productSelect.prices, 1);
        PosLogObjectBoxStruct data = PosLogObjectBoxStruct(
            log_date_time: DateTime.now(),
            doc_mode: posScreenToInt(),
            hold_code: newOrderId,
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
          List<OrderProductOptionModel> options =
              jsonDecode(order.optionSelected)
                  .map<OrderProductOptionModel>(
                      (e) => OrderProductOptionModel.fromJson(e))
                  .toList();
          for (var option in options) {
            for (var choice in option.choices) {
              if (choice.selected) {
                List<PosLogObjectBoxStruct> posLogSelect =
                    await PosLogHelper().selectByGuidFixed(insertGuid);
                if (posLogSelect.isNotEmpty) {
                  await PosLogHelper().insert(PosLogObjectBoxStruct(
                      guid_code_ref: "",
                      doc_mode: posScreenToInt(),
                      guid_ref: insertGuid,
                      log_date_time: DateTime.now(),
                      hold_code: newOrderId,
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

Future<void> checkOrderOnline() async {
  checkOrderActive = true;
  {
    List<OrderTempDataModel> orderTemp = [];
    List<OrderTempDataModel> orderSave = [];
    try {
      // ดึง Order ลูกค้าสั่งเอง
      String selectQuery =
          "select orderid,barcode,sum(qty) as qty,optionselected,remark from ordertemp where shopid='${shopId}' and isclose=1 group by orderid,barcode,optionselected,remark order by barcode";
      var value = await clickHouseSelect(selectQuery);
      ResponseDataModel responseData = ResponseDataModel.fromJson(value);
      // Print
      String orderId = "";
      bool updateOrder = false;
      for (var order in responseData.data) {
        orderId = order["orderid"];
        OrderTempDataModel orderData = OrderTempDataModel(
          orderGuid: Uuid().v4(),
          barcode: order["barcode"],
          qty: double.tryParse(order["qty"].toString()) ?? 0,
          optionSelected: order["optionselected"],
          remark: order["remark"],
        );
        orderTemp.add(orderData);
        orderSave.add(orderData);
        if (orderToKitchenPrintMode == 0) {
          // พิมพ์แยกใบ
          await sendToKitchen(orderId: orderId, orderList: orderTemp);
          updateOrder = true;
          orderTemp.clear();
        }
      }
      if (orderTemp.isNotEmpty) {
        await sendToKitchen(orderId: orderId, orderList: orderTemp);
        updateOrder = true;
      }
      if (updateOrder) {
        // update สถานะ ว่า ส่งไปที่ครัวแล้ว
        String updateQuery =
            "alter table ordertemp update isclose=2 where shopid='${shopId}' and orderid='$orderId'";
        await clickHouseExecute(updateQuery);
      }
    } catch (e) {
      serviceLocator<Log>().error(e.toString());
    }
    //saveOrderToHoldBill(orderSave);
  }
  {
    // Order Staff สั่ง
    List<String> orderIdList = [];
    try {
      // update isOrderSuccess และคำนวนณยอดรวม
      final getData = objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.isOrder
              .equals(false)
              .and(OrderTempObjectBoxStruct_.isOrderSuccess.equals(false)))
          .build()
          .find();
      for (var data in getData) {
        if (!orderIdList.contains(data.orderId)) {
          orderIdList.add(data.orderId);
        }
      }

      for (var orderId in orderIdList) {
        var orderTempUpdate = objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .query(OrderTempObjectBoxStruct_.orderId
                .equals(orderId)
                .and(OrderTempObjectBoxStruct_.isOrderSuccess.equals(false)))
            .build()
            .find();
        for (var data in orderTempUpdate) {
          // ปรับปรุง ว่าส่ง order แล้ว จะได้ไม่วนกลับมาสร้างใหม่
          data.isOrder = false;
          data.isOrderSuccess = true;
          // ถือว่ายังไม่ส่งครัว รอ Step ถัดไป
          data.isOrderSendKdsSuccess = false;
        }
        objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .putMany(orderTempUpdate, mode: PutMode.update);
        // คำนวณ
        orderSumAndUpdateTable(orderId);
      }
      saveOrderToHoldBill(getData);
    } catch (e) {
      serviceLocator<Log>().error(e.toString());
    }
  }
  {
    // ประมวลผลส่งครัว
    List<String> orderIdList = [];

    /// ถ้า isOrderReadySendKds = true คือ ส่ง Order ได้เลย
    /// ถ้า isOrderSendKdsSuccess = false คือ ยังไม่ส่ง Order
    /// ถ้า isOrderSuccess = true คือ ส่ง Order ไปรายการคิดเงินแล้ว
    final getDataOrderId = objectBoxStore
        .box<OrderTempObjectBoxStruct>()
        .query(OrderTempObjectBoxStruct_.isOrder
            .equals(false)
            .and(OrderTempObjectBoxStruct_.isOrderReadySendKds.equals(true))
            .and(OrderTempObjectBoxStruct_.isOrderSendKdsSuccess.equals(false))
            .and(OrderTempObjectBoxStruct_.isOrderSuccess.equals(true)))
        .build()
        .find();
    for (var data in getDataOrderId) {
      if (!orderIdList.contains(data.orderId)) {
        orderIdList.add(data.orderId);
      }
    }
    for (var orderId in orderIdList) {
      // เลือกรายการ Order ทีละโต๊ะ
      List<OrderTempDataModel> orderTemp = [];
      final getData = objectBoxStore
          .box<OrderTempObjectBoxStruct>()
          .query(OrderTempObjectBoxStruct_.orderId.equals(orderId).and(
              OrderTempObjectBoxStruct_.isOrder
                  .equals(false)
                  .and(OrderTempObjectBoxStruct_.isOrderReadySendKds
                      .equals(true))
                  .and(OrderTempObjectBoxStruct_.isOrderSendKdsSuccess
                      .equals(false))
                  .and(OrderTempObjectBoxStruct_.isOrderSuccess.equals(true))))
          .build()
          .find();
      for (var data in getData) {
        orderTemp.add(OrderTempDataModel(
          orderGuid: data.orderGuid,
          barcode: data.barcode,
          qty: data.qty,
          optionSelected: data.optionSelected,
          remark: data.remark,
        ));
        // update สถานะ
        data.isOrderSendKdsSuccess = true;
        objectBoxStore
            .box<OrderTempObjectBoxStruct>()
            .put(data, mode: PutMode.update);
      }
      if (orderToKitchenPrintMode == 0) {
        // พิมพ์แยกใบ พร้อม update KDS ว่าส่ง order แล้ว
        await sendToKitchen(orderId: orderId, orderList: orderTemp);
        print("sendToKitchen 1 : ${orderTemp.length}");
        orderTemp.clear();
      }
      if (orderTemp.isNotEmpty) {
        // พิมพ์ รวม พร้อม update KDS ว่าส่ง order แล้ว
        await sendToKitchen(orderId: orderId, orderList: orderTemp);
        print("sendToKitchen 2 : ${orderTemp.length}");
      }
    }
  }
  checkOrderActive = false;
}

String getNameFromJsonLanguage(String jsonNames, String languageCode) {
  try {
    List<LanguageDataModel> names =
        jsonDecode(jsonNames).map<LanguageDataModel>((item) {
      return LanguageDataModel.fromJson(item);
    }).toList();
    for (var item in names) {
      if (item.code == languageCode) {
        return item.name;
      }
    }
  } catch (_) {}
  return "";
}

String getNameFromLanguage(List<LanguageDataModel> names, String languageCode) {
  for (var item in names) {
    if (item.code == languageCode) {
      return item.name;
    }
  }
  return "*";
}

double getProductPrice(String prices, int keyNumber) {
  List<PriceDataModel> priceList =
      jsonDecode(prices).map<PriceDataModel>((item) {
    return PriceDataModel.fromJson(item);
  }).toList();
  for (var item in priceList) {
    if (item.keynumber == keyNumber) {
      return item.price;
    }
  }
  return 0;
}

Future<void> orderSumAndUpdateTable(String tableNumber) async {
  double orderCount = 0;
  double amount = 0.0;
  {
    // รวมจาก OrderTemp ส่งรายการแล้ว
    final result = objectBoxStore
        .box<OrderTempObjectBoxStruct>()
        .query(OrderTempObjectBoxStruct_.orderId
            .equals(tableNumber)
            .and(OrderTempObjectBoxStruct_.isOrderSuccess.equals(true)))
        .build()
        .find();
    for (var order in result) {
      orderCount += order.qty;
      amount += orderCalcSumAmount(order);
    }
  }
  final boxTable = objectBoxStore.box<TableProcessObjectBoxStruct>();
  final resultTable = boxTable
      .query(TableProcessObjectBoxStruct_.number.equals(tableNumber))
      .build()
      .findFirst();
  if (resultTable != null) {
    resultTable.order_count = orderCount;
    resultTable.amount = amount;
    boxTable.put(resultTable, mode: PutMode.update);
  }
}

String generateRandomPin(int pinLength) {
  String pin = "";
  var rnd = new Random();
  for (var i = 0; i < pinLength; i++) {
    pin += rnd.nextInt(10).toString();
  }
  return pin;
}

Future<void> getProfile() async {
  ApiRepository apiRepository = ApiRepository();
  {
    var value = await apiRepository.getProfileShop();
    shopId = value.data["guidfixed"];
  }
  {
    try {
      ProfileSettingCompanyModel company = ProfileSettingCompanyModel(
        names: [],
        taxID: "",
        branchNames: [],
        addresses: [],
        phones: [],
        emailOwners: [],
        emailStaffs: [],
        latitude: "",
        longitude: "",
        usebranch: false,
        usedepartment: false,
        images: [],
        logo: "",
      );
      List<String> languageList = [];
      ProfileSettingConfigSystemModel configSystem =
          ProfileSettingConfigSystemModel(
        vatrate: 0,
        vattypesale: 0,
        vattypepurchase: 0,
        inquirytypesale: 0,
        inquirytypepurchase: 0,
        headerreceiptpos: "",
        footerreciptpos: "",
      );

      var value = await apiRepository.getProfileSetting();
      var jsonData = value.data;
      for (var data in jsonData) {
        String code = data["code"];
        String body = data["body"];
        if (code == "company") {
          company = ProfileSettingCompanyModel.fromJson(jsonDecode(body));
        } else if (code == "ConfigLanguage") {
          var jsonDecodeBody = jsonDecode(body) as Map<String, dynamic>;
          languageList = List<String>.from(jsonDecodeBody["languageList"]);
        } else if (code == "ConfigSystem") {
          configSystem =
              ProfileSettingConfigSystemModel.fromJson(jsonDecode(body));
        }
      }
      var branchValue = await apiRepository.getProfileSBranch();
      List<ProfileSettingBranchModel> branchs =
          List<ProfileSettingBranchModel>.from(branchValue.data
              .map((e) => ProfileSettingBranchModel.fromJson(e)));

      profileSetting = ProfileSettingModel(
        company: company,
        languagelist: languageList,
        configsystem: configSystem,
        branch: branchs,
      );
      appStorage.write('profile', profileSetting.toJson());
      // Download Logo
      if (profileSetting.company.logo.isNotEmpty) {
        var url = profileSetting.company.logo;
        var response = await http.get(Uri.parse(url));
        var file = File(global.getShopLogoPathName());
        await file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      print(e);
    }
    var getProfile = await appStorage.read('profile');
    profileSetting = ProfileSettingModel.fromJson(getProfile);
  }
  {
    // POS Setting
    var value = await apiRepository.getPosSetting(deviceId);
    var jsonData = value.data;
  }
  await loadConfig();
}

Future<void> loadEmployee() async {
  print("loadEmployee()");
  try {
    ApiRepository apiRepository = ApiRepository();
    var value = await apiRepository.getEmployeeList();
    List<EmployeeModel> employeeList = (value.data as List)
        .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
        .toList();
    employeeHelper.deleteAll();
    List<EmployeeObjectBoxStruct> employeeObjectBoxList = [];
    for (var data in employeeList) {
      employeeObjectBoxList.add(EmployeeObjectBoxStruct(
        guidfixed: data.guidfixed,
        code: data.code,
        name: data.name,
        email: data.email,
        is_enabled: data.isenabled,
        is_use_pos: data.isusepos,
        pin_code: data.pincode,
        profile_picture: data.profilepicture,
      ));
    }
    employeeHelper.insertMany(employeeObjectBoxList);
  } catch (e) {
    print(e);
  }
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

String findBankLogo(String code) {
  BankObjectBoxStruct? bankDataList = BankHelper().selectByCode(code: code);
  if (bankDataList != null) {
    return bankDataList.logo;
  }
  return "";
}

double paperWidth(int paperType) {
  switch (paperType) {
    case 1: // 58
      return 378;
    case 2: // 80
      return 575;
    default:
      return 575;
  }
}

String getShopLogoPathName() {
  return "${applicationDocumentsDirectory.path}/$shopId-logo.png";
}
