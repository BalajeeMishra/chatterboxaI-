import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_images.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../Widget/appbar.dart';
import '../../components/loader_widget_new.dart';
import '../../main.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';
import 'package:uuid/uuid.dart';

class PlayTabooScreen extends StatefulWidget {
  AllGameModel allGameModel;
  int index;

  PlayTabooScreen(this.allGameModel, this.index);

  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();
}

class _PlayTabooScreen extends State<PlayTabooScreen> {
  bool startListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String ques = "";
  String sessionId = "";
  bool isLoading = false;
  bool apiCalled = false;

  //Screen2 data
  double speechRate = 0.4;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  String message = '';
  int _lastSpokenIndex = 0;

  @override
  void initState() {
    super.initState();
    appStore.setLoading(false);
    startListening = false;
    print("at Init time session id is==>" + Uuid().v4());
    setState(() {});
  }

  save() {
    message = 'Correcting Speech recognition mistakes';
    isLoading = true;
    print("Save  Function Called");
    flutterTts.setStartHandler(() {
      print("TTS Started");
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      print("TTS Completed");
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      setState(() {
        isSpeaking = false;
      });
    });

    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .seInitialValue(widget.allGameModel, widget.index, sessionId);
    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .chatPageAPI(context, ques, sessionId);
    configureTts();
    apiCalled = true;
    _lastWords = appStore.lastWords;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = 'Thinking your respond';
      });
    });

  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      setState(() {
        startListening = true;
      });
      _startListening();
      stopSpeaking();
    }
  }

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
      print("Last word is something like that" + _lastWords.toString());
    });
  }

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(speechRate);
    isSpeaking =  true;
  }

  /// Speak text with TTS

  Future<void> speakText(String text) async {
    print("Speacl Test calling----");
    if (text.isNotEmpty) {
      print("TExts is not empty");
      _lastWords = text;

      print("Text is ==>" + text.toString());
      print("_lastWords is ==>" + _lastWords.toString());

      await flutterTts.speak(text);
      print("_lastWords  is 2 ==>" + _lastWords.toString());
      print("Text is 2 ==>" + text.toString());

      isSpeaking = true;


      flutterTts.setCompletionHandler(() {
        isSpeaking = false;
        _lastSpokenIndex = text.length;
      });

      flutterTts.setErrorHandler((error) {
        isSpeaking = false;
        print("Error in TTS: $error");
      });
    } else {
      print("No text provided to speak.");
    }
  }

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

  Future<void> adjustSpeechRate(double change) async {
    speechRate += change;
    speechRate = speechRate.clamp(0.1, 2.0);

    print("New Speech Rate: $speechRate");

    await flutterTts.setSpeechRate(speechRate);

    if (isSpeaking) {
      print("Updating speech rate during ongoing speech");

      await flutterTts.stop();
      print("_lastWords ==>" + _lastWords.toString());

      String remainingText = _getRemainingText();

      Future.delayed(Duration(milliseconds: 200), () async {
        if (remainingText.isNotEmpty) {
          print("Inside  Yes");
          print("_lastWords ==>" + _lastWords.toString());
          print("remainingText ==>" + remainingText.toString());

          await flutterTts.setSpeechRate(speechRate);
          await speakText(remainingText);
        }
      });
    } else {
      print("BOOM");
    }
  }

  String _getRemainingText() {
    if (_lastSpokenIndex < _lastWords.length) {
      print("_getRemainingText_lastWords ==>" + _lastWords.toString());
      print("_getRemainingText_lastWords ==>" + _lastWords.length.toString());
      print("_getRemainingText_lastWords ==>" + _lastSpokenIndex.toString());

      return _lastWords
          .substring(_lastSpokenIndex);
    }
    return '';
  }

  _onIncreaseRatePressed() {
    adjustSpeechRate(0.1);
  }

  _onDecreaseRatePressed() {
    adjustSpeechRate(-0.1);
  }

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
          title: "Taboo"),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment:!apiCalled ? MainAxisAlignment.center: MainAxisAlignment.spaceBetween,
                          children: [
                          if(apiCalled)  IconButton(
                              icon: Icon(Icons.fast_rewind),
                              onPressed: () =>
                                  _onDecreaseRatePressed(),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: Image.asset(
                                  fit: BoxFit.cover,
                                  height: 195,
                                  width: 246,
                                  ic_transparent_girlImage2),
                            ),
                          if(apiCalled)  IconButton(
                              icon: Icon(Icons.fast_forward),
                              onPressed: () =>
                                  _onIncreaseRatePressed(), // Increase speech rate
                            ),
                          ],
                        ).paddingOnly(left: 10, right: 10),
                        SizedBox(
                          height: 15,
                        ),
                        if (!apiCalled)
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: "Your Word:",
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text:
                                            '\"${widget.allGameModel.allGame![widget.index].mainContent}"',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: "Taboo Words:",
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: ListView.builder(
                                      itemCount: widget
                                          .allGameModel
                                          .allGame![widget.index]
                                          .detailOfContent!
                                          .length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        var data = widget
                                            .allGameModel
                                            .allGame![widget.index]
                                            .detailOfContent![index];
                                        return MyText(
                                          text: '${data},',
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: "Go ahead and give your clue!",
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: _lastWords,
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (apiCalled)
                          Consumer<PlayTabooScreenVM>(
                            builder: (context, vm, child) {
                              return vm.tabooGameChatPageModel.response == null
                                  ? LoadingWidget(
                                      message: message,
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
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
                                                : (vm
                                                                .tabooGameChatPageModel
                                                                .response!
                                                                .aiResponse!
                                                                .last ==
                                                            null ||
                                                        vm
                                                                .tabooGameChatPageModel
                                                                .response!
                                                                .aiResponse!
                                                                .last ==
                                                            "")
                                                    ? Text("")
                                                    : Text(vm
                                                        .tabooGameChatPageModel
                                                        .response!
                                                        .aiResponse!
                                                        .last),
                                          )
                                        ],
                                      ),
                                    );
                            },
                          )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: startListening
                      ? listeningWidget()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
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
                                  Icon(
                                    Icons.chat,
                                    size: 36,
                                  ),
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
                            GestureDetector(
                              onTap: () {
                                _initSpeech();
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.keyboard_voice,
                                    size: 36,
                                  ),
                                  MyText(
                                    text: "Speak",
                                    fontSize: 12,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  listeningWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(width: 10),
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
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _stopListening();

                ques = _lastWords;

                setState(() {
                  _lastWords = "";
                });
                if (ques.isNotEmpty) {
                  sessionId = Uuid().v4();
                  save();
                }
                //
                //   // _navigateToSecondScreen();
                // }
              },
              child: Container(
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
              ),
            ).paddingTop(46),
          ],
        ).paddingSymmetric(horizontal: 30),
      ),
    );
  }
}
