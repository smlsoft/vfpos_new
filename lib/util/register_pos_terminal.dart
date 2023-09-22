import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dedepos/api/clickhouse/clickhouse_api.dart';
import 'package:dedepos/api/sync/model/posterminal_model.dart';
import 'package:dedepos/bloc/posterminal_bloc.dart';
import 'package:dedepos/core/objectbox.dart';
import 'package:dedepos/core/request.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/posterminal/domain/entity/posterminal.dart';
import 'package:dedepos/features/shop/shop.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:dedepos/services/user_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/environment.dart';

@RoutePage()
class RegisterPosTerminalPage extends StatefulWidget {
  const RegisterPosTerminalPage({Key? key}) : super(key: key);
  @override
  _RegisterPosTerminalPageState createState() => _RegisterPosTerminalPageState();
}

class _RegisterPosTerminalPageState extends State<RegisterPosTerminalPage> {
  // late Timer findTerminalTimer;
  // late Timer countDownTimer;
  int countdownSecond = 15;
  int countSecond = 0;

  // void findTerminalTimerStart() {
  //   findTerminalTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     if (++countSecond > 15) {
  //       // เกิน 15 วิ เริ่มตรวจสอบว่าอนุมัติหรือไม่
  //       await recheck();
  //     }
  //   });
  // }

  // void countDownTimerStart() {
  //   countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       countdownSecond--;
  //       if (countdownSecond == 0) {
  //         timer.cancel();
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();

    if (global.posTerminalPinTokenId.isNotEmpty && global.deviceId.isNotEmpty) {
      checkPinCode();
    }

