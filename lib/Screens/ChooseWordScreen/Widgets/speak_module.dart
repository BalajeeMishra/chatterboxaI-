// import 'dart:async';
//
// import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Model/AllGameModel.dart';
// import '../../../Utils/app_colors.dart';
// import '../../../Utils/app_constants.dart';
// import '../../../ViewModel/PlayTabooScreenVM.dart';
// import '../../../Widget/text_widget.dart';
// import '../../../extensions/shared_pref.dart';
// import '../../../main.dart';
// import '../../../network/rest_api.dart';
// import '../../../stt/speech_service.dart';
// import '../../TabooGameChatpage/TaboogamechatPage.dart';
// import '../PlayTabooScreen.dart';
// //speaking
// bool isExpanded = false;
// bool isLocked = false;
// bool isshowHistoryAndSubtitle = true;
// bool isSwipingLeft = false;
// bool isSwipingUp = false;
// bool isKeyBoardOpen = false;
//
// class ShowSpeekAndListen extends StatefulWidget {
//   final double height;
//   final double width;
//   final double heightFactor;
//   final double keyboardHeight;
//   AllGameModel allGameModel;
//   int index;
//   String sessionId;
//   String gameName;
//    ShowSpeekAndListen({super.key,required this.index,required this.gameName,required this.sessionId, required this.allGameModel, required this.height, required this.width, required this.heightFactor, required this.keyboardHeight});
//
//   @override
//   State<ShowSpeekAndListen> createState() => _ShowSpeekAndListenState();
// }
//
// class _ShowSpeekAndListenState extends State<ShowSpeekAndListen> {
//   final SpeechToText _speech = SpeechToText();
//
//    @override
//   void initState() {
//     // TODO: implement initState
//      _speech.onResults.listen((result) {
//        setState(() {
//          if (result.text != null) {
//            lastWords = result.text!;
//            print(result.text!);
//          }
//
//        });
//      });
//   }
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         if (isLocked)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Container(
//               height: 115 * widget.heightFactor,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300, // Light gray background
//                 borderRadius: BorderRadius.circular(20), // Rounded corners
//               ),
//               child: TextField(
//                 maxLines: null,
//                 style: TextStyle(fontFamily: "inter", fontSize: 16),
//                 decoration: InputDecoration(
//                   fillColor: Colors.grey.shade300,
//                   filled: true,
//                   hintText: "Spoken words here...",
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(10),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       // borderSide: BorderSide(color: Colors.grey[600]!, width: 2),
//                       borderSide: BorderSide.none),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none
//                     // borderSide: BorderSide(color: Colors.blue, width: 2), // Blue when active
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         if(!(widget.keyboardHeight>0)) Container(
//           height: (!isExpanded) ? widget.height * (130 / 812) : widget.height * .28,
//           width: double.infinity,
//           // height: height * (156 / 812),
//           // color: Colors.grey,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               if (isLocked)
//                 Positioned(
//                   bottom: 40,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         child: Container(
//                           // width: width * (81 / 375),
//                           // height: height * (55 / 812),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.delete_outline,
//                                 size: 36,
//                               ),
//                               MyText(
//                                 text: "Delete",
//                                 fontSize: 12,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: widget.width * .5,
//                       ),
//                       GestureDetector(
//                         // onTap: () async {
//                         //   setState(() {
//                         //     showSubtitle = !showSubtitle;
//                         //   });
//                         // },
//                         child: Container(
//                           // width:72,
//                           // height:60,
//                           // width: width * (81 / 375),
//                           // height: height * (52 / 812),
//
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: 36,
//                                   height: 36,
//                                   decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                           colors: [Colors.purple, Colors.cyan]),
//                                       borderRadius: BorderRadius.circular(18)),
//                                   child: Center(
//                                     child: IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           isExpanded = false;
//                                           isLocked = false;
//                                           isshowHistoryAndSubtitle = true;
//                                         });
//                                       },
//                                       icon: Icon(Icons.send),
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 MyText(
//                                     text: "Send",
//                                     fontSize: 12,
//                                     color: Colors.black)
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ).animate().fadeIn(duration: 300.ms),
//               Positioned(
//                 bottom: 15,
//                 child: GestureDetector(
//                   onTap: isLocked
//                       ? null
//                       : () {
//                     setState(() {
//                       isExpanded = true;
//                       isshowHistoryAndSubtitle = false;
//                     });
//                     Timer(Duration(milliseconds: 300), () {
//                       setState(() {
//                         isExpanded = false;
//                         isshowHistoryAndSubtitle = true;
//                       });
//                     });
//                   },
//                   onLongPress: () => setState(() {
//                     isExpanded = true;
//                     isshowHistoryAndSubtitle = false;
//                     _startListening();
//                   }),
//                   onLongPressEnd: (details) {
//                     if (details.localPosition.dy < -50) {
//                       setState(() {
//                         isSwipingUp = true;
//                       });
//                       Future.delayed(Duration(milliseconds: 2000));
//                       setState(() {
//                         print("Called");
//                         isLocked = true;
//                         isExpanded = false;
//                         isshowHistoryAndSubtitle = false;
//                         isSwipingUp = false;
//                       });
//                     } else {
//                       setState(() {
//                         isExpanded = false;
//                         isshowHistoryAndSubtitle = true;
//                       });
//                     }
//                   },
//                   child: (isExpanded || isLocked)
//                       ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.purple,
//                               Colors.cyan
//                             ], // Gradient Colors
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.keyboard_voice,
//                           size: 50,
//                           color: Colors.white,
//                         ),
//                       ),
//                       MyText(
//                         text: "Speak",
//                         fontSize: 12,
//                       )
//                     ],
//                   )
//                       : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           color: Color(0XFFe0ddf5),
//                         ),
//                         child: Icon(
//                           Icons.keyboard_voice,
//                           size: 50,
//                           color: primaryColor,
//                         ),
//                       ),
//                       MyText(
//                         text: "Speak",
//                         fontSize: 12,
//                       )
//                     ],
//                   ),
//
//                   // AnimatedContainer(
//                   //   duration: Duration(milliseconds: 300),
//                   //   height: isExpanded ? 100 : 70,
//                   //   width: isExpanded ? 100 : 70,
//                   //   decoration: BoxDecoration(
//                   //     gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
//                   //     shape: BoxShape.circle,
//                   //   ),
//                   //   child: Icon(Icons.mic, color: Colors.white, size: 40),
//                   // ),
//                 ),
//               ),
//               if (isExpanded)
//                 Positioned(
//                   top: 0,
//                   child: Column(
//                     children: [
//                       AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color:
//                           isSwipingUp ? Colors.blue : Colors.grey.shade300,
//                         ),
//                         child: CircleAvatar(
//                           child: Icon(Icons.lock,
//                               color: isSwipingUp ? Colors.white : Colors.black),
//                           radius: 15,
//                         ),
//                       ),
//                       Text("Lock", style: TextStyle(color: Colors.black)),
//                       Icon(Icons.keyboard_arrow_up,
//                           color: Colors.grey.shade300, size: 40)
//                           .animate()
//                           .slideY(begin: 0.5, end: 0, duration: 500.ms),
//                       Text("Release To Send",
//                           style: TextStyle(color: Colors.black)),
//                     ],
//                   ).animate().fadeIn(duration: 300.ms),
//                 ),
//               if (isExpanded)
//                 Positioned(
//                   left: 30,
//                   bottom: 35,
//                   child: Container(
//                     // width: width * (81 / 375),
//                     // height: height * (55 / 812),
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               AnimatedContainer(
//                                 duration: Duration(milliseconds: 300),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: isSwipingLeft
//                                       ? Colors.blue
//                                       : Colors.transparent,
//                                 ),
//                                 child: Icon(
//                                   Icons.delete,
//                                   size: 37,
//                                   color: isSwipingLeft
//                                       ? Colors.white
//                                       : Colors.black,
//                                 ),
//                               ),
//                               Icon(Icons.keyboard_arrow_left,
//                                   color: Colors.grey.shade300, size: 40)
//                                   .animate()
//                                   .slideX(begin: 0.5, end: 0, duration: 500.ms),
//                             ],
//                           ),
//                           MyText(
//                             text: "Discard",
//                             fontSize: 12,
//                           ),
//                         ]),
//                   ).animate().fadeIn(duration: 300.ms),
//                 ),
//               if (isshowHistoryAndSubtitle)
//                 Positioned(
//                   bottom: 34,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           analytics.logEvent(
//                             name: 'write',
//                             parameters: {
//                               'content_name': widget.allGameModel
//                                   .allGame![widget.index].mainContent
//                                   .toString(),
//                               'Game_name': widget.gameName,
//                               'User_id': getStringAsync(USER_ID),
//                             },
//                           ).then((_) {
//                             print('Logged event: write with parameters:');
//                           }).catchError((error) {
//                             print('Failed to log event: $error');
//                           });
//                           facebookAppEvents.logEvent(
//                             name: 'write',
//                             parameters: {
//                               'content_name': widget.allGameModel
//                                   .allGame![widget.index].mainContent
//                                   .toString(),
//                               'Game_name': widget.gameName,
//                               'User_id': getStringAsync(USER_ID),
//                             },
//                           ).then((_) {
//                             print('Logged event: write with parameters:');
//                           }).catchError((error) {
//                             print('Failed to log event: $error');
//                           });
//                           stopSpeaking();
//                           final bool res = await TaboogamechatPage(
//                               widget.allGameModel,
//                               widget.index,
//                               widget.sessionId,
//                               widget.gameName)
//                               .launch(context);
//                           if (res == true) {
//                             allConversationApiCall();
//                             if (isMuted) {
//                               stopSpeaking();
//                             }
//                           } else {}
//                         },
//                         child: Container(
//                           width: width * (81 / 375),
//                           height: height * (55 / 812),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.chat,
//                                 size: 35,
//                               ),
//                               MyText(
//                                 text: "History",
//                                 fontSize: 12,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: width * .5,
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           setState(() {
//                             showSubtitle = !showSubtitle;
//                           });
//                         },
//                         child: Container(
//                           // width:72,
//                           // height:60,
//                           width: width * (81 / 375),
//                           height: height * (55 / 812),
//                           // color:Colors.red,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   showSubtitle
//                                       ? Icons.subtitles_off
//                                       : Icons.subtitles,
//                                   size: 35,
//                                   color:
//                                   showSubtitle ? Colors.black : Colors.blue,
//                                 ),
//                                 MyText(
//                                   text: showSubtitle
//                                       ? "Show Subtitle"
//                                       : "Hide Subtitle",
//                                   fontSize: 12,
//                                   color:
//                                   showSubtitle ? Colors.black : Colors.blue,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> allConversationApiCall() async {
//     appStore.setLoading(true);
//     setValue(IS_MUTE, isMuted);
//
//     await allConversationApi(widget.sessionId).then((value) async {
//       appStore.setLoading(false);
//
//       if (value.completeConversation != null) {
//         apiCalled = true;
//
//         Provider.of<PlayTabooScreenVM>(context, listen: false)
//             .updateResponse(value.completeConversation!);
//       } else {}
//     }).catchError((e) {
//       appStore.setLoading(false);
//       // toast(e.toString());
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   void _startListening() async {
//     print("called");
//     final hasPermission = await _speech.startListening();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Microphone permission not granted')),
//       );
//     }
//
//   }
//
//   void _stopListening() {
//     _speech.stopListening();
//   }
//   Future<void> stopSpeaking() async {
//     var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
//     print("Called stop speaking");
//     vm.setIsListening(true);
//     vm.setIsBreakLoop(true);
//     await ttsManager.stop();
//   }
//
//
// }
//
//
