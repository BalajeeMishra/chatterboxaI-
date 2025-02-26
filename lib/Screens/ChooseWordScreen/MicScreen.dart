import 'dart:async';

import 'package:balajiicode/Widget/text_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../Utils/app_colors.dart';
import '../../Widget/text_widget.dart';
import 'PlayTabooScreen.dart';

class AnimatedMicUI extends StatefulWidget {
  @override
  _AnimatedMicUIState createState() => _AnimatedMicUIState();
}

class _AnimatedMicUIState extends State<AnimatedMicUI> {
  bool isExpanded = false;
  bool isLocked = false;
  bool isshowHistoryAndSubtitle = true;
  bool isSwipingLeft = false;
  bool isSwipingUp = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double widthFactor = width / 390;
    double heightFactor = height / 844;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(
        children: [
          Expanded(child: SizedBox()),
          if(isLocked) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 115*heightFactor,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300, // Light gray background
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: TextField(
                maxLines: null,
                style: TextStyle(
                  fontFamily: "inter",
                  fontSize: 16
                ),

                decoration: InputDecoration(
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  hintText: "Spoken words here...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    // borderSide: BorderSide(color: Colors.grey[600]!, width: 2),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                    // borderSide: BorderSide(color: Colors.blue, width: 2), // Blue when active
                  ),

                ),
              ),
            ),
          ),

          Container(
            height: (!isExpanded)?height * (156 / 812) : height * .28,
            width: double.infinity,
            // height: height * (156 / 812),
            color: Colors.grey,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isLocked)
                  Positioned(
                    bottom: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            // width: width * (81 / 375),
                            // height: height * (55 / 812),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 36 ,
                                ),
                                MyText(
                                  text: "Delete",
                                  fontSize: 12,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * .5,
                        ),
                        GestureDetector(
                          // onTap: () async {
                          //   setState(() {
                          //     showSubtitle = !showSubtitle;
                          //   });
                          // },
                          child: Container(
                            // width:72,
                            // height:60,
                            // width: width * (81 / 375),
                            // height: height * (52 / 812),


                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Colors.purple,Colors.cyan]),
                                      borderRadius: BorderRadius.circular(18)
                                    ),
                                    child: Center(
                                      child: IconButton(onPressed: (){ setState(() {
                                        isExpanded = false;
                                        isLocked = false;
                                        isshowHistoryAndSubtitle = true;
                                      });}, icon: Icon(Icons.send),color: Colors.white,),
                                    ),
                                  ),
                                  MyText(
                                    text: "Send",
                                    fontSize: 12,
                                    color: Colors.black

                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                Positioned(
                  bottom: 15,
                  child: GestureDetector(
                    onTap: isLocked
                        ? null
                        : () {
                            setState(() {
                              isExpanded = true;
                              isshowHistoryAndSubtitle = false;
                            });
                            Timer(Duration(milliseconds: 300), () {
                              setState(() {
                                isExpanded = false;
                                isshowHistoryAndSubtitle = true;
                              });
                            });
                          },
                    onLongPress: () => setState(() {
                      isExpanded = true;
                      isshowHistoryAndSubtitle = false;
                    }),
                    onLongPressEnd: (details) {
                      if (details.localPosition.dy < -50) {
                        setState(() {
                          isSwipingUp = true;
                        });
                        Future.delayed(Duration(milliseconds: 2000));
                        setState(() {
                          print("Called");
                          isLocked = true;
                          isExpanded = false;
                          isshowHistoryAndSubtitle = false;
                          isSwipingUp = false;
                        });
                      } else {
                        setState(() {
                          isExpanded = false;
                          isshowHistoryAndSubtitle = true;
                        });
                      }
                    },
                    child: (isExpanded || isLocked)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.cyan
                                    ], // Gradient Colors
                                  ),
                                ),
                                child: Icon(
                                  Icons.keyboard_voice,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              MyText(
                                text: "Speak",
                                fontSize: 12,
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0XFFe0ddf5),
                                ),
                                child: Icon(
                                  Icons.keyboard_voice,
                                  size: 50,
                                  color: primaryColor,
                                ),
                              ),
                              MyText(
                                text: "Speak",
                                fontSize: 12,
                              )
                            ],
                          ),

                    // AnimatedContainer(
                    //   duration: Duration(milliseconds: 300),
                    //   height: isExpanded ? 100 : 70,
                    //   width: isExpanded ? 100 : 70,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: Icon(Icons.mic, color: Colors.white, size: 40),
                    // ),
                  ),
                ),
                if (isExpanded)
                  Positioned(
                    top: 0,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSwipingUp ? Colors.blue : Colors.grey.shade300,
                          ),
                          child: CircleAvatar(
                              child: Icon(Icons.lock, color: isSwipingUp ? Colors.white : Colors.black),
                              radius: 15,
                          ),
                        ),
                        Text("Lock", style: TextStyle(color: Colors.black)),
                        Icon(Icons.keyboard_arrow_up,
                                color: Colors.grey.shade300, size: 40)
                            .animate()
                            .slideY(begin: 0.5, end: 0, duration: 500.ms),
                        Text("Release To Send",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ).animate().fadeIn(duration: 300.ms),
                  ),
                if (isExpanded)
                  Positioned(
                    left: 40,
                    bottom: 35,
                    child: Container(
                      // width: width * (81 / 375),
                      // height: height * (55 / 812),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSwipingLeft ? Colors.blue : Colors.transparent,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    size: 37,
                                    color: isSwipingLeft ? Colors.white : Colors.black,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_left,
                                    color: Colors.grey.shade300, size: 40)
                                    .animate()
                                    .slideX(begin: 0.5, end: 0, duration: 500.ms),
                              ],
                            ),

                            MyText(
                              text: "Discard",
                              fontSize: 12,
                            ),
                          ]),
                    ).animate().fadeIn(duration: 300.ms),
                  ),
                if (isshowHistoryAndSubtitle)
                  Positioned(
                    bottom: 34,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          // onTap: () async {
                          //   analytics.logEvent(
                          //     name: 'write',
                          //     parameters: {
                          //       'content_name': widget
                          //           .allGameModel
                          //           .allGame![widget.index]
                          //           .mainContent
                          //           .toString(),
                          //       'Game_name': widget.gameName,
                          //       'User_id':
                          //       getStringAsync(USER_ID),
                          //     },
                          //   ).then((_) {
                          //     print(
                          //         'Logged event: write with parameters:');
                          //   }).catchError((error) {
                          //     print(
                          //         'Failed to log event: $error');
                          //   });
                          //   facebookAppEvents.logEvent(
                          //     name: 'write',
                          //     parameters: {
                          //       'content_name': widget
                          //           .allGameModel
                          //           .allGame![widget.index]
                          //           .mainContent
                          //           .toString(),
                          //       'Game_name': widget.gameName,
                          //       'User_id':
                          //       getStringAsync(USER_ID),
                          //     },
                          //   ).then((_) {
                          //     print(
                          //         'Logged event: write with parameters:');
                          //   }).catchError((error) {
                          //     print(
                          //         'Failed to log event: $error');
                          //   });
                          //   stopSpeaking();
                          //   final bool res =
                          //   await TaboogamechatPage(
                          //       widget.allGameModel,
                          //       widget.index,
                          //       widget.sessionId,
                          //       widget.gameName)
                          //       .launch(context);
                          //   if (res == true) {
                          //     allConversationApiCall();
                          //     if (isMuted) {
                          //       stopSpeaking();
                          //     }
                          //   } else {}
                          // },
                          child: Container(
                            // width: width * (81 / 375),
                            // height: height * (55 / 812),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  size: 35,
                                ),
                                MyText(
                                  text: "History",
                                  fontSize: 12,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * .5,
                        ),
                        GestureDetector(
                          // onTap: () async {
                          //   setState(() {
                          //     showSubtitle = !showSubtitle;
                          //   });
                          // },
                          child: Container(
                            // width:72,
                            // height:60,
                            // width: width * (81 / 375),
                            // height: height * (55 / 812),
                            // color:Colors.red,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    showSubtitle
                                        ? Icons.subtitles_off
                                        : Icons.subtitles,
                                    size: 35,
                                    color: showSubtitle
                                        ? Colors.black
                                        : Colors.blue,
                                  ),
                                  MyText(
                                    text: showSubtitle
                                        ? "Show Subtitle"
                                        : "Hide Subtitle",
                                    fontSize: 12,
                                    color: showSubtitle
                                        ? Colors.black
                                        : Colors.blue,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
