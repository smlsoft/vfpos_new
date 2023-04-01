import 'dart:isolate';
import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/api/api_repository.dart';
import 'package:dedepos/db/product_category_helper.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/api/sync/model/employee_model.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/api/sync/model/sync_inventory_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/model/json/pagination_model.dart';
import 'package:dedepos/api/sync/model/zone_model.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/api/sync/sync_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as xpath;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global.dart' as global;
import 'services/device.dart';
import 'package:dedepos/model/system/printer_model.dart';
import 'package:dedepos/model/objectbox/config_struct.dart';
import 'package:dedepos/api/sync/model/promotion_model.dart';
import 'package:dedepos/api/user_repository.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/util/network.dart' as network;
import 'dart:developer' as dev;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Timer? timerSwitchToMenu;

  void init() async {
    /*await global.appStorage.remove(global.syncPrinterTimeName);
    await global.appStorage.remove(global.syncCategoryTimeName);
    await global.appStorage.remove(global.syncInventoryTimeName);
    await global.appStorage.remove(global.syncMemberTimeName);
    await global.appStorage.remove(global.syncEmployeeTimeName);
    await global.appStorage.remove(global.syncTableTimeName);
    await global.appStorage.remove(global.syncTableZoneTimeName);
    await global.appStorage.remove(global.syncDeviceTimeName);*/

    if (global.appMode == global.AppModeEnum.posClient) {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('/client');
      });
    } else {
      timerSwitchToMenu =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (global.loginSuccess && global.syncDataSuccess) {
          Navigator.of(context).pushReplacementNamed('/menu');
        }
        setState(() {});
      });
      syncMasterProcess();
    }
  }

  @override
  void dispose() {
    timerSwitchToMenu?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(global.language("sync_data")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
