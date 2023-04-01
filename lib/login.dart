import 'dart:async';

import 'package:dedepos/widgets/pin_numpad.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      global.loginSuccess = true;
      Navigator.of(context).pushReplacementNamed('/loading');
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (global.appLoadSuccess) {}
    late Widget screenWidget;

    if (global.posVersion == global.PosVersionEnum.vfpos) {
      screenWidget = Center(
          child: Container(
              constraints: const BoxConstraints(
                  minWidth: 300, maxWidth: 500, maxHeight: 500, minHeight: 200),
              child: PinNumberPad(
                onChange: (value) {
                  if (value == "0000") {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      global.loginSuccess = true;
                      Navigator.of(context).pushReplacementNamed('/loading');
                    });
                  }
                },
                header: "PIN",
              )));
    } else {
      screenWidget = Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Image(image: AssetImage('assets/icon.png')),
          const Text("POS",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48)),
          const Text("POS",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 96)),
          ElevatedButton.icon(
              icon: const Icon(Icons.lock_open_outlined),
              label: const Text("Continue With Google Account"),
              onPressed: () {
                global.loginSuccess = true;
                Navigator.of(context).pushReplacementNamed('/loading');
              }),
        ],
      ));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(resizeToAvoidBottomInset: false, body: screenWidget)),
    );
  }
}
