import 'package:auto_route/auto_route.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginByEmployeePage extends StatefulWidget {
  const LoginByEmployeePage({Key? key}) : super(key: key);

  @override
  _LoginByEmployeeState createState() => _LoginByEmployeeState();
}

class _LoginByEmployeeState extends State<LoginByEmployeePage> {
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสพนักงาน',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสผ่าน',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // check login
                        context.router.pushAndPopUntil(const MenuRoute(),
                            predicate: (route) => false);
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
