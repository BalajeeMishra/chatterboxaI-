// import 'package:balajiicode/components/loader_widget_new.dart';
// import 'package:balajiicode/extensions/app_text_field.dart';
// import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
// import 'package:balajiicode/extensions/system_utils.dart';
// import 'package:balajiicode/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:provider/provider.dart';
//
// import '../../Constants/ImageConstant.dart';
// import '../../Constants/constantRow.dart';
// import '../../Model/AllGameModel.dart';
// import '../../Utils/app_colors.dart';
// import '../../Utils/app_images.dart';
// import '../../ViewModel/PlayTabooScreenVM.dart';
// import '../../Widget/appbar.dart';
// import '../../Widget/text_widget.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../../Model/AllGameModel.dart';
// import '../TabooGameChatpage/TaboogamechatPage.dart';
// import "./PlayTabooScreen.dart";
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:lottie/lottie.dart';
// import 'package:uuid/uuid.dart';
//
// class PlayTabooScreenTwo extends StatefulWidget {
//   AllGameModel allGameModel;
//   int index;
//   String dataGet;
//   String sessionId;
//   PlayTabooScreenTwo(
//       this.allGameModel, this.index, this.dataGet, this.sessionId);
//
//   @override
//   State<StatefulWidget> createState() => _PlayTabooScreenTwo();
// }
//
// class _PlayTabooScreenTwo extends State<PlayTabooScreenTwo> {
//   // String data =
//   //     "After performing these steps, your project should compile successfully. If the issue persists, consider looking for any other plugins or modules that might have version conflicts, or consult the plugin's issue tracker for any related discussions.";
//
//   bool startListening = false;
//   SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   String _lastWords = '';
//   bool donebuttonClicked = false;
//   String sessionId = "";
//
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         message = 'Thinking your respond';
//       });
//     });
//
//     print("hello");
//     configureTts();
//     flutterTts.setStartHandler(() {
//       print("TTS Started");
//       setState(() {
//         isSpeaking = true;
//       });
//     });
//
//     flutterTts.setCompletionHandler(() {
//       print("TTS Completed");
//       setState(() {
//         isSpeaking = false; // Mark as not speaking when TTS completes
//       });
//     });
//
//     flutterTts.setErrorHandler((msg) {
//       print("TTS Error: $msg");
//       setState(() {
//         isSpeaking = false; // Reset speaking flag if an error occurs
//       });
//     });
//
//     Provider.of<PlayTabooScreenVM>(context, listen: false)
//         .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
//     Provider.of<PlayTabooScreenVM>(context, listen: false)
//         .chatPageAPI(context, widget.dataGet, widget.sessionId);
//     configureTts();
//
//     _lastWords = appStore.lastWords;
//     print("Last words is ==>" + _lastWords.toString());
//     // _initSpeech();
//   }
//
//   /// Initialize speech recognition
//   void _initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//     if (_speechEnabled) {
//       setState(() {
//         startListening = true;
//       });
//       _startListening();
//     }
//   }
//
//   /// Start speech listening
//   void _startListening() async {
//     await _speechToText.listen(
//         localeId: 'en_US', // e.g., 'en_US'
//         onResult: _onSpeechResult);
//     setState(() {});
//   }
//
//   /// Stop listening to speech
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       startListening = false;
//     });
//   }
//
//   /// Process speech result
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = result.recognizedWords;
//       print("Last word is something like that"+ _lastWords.toString());
//     });
//
//     // Optionally speak the recognized words immediately or on another trigger
//     // speakText(_lastWords);
//   }
//
//   Future<void> configureTts() async {
//     await flutterTts.setLanguage('en-US');
//     await flutterTts.setVolume(1.0);
//     await flutterTts.setSpeechRate(speechRate);
//   }
//
//   /// Speak text with TTS
//
//   Future<void> speakText(String text) async {
//     print("Speacl Test calling----");
//     if (text.isNotEmpty) {
//       print("TExts is not empty");
//       // Store the text to keep track of what is currently being spoken
//       _lastWords = text;
//
//       print("Text is ==>" + text.toString());
//       print("_lastWords is ==>" + _lastWords.toString());
//
//       // Start speaking the text
//       await flutterTts.speak(text);
//       print("_lastWords  is 2 ==>" + _lastWords.toString());
//       print("Text is 2 ==>" + text.toString());
//
//       isSpeaking = true;
//
//       // Set up a listener for TTS completion
//       flutterTts.setCompletionHandler(() {
//         // Reset speaking state when TTS finishes
//         isSpeaking = false;
//         _lastSpokenIndex = text.length; // Mark entire text as spoken
//       });
//
//       // Optional: You may want to add an error handler as well
//       flutterTts.setErrorHandler((error) {
//         isSpeaking = false; // Reset speaking state on error
//         print("Error in TTS: $error");
//       });
//     } else {
//       print("No text provided to speak.");
//     }
//   }
//
//   /// Stop speaking
//   Future<void> stopSpeaking() async {
//     await flutterTts.stop();
//   }
//
//   /// Submit and call next function
//   submitNext(String ques) async {
//     isSpeaking = true;
//     await flutterTts.setSpeechRate(speechRate);
//     await flutterTts.speak(ques);
//     isSpeaking = false;
//   }
//
//   Future<void> adjustSpeechRate(double change) async {
//     // Update the speech rate
//     speechRate += change;
//     speechRate = speechRate.clamp(0.1, 2.0); // Ensure rate stays in bounds
//
//     print("New Speech Rate: $speechRate");
//
//     // Set the new speech rate
//     await flutterTts.setSpeechRate(speechRate);
//
//     if (isSpeaking) {
//       print("Updating speech rate during ongoing speech");
//
//       // Stop the ongoing speech temporarily
//       await flutterTts.stop();
//       print("_lastWords ==>" + _lastWords.toString());
//
//       // Get remaining text to speak
//       String remainingText = _getRemainingText();
//
//       // Restart speaking from the remaining text with the updated rate
//       Future.delayed(Duration(milliseconds: 200), () async {
//         if (remainingText.isNotEmpty) {
//           print("Inside  Yes");
//           print("_lastWords ==>" + _lastWords.toString());
//           print("remainingText ==>" + remainingText.toString());
//
//           await flutterTts.setSpeechRate(speechRate); // Update speech rate
//           await speakText(remainingText); // Resume speaking from remaining text
//         }
//       });
//     } else {
//       print("BOOM");
//     }
//   }
//
//   String _getRemainingText() {
//     if (_lastSpokenIndex < _lastWords.length) {
//       print("_getRemainingText_lastWords ==>" + _lastWords.toString());
//       print("_getRemainingText_lastWords ==>" + _lastWords.length.toString());
//       print("_getRemainingText_lastWords ==>" + _lastSpokenIndex.toString());
//
//       return _lastWords
//           .substring(_lastSpokenIndex); // Remaining text to be spoken
//     }
//     return ''; // No remaining text
//   }
//
// // Increase and Decrease Speech Rate handlers
//   _onIncreaseRatePressed() {
//     adjustSpeechRate(0.1);
//   }
//
//   _onDecreaseRatePressed() {
//     adjustSpeechRate(-0.1);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     stopSpeaking();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         finish(context, true);
//
//         return true;
//       },
//       child:   Scaffold(
//         appBar: backCustomAppBar(
//             backButtonshow: true,
//             centerTile: false,
//             onPressed: () {
//               finish(context, true);
//             },
//             title: "Taboo1"),
//         body: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   EquiDistantRow(
//                       playstatus: true,
//                       feedbackstatus: false,
//                       practicestatus: false),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Divider(
//                     height: 1,
//                     color: Color(0xffc1c1c1),
//                   ),
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.fast_rewind),
//                         onPressed: () =>
//                             _onDecreaseRatePressed(), // Decrease speech rate
//                       ),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(27),
//                         child: Image.asset(
//                             fit: BoxFit.cover,
//                             height: 195,
//                             width: 246,
//                             ic_transparent_girlImage2),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.fast_forward),
//                         onPressed: () =>
//                             _onIncreaseRatePressed(), // Increase speech rate
//                       ),
//                     ],
//                   ).paddingOnly(left: 10, right: 10),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Consumer<PlayTabooScreenVM>(
//                     builder: (context, vm, child) {
//                       return vm.tabooGameChatPageModel.response == null
//                           ? LoadingWidget(
//                         message: message,
//                       )
//                           : Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: startListening
//                                   ? MyText(
//                                 text: _lastWords,
//                                 color: Color(0xff000000),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                               )
//                                   : (vm.tabooGameChatPageModel.response!
//                                   .aiResponse!.last ==
//                                   null ||
//                                   vm
//                                       .tabooGameChatPageModel
//                                       .response!
//                                       .aiResponse!
//                                       .last ==
//                                       "")
//                                   ? Text("")
//                                   : Text(vm.tabooGameChatPageModel
//                                   .response!.aiResponse!.last),
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 ],
//               ),
//             ),
//             Center(
//               child: startListening
//                   ? listeningWidget()
//                   : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       sessionId = Uuid().v4();
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => TaboogamechatPage(
//                                   widget.allGameModel,
//                                   widget.index,
//                                   sessionId)));
//                     },
//                     child: Column(
//                       children: [
//                         Image(image: AssetImage(ImageConstant.chatIcon)),
//                         MyText(
//                           text: "Write",
//                           fontSize: 12,
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       Provider.of<PlayTabooScreenVM>(context,
//                           listen: false)
//                           .clearAiResponse();
//                       _initSpeech();
//                       await stopSpeaking();
//                     },
//                     child: Column(
//                       children: [
//                         Image(
//                             image:
//                             AssetImage(ImageConstant.microphoneIcon)),
//                         MyText(
//                           text: "Speak",
//                           fontSize: 12,
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//
//     );
//   }
//   //
//   // listeningWidget() {
//   //   return Padding(
//   //     padding: EdgeInsets.symmetric(horizontal: 15),
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         GestureDetector(
//   //           onTap: () {
//   //             _stopListening();
//   //             setState(() {
//   //               _lastWords = "";
//   //               startListening = false;
//   //             });
//   //           },
//   //           child: Container(
//   //             padding: EdgeInsets.all(2),
//   //             decoration: BoxDecoration(
//   //               color: Colors.black,
//   //               shape: BoxShape.circle,
//   //             ),
//   //             child: Icon(
//   //               size: 24,
//   //               Icons.close,
//   //               color: Colors.white,
//   //             ),
//   //           ),
//   //         ).paddingTop(50),
//   //         SizedBox(
//   //           width: 10,
//   //         ),
//   //         Expanded(
//   //           child: startListening
//   //               ? Padding(
//   //                   padding: EdgeInsets.symmetric(vertical: 10.0),
//   //                   child: Row(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       Lottie.asset(
//   //                         'assets/lottiefile/recordaudio.json',
//   //                         height: 120,
//   //                         fit: BoxFit.contain,
//   //                       ),
//   //                       // Lottie.asset(
//   //                       //   'assets/lottiefile/recordaudio.json',
//   //                       //   height: 60,
//   //                       //   fit: BoxFit.contain,
//   //                       // ),
//   //                     ],
//   //                   ),
//   //                 )
//   //               : Row(
//   //                   mainAxisAlignment: MainAxisAlignment.center,
//   //                   children: [
//   //                     Image(
//   //                       image: AssetImage(ImageConstant.pitch1),
//   //                       height: 50,
//   //                     ),
//   //                     SizedBox(width: 5),
//   //                     Image(
//   //                       image: AssetImage(ImageConstant.pitch2),
//   //                       height: 50,
//   //                     ),
//   //                     SizedBox(width: 5),
//   //                     Image(
//   //                       image: AssetImage(ImageConstant.pitch3),
//   //                       height: 50,
//   //                     ),
//   //                   ],
//   //                 ),
//   //         ),
//   //         SizedBox(
//   //           width: 10,
//   //         ),
//   //         Padding(
//   //           padding: EdgeInsets.only(top: 50.0),
//   //           child: GestureDetector(
//   //             onTap: () {
//   //               _stopListening();
//   //               if (_lastWords.isNotEmpty) {
//   //                 submitNext(_lastWords);
//   //               }
//   //               setState(() {
//   //                 startListening = false;
//   //                 _lastWords = "";
//   //               });
//   //             },
//   //             child: Container(
//   //               padding: EdgeInsets.all(10),
//   //               decoration: BoxDecoration(
//   //                 color: primaryColor,
//   //                 shape: BoxShape.circle,
//   //               ),
//   //               child: Icon(
//   //                 size: 24,
//   //                 Icons.send,
//   //                 color: Colors.white,
//   //               ),
//   //             ),
//   //           ),
//   //         )
//   //       ],
//   //     ).paddingSymmetric(horizontal: 30),
//   //   );
//   // }
// }
