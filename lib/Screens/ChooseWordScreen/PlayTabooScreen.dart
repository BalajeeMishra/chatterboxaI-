import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Model/TabooGameChatPageModel.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/common.dart';
import 'package:balajiicode/extensions/decorations.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Model/AllConversationModel.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/app_images.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../ViewModel/TabooGameChatPageVM.dart';
import '../../Widget/appbar.dart';
import '../../components/loader_widget_new.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/widgets.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayTabooScreen extends StatefulWidget {
  AllGameModel allGameModel;
  int index;
  String sessionId;
  String gameName;

  PlayTabooScreen(this.allGameModel, this.index, this.sessionId, this.gameName);

  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();
}

class _PlayTabooScreen extends State<PlayTabooScreen> {
  bool startListening = false;
  // SpeechToText _speechToText = SpeechToText();
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
  bool _isListening = false;
  bool isSpeechInitialized = false;
  bool isKeyBoardTapped = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    appStore.setLoading(false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlayTabooScreenVM>(context, listen: false)
          .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);

      Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
        context,
        "Hi, Let's play the game!",
        widget.sessionId,
        widget.allGameModel,
        widget.index,
        true,
      );
    });
    startListening = false;
    apiCalled = true;
    if (getStringAsync(USER_NATIVE_LANGUAGE).isNotEmpty &&
        getStringAsync(USER_ENGLISH_PROFICIENCY) == "Beginner") {
      selectedLanguage = getStringAsync(USER_NATIVE_LANGUAGE);
    }
    appStore.setLastWords("");
    setState(() {});
  }

  // Future<void> muteSystemSounds() async {
  //   const platform = MethodChannel('custom_audio_manager');
  //   try {
  //     await platform.invokeMethod('muteSystemSounds');
  //   } catch (e) {}
  // }
  //
  // static Future<void> unmuteSystemSounds() async {
  //   const platform = MethodChannel('custom_audio_manager');
  //
  //   try {
  //     await platform.invokeMethod('unmuteSystemSounds');
  //   } on PlatformException catch (e) {}
  // }

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

  // Future<void> _initSpeech() async {
  //   _previousWords = "";
  //   _speechEnabled = await _speechToText.initialize();
  //   if (_speechEnabled) {
  //     setState(() {
  //       startListening = true;
  //     });
  //     _startListening();
  //     stopSpeaking();
  //   }
  // }

  // Future<void> _startListening() async {
  //   await _speechToText.listen(
  //     localeId: 'en_US',
  //     // listenFor: _listenForDuration,
  //     // pauseFor: _pauseForDuration,
  //     // listenOptions: SpeechListenOptions(
  //     //   listenMode: ListenMode.deviceDefault,
  //     //   autoPunctuation: true,
  //     //   partialResults: true,
  //     //   cancelOnError: false,
  //     //   enableHapticFeedback: true,
  //     //   onDevice: true,
  //     // ),
  //     onResult: _onSpeechResult,
  //   );
  //
  //   // Future.delayed(Duration(seconds: 7), () {
  //   //   if (!_speechToText.isListening) {
  //   //     _startListening();
  //   //   }
  //   // });
  //
  //   // Future.delayed(Duration(seconds: 10), () {
  //   //   if (!_speechToText.isListening) {
  //   //     _stopListening();
  //   //     // startListening = false;
  //   //     // setState(() {
  //   //     //
  //   //     // });
  //   //   }
  //   // });
  //
  //   // setState(() {});
  // }
  //
  // /// Stop listening to speech
  // void _stopListening() {
  //   if (_isListening) {
  //     _speechToText.stop();
  //     _isListening = false;
  //     // setState(() {});
  //   }
  // }
  //
  //
  //
  // /// Process speech result
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _startListening();
  //
  //     isLoading = true;
  //
  //     _lastWords = result.recognizedWords;
  //     if (_lastWords.isNotEmpty) {
  //       isFirstTime = false;
  //     }
  //
  //     if (result.finalResult) {
  //       if (_previousWords.isEmpty) {
  //         _previousWords = result.recognizedWords;
  //       } else {
  //         _previousWords += ' ' + result.recognizedWords;
  //       }
  //
  //       _lastWords = _previousWords;
  //
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       _startListening();
  //     }
  //   });
  // }

  // Future<void> configureTts() async {
  //   setTtsLanguage(selectedLanguage);
  //   await flutterTts.setVolume(1.0);
  //   await flutterTts.setSpeechRate(speechRate);
  //   isSpeaking = true;
  // }
  //
  // Future<void> setTtsLanguage(String language) async {
  //   String ttsLanguage;
  //
  //   switch (language) {
  //     case 'Hindi':
  //       ttsLanguage = 'hi-IN';
  //       break;
  //     case 'English':
  //       ttsLanguage = 'en-US';
  //       break;
  //     case 'Bengali':
  //       ttsLanguage = 'bn-IN';
  //       break;
  //     case 'Kannada':
  //       ttsLanguage = 'kn-IN';
  //       break;
  //     case 'Malayalam':
  //       ttsLanguage = 'ml-IN';
  //       break;
  //     case 'Marathi':
  //       ttsLanguage = 'mr-IN';
  //       break;
  //     case 'Nepali':
  //       ttsLanguage = 'ne-NP';
  //       break;
  //     case 'Punjabi':
  //       ttsLanguage = 'pa-IN';
  //       break;
  //     case 'Tamil':
  //       ttsLanguage = 'ta-IN';
  //       break;
  //     case 'Telugu':
  //       ttsLanguage = 'te-IN';
  //       break;
  //     case 'Urdu':
  //       ttsLanguage = 'ur-IN';
  //       break;
  //     case 'Gujarati':
  //       ttsLanguage = 'gu-IN';
  //       break;
  //     default:
  //       ttsLanguage = 'en-US';
  //       break;
  //   }
  //
  //   await flutterTts.setLanguage(ttsLanguage);
  // }

  /// Speak text with TTS

  Future<void> speakText(String text) async {
    String updatedText = cleanTextForTTS(text);

    await flutterTts.stop();

    if (text.isNotEmpty) {
      _lastWords = updatedText;

      await flutterTts.speak(updatedText);
      isSpeaking = true;

      flutterTts.setCompletionHandler(() {
        isSpeaking = false;
        _lastSpokenIndex = updatedText.length;
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

  Future<void> adjustSpeechRate(double change) async {
    print("LAst Owrds is ==>" + appStore.lastWords);
    _lastWords = appStore.lastWords;

    speechRate += change;
    speechRate = speechRate.clamp(0.1, 2.0);

    await flutterTts.setSpeechRate(speechRate);
    print("isSpeaking" + isSpeaking.toString());
    if (isSpeaking) {
      print("Inside If");
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
    // unmuteSystemSounds();

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
    Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(context,
        ques, widget.sessionId, widget.allGameModel, widget.index, false);
    // configureTts();
    apiCalled = true;

    _lastWords = appStore.lastWords;
    startListening = false;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = 'Thinking...';
      });
    });
    // unmuteSystemSounds();

    setState(() {});
  }

  save2() {
    // unmuteSystemSounds();
    setState(() {
      isSpeaking = true;
    });
    message = 'Correcting Speech recognition mistakes';

    Provider.of<PlayTabooScreenVM>(context, listen: false)
        .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
    Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(context,
        ques, widget.sessionId, widget.allGameModel, widget.index, false);
    // configureTts();
    apiCalled = true;
    _lastWords = appStore.lastWords;
    startListening = false;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = 'Thinking...';
      });
    });
    // unmuteSystemSounds();
    setState(() {});
  }

  void muteKeyboardSounds() async {
    try {
      await MethodChannel('volume_control').invokeMethod('muteKeyboardSounds');
      print("Keyboard voice typing sounds muted.");
    } catch (e) {
      print("Error muting keyboard sounds: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    // VolumeController().removeListener();

    stopSpeaking();
    // _startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          leading: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ).onTap(() {
            if (isKeyBoardTapped) {
              isKeyBoardTapped = false;

              setState(() {});
            } else {
              pop();
            }
          }),
          title: Text(
            widget.gameName,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.appbarBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
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
                      Row(
                        mainAxisAlignment: !apiCalled
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (apiCalled && !isKeyBoardTapped)
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.fast_rewind,
                                    size: 26,
                                  ),
                                  onPressed: () => _onDecreaseRatePressed(),
                                ),
                                Text(
                                  "Slow",
                                  style: secondaryTextStyle(size: 12),
                                ).onTap(() {
                                  _onDecreaseRatePressed();
                                })
                              ],
                            ),
                          if (!isKeyBoardTapped)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: Image.asset(
                                  fit: BoxFit.cover,
                                  height: 195,
                                  width: 246,
                                  ic_transparent_girlImage2),
                            ),
                          if (apiCalled && !isKeyBoardTapped)
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.fast_forward,
                                    size: 26,
                                  ),
                                  onPressed: () => _onIncreaseRatePressed(),
                                ),
                                Text(
                                  "Fast",
                                  style: secondaryTextStyle(size: 12),
                                ).onTap(() {
                                  _onIncreaseRatePressed();
                                })
                              ],
                            ),
                        ],
                      ).paddingOnly(left: 8, right: 8),
                      SizedBox(
                        height: 15,
                      ),
                      if (isKeyBoardTapped)
                        _buildMessageInput(context).expand(),
                      if (isFirstTime)
                        LoadingWidget(
                          message: "Listening...",
                        ),
                      if (!apiCalled && !isLoading)
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
                      if (apiCalled && !isKeyBoardTapped)
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
                                                    : SizedBox(
                                                        height:
                                                            context.height() *
                                                                0.440,
                                                        child:
                                                            SingleChildScrollView(
                                                          child:
                                                              // Text(vm.tabooGameChatPageModel.response!.aiResponse!.last)
                                                              RichText(
                                                            text: TextSpan(
                                                              children: _buildBoldText(vm
                                                                  .tabooGameChatPageModel
                                                                  .response!
                                                                  .aiResponse!
                                                                  .last),
                                                              style:
                                                                  primaryTextStyle(
                                                                          size:
                                                                              16)
                                                                      .copyWith(
                                                                height: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                      ],
                                    ),
                                  );
                          },
                        ),
                    ],
                  ),
                ),
                if (!isKeyBoardTapped)
                  Center(
                    child: startListening
                        ? listeningWidget()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _lastWords = appStore.lastWords;

                                    isMuted = !isMuted;
                                    if (isMuted) {
                                      stopSpeaking();
                                    } else if (_lastWords.isNotEmpty &&
                                        _lastSpokenIndex < _lastWords.length) {
                                      speakText(_lastWords
                                          .substring(_lastSpokenIndex));
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
                                width: !isMuted ? 29 : 22,
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     _initSpeech();
                              //     apiCalled = false;
                              //     isFirstTime = true;
                              //
                              //     _lastWords = "";
                              //     setState(() {});
                              //   },
                              //   child: Column(
                              //     children: [
                              //       Icon(
                              //         Icons.keyboard_voice,
                              //         size: 36,
                              //       ),
                              //       MyText(
                              //         text: "Speak",
                              //         fontSize: 12,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              //
                              // SizedBox(
                              //   width: 24,
                              // ),
                              GestureDetector(
                                onTap: () {
                                  muteKeyboardSounds();
                                  isKeyBoardTapped = true;

                                  _focusNode.requestFocus();
                                  stopSpeaking();

                                  _lastWords = "";
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.keyboard_voice,
                                      size: 44,
                                      color: primaryColor,
                                    ),
                                    MyText(
                                      text: "Keyboard Audio",
                                      fontSize: 12,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 24,
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
                            ],
                          ).paddingSymmetric(horizontal: 20),
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
                // _stopListening();
                setState(() {
                  _lastWords = "";
                  startListening = false;
                  isFirstTime = false;
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
                // _stopListening();

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

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: Consumer<PlayTabooScreenVM>(
              builder: (context, vm, child) {
                vm.controller?.clear();

                return TextField(
                  cursorColor: primaryColor,
                  cursorHeight: 30,
                  cursorWidth: 4,
                  focusNode: _focusNode,
                  controller: vm.controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor, width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor, width: 3),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 4, bottom: 4, left: 14, right: 14),
                decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: Color(0xFFe0ddf5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Use Keyboard Microphone"),
                    4.width,
                    Image.asset('assets/images/voice.gif', width: 40)
                  ],
                ),
              ).expand(),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // FocusScope.of(context).unfocus();
                  // unmuteSystemSounds();
                  var chatPageVM =
                      Provider.of<PlayTabooScreenVM>(context, listen: false);
                  String messageText = chatPageVM.controller.text.trim();
                  _lastWords = messageText;
                  // save2();
                  setState(() {
                    ques = _lastWords;
                    _lastWords = "";
                  });
                  if (ques.isNotEmpty) {
                    save2();
                  }

                  isKeyBoardTapped = false;
                  chatPageVM.controller.clear();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ).paddingTop(10),
        ],
      ),
    );
  }
}

List<TextSpan> _buildBoldText(String response) {
  // Split the response by ** to identify parts that should be bold
  List<String> parts = response.split("**");

  List<TextSpan> textSpans = [];
  for (int i = 0; i < parts.length; i++) {
    if (i % 2 == 0) {
      // Normal text
      textSpans.add(TextSpan(text: parts[i]));
    } else {
      // Bold text
      textSpans.add(TextSpan(
        text: parts[i],
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    }
  }
  return textSpans;
}

String cleanTextForTTS(String text) {
  String textWithoutEmojis = text.replaceAll(emojiRegex(), "");

  return textWithoutEmojis.replaceAll('**', '');
}
