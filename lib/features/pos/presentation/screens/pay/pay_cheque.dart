import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/db/bank_helper.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/objectbox/bank_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/global_model.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

class PayCheque extends StatefulWidget {
  final PosProcessModel posProcess;
  final BuildContext blocContext;
  const PayCheque(
      {super.key, required this.posProcess, required this.blocContext});

  @override
  State<PayCheque> createState() => _PayChequeState();
}

class _PayChequeState extends State<PayCheque> {
  GlobalKey chequeNumberKey = GlobalKey();
  GlobalKey branchNumberKey = GlobalKey();
  GlobalKey amountNumberKey = GlobalKey();
  GlobalKey dueDateKey = GlobalKey();
  String bankCode = "";
  String bankName = "";
  String chequeNumber = "";
  double chequeAmount = 0;
  String branchNumber = "";
  DateTime dueDate = DateTime.now();
  int buttonIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData() {
    if (chequeNumber.trim().isNotEmpty && chequeAmount > 0) {
      global.payScreenData.cheque.add(PayChequeModel(
          due_date: DateTime.now(),
          bank_code: bankCode,
          bank_name: bankName,
          cheque_number: chequeNumber,
          branch_number: branchNumber,
          amount: chequeAmount));
      return true;
    } else {
      return false;
    }
  }

