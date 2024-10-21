import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/ImageConstant.dart';
import '../../Constants/constantRow.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_images.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../Widget/appbar.dart';
import '../../Widget/text_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../Model/AllGameModel.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';
import "./PlayTabooScreen.dart";
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class PlayTabooScreenTwo extends StatefulWidget {
  AllGameModel allGameModel;
  int index;
  String dataGet;
  String sessionId;
  PlayTabooScreenTwo(
      this.allGameModel, this.index, this.dataGet, this.sessionId);

  @override
  State<StatefulWidget> createState() => _PlayTabooScreenTwo();
}

class _PlayTabooScreenTwo extends State<PlayTabooScreenTwo> {
  // String data =
  //     "After performing these steps, your project should compile successfully. If the issue persists, consider looking for any other plugins or modules that might have version conflicts, or consult the plugin's issue tracker for any related discussions.";

  bool startListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool donebuttonClicked = false;
  String sessionId = "";

  double speechRate = 0.4;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false; // Flag to track if speech is active

  @override
  void initState() {
    super.initState();
    print("hello");
    // TODO: implement initState
    super.initState();
    configureTts();
    flutterTts.setStartHandler(() {
      print("TTS Started");
    });
    flutterTts.setCompletionHandler(() {
      print("TTS Completed");
    });
    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .chatPageAPI(context, widget.dataGet, widget.sessionId);
    configureTts();
    _initSpeech();
  }

