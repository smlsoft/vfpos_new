import 'package:auto_route/auto_route.dart';
import 'package:dedepos/app/app.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/shop/domain/entity/shop_user.dart';
import 'package:dedepos/features/shop/presentation/bloc/select_shop_bloc.dart';
import 'package:dedepos/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SelectShopScreen extends StatefulWidget {
  const SelectShopScreen({super.key});

  @override
  SelectShopScreenState createState() => SelectShopScreenState();
}

class SelectShopScreenState extends State<SelectShopScreen> {
  late User user;
  bool isSelectionMode = false;
  final int listLength = 30;
  late List<bool> _selected;
  bool _selectAll = false;
  bool _isGridMode = true;

  @override
  void initState() {
    super.initState();
    context
        .read<SelectShopBloc>()
        .add(const SelectShopEvent.onSelectShopStarted());
    initializeSelection();
  }

  void initializeSelection() {
    _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAuthenticationState =
        context.select((AuthenticationBloc bloc) => bloc.state);

    if (userAuthenticationState is AuthenticationLoadedState) {
      //context.router.push(const SelectShopRoute());
      user = userAuthenticationState.user;
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<SelectShopBloc, SelectShopState>(
            listener: (context, state) {
          if (state is SelectShopSubmitSuccessState) {
            // read state and push next state
            // context.router.pushAndPopUntil(const DashboardRoute(),
            //     predicate: (route) => false);
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEvent.authenticated(user: user));
          }
        }),
        BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
          if (state is AuthenticationInitialState) {
            context.router.pushAndPopUntil(const AuthenticationRoute(),
                predicate: (route) => false);
          } else if (state is AuthenticationAuthenticatedState) {
            context.router.pushAndPopUntil(const DashboardRoute(),
                predicate: (route) => false);
          }
        }),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Center(
                  child: Text(
                    'โปรดเลือกร้านค้า ',
                  ),
                ),
              ],
            ),
            leading: isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isSelectionMode = false;
                      });
                      initializeSelection();
                    },
                  )
                : const SizedBox(),
            actions: <Widget>[
              IconButton(
                tooltip: "สร้างร้านค้า",
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    isSelectionMode = false;
                  });
                  initializeSelection();
                },
              ),
              // Switch(
              //   // This bool value toggles the switch.
              //   value: _isGridMode,
              //   activeColor: Colors.white,
              //   onChanged: (bool value) {
              //     // This is called when the user toggles the switch.
              //     setState(() {
              //       _isGridMode = !_isGridMode;
              //     });
              //   },
              // ),
              // if (_isGridMode)
              //   IconButton(
              //     icon: const Icon(Icons.grid_on),
              //     onPressed: () {
              //       setState(() {
              //         _isGridMode = false;
              //       });
              //     },
              //   )
              // else
              //   IconButton(
              //     icon: const Icon(Icons.list),
              //     onPressed: () {
              //       setState(() {
              //
              //       });
              //     },
              //   ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(const UserLogoutEvent());
                },
              ),
              // if (isSelectionMode)
              //   TextButton(
              //       child: !_selectAll
              //           ? const Text(
              //               'select all',
              //               style: TextStyle(color: Colors.white),
              //             )
              //           : const Text(
              //               'unselect all',
              //               style: TextStyle(color: Colors.white),
              //             ),
              //       onPressed: () {
              //         _selectAll = !_selectAll;
              //         setState(() {
              //           _selected =
              //               List<bool>.generate(listLength, (_) => _selectAll);
              //         });
              //       }),
            ],
          ),
          body: _isGridMode
              ? GridBuilder(
                  isSelectionMode: isSelectionMode,
                  selectedList: _selected,
                  onSelectionChange: (bool x) {
                    setState(() {
                      isSelectionMode = x;
                    });
                  },
                )
              : ListBuilder(
                  isSelectionMode: isSelectionMode,
                  selectedList: _selected,
                  onSelectionChange: (bool x) {
                    setState(() {
                      isSelectionMode = x;
                    });
                  },
                )),
    );
  }
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final Function(bool)? onSelectionChange;
  final List<bool> selectedList;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectShopBloc, SelectShopState>(
      builder: (context, state) {
        if (state is SelectShopLoadedState) {
          return Padding(
            padding: const EdgeInsets.only(left: 150, right: 150),
            child: GridView.builder(
                itemCount: state.shops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () => _toggle(index),
                      child: cardItem(state.shops[index]));
                }),
          );
        }
        return Container();
      },
    );
  }

  Widget cardItem(ShopUser data) {
    return Card(
        elevation: 5,
        child: ListTile(
            onTap: (() {
              context
                  .read<SelectShopBloc>()
                  .add(ShopSelectSubmit(shop: data.toShop));
            }),
            title: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Icon(
                          Icons.store,
                          size: 100,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          data.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;

  final List<bool> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectShopBloc, SelectShopState>(
        builder: (context, state) {
      if (state is SelectShopLoadedState) {
        return Padding(
          padding: const EdgeInsets.only(left: 150, right: 150),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: state.shops.length,
            itemBuilder: (context, index) {
              return cardItem(state.shops[index]);
            },
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget cardItem(ShopUser data) {
    return Card(
        elevation: 5,
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

// import 'package:auto_route/auto_route.dart';
// import 'package:dedepos/app/app.dart';
// import 'package:dedepos/features/authentication/auth.dart';
// import 'package:dedepos/features/shop/domain/entity/shop_user.dart';
// import 'package:dedepos/features/shop/presentation/bloc/select_shop_bloc.dart';
// import 'package:dedepos/routes/app_routers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// @RoutePage()
// class SelectShopScreen extends StatefulWidget {
//   const SelectShopScreen({super.key});

//   @override
//   State<SelectShopScreen> createState() => _SelectShopScreenState();
// }

// class _SelectShopScreenState extends State<SelectShopScreen> {
//   late User user;
//   @override
//   void initState() {
//     super.initState();

//     context
//         .read<SelectShopBloc>()
//         .add(const SelectShopEvent.onSelectShopStarted());
//   }

//   @override
//   Widget build(BuildContext context) {

//     final userAuthenticationState =
//         context.select((AuthenticationBloc bloc) => bloc.state);

//     if (userAuthenticationState is AuthenticationLoadedState) {
//       //context.router.push(const SelectShopRoute());
//       user = userAuthenticationState.user;
//     }

//     // if (SelectShopState is SelectShopSubmitSuccessState) {
//     //       shopName = SelectShopState.shop.name;
//     //     } else {
//     //       shopName = 'XXX';
//     //     }
//     // context
//     //     .read<SelectShopBloc>()
//     //     .add(const SelectShopEvent.onSelectShopStarted());

//     return Scaffold(
//       body: MultiBlocListener(
//         listeners: [
//           BlocListener<SelectShopBloc, SelectShopState>(
//               listener: (context, state) {
//             if (state is SelectShopSubmitSuccessState) {
//               // read state and push next state
//               // context.router.pushAndPopUntil(const DashboardRoute(),
//               //     predicate: (route) => false);
//               context
//                   .read<AuthenticationBloc>()
//                   .add(AuthenticationEvent.authenticated(user: user));
//             }
//           }),
//           BlocListener<AuthenticationBloc, AuthenticationState>(
//               listener: (context, state) {
//             if (state is AuthenticationInitialState) {
//               context.router.pushAndPopUntil(const AuthenticationRoute(),
//                   predicate: (route) => false);
//             } else if (state is AuthenticationAuthenticatedState) {
//               context.router.pushAndPopUntil(const DashboardRoute(),
//                   predicate: (route) => false);
//             }
//           }),
//         ],
//         child: Stack(
//           children: [
//             const BackgroundGradientWidget(),
//             const BackgroundClipperWidget(),
//             Center(
//               child: SizedBox(
//                 width: 600,
//                 height: 700,
//                 child: Card(
//                   child: SingleChildScrollView(
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.all(8),
//                                 child: ElevatedButton(
//                                     onPressed: () {
//                                       context
//                                           .read<AuthenticationBloc>()
//                                           .add(const UserLogoutEvent());
//                                     },
//                                     child: const Text("Logout")),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.all(8),
//                                 child: const Text(
//                                   "Back to Login",
//                                   style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.all(8),
//                                 child: ElevatedButton(
//                                     onPressed: () {
//                                       // showPopup(context);
//                                     },
//                                     child: const Text("create shop")),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           BlocBuilder<SelectShopBloc, SelectShopState>(
//                             builder: (context, state) {
//                               if (state is SelectShopLoadedState) {
//                                 return ListView.builder(
//                                   physics:
//                                       const AlwaysScrollableScrollPhysics(),
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   itemCount: state.shops.length,
//                                   itemBuilder: (context, index) {
//                                     return cardItem(state.shops[index]);
//                                   },
//                                 );
//                               }
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget cardItem(ShopUser data) {
//     return Card(
//         elevation: 5,
//         child: ListTile(
//             onTap: (() {
//               context
//                   .read<SelectShopBloc>()
//                   .add(ShopSelectSubmit(shop: data.toShop));
//             }),
//             title: Text(
//               data.name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             )));
//   }
// }
