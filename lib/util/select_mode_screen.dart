import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

class SelectModeScreen extends StatefulWidget {
  const SelectModeScreen({Key? key}) : super(key: key);

  @override
  State<SelectModeScreen> createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              global.appMode = global.AppModeEnum.posTerminal;
                              Navigator.of(context)
                                  .pushReplacementNamed('login');
                            },
                            child: Text(global.language('pos_terminal'))),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              global.appMode = global.AppModeEnum.posRemote;
                              Navigator.of(context)
                                  .pushReplacementNamed('client');
                            },
                            child: Text(global.language('pos_remote'))),
                      ],
                    ))))));
  }
}
