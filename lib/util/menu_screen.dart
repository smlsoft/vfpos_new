import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/db/buffet_mode_helper.dart';
import 'package:dedepos/features/dashboard/presentation/widgets/dashboard_menu_item.dart';
import 'package:dedepos/features/dashboard/presentation/widgets/top_bar_shop.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_bill_vat.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_cancel_bill.dart';
import 'package:dedepos/flavors.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_screen.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/services/printer_config.dart';
import 'package:dedepos/util/connect_staff_client.dart';
import 'package:dedepos/util/employee_change_password_page.dart';
import 'package:dedepos/util/register_pos_terminal.dart';
import 'package:dedepos/util/select_language_screen.dart';
import 'package:dedepos/util/shift_and_money.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_shadow/simple_shadow.dart';

@RoutePage()
class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  ApiRepository apiRepository = ApiRepository();
  List<Widget> menuPosList = [];
  List<Widget> menuShiftList = [];
  List<Widget> menuVisitList = [];
  List<Widget> menuUtilList = [];
  TextEditingController receiveAmount = TextEditingController();
  TextEditingController empCode = TextEditingController();
  TextEditingController userCode = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loadConfigSuccess = false;
  var appBarHeight = AppBar().preferredSize.height;

  List<Widget> menuForVisit() {
    return [
      menuItem(icon: Icons.list_alt_outlined, title: 'กำหนดพิกัด GPS', callBack: () {}),
      menuItem(icon: Icons.list_alt_outlined, title: 'ถ่ายรูปหน้าร้าน', callBack: () {}),
      menuItem(icon: Icons.list_alt_outlined, title: 'ถ่ายรูปสินค้า', callBack: () {}),
    ];
  }

  List<Widget> menuPos() {
    return [
      ItemMenuDashboard(
        icon: Icons.point_of_sale,
        title: 'POS',
        callBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PosScreen(posScreenMode: global.PosScreenModeEnum.posSale),
            ),
          );
        },
      ),
      ItemMenuDashboard(
        icon: Icons.payments,
        title: global.language("open_shift"), // 'รับเงินทอน',
        callBack: () {
          showDialogShiftAndMoney(1);
        },
      ),
      ItemMenuDashboard(
        icon: Icons.attach_money_sharp,
        title: global.language("close_shift"), //'คืนสินค้า',
        callBack: () {
          showDialogShiftAndMoney(2);
        },
      ),
      ItemMenuDashboard(
        icon: Icons.print,
        title: global.language("full_bill_vat"), // 'พิมพ์สำเนาใบเสร็จ',
        callBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PosBillVatScreen(posScreenMode: global.PosScreenModeEnum.posSale),
            ),
          );
        },
      ),
      ItemMenuDashboard(
        icon: Icons.cancel,
        title: global.language("cancel_bill"), // 'พิมพ์สำเนาใบเสร็จ',
        callBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PosCancelBillScreen(
                posScreenMode: global.PosScreenModeEnum.posSale,
              ),
            ),
          );
        },
      ),
      ItemMenuDashboard(
        icon: Icons.repeat_rounded,
        title: global.language("pos_return_screen"), // 'พิมพ์สำเนาใบเสร็จ',
        callBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PosScreen(posScreenMode: global.PosScreenModeEnum.posReturn),
            ),
          );
        },
      ),
      ItemMenuDashboard(
        icon: Icons.print_rounded,
        title: global.language("printer_config"), // 'พิมพ์สำเนาใบเสร็จ',
        callBack: () async {
          await global.loadPrinter();
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrinterConfigScreen(),
              ),
            ).then((value) async => {await global.loadPrinter()});
          }
        },
      ),
      ItemMenuDashboard(
        icon: Icons.logout,
        title: global.language("logout"), // 'ออกจากระบบ',
        callBack: () {
          global.loginSuccess = false;
          global.userLogin = null;
          if (mounted) {
            context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
          }
        },
      ),
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
              content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return shiftAndMoneyScreen(mode: mode);
              }));
        });
  }

  List<Widget> menuShift() {
    return [
      menuItem(
          iconImage: Image.asset('assets/icons/cashier.png'),
          title: global.language("open_shift"), // 'เปิดกะ/รับเงินทอน',
          callBack: () {
            showDialogShiftAndMoney(1);
          }),
      // menuItem(
      //     iconImage: Image.asset('assets/icons/deposit.png'),
      //     title: global.language("add_change_money"), // 'รับเงินทอนเพิ่ม',
      //     callBack: () {
      //       showDialogShiftAndMoney(3);
      //     }),
      // menuItem(
      //     iconImage: Image.asset('assets/icons/cash-withdrawal.png'),
      //     title: global.language("withdraw_money"), // 'นำเงินออก',
      //     callBack: () {
      //       showDialogShiftAndMoney(4);
      //     }),
      menuItem(
          iconImage: Image.asset('assets/icons/safe.png'),
          title: global.language("close_shift"), // 'ปิดกะ/ส่งเงิน',
          callBack: () {
            showDialogShiftAndMoney(2);
          }),
    ];
  }

  List<Widget> menuUtil() {
    return [
      menuItem(
          iconImage: Image.asset('assets/icons/smartphone.png'),
          title: global.language("connect_staff_client"), // 'เชื่อมต่อเครื่องพนักงาน',
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

  Widget menuItem({IconData? icon, Image? iconImage, required String title, Color color = Colors.white, required Function callBack}) {
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
          Expanded(
              child: (icon != null)
                  ? Icon(
                      icon,
                      size: 30,
                      color: const Color(0xFFF56045),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: SimpleShadow(
                        opacity: 0.5,
                        color: Colors.black,
                        offset: const Offset(2, 2),
                        sigma: 2,
                        child: iconImage!,
                      ))),
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
    if (F.appFlavor == Flavor.SMLMOBILESALES) {
      menuVisitList = menuForVisit();
    }
  }

  @override
  void initState() {
    super.initState();
    rebuildScreen();
    syncBillProcess();
    global.buffetModeLists = BuffetModeHelper().getAll();
    global.getProfile().then((value) {
      loadConfigSuccess = true;
    });
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
              (global.userLogin!.code.isEmpty)
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
                      (global.userLogin!.profile_picture.isNotEmpty)
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 2),
                              ),
                              child: Image.network(
                                global.userLogin!.profile_picture,
                                height: 30,
                              ))
                          : Container(),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.verified_user,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "ผู้ใช้งาน : ${global.userLogin!.name} (${global.userLogin!.code})",
                        overflow: TextOverflow.clip,
                      ),
                    ]),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    global.loginSuccess = false;
                    global.userLogin = null;
                    if (mounted) {
                      context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
                    }
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
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [Text(global.deviceId), const Spacer(), Text(global.deviceName)])),
    ]);

    String companyName = "";

    companyName = global.getNameFromLanguage(global.profileSetting.company.names, global.userScreenLanguage);
    if (global.profileSetting.company.branchNames.isNotEmpty) {
      if (global.getNameFromLanguage(global.profileSetting.company.branchNames, global.userScreenLanguage) != '') {
        companyName += " : ${global.getNameFromLanguage(global.profileSetting.company.branchNames, global.userScreenLanguage)}";
      }
    }
    companyName += global.getAppversion();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xFF005CBF),
            elevation: 0.0,
            foregroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(5),
              child: ((global.getShopLogoPathName().isNotEmpty) && (File(global.getShopLogoPathName()).existsSync()))
                  ? Image.file(
                      File(global.getShopLogoPathName()),
                    )
                  : Container(),
            ),
            title: Text((global.appMode == global.AppModeEnum.posTerminal) ? "${global.language("pos_terminal")}" : "${global.language("pos_remote")} : $companyName"),
            actions: [
              PopupMenuButton(
                elevation: 2,
                icon: const Icon(Icons.more_vert),
                offset: Offset(0.0, appBarHeight),
                onSelected: (value) async {
                  switch (value) {
                    case 1:
                      // ตั้งค่าเครื่องพิมพ์
                      await global.loadPrinter();
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrinterConfigScreen(),
                          ),
                        ).then((value) async => {await global.loadPrinter()});
                      }
                      break;
                    case 3:
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmployeeChangePasswordPage(),
                          ),
                        ).then((value) async => {await global.loadPrinter()});
                      }
                      break;
                    case 9:
                      global.loginSuccess = false;
                      global.userLogin = null;
                      if (mounted) {
                        context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
                      }
                      break;
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
                    title: global.language('change_password'),
                    valueCode: 3,
                    iconData: Icons.lock,
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
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: () async {},
        //     backgroundColor: Colors.green,
        //     icon: const Icon(
        //       Icons.web_asset,
        //       color: Colors.white,
        //       shadows: [
        //         Shadow(
        //           offset: Offset(1.0, 1.0),
        //           blurRadius: 3.0,
        //           color: Colors.black,
        //         )
        //       ],
        //     ),
        //     label: Text(global.applicationName,
        //         style: const TextStyle(shadows: <Shadow>[
        //           Shadow(
        //             offset: Offset(1.0, 1.0),
        //             blurRadius: 3.0,
        //             color: Colors.black,
        //           )
        //         ], fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))),
        body: (global.isPhoneDevice())
            ? Column(children: [
                const TopBarShop(height: 280),
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
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return menuPosList[index];
                              },
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: SizedBox(
                        //     child: GridView.builder(
                        //       shrinkWrap: true,
                        //       physics: const BouncingScrollPhysics(),
                        //       itemCount: menuShiftList.length,
                        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                        //         crossAxisSpacing: 5.0,
                        //         mainAxisSpacing: 5.0,
                        //       ),
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return menuShiftList[index];
                        //       },
                        //     ),
                        //   ),
                        // ),
                        if (menuVisitList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: menuVisitList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return menuVisitList[index];
                                },
                              ),
                            ),
                          ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: SizedBox(
                        //     child: GridView.builder(
                        //       shrinkWrap: true,
                        //       physics: const BouncingScrollPhysics(),
                        //       itemCount: menuUtilList.length,
                        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                        //         crossAxisSpacing: 5.0,
                        //         mainAxisSpacing: 5.0,
                        //       ),
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return menuUtilList[index];
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ])
            : SingleChildScrollView(
                child: Column(children: [
                const TopBarShop(height: 250),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.point_of_sale,
                            title: 'POS',
                            callBack: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PosScreen(posScreenMode: global.PosScreenModeEnum.posSale),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ItemMenuDashboard(
                              icon: Icons.payments,
                              title: global.language("open_shift"), // 'รับเงินทอน',
                              callBack: () {
                                showDialogShiftAndMoney(1);
                              },
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.attach_money_sharp,
                            title: global.language("close_shift"), //'คืนสินค้า',
                            callBack: () {
                              showDialogShiftAndMoney(2);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.print,
                            title: global.language("full_bill_vat"), // 'พิมพ์สำเนาใบเสร็จ',
                            callBack: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PosBillVatScreen(posScreenMode: global.PosScreenModeEnum.mainMenu),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.cancel,
                            title: global.language("cancel_bill"), // 'พิมพ์สำเนาใบเสร็จ',
                            callBack: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PosCancelBillScreen(
                                    posScreenMode: global.PosScreenModeEnum.posSale,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.repeat_rounded,
                            title: global.language("pos_return_screen"), // 'พิมพ์สำเนาใบเสร็จ',
                            callBack: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PosScreen(posScreenMode: global.PosScreenModeEnum.posReturn),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.print_rounded,
                            title: global.language("printer_config"), // 'พิมพ์สำเนาใบเสร็จ',
                            callBack: () async {
                              await global.loadPrinter();
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrinterConfigScreen(),
                                  ),
                                ).then((value) async => {await global.loadPrinter()});
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ItemMenuDashboard(
                            icon: Icons.logout,
                            title: global.language("logout"), // 'ออกจากระบบ',
                            callBack: () {
                              global.loginSuccess = false;
                              global.userLogin = null;
                              if (mounted) {
                                context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ])),
      ),
    );
  }

  PopupMenuItem buildPopupMenuItem({required String title, required IconData iconData, required int valueCode}) {
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
}
