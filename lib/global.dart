import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:dedepos/api/network/sync_model.dart';
import 'package:localstore/localstore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;
import 'dart:ffi';
import 'dart:io' as io;
import 'dart:io';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:dedepos/app_auth.dart';
import 'package:dedepos/db/bill_detail_extra_helper.dart';
import 'package:dedepos/db/bill_detail_helper.dart';
import 'package:dedepos/db/bill_pay_helper.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/db/member_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/bank_and_wallet_model.dart';
import 'package:dedepos/model/objectbox/bank_and_wallet_struct.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/model/json/payment.dart';
import 'package:dedepos/model/pos_pay_struct.dart';
import 'package:dedepos/model/json/print_queue_struct.dart';
import 'package:dedepos/api/sync/sync_master.dart' as sync;
import 'package:dedepos/model/json/printer_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/services/device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/model/objectbox/config_struct.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'dart:async';
import 'db/promotion_helper.dart';
import 'db/promotion_temp_helper.dart';
import 'db/product_category_helper.dart';
import 'db/product_barcode_helper.dart';
import 'db/pos_log_helper.dart';
import 'db/bill_helper.dart';
import 'db/config_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'model/json/language_model.dart';
import 'model/json/struct.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dedepos/api/network/server.dart' as network;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:objectbox/objectbox.dart';

var httpClient = http.Client();
late BuildContext globalContext;
void posProcessRefresh = () {};
String customerCode = "";
String customerName = "";
String customerPhone = "";
String ipAddress = "";
List<String> errorMessage = [];
AuthService appAuth = AuthService();
bool initSuccess = false;
late List<LanguageSystemCodeModel> languageSystemCode;
late String pathApplicationDocumentsDirectory;
PosProcessStruct posProcessResult = PosProcessStruct(
    details: [], select_promotion_temp_list: [], promotion_list: []);
ProductCategoryHelper productCategoryHelper = ProductCategoryHelper();
ProductBarcodeHelper productBarcodeHelper = ProductBarcodeHelper();
MemberHelper memberHelper = MemberHelper();
EmployeeHelper employeeHelper = EmployeeHelper();
PosLogHelper posLogHelper = PosLogHelper();
BillHelper billHelper = BillHelper();
BillDetailHelper billDetailHelper = BillDetailHelper();
BillDetailExtraHelper billDetailExtraHelper = BillDetailExtraHelper();
BillPayHelper billPayHelper = BillPayHelper();
ConfigHelper configHelper = ConfigHelper();
PromotionHelper promotionHelper = PromotionHelper();
PromotionTempHelper promotionTempHelper = PromotionTempHelper();
int syncTimeIntervalMaxBySecond = 10;
int syncTimeIntervalSecond = 1;
final moneyFormat = NumberFormat("##,##0.00");
final qtyShortFormat = NumberFormat("##,##0");
String objectBoxDatabaseName = "smlposmobile.db";
String startGroupCode = '27dcEdktOoaSBYFmnN6G6ett4Jb001';
String deviceId = "";
String deviceName = "POS01";
List<SyncDeviceModel> customerDisplayDeviceList = [];
//"http://192.168.1.4:8084";
String webServiceUrl = "http://smltest1.ddnsfree.com:8084";
String webServiceVersion = "/SMLJavaWebService/webresources/rest/";
String providerName = "DATA";
String databaseName = "DEMO"; // "DATA1 or DEMO";
bool isTablet = false; // False=จอเล็ก,True=จอใหญ่
bool isIphoneX = false;
int posHoldNumber = 0;
bool speechToTextVisible = false;
bool loginSuccess = false;
GetStorage appStorage = GetStorage('AppStorage');
Localstore appLocalStore = Localstore.instance;
late LocalStrongDataModel appLocalStrongData;
bool loginProcess = false;
bool syncDataSuccess = false;
bool syncDataProcess = false;
PayStruct payScreenData = PayStruct();
bool lugenPaymentProvider = true;
List<PaymentProviderStruct> lugenPaymentProviderList = [];
List<PaymentProviderStruct> qrPaymentProviderList = [];
List<PaymentProviderStruct> bankProviderList = [];
List<PosHoldStruct> posHoldList = [];
bool payScreenNumberPadIsActive = false;
double payScreenNumberPadLeft = 100;
double payScreenNumberPadTop = 100;
String payScreenNumberPadText = "";
double payScreenNumberPadAmount = 0;
payScreenNumberPadWidgetEnum payScreenNumberPadWidget =
    payScreenNumberPadWidgetEnum.number;
