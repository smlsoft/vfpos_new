import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/buffet_mode_helper.dart';
import 'package:dedepos/db/printer_helper.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/pos/restaurant/table_manager_page.dart';
import 'package:dedepos/features/receive_money/receive_money.dart';
import 'package:dedepos/flavors.dart';
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/model/system/printer_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_screen.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/services/printer_config.dart';
import 'package:dedepos/util/connect_staff_client.dart';
import 'package:dedepos/util/select_language_screen.dart';
import 'package:dedepos/util/shift_and_money.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

@RoutePage()
class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Widget> menuPosList = [];
  List<Widget> menuShiftList = [];
  List<Widget> menuVisitList = [];
  List<Widget> menuUtilList = [];
  List<Widget> menuRestaurantList = [];
  TextEditingController receiveAmount = TextEditingController();
  TextEditingController empCode = TextEditingController();
  TextEditingController userCode = TextEditingController();
  TextEditingController password = TextEditingController();

  var appBarHeight = AppBar().preferredSize.height;

  List<Widget> menuForVisit() {
    return [
      menuItem(
          icon: Icons.list_alt_outlined,
          title: 'กำหนดพิกัด GPS',
          callBack: () {}),
      menuItem(
          icon: Icons.list_alt_outlined,
          title: 'ถ่ายรูปหน้าร้าน',
          callBack: () {}),
      menuItem(
          icon: Icons.list_alt_outlined,
          title: 'ถ่ายรูปสินค้า',
          callBack: () {}),
    ];
  }

  List<Widget> menuPos() {
    return [
      menuItem(
          icon: Icons.point_of_sale,
          title: global.language("pos_screen"),
          callBack: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const PosScreen(
            //         posScreenMode: global.PosScreenModeEnum.posSale),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PosScreen(
                    posScreenMode: global.PosScreenModeEnum.posSale),
              ),
            );
          }),
      menuItem(
          icon: Icons.list_alt_outlined,
          title: global.language("pos_return_screen"), // 'รับคืนสินค้า',
          callBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PosScreen(
                    posScreenMode: global.PosScreenModeEnum.posReturn),
              ),
            );
          }),
    ];
  }

  Future<void> showDialogShiftAndMoney(int mode) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return shiftAndMoneyScreen(mode: mode);
              }));
        });
  }

  List<Widget> menuShift() {
    return [
      menuItem(
          icon: Icons.request_quote,
          title: global.language("open_shift"), // 'เปิดกะ/รับเงินทอน',
          callBack: () {
            showDialogShiftAndMoney(0);
          }),
      menuItem(
          icon: Icons.request_quote,
          title: global.language("add_change_money"), // 'รับเงินทอนเพิ่ม',
          callBack: () {
            showDialogShiftAndMoney(2);
          }),
      menuItem(
          icon: Icons.request_quote,
          title: global.language("withdraw_money"), // 'นำเงินออก',
          callBack: () {
            showDialogShiftAndMoney(3);
          }),
      menuItem(
          icon: Icons.list_alt_outlined,
          title: global.language("close_shift"), // 'ปิดกะ/ส่งเงิน',
          callBack: () {
            showDialogShiftAndMoney(1);
          }),
    ];
  }

  List<Widget> menuUtil() {
    return [
      menuItem(
          icon: Icons.request_quote,
          title: global
              .language("connect_staff_client"), // 'เชื่อมต่อเครื่องพนักงาน',
          callBack: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConnectStaffClientPage(),
              ),
            );
          }),
    ];
  }

  List<Widget> menuRestaurant() {
    return [
      menuItem(
          icon: Icons.request_quote,
          title: global.language("table_open"),
          callBack: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TableManagerPage(
                    tableManagerMode: global.TableManagerEnum.openTable),
              ),
            );
          }),
    ];
  }

  Widget menuItem(
      {required IconData icon,
      required String title,
      Color color = Colors.white,
      required Function callBack}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
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
            title,
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
    );
  }

  void rebuildScreen() {
    menuPosList = menuPos();
    menuShiftList = menuShift();
    menuUtilList = menuUtil();
    menuRestaurantList = menuRestaurant();
    if (F.appFlavor == Flavor.SMLMOBILESALES) {
      menuVisitList = menuForVisit();
    }
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
    rebuildScreen();
    syncBillProcess();
    global.buffetModeList = BuffetModeHelper().getAll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget infoWidget = Column(children: [
      Container(
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
                      ? const Row(children: [
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
                      global.loginSuccess = false;
                      global.userLoginCode = "";
                      global.userLoginName = "";
                    });
                    context
                        .read<AuthenticationBloc>()
                        .add(const UserLogoutEvent());
                  },
                  child: const Icon(Icons.logout)),
            ],
          )),
      Container(
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
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Text(global.deviceId),
            const Spacer(),
            Text(global.deviceName)
          ])),
    ]);

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationInitialState) {
          context.router.pushAndPopUntil(const AuthenticationRoute(),
              predicate: (route) => false);
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
                centerTitle: true,
                foregroundColor: Colors.white,
                title: Text(
                    "${global.language('dashboard')} : ${(global.appMode == global.AppModeEnum.posTerminal) ? global.language("pos_terminal") : global.language("pos_remote")}"),
                actions: [
                  IconButton(
                    icon: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Image.asset(
                            'assets/flags/${global.userScreenLanguage}.png')),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectLanguageScreen(),
                        ),
                      );
                      setState(() {});
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
                : Column(children: [
                    infoWidget,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: menuPosList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width ~/
                                            150,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return menuPosList[index];
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: menuShiftList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width ~/
                                            150,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return menuShiftList[index];
                                  },
                                ),
                              ),
                            ),
                            if (menuVisitList.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: menuVisitList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width ~/
                                              150,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return menuVisitList[index];
                                    },
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: menuRestaurantList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width ~/
                                            150,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return menuRestaurantList[index];
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: menuUtilList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width ~/
                                            150,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return menuUtilList[index];
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
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

  // void showMsgDialog(
  //     {required String header,
  //     required String msg,
  //     required String type}) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(header),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(msg),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('ตกลง'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void receiveMoneyDialog() {
  //   //receiveAmount.text = "";
  //   empCode.text = '${global.userLoginCode}/${global.userLoginName}';
  //   showDialog(
  //       barrierLabel: "",
  //       barrierDismissible: false,
  //       barrierColor: Colors.black.withOpacity(0.5),
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ReceiveMoneyDialog();
  //       });
  // }

  // void processEvent() async {
  //   serviceLocator<Log>().debug('processEvent()');
  // }
}
