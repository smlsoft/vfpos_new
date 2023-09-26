import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/db/bank_helper.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/objectbox/bank_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/widgets/numpadtext.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/global_model.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

class PayCreditCard extends StatefulWidget {
  final PosHoldProcessModel posProcess;
  final BuildContext blocContext;

  const PayCreditCard({super.key, required this.posProcess, required this.blocContext});

  @override
  State<PayCreditCard> createState() => _PayCreditCardState();
}

class _PayCreditCardState extends State<PayCreditCard> {
  GlobalKey cardNumberKey = GlobalKey();
  GlobalKey approveNumberKey = GlobalKey();
  GlobalKey amountNumberKey = GlobalKey();
  String bookBankCode = "";
  List<LanguageDataModel>? bookBankName = [];
  String bankCode = "";
  String bankName = "";
  String cardNumber = "";
  double cardAmount = 0;
  String approveNumber = "";

  @override
  void initState() {
    super.initState();
    if (global.posConfig.creditcards!.isNotEmpty) {
      bookBankCode = global.posConfig.creditcards![0].bookbank.accountcode!;
      bookBankName = global.posConfig.creditcards![0].names;
    }
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData() {
    if (cardNumber.trim().isNotEmpty && cardAmount > 0) {
      PayCreditCardModel data = PayCreditCardModel(
          book_bank_name: bookBankName!.firstWhere((ele) => ele.code == "th").name,
          book_bank_code: bookBankCode,
          bank_code: bankCode,
          bank_name: bankName,
          card_number: cardNumber,
          approved_code: approveNumber,
          amount: cardAmount);
      global.payScreenData.credit_card.add(data);
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
            children: [
              for (var item in global.posConfig.creditcards!)
                ElevatedButton(
                    onPressed: () {
                      bookBankCode = item.bookbank.bankcode!;
                      bookBankName = item.names;
                      refreshEvent();
                    },
                    child: Column(
                      children: [
                        Container(alignment: Alignment.center, width: 100, height: 50, child: Image(image: NetworkToFileImage(url: global.findBankLogo(item.bookbank.bankcode!)))),
                        Text(
                          "${global.getNameFromLanguage(item.names!, global.userScreenLanguage)} ",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
            ],
          ),
          const SizedBox(height: 10),
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
                                title: Text(global.language("select_card_type")),
                                content: SizedBox(
                                    width: 350,
                                    height: 300,
                                    child: ListView.builder(
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                                            child: ElevatedButton(
                                              child: Row(children: [
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    height: 50,
                                                    child: Image(image: NetworkToFileImage(url: global.findBankLogo(bankDataList[index].code)))),
                                                const SizedBox(width: 10),
                                                Text(bankDataList[index].names[0])
                                              ]),
                                              onPressed: () {
                                                bankCode = bankDataList[index].code;
                                                bankName = bankDataList[index].names[0];
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
                                  child: (bankCode.isNotEmpty) ? Image(image: NetworkToFileImage(url: global.findBankLogo(bankCode))) : Container())),
                          Text(
                            (bankName.isNotEmpty) ? bankName : global.language('bank'),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ))),
              const SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                      key: cardNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (bankCode.isNotEmpty) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text(global.language('card_number')),
                                      content: SizedBox(
                                        width: 300,
                                        height: 300,
                                        child: NumberPadText(onChange: (value) {
                                          setState(() {
                                            cardNumber = value;
                                          });
                                        }),
                                      ));
                                },
                              );
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        cardNumber,
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('card_number'),
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
                      key: approveNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (bankCode.isNotEmpty) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text(global.language('authorization_code')),
                                      content: SizedBox(
                                        width: 300,
                                        height: 300,
                                        child: NumberPadText(onChange: (value) {
                                          setState(() {
                                            approveNumber = value;
                                          });
                                        }),
                                      ));
                                },
                              );
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        approveNumber,
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('authorization_code'),
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
                          onPressed: () async {
                            if (bankCode.isNotEmpty) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text(global.language('amount')),
                                      content: SizedBox(
                                        width: 300,
                                        height: 300,
                                        child: NumberPad(onChange: (value) {
                                          setState(() {
                                            cardAmount = double.tryParse(value) ?? 0;
                                          });
                                        }),
                                      ));
                                },
                              );
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        global.moneyFormat.format(cardAmount),
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('amount'),
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
                      cardAmount = 0;
                      cardNumber = "";
                      approveNumber = "";
                      refreshEvent();
                    }
                  },
                  label: Text(
                    global.language("credit_card_save"),
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
              title: Column(
                children: [
                  Text(global.payScreenData.credit_card[index].book_bank_name),
                  Row(
                    children: [
                      SizedBox(width: 100, height: 50, child: Image(image: NetworkToFileImage(url: global.findBankLogo(global.payScreenData.credit_card[index].bank_code)))),
                      const SizedBox(width: 10),
                      Text(
                        '${global.language('card_number')} : ',
                        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'CourrierPrime'),
                      ),
                      Text(
                        global.payScreenData.credit_card[index].card_number,
                        style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'CourrierPrime'),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildDetailsBlock(
                      label: global.language('authorization_code'),
                      value: global.payScreenData.credit_card[index].approved_code,
                    ),
                    buildDetailsBlock(label: global.language('amount'), value: global.moneyFormat.format(global.payScreenData.credit_card[index].amount)),
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
                            content: Text(global.language("delete_confirm_warning")),
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
                                    global.payScreenData.credit_card.removeAt(index);
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
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.green.shade500, fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cardAmount == 0) cardAmount = diffAmount();
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            cardDetail(),
            (global.payScreenData.credit_card.isEmpty)
                ? Container()
                : Column(
                    children: <Widget>[
                      ...global.payScreenData.credit_card.map((detail) {
                        var index = global.payScreenData.credit_card.indexOf(detail);
                        return buildCreditCard(index: index);
                      }).toList()
                    ],
                  ),
          ],
        )));
  }
}
