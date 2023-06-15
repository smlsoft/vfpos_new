import 'package:auto_route/auto_route.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(global.language("select_language")),
            ),
            body: Container(
              padding: const EdgeInsets.all(4),
              color: Colors.white,
              child: ListView.builder(
                  itemCount: global.countryNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(2),
                        child: ElevatedButton(
                            onPressed: () async {
                              global.userScreenLanguage =
                                  global.countryCodes[index];
                              await GetStorage()
                                  .write('language', global.userScreenLanguage)
                                  .then((value) {
                                global
                                    .languageSelect(global.userScreenLanguage);
                                context.router.pushAndPopUntil(
                                    const MenuRoute(),
                                    predicate: (route) => false);
                              });
                            },
                            child: Row(children: [
                              Image.asset(
                                'assets/flags/${global.countryCodes[index]}.png',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(width: 10),
                              Text(global.countryNames[index])
                            ])));
                  }),
            ),
          ),
        ));
  }
}
