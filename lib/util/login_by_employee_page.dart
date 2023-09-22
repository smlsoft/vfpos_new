import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/util/loading_screen.dart';
import 'package:dedepos/util/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginByEmployeePage extends StatefulWidget {
  const LoginByEmployeePage({Key? key}) : super(key: key);

  @override
  _LoginByEmployeeState createState() => _LoginByEmployeeState();
}

class _LoginByEmployeeState extends State<LoginByEmployeePage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureVisible = true;
  String lastStatus = "";

  @override
  void initState() {
    super.initState();
    global.loginSuccess = false;
    global.syncDataSuccess = false;
    userController.text = '001';
    passwordController.text = '12345';
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is AuthenticationInitialState) {
          context.router.pushAndPopUntil(const AuthenticationRoute(), predicate: (route) => false);
        }
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("${global.language("sign_in")} ${global.applicationName} ${global.getAppversion()}"),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('ลงทะเบียนเครื่องใหม่'),
                                content: const Text('ต้องการลงทะเบียนเครื่องใหม่ เพื่อใช้กับฐานข้อมูลอื่นๆ'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ไม่ต้องการ'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.read<AuthenticationBloc>().add(const UserLogoutEvent());
                                    },
                                    child: const Text('ต้องการ'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.settings)),
                  IconButton(
                    icon: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Image.asset('assets/flags/${global.userScreenLanguage}.png')),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectLanguageScreen(),
                          ));
                      setState(() {});
                    },
                  ),
                ],
              ),
              body: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                          margin: const EdgeInsets.all(5),
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
                          child: SingleChildScrollView(
                            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Row(
                                children: [
                                  if (File(global.getShopLogoPathName()).existsSync())
                                    Image.file(
                                      File(global.getShopLogoPathName()),
                                      width: 50,
                                      height: 50,
                                    ),
                                  Expanded(
                                    child: Text(global.getNameFromLanguage(global.profileSetting.company.names, global.userScreenLanguage),
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ),
                                  if (MediaQuery.of(context).size.width > 600) const Spacer(),
                                  if (MediaQuery.of(context).size.width > 600)
                                    ElevatedButton(
                                      onPressed: () async {
                                        // ตรวจสอบ User,Password
                                        var employee = global.employeeHelper.selectByCode(code: userController.text);
                                        if (employee != null) {
                                          if (employee.pin_code == passwordController.text && employee.is_use_pos == false) {
                                            if (employee.pin_code == "123456") {
                                              // บังคับให้เปลี่ยนรหัสผ่าน
                                              global.userLogin = employee;
                                              await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('ต้องเปลี่ยนรหัสผ่าน'),
                                                      content: const Text('เนื่องจากรหัสผ่านเป็นรหัสเริ่มต้น กรุณาเปลี่ยนรหัสผ่านใหม่'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            context.router.pushAndPopUntil(const EmployeeChangePasswordRoute(), predicate: (route) => false);
                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              global.userLogin = employee;
                                              global.loginSuccess = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const LoadingScreen()),
                                              );
                                            }
                                          } else {
                                            setState(() {
                                              lastStatus = global.language("user_name_or_password_incorrect");
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            lastStatus = global.language("user_name_or_password_incorrect");
                                          });
                                        }
                                      },
                                      child: Text(global.language("sign_in")),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                autofocus: true,
                                controller: userController,
                                decoration: InputDecoration(
                                  labelText: global.language("user_code"),
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                obscureText: obscureVisible,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: global.language("user_password"),
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscureVisible = !obscureVisible;
                                        });
                                      },
                                      icon: const Icon(Icons.visibility)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (MediaQuery.of(context).size.width <= 600)
                                ElevatedButton(
                                  onPressed: () async {
                                    // ตรวจสอบ User,Password
                                    var employee = global.employeeHelper.selectByCode(code: userController.text);
                                    if (employee != null) {
                                      if (employee.pin_code == passwordController.text && employee.is_use_pos == false) {
                                        if (employee.pin_code == "123456") {
                                          // บังคับให้เปลี่ยนรหัสผ่าน
                                          global.userLogin = employee;
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('ต้องเปลี่ยนรหัสผ่าน'),
                                                  content: const Text('เนื่องจากรหัสผ่านเป็นรหัสเริ่มต้น กรุณาเปลี่ยนรหัสผ่านใหม่'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        context.router.pushAndPopUntil(const EmployeeChangePasswordRoute(), predicate: (route) => false);
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        } else {
                                          global.userLogin = employee;
                                          global.loginSuccess = true;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LoadingScreen()),
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          lastStatus = global.language("user_name_or_password_incorrect");
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        lastStatus = global.language("user_name_or_password_incorrect");
                                      });
                                    }
                                  },
                                  child: Text(global.language("sign_in")),
                                ),
                              Text(
                                lastStatus,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ]),
                          )))))),
    );
  }
}
