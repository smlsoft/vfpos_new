import 'package:dedepos/bloc/find_employee_by_name_bloc.dart';
import 'package:dedepos/model/find/find_employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';

class FindEmployee extends StatefulWidget {
  const FindEmployee({Key? key}) : super(key: key);

  @override
  State<FindEmployee> createState() => _FindEmployeeState();
}

class _FindEmployeeState extends State<FindEmployee> with TickerProviderStateMixin {
  final debouncer = global.Debounce(500);
  final List<FindEmployeeModel> findResult = [];
  final TextEditingController textFindByTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FindEmployeeByNameBloc>().add(FindEmployeeByNameLoadStart(''));
  }

  Widget findByText() {
    return BlocBuilder<FindEmployeeByNameBloc, FindEmployeeByNameState>(builder: (context, state) {
      if (state is FindEmployeeByNameLoadSuccess) {
        findResult.addAll(state.result);
        context.read<FindEmployeeByNameBloc>().add(FindEmployeeByNameLoadFinish());
      }
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 51, 204, 255), width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Column(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: TextField(
                    controller: textFindByTextController,
                    onChanged: (string) {
                      debouncer.run(() {
                        findResult.clear();
                        context.read<FindEmployeeByNameBloc>().add(FindEmployeeByNameLoadStart(textFindByTextController.text));
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "ข้อความบางส่วน (ชื่อ)",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          findResult.clear();
                          textFindByTextController.clear();
                        }),
                        icon: const Icon(Icons.clear),
                      ),
                    ))),
            Expanded(child: employeeContent()),
          ]));
    });
  }

  Widget employeeContent() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
        itemCount: findResult.length,
        itemBuilder: (BuildContext ctx, index) {
          return employeeButton(index);
        });
  }

  Widget employeeButton(int index) {
    return Container(
      margin: const EdgeInsets.all(2.5),
      height: 45,
      child: SizedBox(
          child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context, [findResult[index].code, findResult[index].name]);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: (findResult[index].profile_picture.trim().isEmpty)
                    ? Container()
                    : CachedNetworkImage(
                        width: 100,
                        height: 80,
                        imageUrl: findResult[index].profile_picture,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )),
            Text((findResult[index].name),
                style: const TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                    fontSize: 16)),
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: global.posTheme.secondary,
        title: Text(global.language("find_employee")),
      ),
      body: findByText(),
    );
  }
}
