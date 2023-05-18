import 'package:auto_route/auto_route.dart';
import 'package:dedepos/api/sync/master/sync_master.dart';
import 'package:dedepos/core/objectbox.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_screen.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:loading_animation_widget/loading_animation_widget.dart';

@RoutePage()
class InitShopScreen extends StatefulWidget {
  const InitShopScreen({super.key});

  @override
  State<InitShopScreen> createState() => _InitShopScreenState();
}

class _InitShopScreenState extends State<InitShopScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      preparePosScreen().then((_) {
        if (global.appMode == global.AppModeEnum.posRemote) {
          Navigator.of(context).pushReplacementNamed('client');
        } else {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const PosScreen(
          //         posScreenMode: global.PosScreenModeEnum.posSale),
          //   ),
          // );
          context.router.pushAndPopUntil(const DashboardRoute(),
              predicate: (route) => false);
        }
      });
    });
  }

  /// เตรียมข้อมูล
  Future<void> preparePosScreen() async {
    await global.startLoading();
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
                Text(global.language("sync_data")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}