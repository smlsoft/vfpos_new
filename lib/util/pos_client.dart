import 'dart:async';

import 'package:dedepos/global.dart' as global;
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/widgets/pin_numpad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PosClient extends StatefulWidget {
  const PosClient({Key? key}) : super(key: key);

  @override
  _PosClientState createState() => _PosClientState();
}

class _PosClientState extends State<PosClient> {
  late Timer findTerminalTimer;
  String posTerminalCode = 'POS01,0';
  TextEditingController posTerminalCodeController = TextEditingController();
  bool scanStart = false;

  @override
  void initState() {
    super.initState();
    findTerminalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (global.targetDeviceConnected) {
        findTerminalTimer.cancel();
        global.loginSuccess = true;
        setState(() {
          Navigator.of(context).pushReplacementNamed('/menu');
        });
      }
    });
    posTerminalCodeController.text = posTerminalCode;
  }

  @override
  void dispose() {
    findTerminalTimer.cancel();
    posTerminalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                child: Column(children: [
              TextField(
                controller: posTerminalCodeController,
              ),
              ElevatedButton(
                  onPressed: () {
                    List<String> split =
                        posTerminalCodeController.text.split(',');
                    global.scanServerByName(split[0]);
                    setState(() {
                      scanStart = true;
                    });
                  },
                  child: Text("Connect Terminal")),
              if (scanStart)
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 200,
                ),
            ]))),
      ),
    );
  }
}
