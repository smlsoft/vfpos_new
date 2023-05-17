import 'package:auto_route/auto_route.dart';
import 'package:dedepos/app/app.dart';
import 'package:dedepos/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:dedepos/flavors.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  Color vfPrimaryColor = const Color(0xFF007BFF);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const BackgroundGradientWidget(),
      const BackgroundClipperWidget(),
      Center(
          child: SizedBox(
        width: 500,
        height: 600,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationLoadedState) {
                    context.router.push(const SelectShopRoute());
                  } else if (state is AuthenticationAuthenticatedState) {
                    context.router.push(const DashboardRoute());
                  } else if (state is AuthenticationErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
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
                        Center(child: const CircularProgressIndicator()),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      logo(),
                      const SizedBox(height: 16.0),
                      userTextfield(),
                      const SizedBox(height: 16.0),
                      passwordTextfield(),
                      const SizedBox(height: 16.0),
                      buttonLogin(),
                      const SizedBox(height: 16.0),
                      loginSeparatorLine(),
                      const SizedBox(height: 16.0),
                      buttonLoginWithGoogle(),
                      const SizedBox(height: 16.0),
                      buttonLoginWithApple(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ))
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
        hintText: 'Username',
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
        hintText: 'Password',
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
    return ElevatedButton.icon(
      onPressed: () {
        // on click
        debugPrint(
            'on login debug  ${_emailController.text} ${_passwordController.text}');

        final userName = _emailController.text;
        final password = _passwordController.text;
        context.read<AuthenticationBloc>().add(
            AuthenticationEvent.onLoginWithUserPasswordTapped(
                userName: userName, password: password));
      },
      icon: const Icon(Icons.person),
      label: const Text('Login'),
      style: Styles.successButtonStyle(),
    );
  }

  Widget buttonLoginWithGoogle() {
    return ElevatedButton.icon(
      onPressed: () {
        // on click
        context.read<AuthenticationBloc>().add(const LoginWithGoogleEvent());
      },
      icon: const Icon(Icons.mail_outline),
      label: const Text('Login with Google'),
      style: Styles.successButtonStyle(),
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

  Widget buttonLoginWithApple() {
    return ElevatedButton.icon(
      onPressed: () {
        // on click
        // context.router.push(const AuthenticationWithUserPasswordRoute());
      },
      icon: const Icon(Icons.mail_outline),
      label: const Text('Login with Apple'),
      style: Styles.successButtonStyle(),
    );
  }

  Widget loginSeparatorLine() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          horizontalLine(),
          const Text(" OR "),
          horizontalLine()
        ],
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
}
