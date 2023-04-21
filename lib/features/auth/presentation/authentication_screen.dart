import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});
  static const routeName = '/authentication';

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(children: [
        const Text('Authentication'),
      ])),
    );
  }
}
