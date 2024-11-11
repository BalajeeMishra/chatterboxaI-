import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Model/TabooGameChatPageModel.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Model/AllConversationModel.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/app_images.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../Widget/appbar.dart';
import '../../components/loader_widget_new.dart';
import '../../extensions/loader_widget.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';
import 'package:uuid/uuid.dart';

class PlayTabooScreen extends StatefulWidget {
  AllGameModel allGameModel;
  int index;
  String sessionId;

  PlayTabooScreen(this.allGameModel, this.index, this.sessionId);

  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();
}

class _PlayTabooScreen extends State<PlayTabooScreen> {
  bool startListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _previousWords = '';
  String ques = "";
  String sessionId = "";
  bool isLoading = false;
  bool apiCalled = false;
  bool isFirstTime = false;
  bool isMuted = false;
  String currentSpeechText = "";

  //Screen2 data
  double speechRate = 0.4;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  String message = '';
  int _lastSpokenIndex = 0;
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    appStore.setLoading(false);
    startListening = false;
    if (getStringAsync(USER_NATIVE_LANGUAGE).isNotEmpty) {
      selectedLanguage = getStringAsync(USER_NATIVE_LANGUAGE);
    }

    setState(() {});
  }

  Response convertToResponse(CompleteConversation completeConversation) {
    return Response(
      aiResponse: completeConversation.aiResponse,
    );
  }

  Future<void> allConversationApiCall() async {
    appStore.setLoading(true);

    await allConversationApi(widget.sessionId).then((value) async {
      appStore.setLoading(false);

      if (value.completeConversation != null) {
        apiCalled = true;

        Provider.of<PlayTabooScreenVM>(context, listen: false)
            .updateResponse(value.completeConversation!);
      } else {}
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      setState(() {});
    });
  }

  void _initSpeech() async {
    _previousWords ="";
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      setState(() {
        startListening = true;
      });
      _startListening();
      stopSpeaking();
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      startListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {

    setState(() {
      _startListening();

      isLoading = true;

      _lastWords = result.recognizedWords;
      if (_lastWords.isNotEmpty) {
        isLoading = false;
      }
      if (result.finalResult) {
        if (_previousWords.isEmpty) {

          _previousWords = result.recognizedWords;
        } else {
          _previousWords += ' ' + result.recognizedWords;
        }

        _lastWords = _previousWords;

        setState(() {

        });

        _startListening();
      }
    });
  }

  void _startListening() async {
    await _speechToText.listen(
        localeId: 'en_US',
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 10),
        listenOptions: SpeechListenOptions(
            listenMode: ListenMode.deviceDefault,
            autoPunctuation: true,
            partialResults: true,
            cancelOnError: false,
            enableHapticFeedback: true,
            onDevice: true),
        onResult: _onSpeechResult);
    setState(() {});
  }

  /// Stop listening to speech
  // void _stopListening() async {
  //   await _speechToText.stop();
  //   setState(() {
  //     startListening = false;
  //   });
  // }

  /// Process speech result
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     isLoading = true;
  //     _lastWords = result.recognizedWords;
  //     if (_lastWords.isNotEmpty) {
  //       isLoading = false;
  //       setState(() {
  //
  //       });
  //     }
  //   });
  // }
  //
  Future<void> configureTts() async {
    setTtsLanguage(selectedLanguage);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(speechRate);
    isSpeaking = true;
  }

  Future<void> setTtsLanguage(String language) async {
    String ttsLanguage;

    switch (language) {
      case 'Hindi':
        ttsLanguage = 'hi-IN';
        break;
      case 'English':
        ttsLanguage = 'en-US';
        break;
      case 'Bengali':
        ttsLanguage = 'bn-IN';
        break;
      case 'Kannada':
        ttsLanguage = 'kn-IN';
        break;
      case 'Malayalam':
        ttsLanguage = 'ml-IN';
        break;
      case 'Marathi':
        ttsLanguage = 'mr-IN';
        break;
      case 'Nepali':
        ttsLanguage = 'ne-NP';
        break;
      case 'Punjabi':
        ttsLanguage = 'pa-IN';
        break;
      case 'Tamil':
        ttsLanguage = 'ta-IN';
        break;
      case 'Telugu':
        ttsLanguage = 'te-IN';
        break;
      case 'Urdu':
        ttsLanguage = 'ur-IN';
        break;
      case 'Gujarati':
        ttsLanguage = 'gu-IN';
        break;
      default:
        ttsLanguage = 'en-US';
        break;
    }

    await flutterTts.setLanguage(ttsLanguage);
  }

  /// Speak text with TTS

  Future<void> speakText(String text) async {
    await flutterTts.stop();

    if (text.isNotEmpty) {
      _lastWords = text;

      await flutterTts.speak(text);
      isSpeaking = true;

      flutterTts.setCompletionHandler(() {
        isSpeaking = false;
        _lastSpokenIndex = text.length;
      });

      flutterTts.setErrorHandler((error) {
        isSpeaking = false;
      });
    } else {}
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
    _lastWords = appStore.lastWords;

    speechRate += change;
    speechRate = speechRate.clamp(0.1, 2.0);

    await flutterTts.setSpeechRate(speechRate);

    if (isSpeaking) {
      await flutterTts.stop();

      String remainingText = _getRemainingText();

      Future.delayed(Duration(milliseconds: 200), () async {
        if (remainingText.isNotEmpty) {
          await flutterTts.setSpeechRate(speechRate);
          await speakText(remainingText);
        }
      });
    } else {}
  }

  String _getRemainingText() {
    if (_lastSpokenIndex < _lastWords.length) {
      return _lastWords.substring(_lastSpokenIndex);
    }
    return '';
  }

  _onIncreaseRatePressed() {
    adjustSpeechRate(0.1);
  }

  _onDecreaseRatePressed() {
    adjustSpeechRate(-0.1);
  }

  save() {
    message = 'Correcting Speech recognition mistakes';
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
    });

    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
    Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
        context, ques, widget.sessionId, widget.allGameModel, widget.index);
    configureTts();
    apiCalled = true;
    _lastWords = appStore.lastWords;

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = 'Thinking...';
      });
    });
    setState(() {});
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 26,
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
                      Row(
                        mainAxisAlignment: !apiCalled
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (apiCalled)
                            IconButton(
                              icon: Icon(Icons.fast_rewind),
                              onPressed: () => _onDecreaseRatePressed(),
                            ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(27),
                            child: Image.asset(
                                fit: BoxFit.cover,
                                height: 195,
                                width: 246,
                                ic_transparent_girlImage2),
                          ),
                          if (apiCalled)
                            IconButton(
                              icon: Icon(Icons.fast_forward),
                              onPressed: () => _onIncreaseRatePressed(),
                            ),
                        ],
                      ).paddingOnly(left: 8, right: 8),
                      SizedBox(
                        height: 15,
                      ),
                      if (!apiCalled && !isFirstTime)
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
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
                            ],
                          ),
                        ),
                      Lottie.asset(
                        'assets/lottiefile/loader.json',
                        height: 180,
                        fit: BoxFit.contain,
                      ).center().visible(isLoading),
                      if (!apiCalled)
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
                        ).paddingSymmetric(horizontal: 24, vertical: 14),
                      if (apiCalled)
                        Consumer<PlayTabooScreenVM>(
                          builder: (context, vm, child) {
                            return vm.tabooGameChatPageModel.response == null
                                ? LoadingWidget(
                                    message: message,
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 28.0, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: startListening
                                              ? MyText(
                                                  text: _lastWords,
                                                  color: Color(0xff000000),
                                                  fontSize: 18,
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
                                                  : Text(
                                                      vm
                                                          .tabooGameChatPageModel
                                                          .response!
                                                          .aiResponse!
                                                          .last,
                                                      style: primaryTextStyle(
                                                          size: 16),
                                                    ),
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMuted = !isMuted;
                                  if (isMuted) {
                                    stopSpeaking();
                                  } else if (_lastWords.isNotEmpty &&
                                      _lastSpokenIndex < _lastWords.length) {
                                    speakText(
                                        _lastWords.substring(_lastSpokenIndex));
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    !isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    size: 36,
                                  ),
                                  MyText(
                                    text: !isMuted ? "Mute" : "Unmute",
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: !isMuted ? 47 : 40,
                            ),
                            GestureDetector(
                              onTap: () async {
                                stopSpeaking();
                                final bool? res = await TaboogamechatPage(
                                  widget.allGameModel,
                                  widget.index,
                                  widget.sessionId,
                                ).launch(context);
                                if (res == true) {
                                  allConversationApiCall();
                                } else {}
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
                                apiCalled = false;
                                isFirstTime = true;

                                _lastWords = "";
                                setState(() {});
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

                setState(() {
                  ques = _lastWords;
                  _lastWords = "";
                });
                if (ques.isNotEmpty) {
                  save();
                }
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
