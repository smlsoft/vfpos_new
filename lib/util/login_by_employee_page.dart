import 'package:auto_route/auto_route.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/util/loading_screen.dart';
import 'package:dedepos/util/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

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

  @override
  void initState() {
    super.initState();
    global.loginSuccess = false;
    global.syncDataSuccess = false;
    userController.text = 'admin';
    passwordController.text = '1234';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(global.language("sign_in")),
              actions: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('ลงทะเบียนเครื่องใหม่'),
                              content: const Text(
                                  'ต้องการลงทะเบียนเครื่องใหม่ เพื่อใช้กับฐานข้อมูลอื่นๆ'),
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
                                    context.router.pushAndPopUntil(
                                        const RegisterPosTerminalRoute(),
                                        predicate: (route) => false);
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
                      child: Image.asset(
                          'assets/flags/${global.userScreenLanguage}.png')),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectLanguageScreen(),
                      ),
                    );
                    setState(() {});
                  },
                ),
              ],
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                global.getNameFromLanguage(
                                    global.profileSetting.company.names,
                                    global.userScreenLanguage),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            TextFormField(
                              autofocus: true,
                              controller: userController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: obscureVisible,
                              controller: passwordController,
                              decoration: InputDecoration(
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
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  global.userLoginCode = userController.text;
                                  global.userLoginName = 'ทดสอบ';
                                  global.loginSuccess = true;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoadingScreen()),
                                  );
                                },
                                child: Text(global.language("sign_in")),
                              ),
                            )
                          ]),
                    )))));
  }
}
