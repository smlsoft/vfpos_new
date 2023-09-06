import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/api/sync/master/sync_master.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

@RoutePage()
class InitPOSScreen extends StatefulWidget {
  const InitPOSScreen({super.key});

  @override
  State<InitPOSScreen> createState() => _InitPOSScreenState();
}

class _InitPOSScreenState extends State<InitPOSScreen> {
  Timer? timerSwitchToMenu;

  void init() async {
// set global value
    await global.startLoading();

    if (global.appMode == global.AppModeEnum.posRemote) {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('client');
      });
    } else {
      timerSwitchToMenu = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (global.loginSuccess && global.syncDataSuccess) {
          context.router.replace(PosRoute(posScreenMode: global.PosScreenModeEnum.posSale));
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
    global.getDeviceModel(context);
    return SafeArea(
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
              Text("Data Synchronization"),
            ],
          ),
        ),
      ),
    );
  }
}