  Widget cardDetail() {
    List<BankObjectBoxStruct> bankDataList = BankHelper().selectAll();
    return Card(
      elevation: 3.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 90,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title:
                                    Text(global.language("please_select_bank")),
                                content: SizedBox(
                                    width: 350,
                                    height: 300,
                                    child: ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: ElevatedButton(
                                              child: Row(children: [
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    height: 50,
                                                    child: Image.asset(global
                                                        .findLogoImageFromCreditCardProvider(
                                                            bankDataList[index]
                                                                .code))),
                                                const SizedBox(width: 10),
                                                Text(bankDataList[index]
                                                    .names[0])
                                              ]),
                                              onPressed: () {
                                                global.payScreenNumberPadIsActive =
                                                    false;
                                                bankCode =
                                                    bankDataList[index].code;
                                                bankName = bankDataList[index]
                                                    .names[0];
                                                Navigator.of(context).pop();
                                                refreshEvent();
                                              },
                                            ));
                                      },
                                      itemCount: bankDataList.length,
                                    ))));
                        refreshEvent();
                      },
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 50,
                                  child: (bankCode.isNotEmpty)
                                      ? Image.asset(global
                                          .findLogoImageFromCreditCardProvider(
                                              bankCode))
                                      : Container())),
                          Text(
                            global.language("bank_name"),
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ))),
              const SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                      key: chequeNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  chequeNumber = global.payScreenNumberPadText;
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && buttonIndex == 1) {
                                global.payScreenNumberPadIsActive = false;
                                buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    PayScreenNumberPadWidgetEnum.text;
                                global.payScreenNumberPadText = chequeNumber;
                                final RenderBox renderBox = chequeNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size size = renderBox.size;
                                final Offset offset =
                                    renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    offset.dx + (size.width * 1.1);
                                global.payScreenNumberPadTop =
                                    offset.dy - size.height;
                                buttonIndex = 1;
                              }
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        chequeNumber,
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('cheque_number'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
              const SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                      key: branchNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  branchNumber = global.payScreenNumberPadText;
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && buttonIndex == 2) {
                                global.payScreenNumberPadIsActive = false;
                                buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    PayScreenNumberPadWidgetEnum.text;
                                global.payScreenNumberPadText = branchNumber;
                                final RenderBox renderBox = branchNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size size = renderBox.size;
                                final Offset offset =
                                    renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    offset.dx + (size.width * 1.1);
                                global.payScreenNumberPadTop =
                                    offset.dy - size.height;
                                buttonIndex = 2;
                              }
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        branchNumber,
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('chq_branch_number'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: SizedBox(
                      key: dueDateKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (bankCode.isNotEmpty) {
                              global.payScreenNumberPadIsActive = false;
                              DateTime? newDateTime =
                                  await showRoundedDatePicker(
                                context: context,
                                locale: const Locale("th", "TH"),
                                era: EraMode.BUDDHIST_YEAR,
                                initialDate: dueDate,
                                firstDate: DateTime(DateTime.now().year - 10),
                                lastDate: DateTime(DateTime.now().year + 10),
                                borderRadius: 16,
                              );
                              dueDate = newDateTime ?? DateTime.now();
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                          child: Text(
                                        DateFormat.yMMMMEEEEd()
                                            .formatInBuddhistCalendarThai(
                                                dueDate),
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.center,
                                      )))),
                              Text(
                                global.language('due_date'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
              const SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                      key: amountNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  chequeAmount = global.calcTextToNumber(
                                      global.payScreenNumberPadText);
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && buttonIndex == 3) {
                                global.payScreenNumberPadIsActive = false;
                                buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    PayScreenNumberPadWidgetEnum.number;
                                global.payScreenNumberPadAmount = chequeAmount;
                                final RenderBox renderBox = amountNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size size = renderBox.size;
                                final Offset offset =
                                    renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    offset.dx + (size.width * 1.1);
                                global.payScreenNumberPadTop =
                                    offset.dy - size.height;
                                global.payScreenNumberPadAmount = chequeAmount;
                                global.payScreenNumberPadText =
                                    (chequeAmount == 0)
                                        ? ""
                                        : chequeAmount
                                            .toString()
                                            .replaceAll(".0", "");
                                buttonIndex = 3;
                              }
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        global.moneyFormat.format(chequeAmount),
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('money_amount'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.push_pin),
                  onPressed: () {
                    if (saveData()) {
                      bankCode = "";
                      chequeAmount = 0;
                      chequeNumber = "";
                      branchNumber = "";
                      global.payScreenNumberPadText = "";
                      global.payScreenNumberPadAmount = 0;
                      refreshEvent();
                    }
                  },
                  label: Text(
                    global.language("cheque_save"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget buildCreditCard({required int index}) {
    return Column(
      children: [
        Card(
          elevation: 3.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Row(
                children: [
                  SizedBox(
                      width: 100,
                      height: 50,
                      child: Image.asset(
                          global.findLogoImageFromCreditCardProvider(
                              global.payScreenData.cheque[index].bank_code))),
                  const SizedBox(width: 10),
                  buildDetailsBlock(
                      label: global.language("cheque_number"),
                      value: global.payScreenData.cheque[index].cheque_number),
                  const SizedBox(width: 50),
                  buildDetailsBlock(
                      label: global.language("bank_branch_number"),
                      value: global.payScreenData.cheque[index].branch_number),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildDetailsBlock(
                      label: global.language('due_date'),
                      value: DateFormat.yMMMMEEEEd()
                          .formatInBuddhistCalendarThai(
                              global.payScreenData.cheque[index].due_date),
                    ),
                    buildDetailsBlock(
                        label: global.language('amount'),
                        value: global.moneyFormat
                            .format(global.payScreenData.cheque[index].amount)),
                  ],
                ),
              ),
              trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 30.0,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(global.language("delete_confirm")),
                            actions: [
                              TextButton(
                                child: Text(global.language("cancel")),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(global.language("confirm")),
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    global.payScreenData.cheque.removeAt(index);
                                    refreshEvent();
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Column buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
              color: Colors.green.shade500,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chequeAmount == 0) chequeAmount = diffAmount();
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          cardDetail(),
          Column(
            children: <Widget>[
              ...global.payScreenData.cheque.map((detail) {
                var index = global.payScreenData.cheque.indexOf(detail);
                return buildCreditCard(index: index);
              }).toList()
            ],
          ),
        ],
      ),
    )));
  }
}
