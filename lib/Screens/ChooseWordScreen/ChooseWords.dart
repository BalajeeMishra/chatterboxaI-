import 'dart:async';

import 'package:balajiicode/Widget/appbar.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../Utils/app_colors.dart';
import '../../ViewModel/AllGameVm.dart';
import '../../components/tts.dart';
import '../../extensions/loader_widget.dart';
import '../../main.dart';
import '../youtube_video_player_screen.dart';
import 'PlayTabooScreen.dart';
import 'package:uuid/uuid.dart';

class ChooseWordScreen extends StatefulWidget {
  String dataId;
  String gameName;

  ChooseWordScreen(this.dataId, this.gameName, {super.key});

  @override
  State<StatefulWidget> createState() => _ChooseWordScreen();
}

class _ChooseWordScreen extends State<ChooseWordScreen> {
  final TTSManager ttsManager = TTSManager();

  @override
  void initState() {
    super.initState();
    Provider.of<AllGameVm>(context, listen: false).seInitialValue();
    Provider.of<AllGameVm>(context, listen: false)
        .allGamePageAPI(context, widget.dataId);
  }


  timerFunction(){
    print("Timer function calling");
    int elapsedSeconds = 0;
    const int maxDuration = 10;

    Timer.periodic(Duration(seconds: 2,milliseconds: 400), (Timer timer) async {
      elapsedSeconds++;

      if (userStore.isTTSPlaying =="YES") {
        print("Into iF");
        userStore.setTTSPlaying("NO");
        await ttsManager.stop();
        print("Condition met. Stopping TTS and timer.");
        timer.cancel();
      }

      if (elapsedSeconds >= maxDuration) {
        print("Timer exceeded 10 seconds. Stopping the timer.");
        timer.cancel();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: backCustomAppBar(
          backButtonshow: true,
          centerTile: false,
          onPressed: () {
            Navigator.pop(context);
          },
          title: widget.gameName),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await Provider.of<AllGameVm>(context, listen: false).seInitialValue();
          await Provider.of<AllGameVm>(context, listen: false)
              .allGamePageAPI(context, widget.dataId);
        },
        child: Stack(
          children: [
            Consumer<AllGameVm>(
              builder: (context, vm, child) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // EquiDistantRow(
                    //     playstatus: true,
                    //     feedbackstatus: false,
                    //     practicestatus: false),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Divider(
                    //   height: 1,
                    //   color: Color(0xffc1c1c1),
                    // ),
                    SizedBox(
                      height: 15.0,
                    ),
                    vm.apiHitStatus
                        ? vm.homePageModel.allGame == null
                        ? Center(
                      child: MyText(
                        text: 'No Game Found',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                        : ListView.builder(
                        itemCount: vm.homePageModel.allGame!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var data = vm.homePageModel.allGame![index];
                          Color containerColor = (index % 2 == 0)
                              ? Color(0xffd3e2f5)
                              : Color(0xffe4d7f1);

                          return Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final bool? res =
                                  await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                YoutubeVideoPlayerScreen(
                                                  vm.homePageModel,
                                                  index,
                                                  Uuid().v4(),
                                                  widget.gameName,
                                                )));

                                  // await Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             PlayTabooScreen(
                                  //               vm.homePageModel,
                                  //               index,
                                  //               Uuid().v4(),
                                  //               widget.gameName,
                                  //             )));
                                  if (res == true) {
                                    timerFunction();

                                  }
                                },
                                child: Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.9,
                                    decoration: BoxDecoration(
                                        color: containerColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                          vertical: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data.mainContent}",
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w800,
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "#${data.level}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                Color(0xff646464),
                                                fontWeight:
                                                FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          );
                        }).expand()
                        : SizedBox()
                  ],
                );
              },
            ),
            Observer(
              builder: (context) {
                // Show the custom Loader based on appStore.isLoading
                return Loader().center().visible(appStore.isLoading);
              },
            ),
          ],
        ),
      ),
    );

  }
}