VoidCallback numberPadCallBack = () {};
late String saleActiveCode;
late String saleActiveName;
late String customerActiveCode;
late String customerActiveName;
String userLanguage = "";
String userLoginCode = "001";
String userLoginName = "สมชาย";
String employeeLogin = "";
String employeeLoginName = "";
int machineNumber = 1;
String selectTableCode = "";
String selectTableGroup = "";
ThemeStruct posTheme = ThemeStruct();
bool transDisplayImage = true;
List<ProductCategoryObjectBoxStruct> productCategoryCodeSelected = [];
List<ProductCategoryObjectBoxStruct> productCategoryList = [];
List<ProductBarcodeObjectBoxStruct> productListByCategory = [];
List<ProductCategoryObjectBoxStruct> productCategoryChildList = [];
List<PrinterStruct> printerList = [];
AudioPlayer audio = AudioPlayer();
String cashierPrinterCode = 'E2'; // เครื่องพิมพ์สำหรับพิมพ์บิล
String tablePrinterCode = 'E3'; // เครื่องพิมพ์สำหรับพิมพ์โต๊/ปิดโต๊
String orderSummeryPrinterCode = "E1"; // ใบสรุปรายการสั่งอาหาร
bool isServer = false;
String serverIp = "";
int serverPort = 4040;
AppModeEnum appMode = AppModeEnum.pos;
bool apiConnected = false;
String apiUserName = "maxkorn";
String apiUserPassword = "maxkorn";
String apiShopID =
    "2Eh6e3pfWvXTp0yV3CyFEhKPjdI"; // "27dcEdktOoaSBYFmnN6G6ett4Jb";
bool syncRefreshProductCategory = true;
bool syncRefreshProductBarcode = true;
bool syncRefreshPrinter = true;
String syncDateBegin = "2000-01-01T00:00:00";
String syncCategoryTimeName = "lastSyncCategory";
String syncProductBarcodeTimeName = "lastSyncProductBarcode";
String syncPrinterTimeName = "lastSyncPrinter";
String syncInventoryTimeName = "lastSyncInventory";
String syncMemberTimeName = "lastSyncMember";
String syncEmployeeTimeName = "lastSyncEmployee";
String syncTableTimeName = "lastSyncTable";
String syncTableZoneTimeName = "lastSyncTableZone";
String syncDeviceTimeName = "lastSyncDevice";
// String apiShopCode = "290P2Puyksvx04jlsavRTZhTyvg";
bool isOnline = false;
MemberObjectBoxStruct? userData;
Payment? paymentData;
late Store objectBoxStore;
String dateFormatSync = "yyyy-MM-ddTHH:mm:ss";
PosVersionEnum posVersion = PosVersionEnum.vfpos;
PrinterCashierTypeEnum printerCashierType = PrinterCashierTypeEnum.thermal;
PrinterCashierConnectEnum printerCashierConnect = PrinterCashierConnectEnum.ip;
String printerCashierIpAddress = "";
int printerCashierIpPort = 9100;

enum PrinterCashierTypeEnum { thermal, dot, laser, inkjet }

enum PrinterCashierConnectEnum { ip, bluetooth, usb, serial }

enum PosVersionEnum { pos, restaurant, vfpos }

enum SoundEnum { beep, fail, buttonTing }

enum AppModeEnum { pos, restaurant }

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
  return await CharsetConverter.encode('TIS620', word);
}

void playSound({SoundEnum sound = SoundEnum.beep, String word = ""}) {
  try {
    if (speechToTextVisible && word.isNotEmpty) {
      TextToSpeech tts = TextToSpeech();
      tts.setRate(1);
      tts.speak(word);
    } else {
      switch (sound) {
        case SoundEnum.beep:
          audio
              .setAsset('assets/audios/scan_success.wav')
              .then((value) => audio.play());
          break;
        case SoundEnum.fail:
          audio
              .setAsset('assets/audios/scan_fail.wav')
              .then((value) => audio.play());
          break;
        case SoundEnum.buttonTing:
          audio
              .setAsset('assets/audios/button_ting.wav')
              .then((value) => audio.play());

          break;
      }
    }
  } catch (_) {}
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
    word = word.replaceAll(firstBreak[index], " " + firstBreak[index]);
  }
  for (int index0 = 0; index0 < endBreak.length; index0++) {
    word = word.replaceAll(endBreak[index0], endBreak[index0] + " ");
  }
  split = word.split(" ");
  return split;
}

double calcTextToNumber(String text) {
  double result = 0;
  String text0 = text.trim();
  while (text0.contains(" ")) {
    text0 = text0.replaceAll(" ", "");
  }
  if (text0.isNotEmpty) {
    text0 = text0
        .replaceAll("X", "")
        .replaceAll("x", "")
        .replaceAll("+", "")
        .replaceAll("-", "");
    result = double.parse(text0);
  }
  return result;
}

