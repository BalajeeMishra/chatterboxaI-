import 'dart:ui';

import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Model/TabooGameChatPageModel.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/common.dart';
import 'package:balajiicode/extensions/decorations.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Model/AllConversationModel.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/app_images.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../components/loader_widget_new.dart';
import '../../components/tts.dart';
import '../../extensions/app_button.dart';
import '../../extensions/colors.dart';
import '../../extensions/constants.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';


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
  bool isLoaderShow = false;

  bool isMuted = false;
  String currentSpeechText = "";

  //Screen2 data
  double speechRate = 0.4;
  final TTSManager ttsManager = TTSManager();
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
  String newEnglishLevel = "";
  //showcase
  // GlobalKey _one = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String previousSentence = "";

  @override
  void initState() {
    super.initState();
    appStore.setLoading(false);
    selectedLanguageForList = userStore.userNativeLanguage;
    englishLevel = userStore.userEnglishProficiency;
    newEnglishLevel = userStore.userEnglishProficiency;
    print("User NAtive Language is==>" + userStore.userNativeLanguage);
    print("User English Proficiency is==>" + userStore.userEnglishProficiency);

    WidgetsBinding.instance.addPostFrameCallback((_) {
// _focusNode.unfocus();
      Provider.of<PlayTabooScreenVM>(context, listen: false)
          .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);

      Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
          context,
          "Hi, Let's play the game!",
          widget.sessionId,
          widget.allGameModel,
          widget.index,
          true,
          false);
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

    await ttsManager.setLanguage(ttsLanguage);
  }

  Future<void> configureTts() async {
    print("Configuration time ==>" + userStore.userNativeLanguage.toString());
    // if (userStore.userNativeLanguage.isNotEmpty &&
    //     userStore.userEnglishProficiency == "Beginner") {
    //   selectedLanguage = userStore.userNativeLanguage;
    //   setTtsLanguage(selectedLanguage);
    // } else {
    //   print("Amrican");
    //   await ttsManager.setLanguage('en-US');
    //   // await flutterTts.se;
    // }
    await ttsManager.setLanguage('en-US');

    // print("Selectd Language is ==>" + selectedLanguage.toString());

    // await ttsManager.setSpeechRate(0.4);
    await ttsManager.setVolume(1.0);
  }

  Future<void> speakText(String text) async {
    configureTts();
    String updatedText = cleanTextForTTS(text);

    await ttsManager.stop();

    if (text.isNotEmpty) {
      _lastWords = updatedText;

      await ttsManager.speak(updatedText);
      isSpeaking = true;

      ttsManager.setCompletionHandler(() {
        isSpeaking = false;
        _lastSpokenIndex = updatedText.length;
      });

      ttsManager.setErrorHandler((error) {
        isSpeaking = false;
      });
    } else {}
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await ttsManager.stop();
  }

  /// Submit and call next function

  Future<void> adjustSpeechRate(double change) async {
    print("Last Words: ${appStore.lastWords}");
    _lastWords = appStore.lastWords;

    speechRate = (speechRate + change).clamp(0.2, 2.0);
    print("Speech Rate is: $speechRate");

    await ttsManager.setSpeechRate(speechRate);

    if (isSpeaking || userStore.isTTSPlaying == "YES") {
      print("Inside If: Stopping TTS and restarting with new rate");
      await ttsManager.stop();

      String remainingText = _getRemainingText();

      Future.delayed(Duration(milliseconds: 200), () async {
        if (remainingText.isNotEmpty) {
          await ttsManager.setSpeechRate(speechRate);
          await speakText(remainingText);
          setState(() {});
        }
      });
    }
  }

  _onIncreaseRatePressed() {
    adjustSpeechRate(0.2);
    setState(() {});
  }

  _onDecreaseRatePressed() {
    adjustSpeechRate(-0.2);
    setState(() {});
  }

  String _getRemainingText() {
    print("Last Word is " + _lastWords.toString());
    if (_lastSpokenIndex < _lastWords.length) {
      return _lastWords.substring(_lastSpokenIndex);
    }
    return '';
  }

  save() {
    // unmuteSystemSounds();

    message = 'Correcting Speech recognition mistakes';
    ttsManager.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    ttsManager.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    ttsManager.setErrorHandler((msg) {
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

  save2(String? correctedQues, String? sessionId) async {
    setState(() {
      isSpeaking = true;
    });
    message = 'Correcting Speech recognition mistakes';
    try {
      print("into try");
      final correctedSentence = await correctSentence(correctedQues, sessionId);
      print("into correct sence check" + correctedSentence.toString());

      if (correctedSentence != null) {
        print("Corrected Sentence is ==>" + correctedSentence.toString());
        correctedQues = correctedSentence;
      }

      Provider.of<PlayTabooScreenVM>(context, listen: false)
          .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
      Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
          context,
          correctedQues!,
          sessionId!,
          widget.allGameModel,
          widget.index,
          false,
          isMuted);
      // configureTts();
      apiCalled = true;
      _lastWords = appStore.lastWords;
      userStore.setPreviousSentence(_lastWords);
      print("Last Words is here ==>" + _lastWords.toString());
      print("Last Words appStore ==>" + appStore.lastWords.toString());

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
    } catch (e) {
      toast(e.toString());
    }
  }

  save3(String? correctedQues, String? sessionId) async {
    setState(() {
      isSpeaking = true;
    });

    try {
      Provider.of<PlayTabooScreenVM>(context, listen: false)
          .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
      Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
          context,
          correctedQues!,
          sessionId!,
          widget.allGameModel,
          widget.index,
          false,
          isMuted);
      isLoaderShow = false;
      apiCalled = true;
      _lastWords = appStore.lastWords;
      userStore.setPreviousSentence(_lastWords);
      startListening = false;
      isMuted = getBoolAsync(IS_MUTE);

      setState(() {});
    } catch (e) {
      toast(e.toString());
    }
  }

  showUpdateDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        String tempEnglishLevel = englishLevel;

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                pop();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: primaryColor.withOpacity(0.4),
                ),
              ),
            ),
            AlertDialog(
              title: const Text('Personalise your learning'),
              actions: [
                Row(
                  children: [
                    Text('Your Native Language',
                        style:
                            secondaryTextStyle(color: textPrimaryColorGlobal)),
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
                  selectedItem: selectedLanguageForList,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(hintText: 'Search Language'),
                    ),
                    emptyBuilder: (context, searchEntry) {
                      return Text('No Language available').center();
                    },
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguageForList = value!;
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
                        style:
                            secondaryTextStyle(color: textPrimaryColorGlobal)),
                    2.width,
                    Text('*', style: secondaryTextStyle(color: redColor))
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 4),
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
                  value: tempEnglishLevel,
                  onChanged: (String? value) {
                    setState(() {
                      tempEnglishLevel = value!;
                    });
                  },
                  // onSaved: (String? newValue) {
                  //   newEnglishLevel =newValue!;
                  //   print("New Value==>"+newValue.toString());
                  // },
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
                    englishLevel = tempEnglishLevel;

                    updateProficiency(englishLevel, selectedLanguageForList);
                  },
                ),
              ],
            ).center(),
          ],
        );
      },
    );
  }

  void showInstructionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      10.height,
                      Text(
                        'How should I speak?',
                        style: secondaryTextStyle(
                            size: 24, weight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Please locate the Mic icon on your keyboard.',
                        style: secondaryTextStyle(),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Not seeing a Mic icon?',
                        style: secondaryTextStyle(size: 18),
                      ),
                      SizedBox(height: 10),
                      buildReason(
                          'Reason 1',
                          '(Gboard) Long press comma and open settings. Turn on ',
                          'voice typing ',
                          'inside settings\n'),
                      buildReason(
                          'Reason 2',
                          'Check your App settings and locate your keyboard App. Make sure you have given ',
                          'microphone permission.\n',
                          ''),
                      buildReason(
                          'Reason 3',
                          'Inside Keyboard settings, go to Text suggestions and then turn on ',
                          'show suggestion strip\n',
                          ''),
                    ],
                  ),
                  Positioned(
                    top: -30,
                    right: -30,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildReason(
      String title, String text, String highlight, String remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: primaryTextStyle(),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: text),
              TextSpan(
                  text: highlight,
                  style: primaryTextStyle(weight: FontWeight.bold)),
              TextSpan(text: remaining),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Future<void> updateProficiency(
      String? englishProficiency, String? selectedNLanguage) async {
    Map<String, dynamic> req = {
      'nativeLanguage': selectedNLanguage,
      'engprolevel': englishProficiency
    };

    try {
      isLoaderShow = true;
      final value = await updateProficiencyApi(req);
      newEnglishLevel = englishProficiency!;
      ques = appStore.userResponse;
      print("UserResponse is =>" + ques.toString());
      if (ques.isNotEmpty) {
        ttsManager.stop();
        save3(ques, widget.sessionId);
      }

      setValue(USER_NATIVE_LANGUAGE, value.user!.nativeLanguage.toString());
      userStore.setUserNativeLanguage(value.user!.nativeLanguage.toString());
      setValue(USER_ENGLISH_PROFICIENCY, value.user!.engprolevel.toString());
      userStore.setUserEnglishProficiency(value.user!.engprolevel.toString());
      pop();
      setState(() {});
    } catch (e) {
      toast(e.toString());
      appStore.setLoading(false);
    }
  }

  Future<String?> correctSentence(String? ques, String? sessionId) async {
    Map<String, dynamic> req = {
      'sessionId': sessionId,
      'sentence': ques,
      'previousSentence': userStore.previousSentence,
    };

    try {
      final value = await correctSentenceApi(req);
      return value.response?.text;
    } catch (e) {
      // print("Error in correctSentence: $e");
      toast(e.toString());
      appStore.setLoading(false);
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    stopSpeaking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: false,
          leading: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ).onTap(() {
            if (isKeyBoardTapped) {
              isKeyBoardTapped = false;
              setState(() {});
            } else {
              pop(true);
              pop(true);
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
            if (!isKeyBoardTapped)
              Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Text(
                            newEnglishLevel,
                            style:
                                secondaryTextStyle(fontStyle: FontStyle.italic),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: primaryColor,
                          )
                        ],
                      ).paddingOnly(left: 8, right: 2))
                  .onTap(() {
                showUpdateDialog();
              }).paddingRight(12)
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isKeyBoardTapped) {
            isKeyBoardTapped = false;

            setState(() {});
          } else {
            pop(true);
            pop(true);
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
                      if (isLoaderShow)
                        CircularProgressIndicator(color: primaryColor),
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
                      if (apiCalled && !isKeyBoardTapped && !isLoaderShow)
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
                if (!isKeyBoardTapped && !isLoaderShow)
                  Consumer<PlayTabooScreenVM>(builder: (context, vm, child) {
                    return vm.tabooGameChatPageModel.response == null
                        ? SizedBox()
                        : Center(
                            child: startListening
                                ? listeningWidget()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                _lastSpokenIndex <
                                                    _lastWords.length) {
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
                                              text:
                                                  !isMuted ? "Mute" : "Unmute",
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
                                                        BorderRadius.circular(
                                                            50),
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
                                          final bool? res =
                                              await TaboogamechatPage(
                                                      widget.allGameModel,
                                                      widget.index,
                                                      widget.sessionId,
                                                      widget.gameName)
                                                  .launch(context);
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
                                  ).paddingOnly(
                                    left: 20, right: 20, bottom: 20),
                          );
                  })
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
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                        top: 80, bottom: 0, left: 10, right: 10),
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DottedBorder(
                color: gradientStartColor, strokeWidth: 2,
                dashPattern: [2, 2],
                // strokeCap: StrokeCap.round,
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                child: ClipRRect(
                  child: Container(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    // decoration: BoxDecoration(border: Border.all()),
                    // decoration: boxDecorationWithRoundedCorners(
                    //     // backgroundColor: Color(0xFFe0ddf5)
                    //
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/voice.gif', width: 40),
                        Text("Use keyboard's voice typing"),
                        4.width,
                        Icon(
                          Icons.help_outlined,
                          size: 20,
                        ).onTap(() {
                          showInstructionDialog();
                        }),
                        // ShowCaseWidget(builder: (context) {
                        //   return Showcase(
                        //     key: _one,
                        //     title: "How should i Speak?",
                        //     description:
                        //         "\nPlease locate the Mic icon on your keyboard.\n\n"
                        //         "Not seeing a Mic icon?\n\n"
                        //         "Reason 1\n"
                        //         "(Gboard) Long press comma and open settings. Turn on voice typing inside settings.\n\n"
                        //         "Reason 2\n"
                        //         "Check your App settings and locate your keyboard App. Make sure you have given microphone permission.\n\n"
                        //         "Reason 3\n"
                        //         "Inside Keyboard settings, go to Text suggestions and then turn on show suggestion strip.",
                        //     // description:_buildRichDescription(),
                        //     // RichText(
                        //     //   text: TextSpan(
                        //     //     children: [
                        //     //       TextSpan(
                        //     //         text: "Reason 1: ",
                        //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        //     //       ),
                        //     //       TextSpan(
                        //     //         text: "Long press comma and open settings to turn on voice typing.\n\n",
                        //     //         style: TextStyle(color: Colors.black),
                        //     //       ),
                        //     //       TextSpan(
                        //     //         text: "Reason 2: ",
                        //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        //     //       ),
                        //     //       TextSpan(
                        //     //         text: "Check your app settings and ensure microphone permission is enabled.\n\n",
                        //     //         style: TextStyle(color: Colors.black),
                        //     //       ),
                        //     //       TextSpan(
                        //     //         text: "Reason 3: ",
                        //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        //     //       ),
                        //     //       TextSpan(
                        //     //         text: "Go to text suggestions in keyboard settings and enable 'show suggestion strip'.",
                        //     //         style: TextStyle(color: Colors.black),
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //     // ),
                        //     //
                        //     child: Column(
                        //       children: [
                        //         Icon(
                        //           Icons.help_outlined,
                        //           size: 20,
                        //         ).onTap(() {
                        //           WidgetsBinding.instance.addPostFrameCallback(
                        //             (_) => ShowCaseWidget.of(context)
                        //                 .startShowCase([_one]),
                        //           );
                        //         }),
                        //         // _buildRichDescription(),
                        //       ],
                        //     ),
                        //   );
                        // }),
                        4.width,
                      ],
                    ),
                  ),
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
                  setState(() {
                    ques = _lastWords;
                    _lastWords = "";
                  });
                  if (ques.isNotEmpty) {
                    save2(ques, widget.sessionId);
                  }

                  isKeyBoardTapped = false;
                  chatPageVM.controller.clear();
                },
                child: Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(40),
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
