import 'package:dedepos/global.dart' as global;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PosConnectClient extends StatefulWidget {
  const PosConnectClient({Key? key}) : super(key: key);

  @override
  _PosConnectClientState createState() => _PosConnectClientState();
}

class _PosConnectClientState extends State<PosConnectClient> {
  late Timer timerSwitchToMenu;

  @override
  void initState() {
    super.initState();
    timerSwitchToMenu =
        Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      print("timerSwitchToMenu xxxxx");
    });
  }

  @override
  void dispose() {
    timerSwitchToMenu.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(global.language("pos_hold_bill")),
          backgroundColor: global.posTheme.background,
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(
            height: 25,
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset:
                          Offset(1.0, 1.0), // shadow direction: bottom right
                    )
                  ],
                  border: Border.all(color: Colors.grey, width: 1)),
              width: 150,
              height: 150,
              child: QrImage(
                  data: "${global.deviceId},0", version: QrVersions.auto)),
          const SizedBox(
            height: 25,
          ),
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blue,
            size: 50,
          ),
        ])));
  }
}
