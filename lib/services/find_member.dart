import 'dart:developer';
import 'package:dedepos/bloc/find_member_by_tel_name_bloc.dart';
import 'package:dedepos/model/find/find_member_struct.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/model/find/find_item_struct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/bloc/find_item_by_code_name_barcode_bloc.dart';
// import 'package:last_qr_scanner/last_qr_scanner.dart';
import 'package:dedepos/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import '../model/json/struct.dart';

class FindMember extends StatefulWidget {
  const FindMember({Key? key}) : super(key: key);

  @override
  _FindMemberState createState() => _FindMemberState();
}

class _FindMemberState extends State<FindMember> with TickerProviderStateMixin {
  final _debouncer = global.Debounce(500);
  final List<FindMemberStruct> _findByTelNameLastResult = [];
  ScrollController? _findByTextScrollController;
  final TextEditingController _textFindByTextController =
      TextEditingController();
  FocusNode? _textFindByTextFocus;

  @override
  void initState() {
    super.initState();
    _textFindByTextFocus = FocusNode();
    _findByTextScrollController = ScrollController()
      ..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _findByTextScrollController!.dispose();
    _textFindByTextFocus!.dispose();
  }

  void _scrollListener() {
    if (_findByTextScrollController!.hasClients) {
      if (_findByTextScrollController!.position.pixels ==
          _findByTextScrollController!.position.maxScrollExtent) {
        //context.read<FindItemByCodeNameBarcodeBloc>().add(FindItemByCodeNameBarcodeLoadStart(_textFindByTextController.text, _findByCodeNameLastResult.length, 25));
      }
    }
  }

  Widget findByText() {
    return BlocBuilder<FindMemberByTelNameBloc, FindMemberByTelNameState>(
        builder: (context, state) {
      if (state is FindMemberByTelNameLoadSuccess) {
        _findByTelNameLastResult.addAll(state.result);
        context
            .read<FindMemberByTelNameBloc>()
            .add(FindMemberByTelNameLoadFinish());
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
            TextField(
                autofocus: true,
                focusNode: _textFindByTextFocus,
                controller: _textFindByTextController,
                onChanged: (string) {
                  _debouncer.run(() {
                    _findByTelNameLastResult.clear();
                    context.read<FindMemberByTelNameBloc>().add(
                        FindMemberByTelNameLoadStart(
                            _textFindByTextController.text, 0, 50));
                  });
                },
                decoration: InputDecoration(
                  hintText: "ข้อความบางส่วน (ชื่อ,เบอร์โทร)",
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _findByTelNameLastResult.clear();
                      _textFindByTextController.clear();
                    }),
                    icon: const Icon(Icons.clear),
                  ),
                )),
            Container(
                child: Row(children: [
              Expanded(
                flex: 3,
                child: Text(
                  "telephone",
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "name" + " - " + "surname",
                ),
              ),
              Expanded(
                flex: 6,
                child: Text("address"),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "save",
                  ),
                ),
              )
            ])),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              children: _findByTelNameLastResult.map((value) {
                var _index = _findByTelNameLastResult.indexOf(value);
                var _detail = _findByTelNameLastResult[_index];
                return Container(
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(_detail.telephone)),
                      Expanded(flex: 3, child: Text(_detail.name)),
                      Expanded(flex: 6, child: Text(_detail.address)),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(2),
                            ),
                            onPressed: () {
                              setState(() {
                                global.userLoginName = _detail.name;
                                global.userData = MemberObjectBoxStruct(
                                  address: _detail.address,
                                  branchcode: _detail.branchcode,
                                  branchtype: _detail.branchtype,
                                  contacttype: _detail.contacttype,
                                  name: _detail.name,
                                  personaltype: _detail.personaltype,
                                  surname: _detail.surname,
                                  taxid: _detail.taxid,
                                  telephone: _detail.telephone,
                                  zipcode: _detail.zipcode,
                                );
                              });
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.save),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )))
          ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: global.posTheme.secondary,
        title: const Text("ค้นหา สมาชิก"),
      ),
      body: findByText(),
    );
  }
}
