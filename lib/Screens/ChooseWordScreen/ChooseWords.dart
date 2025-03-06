import 'dart:async';

import 'package:balajiicode/Constants/shared_pref_constrants.dart';
import 'package:balajiicode/ShareAndReview/share_and_review.dart';
import 'package:balajiicode/ViewModel/PlayTabooScreenVM.dart';
import 'package:balajiicode/Widget/appbar.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../ViewModel/AllGameVm.dart';
import '../../components/tts.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/shared_pref.dart';
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

  @override
  void initState() {
    super.initState();
    Provider.of<AllGameVm>(context, listen: false).seInitialValue();
    Provider.of<AllGameVm>(context, listen: false)
        .allGamePageAPI(context, widget.dataId);

  }

  timerFunction() {
    print("Timer function calling");
    int elapsedSeconds = 0;
    const int maxDuration = 10;
    var vm = Provider.of<PlayTabooScreenVM>(context,listen: false);

    Timer.periodic(Duration(seconds: 2, milliseconds: 400),
        (Timer timer) async {
      elapsedSeconds++;
      if (userStore.isTTSPlaying == "YES") {
        print("Into iF");
        userStore.setTTSPlaying("NO");
        vm.setIsBreakLoop(true);
        await ttsManager.stop();
        await ttsManager.stopAndReset();
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: backCustomAppBar(
            backButtonshow: true,
            centerTile: false,
            onPressed: () {
              Navigator.pop(context,true);
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
              Consumer<PlayTabooScreenVM>(
               builder: (context,playVm,child)=>
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
                                              setValue(SESSION_ID, Uuid().v4());
                                               playVm.clearUint8list();
                                               playVm.talkingString = data.talkingCharacter ?? "";
                                               playVm.listeningString = data.listeningCharacter ?? "";
                                               if(playVm.talkingString != '' && playVm.listeningString !='') {
                                                 playVm.saveGifs();
                                               }

                                              final bool res =
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

                                              if (res == true) {
                                                await ttsManager.stopAndReset();
                                                timerFunction();
                                              }
                                              analytics.logEvent(
                                                name: 'content_selection',
                                                parameters: {
                                                  'content_name':
                                                      data.mainContent.toString(),
                                                  'Game_name': widget.gameName,
                                                  'User_id':
                                                      getStringAsync(USER_ID),
                                                  'days_since_install':
                                                      await InstallDateHelper
                                                          .getDaysSinceInstall()
                                                },
                                              ).then((_) {
                                                print(
                                                    'Logged event: content_selection with parameters:');
                                              }).catchError((error) {
                                                print(
                                                    'Failed to log event: $error');
                                              });
                                              facebookAppEvents.logEvent(
                                                name: 'content_selection',
                                                parameters: {
                                                  'content_name':
                                                      data.mainContent.toString(),
                                                  'Game_name': widget.gameName,
                                                  'User_id':
                                                      getStringAsync(USER_ID),
                                                  'days_since_install':
                                                      await InstallDateHelper
                                                          .getDaysSinceInstall()
                                                },
                                              ).then((_) {
                                                print(
                                                    'Logged event: content_selection with parameters:');
                                              }).catchError((error) {
                                                print(
                                                    'Failed to log event: $error');
                                              });
                                            },
                                            child:
                                            Container(
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width * 0.9,
                                                width: double.infinity,
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
                                                      MyText(
                                                       text:  "${data.mainContent}",
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: Colors.black,
                                                            fontSize: 20),

                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      MyText(
                                                        text: "#${data.level}",
                                                            fontSize: 14,
                                                            color:
                                                                Color(0xff646464),
                                                            fontWeight:
                                                                FontWeight.w400
                                                      )
                                                    ],
                                                  ),
                                                )).paddingSymmetric(horizontal: 16),
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
      ),
    );
  }
}
