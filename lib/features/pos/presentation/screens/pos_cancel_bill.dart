import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_cancel_bill_detail.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosCancelBillScreen extends StatefulWidget {
  final global.PosScreenModeEnum posScreenMode;

  @override
  const PosCancelBillScreen({Key? key, required this.posScreenMode}) : super(key: key);

  @override
  State<PosCancelBillScreen> createState() => _PosCancelBillScreenState();
}

class _PosCancelBillScreenState extends State<PosCancelBillScreen> {
  List<BillObjectBoxStruct> dataList = [];

  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(BillLoad(
          posScreenMode: widget.posScreenMode,
        ));
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
              title: Text(global.language("cancel_bill")),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  dataList.length,
                  (index) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: (dataList[index].is_cancel) ? Colors.red.shade100 : Colors.blue.shade100,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PosCancelBillDetailScreen(docNumber: dataList[index].doc_number, posScreenMode: widget.posScreenMode),
                        ),
                      );
                    },
                    child: posBill(dataList[index]),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
