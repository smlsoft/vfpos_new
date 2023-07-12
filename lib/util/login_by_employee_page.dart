import 'package:auto_route/auto_route.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/util/loading_screen.dart';
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
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    global.loginSuccess = false;
    global.syncDataSuccess = false;
    userController.text = 'admin';
    passController.text = '1234';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Login by Employee'),
            ),
            body: Center(
                child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: userController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสพนักงาน',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสผ่าน',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // check login
                        global.userLoginCode = userController.text;
                        global.userLoginName = 'ทดสอบ';
                        global.loginSuccess = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoadingScreen()),
                        );
                      },
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                    const SizedBox(height: 100),
                    Text(
                        "กรณีต้องการลงทะเบียนเครื่องใหม่ เพื่อใช้กับฐานข้อมูลใหม่"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          // check login
                          context.router.pushAndPopUntil(
                              const RegisterPosTerminalRoute(),
                              predicate: (route) => false);
                        },
                        child: const Text('ลงทะเบียนเครื่องใหม่')),
                  ]),
            ))));
  }
}
