import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/features/pos/presentation/screens/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:presentation_displays/secondary_display.dart';
import 'package:dedepos/global.dart' as global;
import 'package:video_player/video_player.dart';

@RoutePage()
class PosSecondaryScreen extends StatefulWidget {
  const PosSecondaryScreen({Key? key}) : super(key: key);

  @override
  PosSecondaryScreenState createState() => PosSecondaryScreenState();
}

class PosSecondaryScreenState extends State<PosSecondaryScreen> {
  PosHoldProcessModel processResult = PosHoldProcessModel(code: "");
  final ScrollController detailScrollController = ScrollController();
  int changeScreenDelaySecond = 1;
  late Timer syncInformationTimer;
  late Timer refreshTimer;
  int informationIndex = 0;
  Widget informationMedia = const SizedBox();
  int informationCountDownSecond = 0;
  late VideoPlayerController videoController;

  String value = "";

  @override
  void initState() {
    super.initState();
    syncInformationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // นับถอยหลังกลับหน้าจอ Customer Display
      if (--changeScreenDelaySecond < 0) {
        setState(() {
          changeScreenDelaySecond = 1;
        });
      }
      // นับถอยหลัง Information (Image, Video)
      if (global.informationList.isNotEmpty) {
        if (--informationCountDownSecond < 0) {
          changeInformationMedia();
        }
      }
    });
  }

  Widget detail(int index, PosProcessDetailModel detail, Color backgroundColor) {
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
    );
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            children: <Widget>[
              Expanded(flex: 5, child: Text("$index.${global.getNameFromJsonLanguage(detail.item_name, global.userScreenLanguage)}", style: textStyle)),
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        global.moneyFormat.format(detail.qty),
                        style: textStyle,
                      ))),
              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text(global.moneyFormat.format(detail.total_amount), style: textStyle))),
            ],
          ),
        ));
  }

  Widget detailList() {
    return ListView.builder(
      controller: detailScrollController,
      itemCount: processResult.posProcess.details.length,
      itemBuilder: (context, index) {
        Color? backgroundColor = (index.isOdd) ? Colors.white : Colors.grey[200];
        return detail(index + 1, processResult.posProcess.details[index], backgroundColor!);
      },
    );
  }

  Widget summery() {
    return (Container(
      width: double.infinity,
      height: 60,
      color: Colors.cyan,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: screenBoxShadowLabelAndNumber(
              label: global.language("unit_pc"),
              value: processResult.posProcess.total_piece,
            ),
          ),
          Expanded(
            flex: 3,
            child: screenBoxShadowLabelAndNumber(label: global.language("money_symbol"), value: processResult.posProcess.total_amount),
          ),
        ],
      ),
    ));
  }

  Widget detailHeader() {
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    return (Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Text(
                global.language("product_description"), // 'รายละเอียดสินค้า',
                style: textStyle,
              )),
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    global.language("product_qty"), //'จำนวน',
                    style: textStyle,
                  ))),
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    global.language("product_amount"), // 'ยอดรวม',
                    style: textStyle,
                  ))),
        ],
      ),
    ));
  }

  void checkEndVideo() {
    if (videoController.value.isInitialized && (videoController.value.duration == videoController.value.position)) {
      changeInformationMedia();
    }
  }

  void changeInformationMedia() {
    if (global.informationList.isNotEmpty) {
      try {
        informationMedia = const SizedBox();
        try {
          videoController.dispose();
        } catch (_) {}
        informationIndex = Random().nextInt(global.informationList.length);
        if (global.informationList[informationIndex].mode == 0) {
          // Show Image
          informationMedia = CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: global.informationList[informationIndex].sourceUrl,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
          informationCountDownSecond = global.informationList[informationIndex].delaySecond;
          setState(() {});
        }
        if (global.informationList[informationIndex].mode == 1) {
          // Show Video
          videoController = VideoPlayerController.network(global.informationList[informationIndex].sourceUrl);
          informationMedia = VideoPlayer(videoController);
          videoController.setLooping(false);
          videoController.initialize().then((_) {
            setState(() {});
            videoController.play();
          }).onError((error, stackTrace) {
            informationCountDownSecond = 0;
          }).catchError((error, stackTrace) {
            informationCountDownSecond = 0;
          });
          videoController.removeListener(checkEndVideo);
          videoController.addListener(checkEndVideo);
          informationCountDownSecond = 10000;
        }
        setState(() {});
      } catch (_) {}
    }
  }

  Widget informationScreen() {
    return Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                child: InkWell(
              onTap: () {
                changeInformationMedia();
              },
              child: informationMedia,
            )),
            const Text('Information'),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (value != "") {
      PosHoldProcessModel processDecode = PosHoldProcessModel.fromJson(jsonDecode(value) as Map<String, dynamic>);
      processResult = processDecode;
    }
    // PosHoldProcessModel.fromJson(
    //     jsonDecode(argument) as Map<String, dynamic>);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Display',
        home: Scaffold(
            body: SecondaryDisplay(
                callback: (argument) {
                  setState(() {
                    value = argument;
                  });
                  // serviceLocator<Log>()
                  //     .trace("Receive Callback SecondaryDisplay");
                  // PosHoldProcessModel processDecode =
                  //     PosHoldProcessModel.fromJson(
                  //         jsonDecode(argument) as Map<String, dynamic>);
                  // setState(() {
                  //   processResult = processDecode;
                  //   // PosHoldProcessModel.fromJson(
                  //   //     jsonDecode(argument) as Map<String, dynamic>);
                  // });
                },
                child: Container(
                  margin: const EdgeInsets.all(0),
                  color: Colors.white,
                  width: double.infinity,
                  child: Row(children: [
                    Expanded(
                        child: Column(
                      children: [
                        SizedBox(height: 60, child: Container()),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.cyan, width: 4)),
                          padding: const EdgeInsets.all(4),
                          child: informationScreen(),
                        ))
                      ],
                    )),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          summery(),
                          Expanded(
                              child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.cyan, width: 4)),
                                  padding: const EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      detailHeader(),
                                      Expanded(child: detailList()),
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                  ]),
                ))));
  }
}
