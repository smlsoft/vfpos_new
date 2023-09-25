import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/util/loading_screen.dart';
import 'package:dedepos/util/login_by_employee_page.dart';
import 'package:dedepos/util/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

@RoutePage()
class EmployeeChangePasswordPage extends StatefulWidget {
  const EmployeeChangePasswordPage({Key? key}) : super(key: key);

  @override
  _EmployeeChangePasswordState createState() => _EmployeeChangePasswordState();
}

class _EmployeeChangePasswordState extends State<EmployeeChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newFirstPasswordController = TextEditingController();
  TextEditingController newSecondPasswordController = TextEditingController();
  String lastStatus = "";

  @override
  void initState() {
    super.initState();
    oldPasswordController.text = '';
    newFirstPasswordController.text = '';
    newSecondPasswordController.text = '';
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newFirstPasswordController.dispose();
    newSecondPasswordController.dispose();
    super.dispose();
  }

  void changePassword() {
    oldPasswordController.text = oldPasswordController.text.trim();
    newFirstPasswordController.text = newFirstPasswordController.text.trim();
    newSecondPasswordController.text = newSecondPasswordController.text.trim();
    print(global.userLogin!.pin_code);
    if (oldPasswordController.text != global.userLogin!.pin_code) {
      setState(() {
        lastStatus = global.language("old_password_not_match");
      });
      return;
    } else if (newFirstPasswordController.text != newSecondPasswordController.text) {
      setState(() {
        lastStatus = global.language("new_password_not_match");
      });
      return;
    } else {
      ApiRepository apiRepository = ApiRepository();
      apiRepository.userChangePassword(global.userLogin!.code, newFirstPasswordController.text).then((result) {
        if (result == true) {
          global.loadConfig();
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginByEmployeePage()),
            );
          }
        } else {
          setState(() {
            lastStatus = global.language("change_password_fail");
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.red[100],
            appBar: AppBar(
              title: Text("${global.language("change_password")} ${global.applicationName}"),
            ),
            body: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                        if (File(global.getShopLogoPathName()).existsSync())
                          Image.file(
                            File(global.getShopLogoPathName()),
                            width: 100,
                            height: 100,
                          ),
                        Text(global.getNameFromLanguage(global.profileSetting.company.names, global.userScreenLanguage),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          controller: oldPasswordController,
                          decoration: InputDecoration(
                            labelText: global.language("old_password"),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: newFirstPasswordController,
                          decoration: InputDecoration(
                            labelText: global.language("new_password"),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: newSecondPasswordController,
                          decoration: InputDecoration(
                            labelText: global.language("new_password_confirm"),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lastStatus,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              changePassword();
                            },
                            child: Text(global.language("change_password")),
                          ),
                        ),
                      ]),
                    )))));
  }
}
