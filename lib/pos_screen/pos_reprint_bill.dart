import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosReprintBillScreen extends StatefulWidget {
  @override
  const PosReprintBillScreen({Key? key}) : super(key: key);

  _PosReprintBillScreenState createState() => _PosReprintBillScreenState();
}

class _PosReprintBillScreenState extends State<PosReprintBillScreen> {
  List<BillObjectBoxStruct> dataList = [];

  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(BillLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillLoadSuccess) {
          context.read<BillBloc>().add(BillLoadFinish());
          dataList = state.result;
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(global.language("reprint_bill")),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: dataList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(global.language("reprint_bill")),
                              content: Text(dataList[index].doc_number),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(global.language("cancel"))),
                                TextButton(
                                    onPressed: () {
                                      printBill(dataList[index].doc_number);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text(global.language("confirm"))),
                              ],
                            );
                          });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(children: [
                              const Text("เลขที่"),
                              Text(
                                dataList[index].doc_number,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                            TableRow(children: [
                              const Text("วันที่"),
                              Text(
                                global
                                    .dateTimeFormat(dataList[index].date_time),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                            TableRow(children: [
                              const Text("มูลค่า"),
                              Text(
                                global.moneyFormat
                                    .format(dataList[index].total_amount),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ],
                        )),
                  );
                },
              ),
            ));
      },
    );
  }
}
