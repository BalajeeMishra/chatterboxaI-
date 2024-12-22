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
import 'package:dropdown_search/dropdown_search.dart';
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
import '../../extensions/app_button.dart';
import '../../extensions/colors.dart';
import '../../extensions/constants.dart';
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
  // bool _isListening = false;
  bool isSpeechInitialized = false;
  bool isKeyBoardTapped = false;
  final FocusNode _focusNode = FocusNode();

  //level
  final FocusNode languageFocus = FocusNode();
  final FocusNode englishLevelFocus = FocusNode();
  final List<String> languageList = [
    'Afrikaans',
    'Amharic',
    'Assamese',
    'Aymara',
    'Azerbaijani',
    'Bahasa Indonesia',
    'Balochi',
    'Bashkir',
    'Bengali',
    'Bhojpuri',
    'Bulgarian',
    'Burmese',
    'Catalan',
    'Cebuano',
    'Chewa',
    'Czech',
    'Danish',
    'Deccan',
    'Dhundhari',
    'Dutch',
    'Eastern Min',
    'English',
    'Farsi',
    'Finnish',
    'French',
    'Fula',
    'German',
    'Greek',
    'Gujarati',
    'Haitian Creole',
    'Hakka',
    'Haryanvi',
    'Hausa',
    'Hebrew',
    'Hiligaynon',
    'Hindi',
    'Hmong',
    'Hungarian',
    'Igbo',
    'Italian',
    'Japanese',
    'Javanese',
    'Kannada',
    'Khmer',
    'Kinyarwanda',
    'Korean',
    'Kurdish',
    'Lithuanian',
    'Madurese',
    'Magahi',
    'Maithili',
    'Malagasy',
    'Malay/Indonesian',
    'Malayalam',
    'Mandarin Chinese',
    'Marathi',
    'Min Nan',
    'Mossi',
    'Nepali',
    'Norwegian',
    'Odia',
    'Oriya',
    'Persian',
    'Polish',
    'Portuguese',
    'Punjabi',
    'Romanian',
    'Russian',
    'Serbian',
    'Shona',
    'Sindhi',
    'Sinhala',
    'Sinhalese',
    'Slovak',
    'Somali',
    'Spanish',
    'Sudanese Arabic',
    'Sunda',
    'Swahili',
    'Swedish',
    'Tagalog',
    'Tamil',
    'Telugu',
    'Thai',
    'Tigrinya',
    'Turkish',
    'Turkmen',
    'Twi',
    'Ukrainian',
    'Urdu',
    'Uyghur',
    'Uzbek',
    'Vietnamese',
    'Western Punjabi',
    'Xiang',
    'Yoruba',
    'Yue Chinese (Cantonese)',
    'Zhuang',
    'Zulu'
  ];
  final List<String> englishLevelList = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  String englishLevel = 'Beginner';
  String selectedLanguageForList = 'Hindi';
  final dropDownKey = GlobalKey<DropdownSearchState>();


  @override
  void initState() {
    super.initState();
    appStore.setLoading(false);
    selectedLanguageForList = getStringAsync(USER_NATIVE_LANGUAGE);
    englishLevel = getStringAsync(USER_ENGLISH_PROFICIENCY);

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
          isMuted);
    });
    startListening = false;
    apiCalled = true;
    // if (getStringAsync(USER_NATIVE_LANGUAGE).isNotEmpty) {
    //   selectedLanguage = getStringAsync(USER_NATIVE_LANGUAGE);
    //   setTtsLanguage(selectedLanguage);
    // }else{
    //   await flutterTts.setLanguage('en-US');
    //
    // }

    // else{
    //   selectedLanguage =
    // }
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
    setValue(IS_MUTE, isMuted);

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
    Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
        context,
        ques,
        widget.sessionId,
        widget.allGameModel,
        widget.index,
        false,
        isMuted);
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
    isMuted = getBoolAsync(IS_MUTE);

    print("ISMUTED ==>" + isMuted.toString());
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
    Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
        context,
        ques,
        widget.sessionId,
        widget.allGameModel,
        widget.index,
        false,
        isMuted);
    // configureTts();
    apiCalled = true;
    _lastWords = appStore.lastWords;
    startListening = false;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = 'Thinking...';
      });
    });
    isMuted = getBoolAsync(IS_MUTE);
    print("ISMUTED ==>" + isMuted.toString());

    // unmuteSystemSounds();
    setState(() {});
  }

  showUpdateDialog() {
    return showDialog(
      // useSafeArea: true,
        context: context,
        builder: (context) {
          return AlertDialog(

            title: const Text('Personalise your learning'),
            actions: [
              Row(
                children: [
                  Text('Your Native Language',
                      style: secondaryTextStyle(
                          color: textPrimaryColorGlobal)),
                  2.width,
                  Text('*', style: secondaryTextStyle(color: redColor))
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              4.height,
              DropdownSearch<String>(
                key: dropDownKey,
                items: (String filter, LoadProps? loadProps) async {
                  if (filter.isEmpty) {
                    return languageList;
                  } else {
                    return languageList
                        .where((language) => language
                        .toLowerCase()
                        .contains(filter.toLowerCase()))
                        .toList();
                  }
                },
                selectedItem: selectedLanguage,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration:
                    InputDecoration(hintText: 'Search Language'),
                  ),
                  emptyBuilder: (context, searchEntry) {
                    return Text('No Language available').center();
                  },
                ),
                onChanged: (String? value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: defaultInputDecoration(
                      context), // Applying the decoration here
                ),
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              16.height,
              Row(
                children: [
                  Text('Your English Proficiency',
                      style: secondaryTextStyle(
                          color: textPrimaryColorGlobal)),
                  2.width,
                  Text('*', style: secondaryTextStyle(color: redColor))
                ],
              ).
              paddingSymmetric(horizontal: 16, vertical: 4),
              4.height,
              DropdownButtonFormField(
                items: englishLevelList
                    .map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: primaryTextStyle()),
                ))
                    .toList(),
                isExpanded: false,
                isDense: true,
                borderRadius: radius(),
                decoration: defaultInputDecoration(context),
                value: englishLevel,
                onChanged: (String? value) {
                  setState(() {
                    englishLevel = value!;
                    if (selectedLanguageForList.isNotEmpty) {
                      toastLeft(
                          durationInSeconds: 7,
                          bgColor: primaryColor,
                          textColor: Colors.white,
                          "You have chosen $englishLevel.\nAI will talk in your Native language & share few references in $selectedLanguage");
                    }
                  });
                },
                focusNode: englishLevelFocus,
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              40.height,

              AppButton(
                text: 'Confirm',
                padding: EdgeInsetsDirectional.all(0),
                width: context.width() * 0.68,
                height: context.height() * 0.056,
                color: primaryColor,
                onTap: () {
                  // save();
                },
              ),

            ],
          );
        }
    );
  }
  // void muteKeyboardSounds() async {
  //   try {
  //     await MethodChannel('volume_control').invokeMethod('muteKeyboardSounds');
  //     print("Keyboard voice typing sounds muted.");
  //   } catch (e) {
  //     print("Error muting keyboard sounds: $e");
  //   }
  // }
  //

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
        preferredSize: const Size.fromHeight(40.0),
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
            softWrap: true,
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
          actions: [
            if(!isKeyBoardTapped) Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Text(
                      englishLevel,
                      style:
                      secondaryTextStyle(fontStyle: FontStyle.italic),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: primaryColor,
                    )
                  ],
                ).paddingOnly(left: 8, right: 2)).onTap((){
              showUpdateDialog();
            })
                .paddingRight(12)
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isKeyBoardTapped) {
            isKeyBoardTapped = false;

            setState(() {});
          } else {
            pop();
          }
          return false;
        },
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: !apiCalled
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceBetween,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              if (apiCalled && !isKeyBoardTapped)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // IconButton(
                                    //   alignment: Alignment.bottomLeft,
                                    //
                                    //   padding: EdgeInsets.all(0),
                                    //   // constraints: BoxConstraints(maxWidth: 0,minWidth: 0),
                                    //
                                    //   icon:
                                    InkWell(
                                      onTap: () => _onDecreaseRatePressed(),
                                      child: Icon(
                                        Icons.fast_rewind,
                                        size: 30,
                                      ),
                                    ),

                                    //   onPressed: () => _onDecreaseRatePressed(),
                                    // ),
                                    Text(
                                      "Slow",
                                      style: secondaryTextStyle(size: 12),
                                    ).onTap(() {
                                      _onDecreaseRatePressed();
                                    })
                                  ],
                                ).paddingOnly(bottom: 20, left: 4),
                              if (!isKeyBoardTapped)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                      fit: BoxFit.cover,
                                      height: 212,
                                      width: 270,
                                      ic_transparent_girlImage2),
                                ),
                              if (apiCalled && !isKeyBoardTapped)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // IconButton(
                                    //   alignment: Alignment.bottomRight,
                                    //
                                    //   // constraints: BoxConstraints(maxWidth: 0,minWidth: 0),
                                    //   padding: EdgeInsets.all(0),
                                    //   icon:
                                    InkWell(
                                      onTap: () => _onIncreaseRatePressed(),
                                      child: Icon(
                                        Icons.fast_forward,
                                        size: 30,
                                      ),
                                    ),
                                    //   onPressed: () => _onIncreaseRatePressed(),
                                    // ),
                                    Text(
                                      "Fast",
                                      style: secondaryTextStyle(size: 12),
                                    ).onTap(() {
                                      _onIncreaseRatePressed();
                                    })
                                  ],
                                ).paddingOnly(bottom: 20, right: 4),
                            ],
                          ).paddingOnly(left: 4, right: 4),
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
                                                0.420,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _lastWords = appStore.lastWords;

                                  // isMuted= getBoolAsync(IS_MUTE);

                                  isMuted = !isMuted;
                                  setValue(IS_MUTE, isMuted);
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
                                  // muteKeyboardSounds();
                                  isKeyBoardTapped = true;

                                  _focusNode.requestFocus();
                                  stopSpeaking();

                                  _lastWords = "";
                                  if (isMuted) {
                                    stopSpeaking();
                                  }
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.keyboard_voice,
                                        size: 50,
                                        color: primaryColor,
                                      ),
                                      padding: EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          color: Color(0XFFe0ddf5)),
                                    ),
                                    MyText(
                                      text: "Speak",
                                      fontSize: 12,
                                    )
                                  ],
                                )
                              // .paddingBottom(40),
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
                                  if (isMuted) {
                                    stopSpeaking();
                                  }
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
                        ).paddingOnly(left: 20, right: 20, bottom: 20),
                      )
                  ],
                )),
          ],
        ),
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
                // isMuted= getBoolAsync(IS_MUTE);

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