Future<String> billRunning() async {
  // Format : DEVICE-DATE-#####
  String dateNow = DateFormat('yyMMdd').format(DateTime.now());
  String result = "";
  bool success = false;
  while (success == false) {
    int number = 0;
    String deviceCode = "";
    List<ConfigObjectBoxStruct> configGet = configHelper.select();
    if (configGet.isNotEmpty) {
      ConfigObjectBoxStruct config = configGet[0];
      deviceCode = config.device_code;
      List<String> split = config.last_doc_number.split("-");
      if (split.isNotEmpty) {
        number = int.tryParse(split[split.length - 1]) ?? 0;
        if (split.length > 1) {
          String date = split[1];
          if (date != dateNow) {
            number = 0;
          }
        }
      }
    }
    result =
        "$deviceCode-$dateNow-${(NumberFormat("00000")).format(number + 1)}";

    /// ค้นหาว่ามีเลขที่เอกสารนี้อยู่ในฐานข้อมูลหรือไม่
    var find = billHelper.selectByDocNumber(docNumber: result);
    if (find.isEmpty) {
      success = true;
    } else {
      configHelper.update(ConfigObjectBoxStruct(
          device_code: deviceCode, last_doc_number: result));
    }
  }
  return result;
}

Future<bool> hasNetwork() async {
  try {
    final result = await io.InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

void showAlertDialog(
    {required BuildContext context,
    required String title,
    required String message}) {
  Widget okButton = TextButton(
    child: const Text("OK"),
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
  var url = "http://$serverIp:$serverPort";
  var uri = Uri.parse(url);
  try {
    http.Response response = await http
        .post(uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(network.HttpPost(command: 'print_queue')))
        .timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      dev.log('Success');
    }
  } catch (e) {
    dev.log('failed : ' + e.toString());
  }
}

String dateTimeFormat(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy kk:mm').format(dateTime);
}

Future<String> getDeviceId() async {
  /*String deviceIdentifier = "";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceIdentifier = androidInfo.androidId ?? "";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceIdentifier = iosInfo.identifierForVendor ?? "";
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    deviceIdentifier = linuxInfo.machineId ?? "";
  }
  return deviceIdentifier;*/
  return "xxx";
}

Future<void> systemProcess() async {
  dev.log("Process");
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

Future<void> createLogoImageFromBankProvider() async {
  for (var element in bankProviderList) {
    if (element.paymentlogo != "") {
      String base64 =
          element.paymentlogo.replaceFirst("data:image/png;base64,", "");
      Uint8List bytes = base64Decode(base64);
      File file = File(
          "$pathApplicationDocumentsDirectory/bank${element.paymentcode.toLowerCase()}.png");
      file.writeAsBytes(bytes);
    }
  }
}

String findLogoImageFromCreditCardProvider(String code) {
  return "$pathApplicationDocumentsDirectory/bank${code.toLowerCase()}.png";
}

String language(String code) {
  String result = "";
  for (int i = 0; i < languageSystemCode.length; i++) {
    if (languageSystemCode[i].code == code) {
      for (int j = 0; j < languageSystemCode[i].langs.length; j++) {
        if (languageSystemCode[i].langs[j].code == userLanguage) {
          result = languageSystemCode[i].langs[j].text;
          break;
        }
      }
      break;
    }
  }
  if (result.trim().isEmpty) {
    dev.log(code);
  }
  return (result.trim().isEmpty) ? code : result;
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

void loadConfig() {
  appLocalStrongData = LocalStrongDataModel(
    printerCashierConnectType: 0,
    printerCashierType: 0,
    printerCashierIpAddress: "",
    printerCashierIpPort: 9100,
  );
  try {
    appLocalStore.collection("dedepos").doc("device").get().then((value) {
      appLocalStrongData =
          LocalStrongDataModel.fromJson(jsonDecode(jsonEncode(value)));
      {
        // ประเภทเครื่องพิมพ์ Cashier
        switch (appLocalStrongData.printerCashierType) {
          case 0:
            printerCashierType = PrinterCashierTypeEnum.thermal;
            break;
          case 1:
            printerCashierType = PrinterCashierTypeEnum.dot;
            break;
          case 2:
            printerCashierType = PrinterCashierTypeEnum.laser;
            break;
          case 3:
            printerCashierType = PrinterCashierTypeEnum.inkjet;
            break;
        }
      }
      {
        // การเชื่อมต่อเครื่องพิมพ์ Cashier
        switch (appLocalStrongData.printerCashierConnectType) {
          case 0:
            printerCashierConnect = PrinterCashierConnectEnum.ip;
            break;
          case 1:
            printerCashierConnect = PrinterCashierConnectEnum.bluetooth;
            break;
          case 3:
            printerCashierConnect = PrinterCashierConnectEnum.usb;
            break;
        }
      }
      {
        printerCashierIpAddress = appLocalStrongData.printerCashierIpAddress;
        printerCashierIpPort = appLocalStrongData.printerCashierIpPort;
      }
    });
  } catch (e) {
    dev.log(e.toString());
  }
}

Future<void> loading() async {
  {
    dev.log("loadConst");
    Device getDevice = Device.get();
    isTablet = getDevice.isTablet;
    isIphoneX = getDevice.isIphoneX;
    loadConfig();
    if (isServer) {
      //global.printerList = await global.printerHelper.select();
    }
    // Payment
    qrPaymentProviderList.add(PaymentProviderStruct(
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
    lugenPaymentProviderList.add(PaymentProviderStruct(
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
    lugenPaymentProviderList.add(PaymentProviderStruct(
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
    lugenPaymentProviderList.add(PaymentProviderStruct(
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
    lugenPaymentProviderList.add(PaymentProviderStruct(
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
    ));
  }
  deviceId = "A1";
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  //Widget _defaultHome = new PrinterConfigScreen();

  bool result = await appAuth.login();
  if (result) {
    //_defaultHome = new MenuScreen();
  }

  DartPingIOS.register();

  final appDirectory = await getApplicationDocumentsDirectory();
  final objectBoxDirectory =
      Directory("${appDirectory.path}/$objectBoxDatabaseName");
  if (!objectBoxDirectory.existsSync()) {
    await objectBoxDirectory.create(recursive: true);
  }
  try {
    final isExists = await objectBoxDirectory.exists();
    if (isExists) {
      // ลบทิ้ง เพิ่มทดสอบใหม่
      dev.log("===??? $isExists");
      //await objectBoxDirectory.delete(recursive: true);
    }
    objectBoxStore = Store(getObjectBoxModel(),
        directory: objectBoxDirectory.path,
        maxDBSizeInKB: 1024000,
        queriesCaseSensitiveDefault: false);
  } catch (e) {
    dev.log(e.toString());
    // โครงสร้างเปลี่ยน เริ่ม Sync ใหม่ทั้งหมด
    final isExists = await objectBoxDirectory.exists();
    if (isExists) {
      dev.log("===??? $isExists");
      await objectBoxDirectory.delete(recursive: true);
    }

    objectBoxStore = Store(getObjectBoxModel(),
        directory: objectBoxDirectory.path,
        maxDBSizeInKB: 1024000,
        queriesCaseSensitiveDefault: false);
  }
  //global.objectBoxStore =Store(getObjectBoxModel(), directory: value.path + '/xobjectbox');
  //global.objectBoxStore = await openStore(maxDBSizeInKB: 102400);
  dev.log("Start");
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
  dev.log("Init 1");
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (loginSuccess) systemProcess();
  });
  dev.log("Init 2");

  for (int index = 0; index < 50; index++) {
    posHoldList.add(PosHoldStruct());
  }
  dev.log("Init 3");
  pathApplicationDocumentsDirectory =
      (await getApplicationDocumentsDirectory()).path;

  languageSystemCode =
      (json.decode(await rootBundle.loadString('assets/language.json')) as List)
          .map((i) => LanguageSystemCodeModel.fromJson(i))
          .toList();
  languageSystemCode.sort((a, b) {
    return a.code.compareTo(b.code);
  });
  initSuccess = true;
  dev.log("Init Finish");
}

Future<String> sendToServer(String ip, String jsonData) async {
  bool success = false;
  String result = "";
  int count = 0;
  while (success == false) {
    try {
      if (count++ > 1000) {
        return "fail";
      }
      var request = http.Request("POST", Uri.parse(ip));
      request.headers["Content-Type"] = "application/json";
      request.headers["Cache-Control"] = "no-cache";
      request.headers["Accept"] = "text/event-stream";
      request.body = jsonData;
      // wait for the response
      http.StreamedResponse response = await httpClient.send(request);
      response.stream.listen((data) {
        result = utf8.decode(data);
      }, onError: (e, s) {});
      success = true;
    } catch (e) {
      print("sendToServer : " + e.toString());
    }
  }
  return result;
}

void openCashDrawer() async {
  PaperSize paper = PaperSize.mm80;
  CapabilityProfile profile = await CapabilityProfile.load();
  NetworkPrinter printer = NetworkPrinter(paper, profile);

  try {
    PosPrintResult res = await printer.connect(printerCashierIpAddress,
        port: printerCashierIpPort);
    if (res == PosPrintResult.success) {
      printer.drawer();
      printer.disconnect();
    }
  } catch (e) {
    print(e);
  }
}
