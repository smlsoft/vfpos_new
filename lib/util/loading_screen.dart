import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:dedepos/api/sync/master/sync_master.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/util/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? timerSwitchToMenu;

  void init() async {
    if (global.appMode == global.AppModeEnum.posRemote) {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('client');
      });
    } else {
      timerSwitchToMenu =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (global.loginSuccess && global.syncDataSuccess) {
          if (mounted) {
            context.router.pushAndPopUntil(const MenuRoute(),
                predicate: (route) => false);
          }
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
                Text("Data Synchronization"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
