// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/app/app.dart';
import 'package:dedepos/core/core.dart';
import 'package:dedepos/core/environment.dart';
import 'package:dedepos/core/objectbox.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/shop/shop.dart';
import 'package:dedepos/flavors.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/services/user_cache_service.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@RoutePage()
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  int logoTouch = 0;
  Color vfPrimaryColor = const Color(0xFF007BFF);

  @override
  void initState() {
    // TODO: implement initState

    resetPrefer();
    super.initState();
  }

  void resetPrefer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('pos_terminal_token', '');
    sharedPreferences.setString('pos_device_id', '');
    sharedPreferences.setString('pos_terminal_pin_code', '');

    global.posTerminalPinCode = "";
    global.posTerminalPinTokenId = "";
    global.deviceId = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(clipBehavior: Clip.antiAlias, children: [
      const BackgroundGradientWidget(),
      const BackgroundClipperWidget(),
      Center(
        child: Container(
          width: 500,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationLoadedState) {
                    objectBoxDeleteAll();
                    //context.router.push(const SelectShopRoute());
                    global.appStorage.write("apiUserName", _emailController.text);
                    global.appStorage.write("apiUserPassword", _passwordController.text);
                    global.appStorage.write("token", state.user.token);
                    global.appStorage.write("refresh", state.user.refresh);
                    global.appStorage.write("isdev", state.user.isDev);
                    // context.read<AuthenticationBloc>().add(AuthenticationEvent.authenticated(user: state.user));
                    context.router.pushAndPopUntil(const SelectShopRoute(), predicate: (route) => false);
                  } else if (state is AuthenticationAuthenticatedState) {
                    global.appStorage.write("token", state.user.token);
                    global.appStorage.write("refresh", state.user.refresh);
                    global.appStorage.write("isdev", state.user.isDev);
                    context.router.pushAndPopUntil(const InitShopRoute(), predicate: (route) => false);
                  } else if (state is AuthenticationErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is AuthenticationInitialState) {
                    serviceLocator<Log>().debug("stage change to AuthenticationInitialState");
                  }
                },
                builder: (context, state) {
                  if (state is AuthenticationLoadingState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        logo(),
                        const SizedBox(
                          height: 13.0,
                          width: 200,
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24.0),
                      InkWell(
                          onTap: () async {
                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            setState(() {
                              logoTouch = logoTouch + 1;
                              if (logoTouch >= 5) {
                                if (global.environmentVersion == "PROD") {
                                  Environment().initConfig(Environment.DEV);
                                  global.environmentVersion = "DEV";
                                  sharedPreferences.setString('pos_env_mode', 'DEV');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Develop Mode Active$logoTouch"),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                } else {
                                  Environment().initConfig(Environment.PROD);
                                  global.environmentVersion = "PROD";
                                  sharedPreferences.setString('pos_env_mode', 'PROD');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Production Mode Active"),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                                logoTouch = 0;
                              }
                            });
                          },
                          child: logo()),
                      const SizedBox(height: 64.0),
                      if (global.getAppversion() != '')
                        Container(
                            margin: const EdgeInsets.only(bottom: 3),
                            child: Text("* ${global.getAppversion().replaceAll("(", "").replaceAll(")", "")} Mode", style: const TextStyle(color: Colors.red, fontSize: 12))),
                      userTextfield(),
                      const SizedBox(height: 24.0),
                      passwordTextfield(),
                      const SizedBox(height: 24.0),
                      buttonLogin(),
                      // const SizedBox(height: 40.0),
                      // if (Platform.isIOS) buttonLoginWithApple(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      )
    ]));
  }

  Widget logo() {
    if (F.appFlavor == Flavor.VFPOS) {
      return Image.asset(
        'assets/icons/vf-pos-logo.png', // path to your image asset
        height: 150.0,
      );
    }

    return Image.asset(
      'assets/icons/dede-pos-icon.png', // path to your image asset
      height: 150.0,
    );
  }

  Widget userTextfield() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: 'ชื่อผู้ใช้งาน',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget passwordTextfield() {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(
        hintText: 'รหัสผ่าน',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      obscureText: true,
    );
  }

  Widget buttonLogin() {
    return ElevatedButton(
      onPressed: () {
        // on click
        debugPrint('on login debug  ${_emailController.text} ${_passwordController.text}');

        final userName = _emailController.text;
        final password = _passwordController.text;
        context.read<AuthenticationBloc>().add(AuthenticationEvent.onLoginWithUserPasswordTapped(userName: userName, password: password));
      },
      //icon: const Icon(Icons.person),
      //label: const Text('เข้าสู่ระบบ'),
      style: Styles.successButtonStyle(),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'เข้าสู่ระบบ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buttonLoginWithOther() {
    return ElevatedButton.icon(
      onPressed: () {
        // on click
        // context.router.push(const AuthenticationWithUserPasswordRoute());
      },
      icon: const Icon(Icons.mail_outline),
      label: const Text('Login with User/Password'),
      style: Styles.successButtonStyle(),
    );
  }

  // Widget buttonLoginWithApple() {
  //   return ElevatedButton.icon(
  //     onPressed: () {
  //       _loginWithApple(context);
  //     },
  //     icon: const Icon(Icons.mail_outline),
  //     label: const Text('Login with Apple'),
  //     style: Styles.successButtonStyle(),
  //   );
  // }

  Future<void> _loginWithApple(BuildContext context) async {
    // try {
    //   final rawNonce = generateNonce();
    //   final appleCredential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   );

    //   final oauthCredential = firebaseAuth.OAuthProvider("apple.com").credential(
    //     idToken: appleCredential.identityToken,
    //     rawNonce: rawNonce,
    //   );
    //   final authResult = await firebaseAuth.FirebaseAuth.instance.signInWithCredential(oauthCredential);
    //   String? userIdToken = await getCurrentUserIdToken();
    //   if (userIdToken != null) {
    //     context.read<AuthenticationBloc>().add(AuthenticationEvent.onLoginWithTokenTapped(token: userIdToken));
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Failed to login with Apple")),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Failed to login with Apple: $e")),
    //   );
    // }
  }

  // Future<String?> getCurrentUserIdToken() async {
  //   firebaseAuth.User? currentUser = firebaseAuth.FirebaseAuth.instance.currentUser;

  //   if (currentUser != null) {
  //     String? idToken = await currentUser.getIdToken();
  //     return idToken;
  //   } else {
  //     // No user is signed in.
  //     return null;
  //   }
  // }

  Widget buttonLoginDev() {
    return ElevatedButton.icon(
      onPressed: () {
        // on click
        // context.router.push(const AuthenticationWithUserPasswordRoute());
        // add select shop event
        // loginDev();
      },
      icon: const Icon(Icons.mail_outline),
      label: const Text('Login Auto'),
      style: Styles.successButtonStyle(),
    );
  }

  Widget loginSeparatorLine() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[horizontalLine(), Text(" ${global.language("or")} "), horizontalLine()],
      ),
    );
  }

  Widget horizontalLine() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 100,
          height: 1.0,
          color: Colors.black.withOpacity(0.6),
        ),
      );

  // void loginDev() {
  //   // authen with dev user,dev password
  //   serviceLocator<LoginUserRepository>().loginWithUserPassword(username: AppConstant.userDev, password: AppConstant.passwordDev).then((response) async {
  //     if (response.isRight()) {
  //       final remoteUser = response.getOrElse(() => User());
  //       await serviceLocator<UserCacheService>().saveUser(remoteUser);

  //       // select shop
  //       serviceLocator<ShopAuthenticationRepository>().selectShop(shopid: AppConstant.shopIdDev).then((selectShopResponse) async {
  //         if (selectShopResponse.isRight()) {
  //           global.loginSuccess = true;
  //           context.read<AuthenticationBloc>().add(AuthenticationEvent.authenticated(user: remoteUser));
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text("Auto Login Failed."),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //         }
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Auto Login Failed."),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   });
  // }
}