    context.read<PosTerminalBloc>().add(const PosTerminalLoad());
    // countDownTimerStart();
    // findTerminalTimerStart();
  }

  Future<void> recheck() async {
    var responseData = await clickHouseSelect("SELECT status,token,deviceid,access_token,shipid,isdev FROM poscenter.pinlist WHERE pincode='${global.posTerminalPinCode}'");
    if (responseData.isNotEmpty) {
      ResponseDataModel result = ResponseDataModel.fromJson(responseData);
      if (result.data.isNotEmpty) {
        if (result.data[0]['status'] == 1) {
          global.posTerminalPinTokenId = result.data[0]['token'];
          global.deviceId = result.data[0]['deviceid'];

          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('pos_terminal_token', global.posTerminalPinTokenId);
          sharedPreferences.setString('pos_device_id', global.deviceId);

          // do authen with token
          String accessToken = result.data[0]['access_token'];
          String shopId = result.data[0]['shipid'];
          global.appStorage.write("token", accessToken);

          global.apiConnected = true;
          global.loginProcess = true;
          bool isDev = result.data[0]['isdev'] != null && result.data[0]['isdev'] == 1;
          if (isDev) {
            // Environment().initConfig("DEV");
            serviceLocator<Request>().updateEndpoint();
          } else {
            //   Environment().initConfig("PROD");
            serviceLocator<Request>().updateEndpoint();
          }
          serviceLocator<Request>().updateDioInterceptors();
          serviceLocator<Request>().updateAuthorization(accessToken);

          serviceLocator<LoginUserRepository>().profile().then((response) async {
            if (response.isRight()) {
              // save user cache
              User remoteUser = response.getOrElse(() => User());
              remoteUser = remoteUser.copyWith(token: accessToken, isDev: isDev ? 1 : 0);

              await serviceLocator<UserCacheService>().saveUser(remoteUser);
              // select shop
              serviceLocator<ShopAuthenticationRepository>().selectShop(shopid: shopId).then((selectShopResponse) async {
                if (selectShopResponse.isRight()) {
                  global.loginSuccess = true;
                  // add user autenticate bloc
                  context.read<AuthenticationBloc>().add(AuthenticationEvent.authenticated(user: remoteUser));
                  await global.getProfile();
                  if (mounted) {
                    context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed Not Selected Shop"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid Token"),
                  backgroundColor: Colors.red,
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                context.read<AuthenticationBloc>().add(const UserLogoutEvent());
              });
            }
          });
        }
      }
    }
  }

  Future<void> checkPinCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    global.posTerminalPinTokenId = sharedPreferences.getString('pos_terminal_pin_code') ?? "";
    global.deviceId = sharedPreferences.getString('pos_device_id') ?? "";
    global.posTerminalPinCode = sharedPreferences.getString('pos_terminal_pin_code') ?? "";
    // do authen with token
    String accessToken = global.appStorage.read("token").toString();
    String shopId = global.appStorage.read("cache_shopid").toString();

    global.apiConnected = true;
    global.loginProcess = true;

    serviceLocator<Request>().updateEndpoint();

    serviceLocator<Request>().updateDioInterceptors();
    serviceLocator<Request>().updateAuthorization(accessToken);

    serviceLocator<LoginUserRepository>().profile().then((response) async {
      if (response.isRight()) {
        // save user cache
        User remoteUser = response.getOrElse(() => User());
        remoteUser = remoteUser.copyWith(token: accessToken, isDev: 0);

        await serviceLocator<UserCacheService>().saveUser(remoteUser);
        // select shop
        serviceLocator<ShopAuthenticationRepository>().selectShop(shopid: shopId).then((selectShopResponse) async {
          if (selectShopResponse.isRight()) {
            global.loginSuccess = true;
            // add user autenticate bloc
            context.read<AuthenticationBloc>().add(AuthenticationEvent.authenticated(user: remoteUser));
            await global.getProfile();
            if (mounted) {
              context.router.pushAndPopUntil(const LoginByEmployeeRoute(), predicate: (route) => false);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed Not Selected Shop"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Token"),
            backgroundColor: Colors.red,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          context.read<AuthenticationBloc>().add(const UserLogoutEvent());
        });
      }
    });
  }

  Future<void> initPinCode() async {
    global.posTerminalPinCode = global.generateRandomPin(8);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('pos_terminal_pin_code', global.posTerminalPinCode);

    setState(() {});
  }

  @override
  void dispose() {
    // if (findTerminalTimer.isActive) {
    //   findTerminalTimer.cancel();
    // }
    // if (countDownTimer.isActive) {
    //   countDownTimer.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late double sizing;
    late double PD;
    late int Cros;
    if (Util.isLandscape(context)) {
      sizing = 0.8;
      PD = 20;
      Cros = 4;
    } else {
      sizing = 0.8;
      PD = 10;
      Cros = 2;
    }
    return MultiBlocListener(
        listeners: [
          BlocListener<PosTerminalBloc, PosTerminalState>(
            listener: (context, state) {
              if (state is PosSubmitSuccess) {
                recheck();
              } else if (state is PosLoadFailed) {
                initPinCode();
                context.read<PosTerminalBloc>().add(const PosTerminalLoad());
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(listener: (context, state) {
            if (state is AuthenticationInitialState) {
              context.router.pushAndPopUntil(const AuthenticationRoute(), predicate: (route) => false);
            }
          }),
        ],
        child: BlocBuilder<PosTerminalBloc, PosTerminalState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: (global.posTerminalPinCode.isNotEmpty) ? Text('ดึงข้อมูลเครื่องPOS ${global.getAppversion()}') : Text('เลือกเครื่อง POS ${global.getAppversion()}'),
                centerTitle: true,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(const UserLogoutEvent());
                      },
                      child: const Icon(Icons.logout))
                ],
              ),
              body: SafeArea(
                  child: (state is PosLoadSuccess && (global.posTerminalPinCode.isEmpty || global.posTerminalPinTokenId.isEmpty))
                      ? Padding(
                          padding: EdgeInsets.only(left: PD, right: PD, top: 20),
                          child: GridView.builder(
                              itemCount: state.posList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Cros,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 150,
                              ),
                              itemBuilder: (context, index) {
                                return cardItem(state.posList[index]);
                              }),
                        )
                      : const Center(child: CircularProgressIndicator())));
        }));
  }

  Widget cardItem(PosTerminalModel data) {
    return Card(
        elevation: 5,
        child: ListTile(
            onTap: (() async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString('pos_terminal_token', global.appStorage.read("token"));
              sharedPreferences.setString('pos_device_id', data.code.toString());
              sharedPreferences.setString('pos_terminal_pin_code', global.generateRandomPin(8));
              checkPinCode();
            }),
            title: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.store_outlined,
                          size: 90,
                          color: Color(0xFFE27D01),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          data.devicenumber,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 120),
                  //   child: Center(
                  //     child: Text(
                  //       data.name,
                  //       style: const TextStyle(
                  //           fontSize: 18, fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )));
  }
}
