import 'package:auto_route/auto_route.dart';
import 'package:dedepos/app/app.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/shop/domain/entity/shop_user.dart';
import 'package:dedepos/features/shop/presentation/bloc/select_shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SelectShopScreen extends StatefulWidget {
  const SelectShopScreen({super.key});

  @override
  State<SelectShopScreen> createState() => _SelectShopScreenState();
}

class _SelectShopScreenState extends State<SelectShopScreen> {
  late User user;
  @override
  void initState() {
    super.initState();

    context
        .read<SelectShopBloc>()
        .add(const SelectShopEvent.onSelectShopStarted());
  }

  @override
  Widget build(BuildContext context) {
    final userAuthenticationState =
        context.select((AuthenticationBloc bloc) => bloc.state);

    if (userAuthenticationState is AuthenticationLoadedState) {
      //context.router.push(const SelectShopRoute());
      user = userAuthenticationState.user;
    }

    // if (SelectShopState is SelectShopSubmitSuccessState) {
    //       shopName = SelectShopState.shop.name;
    //     } else {
    //       shopName = 'XXX';
    //     }
    // context
    //     .read<SelectShopBloc>()
    //     .add(const SelectShopEvent.onSelectShopStarted());

    return Scaffold(
      body: BlocListener<SelectShopBloc, SelectShopState>(
        listener: (context, state) {
          if (state is SelectShopSubmitSuccessState) {
            // read state and push next state
            // context.router.pushAndPopUntil(const DashboardRoute(),
            //     predicate: (route) => false);
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEvent.authenticated(user: user));
          }
        },
        child: Stack(
          children: [
            const BackgroundGradientWidget(),
            const BackgroundClipperWidget(),
            Center(
              child: SizedBox(
                width: 600,
                height: 800,
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Logout")),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: const Text(
                                "Select Shop ",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                  onPressed: () {
                                    // showPopup(context);
                                  },
                                  child: const Text("create shop")),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<SelectShopBloc, SelectShopState>(
                          builder: (context, state) {
                            if (state is SelectShopLoadedState) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: state.shops.length,
                                itemBuilder: (context, index) {
                                  return cardItem(state.shops[index]);
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardItem(ShopUser data) {
    return Card(
        elevation: 3,
        child: ListTile(
            onTap: (() {
              context
                  .read<SelectShopBloc>()
                  .add(ShopSelectSubmit(shop: data.toShop));
            }),
            title: Text(
              data.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )));
  }
}
