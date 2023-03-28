import 'dart:developer';
import 'package:dedepos/bloc/find_employee_by_name_bloc.dart';
import 'package:dedepos/bloc/find_member_by_tel_name_bloc.dart';
import 'package:dedepos/model/find/find_employee_struct.dart';
import 'package:dedepos/model/find/find_member_struct.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/model/find/find_item_struct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/bloc/find_item_by_code_name_barcode_bloc.dart';
import 'package:dedepos/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import '../model/json/struct.dart';

class FindEmployee extends StatefulWidget {
  const FindEmployee({Key? key}) : super(key: key);

  @override
  _FindEmployeeState createState() => _FindEmployeeState();
}

class _FindEmployeeState extends State<FindEmployee>
    with TickerProviderStateMixin {
  final _debouncer = global.Debounce(500);
  final List<FindEmployeeStruct> _findResult = [];
  final TextEditingController _textFindByTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FindEmployeeByNameBloc>().add(FindEmployeeByNameLoadStart(''));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget findByText() {
    return BlocBuilder<FindEmployeeByNameBloc, FindEmployeeByNameState>(
        builder: (context, state) {
      if (state is FindEmployeeByNameLoadSuccess) {
        _findResult.addAll(state.result);
        context
            .read<FindEmployeeByNameBloc>()
            .add(FindEmployeeByNameLoadFinish());
      }
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 51, 204, 255), width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Column(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: TextField(
                    controller: _textFindByTextController,
                    onChanged: (string) {
                      _debouncer.run(() {
                        _findResult.clear();
                        context.read<FindEmployeeByNameBloc>().add(
                            FindEmployeeByNameLoadStart(
                                _textFindByTextController.text));
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "ข้อความบางส่วน (ชื่อ)",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _findResult.clear();
                          _textFindByTextController.clear();
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
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: _findResult.length,
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
          Navigator.pop(
              context, [_findResult[index].code, _findResult[index].name]);
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
                child: CachedNetworkImage(
                  width: 100,
                  height: 80,
                  imageUrl: _findResult[index].profilepicture,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            Text((_findResult[index].name),
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
        title: const Text("ค้นหา พนักงาน"),
      ),
      body: findByText(),
    );
  }
}
