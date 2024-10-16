import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/ImageConstant.dart';
import '../../Constants/constantRow.dart';
import '../../Model/AllGameModel.dart';
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

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      setState(() {
        startListening = true;
      });
      _startListening();
    }
  }

  // Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        localeId: 'en_US', // e.g., 'en_US'
        onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      startListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configureTts();
    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .chatPageAPI(context, widget.dataGet, widget.sessionId);
  }

  void submitNext(String ques) {
    configureTts();
    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .chatPageAPI(context, ques, widget.sessionId);
  }

  startSpeaking() {
    Future.delayed(Duration(seconds: 2), () {
      speakText("${widget.dataGet}");
    });
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  // void stopSpeaking() async {
  //   await flutterTts.stop();
  // }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                InkWell(
                  onTap: () {},
                  child: Image(image: AssetImage(ImageConstant.girlsImage)),
                ),
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
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: InkWell(
              onTap: () {
                _stopListening();
                setState(() {
                  _lastWords = "";
                });
              },
              child: Image(image: AssetImage(ImageConstant.IconCancel)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          startListening
              ? Expanded(
                  child: Lottie.asset('assets/lottiefile/recordaudio.json'),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Row(
                    children: [
                      Image(image: AssetImage(ImageConstant.pitch1)),
                      Image(image: AssetImage(ImageConstant.pitch2)),
                      Image(image: AssetImage(ImageConstant.pitch3)),
                    ],
                  ),
                ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: InkWell(
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
              child: Image(image: AssetImage(ImageConstant.doneButton)),
            ),
          )
        ],
      ),
    );
  }
}
