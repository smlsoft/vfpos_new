import 'package:auto_size_text/auto_size_text.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/db/printer_helper.dart';
import 'package:dedepos/model/json/print_queue_model.dart';
import 'package:dedepos/model/json/receive_money_model.dart';
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/model/system/printer_model.dart';
import 'package:dedepos/pos_screen/pos_screen.dart';
import 'package:dedepos/util/pos_compile_process.dart';
import 'package:dedepos/util/select_language_screen.dart';
import 'package:dedepos/services/printer_config.dart';
import 'package:dedepos/util/network.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:dedepos/util/network.dart' as network;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Widget> menuListProduct = [];
  TextEditingController receiveAmount = TextEditingController();
  TextEditingController empCode = TextEditingController();
  TextEditingController userCode = TextEditingController();
  TextEditingController password = TextEditingController();

  var appBarHeight = AppBar().preferredSize.height;

  Widget menuItem(
      {required IconData icon,
      required String title,
      required Function callBack}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          callBack();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 30,
              color: const Color(0xFFF56045),
            ),
            AutoSizeText(
              global.language(title),
              textAlign: TextAlign.center,
              // overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    List<PrinterObjectBoxStruct> printers = (PrinterHelper()).selectAll();
    global.printerList.clear();
    for (var printer in printers) {
      PrinterModel newPrinter = PrinterModel(
          guidfixed: printer.guid_fixed,
          printer_ip_address: printer.print_ip_address,
          printer_port: printer.printer_port,
          code: printer.code,
          name: printer.name1,
          printer_type: printer.type);
      global.printerList.add(newPrinter);
    }

    try {
      global.userLanguage = GetStorage().read("language");
    } catch (_) {
      global.userLanguage = "en";
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    menuListProduct.add(
      menuItem(
          icon: Icons.point_of_sale,
          title: 'pos_screen',
          callBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PosScreen(),
              ),
            );
          }),
    );
    menuListProduct.add(menuItem(
        icon: Icons.list_alt_outlined,
        title: 'พิมพ์ใบกำกับภาษี(แบบเต็ม)',
        callBack: () {}));
    menuListProduct.add(menuItem(
        icon: Icons.list_alt_outlined,
        title: 'พิมพ์สำเนาใบเสร็จ',
        callBack: () {}));
    menuListProduct.add(menuItem(
        icon: Icons.list_alt_outlined,
        title: 'ยกเลิกใบเสร็จ',
        callBack: () {}));
    menuListProduct.add(menuItem(
        icon: Icons.list_alt_outlined, title: 'คืนสินค้า', callBack: () {}));
    menuListProduct.add(menuItem(
        icon: Icons.request_quote,
        title: 'รับเงินทอน',
        callBack: () {
          receiveMoneyDialog();
        }));
    menuListProduct.add(menuItem(
        icon: Icons.list_alt_outlined,
        title: 'ส่งยอดขาย',
        callBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container() /*SendMoney()*/,
            ),
          );
        }));
    syncBillProcess();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget infoWidget = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  posLoginDialog();
                },
                child: (global.userLoginCode.isEmpty)
                    ? Row(children: const [
                        Icon(
                          Icons.key,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Login",
                          overflow: TextOverflow.clip,
                        ),
                      ])
                    : Row(children: [
                        const Icon(
                          Icons.verified_user,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${global.userLoginCode} : ${global.userLoginName}",
                          overflow: TextOverflow.clip,
                        ),
                      ])),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    global.userLoginCode = "";
                    global.userLoginName = "";
                  });
                },
                child: const Icon(Icons.logout)),
          ],
        ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                  "${global.language('dashboard')} : ${(global.appMode == global.AppModeEnum.posCashierTerminal) ? global.language("pos_terminal") : global.language("pos_client")}"),
              actions: [
                IconButton(
                  icon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Image.asset(
                          'assets/flags/${global.userLanguage}.png')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectLanguageScreen()),
                    );
                  },
                ),
                PopupMenuButton(
                  elevation: 2,
                  icon: const Icon(Icons.more_vert),
                  offset: Offset(0.0, appBarHeight),
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrinterConfigScreen(),
                        ),
                      );
                    }
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  itemBuilder: (ctx) => [
                    buildPopupMenuItem(
                      title: global.language('printer_config'),
                      valueCode: 1,
                      iconData: Icons.print_rounded,
                    ),
                    buildPopupMenuItem(
                      title: global.language('logout'),
                      valueCode: 9,
                      iconData: Icons.logout,
                    ),
                  ],
                )
              ]),
          resizeToAvoidBottomInset: false,
          body: (global.userLoginCode.isEmpty)
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.25), BlendMode.dstATop),
                      image: const AssetImage('assets/images/login.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 10,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                posLoginDialog();
                              },
                              child: Text(
                                global.language("login"),
                                overflow: TextOverflow.clip,
                              ),
                            )),
                      )))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      infoWidget,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: menuListProduct.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return menuListProduct[index];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  PopupMenuItem buildPopupMenuItem(
      {required String title,
      required IconData iconData,
      required int valueCode}) {
    return PopupMenuItem(
      value: valueCode,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
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

  void posLoginDialog() {
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    constraints: const BoxConstraints(maxWidth: 500),
                    width: (MediaQuery.of(context).size.width / 100) * 40,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            global.language("login"),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: true,
                            controller: userCode,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.person),
                              hintText: global.language('emp_code'),
                              labelText: global.language('emp_code'),
                            ),
                            readOnly: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: password,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.password),
                              hintText: global.language('password'),
                              labelText: global.language('password'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade600),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(global.language("cancel")),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(global.language("login")),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void showMsgDialog(
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
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  receiveMoneyDialog() {
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
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "receive_money",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: empCode,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'Emp Code',
                                        labelText: 'พนักงาน',
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
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.money),
                                        hintText: 'จำนวนเงิน',
                                        labelText: 'เงินทอน',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.amber.shade600),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("ยกเลิก"),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green.shade600),
                                          onPressed: () async {
                                            String docNumber =
                                                const Uuid().v4();
                                            /*ReceiveMoneyHelper
                                                _receiveMoneyHelper =
                                                ReceiveMoneyHelper();
                                            _receiveMoneyHelper.insert(
                                                ReceiveMoneyStruct(
                                                    doc_number: docNumber,
                                                    person_code: emp_code.text,
                                                    create_date_time:
                                                        DateTime.now(),
                                                    receive_money: double.parse(
                                                        receiveAmount.text)));

                                            await PrintQueueHelper().insert(
                                                PrintQueueStruct(
                                                    code: 3,
                                                    doc_number: docNumber,
                                                    printer_code: global
                                                        .cashierPrinterCode));*/
                                            global.printQueueStartServer();
                                            processEvent();

                                            Navigator.of(context).pop();

                                            global.playSound(
                                                word: "รับเงินทอน จำนวน " +
                                                    receiveAmount.text +
                                                    " " +
                                                    global.language(
                                                        "money_symbol"));

                                            showMsgDialog(
                                                header: "บันทึกสำเร็จ",
                                                msg: "รับเงินทอน จำนวน " +
                                                    receiveAmount.text +
                                                    " " +
                                                    global.language(
                                                        "money_symbol"),
                                                type: "success");
                                          },
                                          child: const Text("บันทึก"),
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
                                      SizedBox(
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
                                      SizedBox(
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
                                      SizedBox(
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
                                      SizedBox(
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

  void processEvent() async {
    print("processEvent()");
  }
}