  /// Initialize speech recognition
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      setState(() {
        startListening = true;
      });
      _startListening();
    }
  }

  /// Start speech listening
  void _startListening() async {
    await _speechToText.listen(
        localeId: 'en_US', // e.g., 'en_US'
        onResult: _onSpeechResult);
    setState(() {});
  }

  /// Stop listening to speech
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      startListening = false;
    });
  }

  /// Process speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    // Optionally speak the recognized words immediately or on another trigger
    // speakText(_lastWords);
  }

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(speechRate);
    // Get and set available voices
  List<dynamic> voices = await flutterTts.getVoices;
  print(voices);
  print("hello world okayyy");
  }


  /// Speak text with TTS
  Future<void> speakText(String text) async {
    if (text.isNotEmpty) {
      _lastWords = text; // Update the last words
      await flutterTts.speak(text); // Speak the text
      print("Speaking: $text"); // Log what is being spoken
    } else {
      print("No text provided to speak.");
    }
  }


  // Future<void> speakText(String text) async {
  //   if (isSpeaking) {
  //     await flutterTts.stop(); // Stop ongoing speech
  //   }
  //   isSpeaking = true;
  //   await flutterTts.setSpeechRate(speechRate); // Set the new speech rate
  //   await flutterTts.speak(text); // Start speaking
  //   isSpeaking = false;
  // }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  /// Submit and call next function
  submitNext(String ques) async {
    isSpeaking = true;
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(ques);
    isSpeaking = false;
  }

  // void adjustTtsSpeechRate(double change) {
  //   setState(() {
  //     speechRate += change;
  //     if (speechRate < 0.1) speechRate = 0.1;
  //     if (speechRate > 2.0) speechRate = 2.0;
  //   });
  //   flutterTts.setSpeechRate(speechRate);
  // }
  // Future<void> adjustSpeechRate(double change) async {
  //   print("Adjusting Speech Rate by: $change");
  //   setState(() {
  //     speechRate += change;
  //   });
  //
  //   print("New Speech Rate: $speechRate");
  //
  //   await flutterTts.setSpeechRate(speechRate);
  //   // Log if speaking
  //   if (_lastWords.isNotEmpty) {
  //     print("Re-speaking last words with new rate");
  //     await speakText(_lastWords);
  //   }
  // }

  Future<void> adjustSpeechRate(double change) async {
    // Print the change for debugging purposes
    print("Adjusting Speech Rate by: $change");

    // Update the state with the new speech rate
    setState(() {
      speechRate += change;
      // Clamp the speech rate to prevent it from going out of bounds
      speechRate = speechRate.clamp(0.1, 1.0); // Example clamp between 0.1 and 1.0
    });

    // Log the new speech rate
    print("New Speech Rate: $speechRate");

    // Set the new speech rate for the TTS
    await flutterTts.setSpeechRate(speechRate);

    // Check if there's new text to speak
    if (_lastWords.isNotEmpty) {
      print("Last words before adjustment: $_lastWords");
      // Only re-speak the last words if it's appropriate
      await speakText(_lastWords);
    } else {
      print("No text to speak after rate adjustment.");
    }
  }


  _onIncreaseRatePressed() {
    adjustSpeechRate(0.1);
  }

   _onDecreaseRatePressed() {
    adjustSpeechRate(-0.1);
  }

  // increaseSpeechRate() async {
  //   if (speechRate < 2.0) {
  //     // Increase speech rate
  //     setState(() {
  //       speechRate += 0.1; // Increase speech rate
  //     });
  //
  //     await flutterTts.setSpeechRate(speechRate); // Just update the speech rate
  //
  //     print("Increased Speech Rate: $speechRate");
  //   }
  // }
  //
  // decreaseSpeechRate() async {
  //   if (speechRate > 0.1) {
  //     // Decrease speech rate
  //     setState(() {
  //       speechRate -= 0.1; // Decrease speech rate
  //     });
  //
  //     await flutterTts.setSpeechRate(speechRate); // Just update the speech rate
  //
  //     print("Decreased Speech Rate: $speechRate");
  //   }
  // }

  // void testTtsWithNewRate() async {
  //   await flutterTts.speak("This is a test of the speech rate.");
  // }

  @override
  void dispose() {
    super.dispose();
    stopSpeaking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backCustomAppBar(
          backButtonshow: true,
          centerTile: false,
          onPressed: () {
            Navigator.pop(context);
          },
          title: "Taboo1"),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                EquiDistantRow(
                    playstatus: true,
                    feedbackstatus: false,
                    practicestatus: false),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xffc1c1c1),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.fast_rewind),
                      onPressed: () => _onDecreaseRatePressed(), // Decrease speech rate
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(27),
                      child: Image.asset(
                          fit: BoxFit.cover,
                          height: 195,
                          width: 246,
                          ic_transparent_girlImage2),
                    ),
                    IconButton(
                      icon: Icon(Icons.fast_forward),
                      onPressed: () => _onIncreaseRatePressed(), // Increase speech rate
                    ),
                  ],
                ).paddingOnly(left: 10, right: 10),
                SizedBox(
                  height: 15,
                ),
                Consumer<PlayTabooScreenVM>(
                  builder: (context, vm, child) {
                    return vm.tabooGameChatPageModel.response == null
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: startListening
                                      ? MyText(
                                          text: _lastWords,
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        )
                                      : (vm.tabooGameChatPageModel.response!
                                                      .aiResponse!.last ==
                                                  null ||
                                              vm
                                                      .tabooGameChatPageModel
                                                      .response!
                                                      .aiResponse!
                                                      .last ==
                                                  "")
                                          ? Text("")
                                          : Text(vm.tabooGameChatPageModel
                                              .response!.aiResponse!.last),
                                )
                              ],
                            ),
                          );
                  },
                )
              ],
            ),
          ),
          Center(
            child: startListening
                ? listeningWidget()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          sessionId = Uuid().v4();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaboogamechatPage(
                                      widget.allGameModel,
                                      widget.index,
                                      sessionId)));
                        },
                        child: Column(
                          children: [
                            Image(image: AssetImage(ImageConstant.chatIcon)),
                            MyText(
                              text: "Write",
                              fontSize: 12,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          Provider.of<PlayTabooScreenVM>(context, listen: false)
                              .clearAiResponse();
                          _initSpeech();
                          await stopSpeaking();
                        },
                        child: Column(
                          children: [
                            Image(
                                image:
                                    AssetImage(ImageConstant.microphoneIcon)),
                            MyText(
                              text: "Speak",
                              fontSize: 12,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  listeningWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _stopListening();
              setState(() {
                _lastWords = "";
                startListening = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                size: 24,
                Icons.close,
                color: Colors.white,
              ),
            ),
          ).paddingTop(50),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: startListening
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottiefile/recordaudio.json',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  // Lottie.asset(
                  //   'assets/lottiefile/recordaudio.json',
                  //   height: 60,
                  //   fit: BoxFit.contain,
                  // ),
                ],
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(ImageConstant.pitch1),
                  height: 50,
                ),
                SizedBox(width: 5),
                Image(
                  image: AssetImage(ImageConstant.pitch2),
                  height: 50,
                ),
                SizedBox(width: 5),
                Image(
                  image: AssetImage(ImageConstant.pitch3),
                  height: 50,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: GestureDetector(
              onTap: () {
                _stopListening();
                if (_lastWords.isNotEmpty) {
                  submitNext(_lastWords);
                }
                setState(() {
                  startListening = false;
                  _lastWords = "";
                });
              },
              child:  Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  size: 24,
                  Icons.send,
                  color: Colors.white,
                ),
              ),),
          )
        ],
      ).paddingSymmetric(horizontal: 30),
    );
  }
}
