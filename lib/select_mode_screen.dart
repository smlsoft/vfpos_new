import 'dart:convert';

import 'package:dedepos/global_model.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

class SelectModeScreen extends StatefulWidget {
  const SelectModeScreen({Key? key}) : super(key: key);

  @override
  _SelectModeScreenState createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                    width: double.infinity,
                    child: Center(
                        child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              global.appMode =
                                  global.AppModeEnum.posCashierTerminal;
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            child: Text(global.language('pos_terminal'))),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              global.appMode = global.AppModeEnum.posClient;
                              Navigator.of(context)
                                  .pushReplacementNamed('/client');
                            },
                            child: Text(global.language('pos_client'))),
                      ],
                    ))))));
  }
}
