import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      if (global.initSuccess) {
        Navigator.of(context).pushReplacementNamed('/select_mode');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    global.getDeviceModel(context);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body:
                  Center(child: Image(image: AssetImage('assets/icon.png'))))),
    );
  }
}
