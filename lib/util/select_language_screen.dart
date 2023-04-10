import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:get_storage/get_storage.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  List<String> countryNames = [
    "English",
    "Thai",
    "Laos",
    "Chinese",
    "Japan",
    "Korea"
  ];
  List<String> countryCodes = ["en", "th", "lo", "ch", "jp", "kr"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                        itemCount: countryNames.length,
                        itemBuilder: (xcontext, index) {
                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            title: Row(children: [
                              Image.asset(
                                'assets/flags/${countryCodes[index]}.png',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(width: 10),
                              Text(countryNames[index])
                            ]),
                            onTap: () {
                              setState(() {
                                global.userLanguage = countryCodes[index];
                                GetStorage()
                                    .write('language', global.userLanguage);
                                Navigator.of(context)
                                    .pushReplacementNamed('menu');
                              });
                            },
                          );
                        })))),
      ),
    );
  }
}
