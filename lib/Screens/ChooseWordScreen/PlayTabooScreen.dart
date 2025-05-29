import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Model/TabooGameChatPageModel.dart';
import 'package:balajiicode/Widget/text_gradient.dart';
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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Cloud tts/tts.dart';
import '../../Model/AllConversationModel.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../components/loader_widget_new.dart';
import '../../extensions/app_button.dart';
import '../../extensions/colors.dart';
import '../../extensions/constants.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../../stt/speech_service.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';
import 'Providers/PlayTabooScreenProvider.dart';
import 'Providers/completeMessageProvider.dart';
import 'Widgets/CompletingUserMessage.dart';
import 'Widgets/SuggetionsWidget.dart';

String text1 = """This is a test sentence. 😂😂😂😂
Another sentence without emoji.
Here is one with an emoji. 😎
Let's see if this works properly. 😂😂😂
Final test case. 🚀🚀🚀\n""";

final cloudTtsService = GoogleCloudTTSService();
final AudioPlayer audioPlayer = AudioPlayer();

bool showSubtitle = false;

class PlayTabooScreen extends StatefulWidget {
  final AllGameModel allGameModel;
  final int index;
  final String sessionId;
  final String gameName;

  const PlayTabooScreen(
      this.allGameModel, this.index, this.sessionId, this.gameName,
      {super.key});

  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();
}

class _PlayTabooScreen extends State<PlayTabooScreen> {
  final FocusNode languageFocus = FocusNode();
  final FocusNode englishLevelFocus = FocusNode();

  final TextEditingController aiMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final SpeechToText _speech = SpeechToText();
  int lastTapTime = 0;
  String previousSentence = "";
  String previousSessionId = "";
  String currentSessionId = "";
  String englishLevel = 'Beginner';
  String selectedLanguageForList = 'Hindi';
  final dropDownKey = GlobalKey<DropdownSearchState>();
  String newEnglishLevel = "";
  String ques = "";
  Timer? _noChangeTimer;
  String _lastRecognizedText = '';
  String currentText = '';


  ScrollController aiMessageScrollController = ScrollController();
  final bool _userScrolled = false;
  List<GlobalKey> _paraKeys = [];

  Timer? _noChangeTimerFor3Sec;
  String _lastRecognizedTextFor3Sec = '';

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
  getPermision() async {
    await requestMicrophonePermission();
  }

  @override
  void initState() {
    super.initState();
    getPermision();
    setUserMessageScrollController();
    setAIMessageScrollController();

    appStore.setLoading(false);
    print("this is game name : ${widget.gameName}");

    setisPop();
    currentSessionId = widget.sessionId;
    previousSessionId = getStringAsync(SESSION_ID);

    print(
        "=============CURRENT SESSION id is ==>" + currentSessionId.toString());
    print("=============PREVIOUS SESSION id is ==>" +
        previousSessionId.toString());

    // ttsManager.setSpeechRate(0.3);
    // ttsManager.setVoice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
      var completeMessagePro = Provider.of<AnswerAssistProvider>(context, listen: false);
      completeMessagePro.setCanActiveOrNot(true);
      vm.seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
      vm.chatPageAPI(
        context,
        "Hi, Let's play the game!",
        widget.sessionId,
        widget.allGameModel,
        widget.index,
        true,
        false,
        "speak",
        widget.gameName,
      );
    });

    Provider.of<PlayTabooScreenProvider>(context, listen: false)
        .setStartListening(false);
    Provider.of<PlayTabooScreenProvider>(context, listen: false)
        .setApiCalled(true);
    appStore.setLastWords("");

  }

  void setUserMessageScrollController() {
    scrollController.addListener(() {
      // Scroll to bottom when text changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void setAIMessageScrollController() {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    // Remove old logic and use ValueNotifier listener
    vm.currentParaIndex.addListener(() {
      if (vm.currentParaIndex.value > 1 &&
          aiMessageScrollController.hasClients &&
          !_userScrolled) {
        if (_paraKeys.length > vm.currentParaIndex.value) {
          final key = _paraKeys[vm.currentParaIndex.value];
          if (key.currentContext != null) {
            Scrollable.ensureVisible(
              key.currentContext!,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
              alignment: 0.1, // adjust as needed
            );
          }
        }
      }
    });
  }

  void animateAIMessageToStart() {
    if (aiMessageScrollController.hasClients) {
      aiMessageScrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void setisPop() {
    Future.delayed(Duration(seconds: 4)).then((e) {
      Provider.of<PlayTabooScreenProvider>(context, listen: false)
          .setIsPopAvailable(true);
    });
  }

  Response convertToResponse(CompleteConversation completeConversation) {
    return Response(
      aiResponse: completeConversation.aiResponse,
    );
  }

  Future<void> allConversationApiCall() async {
    appStore.setLoading(true);
    setValue(IS_MUTE,
        Provider.of<PlayTabooScreenProvider>(context, listen: false).isMuted);

    await allConversationApi(widget.sessionId).then((value) async {
      appStore.setLoading(false);

      if (value.completeConversation != null) {
        Provider.of<PlayTabooScreenProvider>(context, listen: false)
            .setApiCalled(true);
        Provider.of<PlayTabooScreenVM>(context, listen: false)
            .updateResponse(value.completeConversation!);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> speakText() async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);

    String text = vm.tabooGameChatPageModel.response!.aiResponse!.last;
    String updatedText = vm.cleanTextForTTS(text);

    await stopSpeaking();
    print("This speak to text called");
    if (text.isNotEmpty) {
      Provider.of<PlayTabooScreenProvider>(context, listen: false)
          .setLastWords(updatedText);
      // vm.setIsListening(false);
      // vm.speakParagraphs(updatedText, ttsManager, 0);
      if (cloudTtsService.ttsFilePaths.isNotEmpty) {
        cloudTtsService.speekSaved();
      } else {
        vm.speakText(updatedText);
      }
      Provider.of<PlayTabooScreenProvider>(context, listen: false)
          .setIsSpeaking(true);
    }
  }

  Future<void> stopSpeaking() async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    print("Called stop speaking");
    vm.setIsListening(true);
    vm.setIsBreakLoop(true);
    cloudTtsService.stop();
    // await ttsManager.stop();
  }

  // Future<void> adjustSpeechRate(double change) async {
  //   var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
  //   var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
  //
  //   provider.setLastWords(appStore.lastWords);
  //   double newRate = (provider.speechRate + change).clamp(0.2, 2.0);
  //   provider.setSpeechRate(newRate);
  //   // await ttsManager.setSpeechRate(newRate);
  //
  //   if (provider.isSpeaking || userStore.isTTSPlaying == "YES") {
  //     stopSpeaking();
  //     String remainingText = _getRemainingText();
  //
  //     Future.delayed(Duration(milliseconds: 1000), () async {
  //       // await ttsManager.setSpeechRate(newRate);
  //       await speakText();
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     });
  //   }
  // }

  Future<void> adjustSpeechRate(double change) async {
    double speed = cloudTtsService.audioSpeed;
    double newSpeed = double.parse((speed + change).toStringAsFixed(1));

    // Clamp between 0.5 and 1.7
    if (newSpeed >= 0.5 && newSpeed <= 1.7) {
      audioPlayer.setSpeed(newSpeed);
      cloudTtsService.audioSpeed = newSpeed;
      print("Adjusted speed: $newSpeed");
      // cloudTtsService.speekSaved();
    }
  }

  void _onDecreaseRatePressed() async {
    // int currentTime = DateTime.now().millisecondsSinceEpoch;
    // if (currentTime - lastTapTime < 800) return;
    // lastTapTime = currentTime;

    double speed = cloudTtsService.audioSpeed;
    if (speed > 0.5) {
      await adjustSpeechRate(-0.1);
    } else {
      Fluttertoast.showToast(msg: "Min speed");
    }
  }

  void _onIncreaseRatePressed() async {
    // int currentTime = DateTime.now().millisecondsSinceEpoch;
    // if (currentTime - lastTapTime < 800) return;
    // lastTapTime = currentTime;

    double speed = cloudTtsService.audioSpeed;
    if (speed < 1.7) {
      await adjustSpeechRate(0.1);
    } else {
      Fluttertoast.showToast(msg: "Max speed");
    }
  }

  String _getRemainingText() {
    var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
    if (provider.lastSpokenIndex < provider.lastWords.length) {
      return provider.lastWords.substring(provider.lastSpokenIndex);
    }
    return '';
  }

  // void save() {
  //   print("Save 1 Called");
  //   var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
  //   var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
  //
  //   provider.setMessage('Correcting Speech recognition mistakes');
  //   // ttsManager.setStartHandler(() {
  //   //   if (mounted) {
  //   //     provider.setIsSpeaking(true);
  //   //   }
  //   // });
  //   //
  //   // ttsManager.setCompletionHandler(() {
  //   //   vm.setIsListening(true);
  //   //   print('tts completed ${vm.isListening}');
  //   //   provider.setIsSpeaking(false);
  //   // });
  //   //
  //   // ttsManager.setErrorHandler((msg) {
  //   //   provider.setIsSpeaking(false);
  //   //   vm.setIsListening(true);
  //   // });
  //
  //   Provider.of<PlayTabooScreenVM>(context, listen: false)
  //       .seInitialValue(widget.allGameModel, widget.index, widget.sessionId);
  //   Provider.of<PlayTabooScreenVM>(context, listen: false).chatPageAPI(
  //     context,
  //     provider.ques,
  //     widget.sessionId,
  //     widget.allGameModel,
  //     widget.index,
  //     false,
  //     provider.isMuted,
  //     "speak",
  //     widget.gameName,
  //   );
  //
  //   provider.setApiCalled(true);
  //   provider.setLastWords(appStore.lastWords);
  //   provider.setStartListening(false);
  //   Future.delayed(Duration(seconds: 2), () {
  //     if (mounted) {
  //       provider.setMessage('Thinking...');
  //     }
  //   });
  // }

  void save2(String? correctedQues, String? sessionId) async {
    var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
    provider.setIsSpeaking(true);
    provider.setMessage('Correcting Speech recognition mistakes');
    try {
      final correctedSentence = await correctSentence(correctedQues, sessionId);

      if (correctedSentence != null) {
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
        provider.isMuted,
        "speak",
        widget.gameName,
      );

      provider.setApiCalled(true);
      provider.setLastWords(appStore.lastWords);
      userStore.setPreviousSentence(provider.lastWords);
      provider.setStartListening(false);
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          provider.setMessage('Thinking...');
        }
      });
    } catch (e) {
      toast(e.toString());
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

      return value?.response?.text;
    } catch (e) {
      toast(e.toString());
      appStore.setLoading(false);
      return null;
    }
  }

  void save3(String? correctedQues, String? sessionId) async {
    var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
    provider.setIsSpeaking(true);

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
        provider.isMuted,
        "speak",
        widget.gameName,
      );
      provider.setIsLoaderShow(false);
      provider.setApiCalled(true);
      provider.setLastWords(appStore.lastWords);
      userStore.setPreviousSentence(provider.lastWords);
      provider.setStartListening(false);
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

  Future<void> updateProficiency(
      String? englishProficiency, String? selectedNLanguage) async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    var playTabooScreenpro =
        Provider.of<PlayTabooScreenProvider>(context, listen: false);
    Map<String, dynamic> req = {
      'nativeLanguage': selectedNLanguage,
      'engprolevel': englishProficiency
    };

    try {
      playTabooScreenpro.setIsLoaderShow(true);
      final value = await updateProficiencyApi(req);
      newEnglishLevel = englishProficiency!;
      ques = appStore.userResponse;
      print("UserResponse is =>" + ques.toString());
      if (ques.isNotEmpty) {
        vm.setIsListening(true);
        vm.setIsBreakLoop(true);
        // ttsManager.stop();
        cloudTtsService.stop();

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

  void _sendAnalytics() {
    analytics.logEvent(
      name: 'speak',
      parameters: {
        'content_name':
            widget.allGameModel.allGame![widget.index].mainContent.toString(),
        'Game_name': widget.gameName,
        'User_id': getStringAsync(USER_ID),
      },
    ).then((_) {
      print('Logged event: speak with parameters:');
    }).catchError((error) {
      print('Failed to log event: $error');
    });
    facebookAppEvents.logEvent(
      name: 'speak',
      parameters: {
        'content_name':
            widget.allGameModel.allGame![widget.index].mainContent.toString(),
        'Game_name': widget.gameName,
        'User_id': getStringAsync(USER_ID),
      },
    ).then((_) {
      print('Logged event: speak with parameters:');
    }).catchError((error) {
      print('Failed to log event: $error');
    });
  }

  void _stopAndSendResponse(PlayTabooScreenVM vm) {
    _stopListening();
    vm.setIsPlayScreen(true);
    var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
    var completeProvider = Provider.of<AnswerAssistProvider>(context,listen: false);
    provider.setIsMuted(false);
    print("Mute state ${provider.isMuted}");
    provider.setSpeechRate(0.3);
    provider.setQues(completeProvider.wordController.text);
    provider.setLastWords(completeProvider.wordController.text);
    completeProvider.wordController.clear();
    provider.setLastWords("");
    completeProvider.setCanActiveOrNot(true);
    completeProvider.setIdle();
    if (provider.ques.isNotEmpty) {
      save2(provider.ques, widget.sessionId);
    }
    Future.delayed(Duration( milliseconds: 1000)).then((val){ completeProvider.setIdle();completeProvider.wordController.clear();});
    Future.delayed(Duration(milliseconds: 2100)).then((val){completeProvider.setIdle();});
  }

  void _startListening() async {
    print("called");
    final hasPermission = await _speech.startListening();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission not granted')),
      );
    }
  }

  void _stopListening() {
    _speech.stopListening();
  }

  @override
  void dispose() async {
    await stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double widthFactor = width / 390;
    double heightFactor = height / 844;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Consumer<AnswerAssistProvider>(
      builder: (context, completProvider, _) => Consumer<PlayTabooScreenVM>(
        builder: (context, vm, child) => Consumer<PlayTabooScreenProvider>(
          builder: (context, provider, child) => Scaffold(
              resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                centerTitle: false,
                leading: provider.isPopAvailable
                    ? InkWell(
                        onTap: () async {
                          await stopSpeaking();
                          appStore.setLoading(false);
                          vm.setIsPlayScreen(false);
                          provider.setIsExpanded(false);
                          provider.setIsLocked(false);
                          completProvider.wordController.clear();
                          provider.setIsshowHistoryAndSubtitle(
                              true);
                          completProvider.setIdle();
                          if (mounted) {
                            pop(true);
                          }
                        },
                        child: Icon(Icons.close)).withGradient()
                    : SizedBox(),
                title: Text(
                  softWrap: true,
                  widget.gameName,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 20 / 16,
                      color: Colors.white),
                ).withGradient(),
                actions: [
                  Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Text(
                                userStore.userEnglishProficiency,
                                style: secondaryTextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.white,
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
                print(
                    "======================= HELLO GAME COMPLETE =======================");
                print("======================= BYE =======================");
                if (provider.isPopAvailable) {
                  await stopSpeaking();
                  provider.setIsExpanded(false);
                  provider.setIsLocked(false);
                  provider.setIsshowHistoryAndSubtitle(true);
                  completProvider.wordController.clear();
                  vm.setIsPlayScreen(false);
                  completProvider.setIdle();
                  if (mounted) {
                    pop(true);
                  }
                  removeKey(SESSION_ID);
                }
                return false;
              },
              child: LayoutBuilder(
                builder: (context,constraints)=>
                 SingleChildScrollView(
                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                   child: ConstrainedBox(
                     constraints: BoxConstraints(minHeight: constraints.maxHeight),
                     child: Column(
                      children: [
                        Column(
                          children: [
                            5.height,
                            if (showSubtitle && !isLandscape)
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.175,
                              ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: !provider.apiCalled
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                              fit: BoxFit.cover,
                                              height: height * (205 / 812),
                                              ImageConstant.listening_female),
                                        ),
                                        if (!vm.isGifDownloaded &&
                                            vm.isListening)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                                fit: BoxFit.cover,
                                                height: height * (205 / 812),
                                                ImageConstant
                                                    .listening_female),
                                          ),
                                        if (!vm.isGifDownloaded &&
                                            !vm.isListening)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                                fit: BoxFit.cover,
                                                height: height * (205 / 812),
                                                ImageConstant
                                                    .speaking_female),
                                          ),
                                        if (vm.isListening &&
                                            vm.listeningGif != null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.memory(
                                                fit: BoxFit.cover,
                                                height: height * (205 / 812),
                                                vm.listeningGif!),
                                          ),
                                        if (!vm.isListening &&
                                            vm.talkingGif != null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.memory(
                                                fit: BoxFit.cover,
                                                height: height * (205 / 812),
                                                vm.talkingGif!),
                                          ),
                                      ],
                                    ),
                                    8.height,
                                    if (provider.apiCalled)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () =>
                                                      _onDecreaseRatePressed(),
                                                  child: Image.asset(
                                                    ImageConstant
                                                        .backward_icon,
                                                    width: 25,
                                                    height: 25,
                                                  )),
                                              Text(
                                                "Slow",
                                                style: secondaryTextStyle(
                                                    size: 11),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.visible,
                                              ).onTap(() {
                                                _onDecreaseRatePressed();
                                              })
                                            ],
                                          ),
                                          SizedBox(width: 25),
                                          Container(
                                            width: width * 0.14,
                                            height: height * 0.07,
                                            // color:Colors.redAccent,
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      int currentTime = DateTime
                                                              .now()
                                                          .millisecondsSinceEpoch;
                                                      if (currentTime -
                                                              lastTapTime <
                                                          800) {
                                                        return;
                                                      }
                                                      lastTapTime =
                                                          currentTime;
                                                      provider.setIsMuted(
                                                          !provider.isMuted);
                                                      setValue(IS_MUTE,
                                                          provider.isMuted);
                                                      if (provider.isMuted) {
                                                        await stopSpeaking();
                                                      } else {
                                                        await stopSpeaking();
                                                        animateAIMessageToStart();
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 1),
                                                            () {
                                                          speakText();
                                                        });
                                                      }
                                                    },
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        !provider.isMuted
                                                            ? 'assets/svg/unmute.svg'
                                                            : 'assets/svg/mute.svg',
                                                        width: 35,
                                                        height: 35,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: MyText(
                                                      text: !provider.isMuted
                                                          ? "Mute"
                                                          : "Unmute",
                                                      softwrap: false,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .visible,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 25),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () =>
                                                      _onIncreaseRatePressed(),
                                                  child: Image.asset(
                                                    ImageConstant
                                                        .forward_icon,
                                                    width: 25,
                                                    height: 25,
                                                  )),
                                              Text(
                                                "Fast",
                                                style: secondaryTextStyle(
                                                    size: 12),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.visible,
                                              ).onTap(() {
                                                _onIncreaseRatePressed();
                                              })
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                            8.height,
                            if (provider.isFirstTime)
                              LoadingWidget(message: "Listening..."),
                            if (provider.isLoaderShow)
                              CircularProgressIndicator(color: primaryColor),
                            if (!provider.apiCalled && !provider.isLoading)
                              Row(
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text: provider.lastWords,
                                      color: Color(0xff000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(
                                  horizontal: 16, vertical: 14),
                            if(showSubtitle)SizedBox(height: 89*heightFactor,),
                            if (provider.apiCalled &&
                                !provider.isLoaderShow &&
                                !showSubtitle &&
                                !isLandscape &&
                                !(keyboardHeight > 0) &&
                                !provider.isFirstTime)
                              vm.tabooGameChatPageModel.response == null
                                  ? LoadingWidget(message: provider.message)
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: provider.startListening
                                                  ? MyText(
                                                      text:
                                                          provider.lastWords,
                                                      color:
                                                          Color(0xff000000),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                      height: provider
                                                              .isExpanded
                                                          ? height * 0.18
                                                          : provider
                                                                  .isLocked
                                                              ? (completProvider.state ==
                                                                      AnswerAssistState.completing || completProvider.state ==
                                                                  AnswerAssistState.encouraging)
                                                                  ? height *
                                                                      0.1
                                                                  : height *
                                                                      .28
                                                              : height *
                                                                  0.28,
                                                      // height: height* 0.30,
                                                      child: Scrollbar(
                                                        child:
                                                            SingleChildScrollView(
                                                          controller:
                                                              aiMessageScrollController,
                                                          child: RichText(
                                                            textAlign:
                                                                TextAlign
                                                                    .left,
                                                            text:
                                                                TextSpan(
                                                              children: buildHighlightedTextSpans(vm
                                                                  .tabooGameChatPageModel
                                                                  .response!
                                                                  .aiResponse!
                                                                  .last),
                                                              style: primaryTextStyle(
                                                                      size:
                                                                          16)
                                                                  .copyWith(
                                                                height:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    ),
                          ],
                        ),
                        if (!provider.isLoaderShow)
                          vm.tabooGameChatPageModel.response == null
                              ? SizedBox()
                              : Container(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(

                                      children: [
                                        Suggetionswidget(
                                            text: "Skip Question",
                                            onTap: () {
                                              stopSpeaking();
                                              _sendAnalytics();
                                             completProvider.wordController.text =
                                                  "Skip Question";
                                              _stopAndSendResponse(vm);
                                            },
                                            isIcon: true),
                                        10.width,
                                        Suggetionswidget(
                                            text: "Yes, I'm ready",
                                            onTap: () {
                                              stopSpeaking();
                                              _sendAnalytics();
                                              completProvider.wordController.text =
                                                  "Yes, I'm ready";
                                              _stopAndSendResponse(vm);
                                            }),
                                        10.width,
                                        Suggetionswidget(
                                            text:
                                                "No, help me understand the game",
                                            onTap: () {
                                              stopSpeaking();
                                              _sendAnalytics();
                                              completProvider.wordController.text =
                                                  "No, help me understand the game";
                                              _stopAndSendResponse(vm);
                                            }),
                                      ],
                                    ).paddingSymmetric(
                                        vertical: 4,),
                                  ),
                              ).paddingSymmetric(horizontal: 12),
                        if (!provider.isLoaderShow)
                          vm.tabooGameChatPageModel.response == null
                              ? SizedBox()
                              : CompletingUserMessage(userMessage: completProvider.wordController.text.trim(), sessionId: widget.sessionId, gameModel: widget.allGameModel, index: widget.index, modality: '',).paddingSymmetric(
                                  vertical: 4, horizontal: 12),
                        // Row(children: [Expanded(child: SizedBox()),Expanded(child: CompletingAnswer())]),
                        if (!provider.isLoaderShow)
                          vm.tabooGameChatPageModel.response == null
                              ? SizedBox()
                              : Center(
                                  child: _showSpeakAndListen(vm, height, width,
                                      heightFactor, keyboardHeight)),
                      ],
                     ),
                   ),
                 ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showSpeakAndListen(PlayTabooScreenVM vm, double height, double width,
      double heightFactor, double keyboardHeight) {
    var provider = Provider.of<PlayTabooScreenProvider>(context, listen: true);
    var completeProvider = Provider.of<AnswerAssistProvider>(context,listen: false);

    // if( provider.isTtsCompleted){
    //   provider.setIsTtsCompleted(false);
    //   stopSpeaking();
    //   provider.setIsOnPressedEnd(true);
    //   provider.setIsLocked(true);
    //   provider.setIsOnLockedAndRestartListening(true);
    //   provider.setIsshowHistoryAndSubtitle(false);
    //   print("setIsOnLockedAndRestartListening ${provider.isOnLockedAndRestartListening}");
    //   provider.setpreviousSpokenTextWhenStateIsLocked(completeProvider.wordController.text.trim());
    //   print("last reconginzed $_lastRecognizedText");
    //   _startListening();
    // }


    _speech.onResults.listen((result) {
      currentText = result.text ?? '';
      // Update text in controller
      print(provider.isOnLockedAndRestartListening);
      if (provider.isOnLockedAndRestartListening) {
        print("inside listener last word $_lastRecognizedText");
        currentText = '${provider.previousSpokenTextWhenStateIsLocked} $currentText';
      }

      completeProvider.wordController.text = currentText;
      print(currentText);

      // Track status
      print("status of tts ${result.status}");

      // Check recognizing state
      if (result.status == "recognizing") {
        // If text changed, reset timer
        provider.setIsRecognizingText(true);

        if (currentText != _lastRecognizedTextFor3Sec) {
          // Text changed, reset timer
          _lastRecognizedTextFor3Sec = currentText;

          // Cancel the old timer
          _noChangeTimerFor3Sec?.cancel();

          // Start a new 3-second timer
          _noChangeTimerFor3Sec = Timer(Duration(seconds: 3), () {
            print("pause for 3 second called ");
            if(completeProvider.canDoActiveOrNot){
              var pro =  Provider.of<AnswerAssistProvider>(context,listen: false);
              pro.setActive();
              pro.setCanActiveOrNot(false);
            }
          });
        }

        if (currentText != _lastRecognizedText) {
          _lastRecognizedText = currentText;

          // Cancel any existing timer
          _noChangeTimer?.cancel();

          // Start new timer
          _noChangeTimer = Timer(Duration(seconds: 8), () {
            // Trigger function if text unchanged for 10s
            provider.setIsOnPressedEnd(false);
            _stopListening();
          });
        }
      } else {
        provider.setIsRecognizingText(false);
      }
    });

    return Column(
      children: [
        if (provider.isLocked)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              // height: 95 * heightFactor,
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightGreyBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Scrollbar(
                  // optional for better UX
                  child: SingleChildScrollView(
                    // controller: scrollController,
                    padding: EdgeInsets.zero,
                    child: TextField(
                      controller: completeProvider.wordController,
                      onChanged: (val) {
                        _stopListening();
                      },
                      onTap: () {
                        _stopListening();
                      },
                      maxLines: 3,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontFamily: "inter", fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Spoken words here...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (!(keyboardHeight > 0))
          Container(
            height:
                (!provider.isExpanded) ? height * (140 / 812) : height * .30,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (provider.isLocked || provider.isExpanded)
                        GestureDetector(
                          child: Container(
                            child: GestureDetector(
                              onTap: provider.isExpanded
                                  ? null
                                  : () {

                                      _stopListening();
                                      provider.setIsExpanded(false);
                                      provider.setIsLocked(false);
                                      provider.setIsOnPressedEnd(false);
                                      provider
                                          .setIsshowHistoryAndSubtitle(true);
                                      provider.setIsOnLockedAndRestartListening(
                                          false);
                                      provider.setpreviousSpokenTextWhenStateIsLocked('');
                                     completeProvider.setCanActiveOrNot(true);
                                      completeProvider.setIdle();
                                     Future.delayed(Duration( milliseconds: 1000)).then((val){ completeProvider.setIdle();completeProvider.wordController.clear();});
                                     Future.delayed(Duration( milliseconds: 2100)).then((val){ completeProvider.setIdle();completeProvider.wordController.clear();});
                                    },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 37,
                                  ),
                                  MyText(
                                    text: "Discard",
                                    fontSize: 12,
                                    softwrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: width * .5),
                      if (provider.isExpanded)
                        SizedBox(
                          width: 37,
                        ),
                      if (provider.isLocked)
                        GestureDetector(
                          child: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 37,
                                    height: 37,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.purple,
                                          Colors.cyan
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(18.5)),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          _sendAnalytics();
                                          _stopAndSendResponse(vm);


                                          provider.setIsExpanded(false);
                                          provider.setIsLocked(false);
                                          provider.setIsshowHistoryAndSubtitle(
                                              true);
                                          provider.setIsOnPressedEnd(false);
                                          provider
                                              .setIsOnLockedAndRestartListening(
                                                  false);
                                          provider.setpreviousSpokenTextWhenStateIsLocked('');


                                          // scrollController = ScrollController();
                                          // setAIMessageScrollController();
                                        },
                                        icon: Icon(Icons.send),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  MyText(
                                    text: "Send",
                                    fontSize: 12,
                                    color: blackColor,
                                    softwrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
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
                  bottom: 25,
                  child: GestureDetector(
                    // onTap: provider.isLocked
                    //     ?
                       onTap:  () {
                            if (provider.isOnPressedEnd) {
                              provider.setIsOnPressedEnd(false);
                              _stopListening();

                            } else {
                              stopSpeaking();
                              provider.setIsOnPressedEnd(true);
                              provider.setIsLocked(true);
                              provider.setIsOnLockedAndRestartListening(true);
                              provider.setIsshowHistoryAndSubtitle(false);
                              print("setIsOnLockedAndRestartListening ${provider.isOnLockedAndRestartListening}");
                              provider.setpreviousSpokenTextWhenStateIsLocked(completeProvider.wordController.text.trim());
                              print("last reconginzed $_lastRecognizedText");
                              _startListening();
                            }
                          },
                        // : () {
                        //     provider.setIsExpanded(true);
                        //     provider.setIsshowHistoryAndSubtitle(false);
                        //     Timer(Duration(milliseconds: 300), () {
                        //       provider.setIsExpanded(false);
                        //       provider.setIsshowHistoryAndSubtitle(true);
                        //     });
                        //   },
                    onTapUp: (details) {
                      // if (details.localPosition.dy < -50) {
                      //   provider.setIsSwipingUp(true);
                      //   Future.delayed(Duration(milliseconds: 2000));
                      //   provider.setIsLocked(true);
                      //   provider.setIsExpanded(false);
                      //   provider.setIsshowHistoryAndSubtitle(false);
                      //   provider.setIsSwipingUp(false);
                      // }
                    },
                    onLongPress: provider.isLocked
                        ? null
                        : () async {
                            provider.setIsExpanded(true);
                            provider.setIsshowHistoryAndSubtitle(false);
                            provider.setIsOnPressedEnd(true);
                            await stopSpeaking();
                            _startListening();
                            showTextBox();
                          },
                    onLongPressEnd: (details) async {
                      if (details.localPosition.dx < -50) {
                        _stopListening();
                        print("swip left");
                        provider.setIsExpanded(false);
                        provider.setIsLocked(false);
                        provider.setIsshowHistoryAndSubtitle(true);
                        // provider.setIsOnPressedEnd(false);
                        completeProvider.setCanActiveOrNot(true);
                      } else if (details.localPosition.dy < -50) {
                        provider.setIsSwipingUp(true);
                        Future.delayed(Duration(milliseconds: 1000));
                        provider.setIsLocked(true);
                        provider.setIsExpanded(false);
                        provider.setIsshowHistoryAndSubtitle(false);
                        provider.setIsSwipingUp(false);
                      } else {
                        _stopListening();
                        provider.setIsLocked(true);
                        provider.setIsExpanded(false);
                        provider.setIsshowHistoryAndSubtitle(false);
                        provider.setIsSwipingUp(false);
                        provider.setIsOnPressedEnd(false);
                      }
                    },
                    child: ((provider.isExpanded || provider.isLocked) &&
                            provider.isOnPressedEnd)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 76,
                                width: 76,
                                // padding: EdgeInsets.only(left: 4,right: 4,bottom: 17),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(43),
                                   gradient:  LinearGradient(
                                      colors: [ Color(0xff9840EB),Color(0xff09C8C8)], // Gradient Colors
                                    )
                                ),
                                child: Lottie.asset(
                                    delegates: LottieDelegates(
                                      values: [
                                        ValueDelegate.color(
                                          const [
                                            '**'
                                          ], // wildcard to match all layers
                                          value: Colors.white,
                                        ),
                                      ],
                                    ),
                                    'assets/lottiefile/Waveform Animation.json'),
                              ).center(),
                              MyText(
                                text: "Listening…",
                                fontSize: 12,
                                maxLines: 1,
                                softwrap: false,
                                overflow: TextOverflow.visible,
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
                                  color: Color(0xffE1DDF4),
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
                                softwrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              )
                            ],
                          ),
                  ),
                ),
                if (provider.isExpanded)
                  Positioned(
                    top: 5,
                    // bottom: 110,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.isSwipingUp
                                ? primaryColor
                                : Colors.grey.shade300,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(Icons.lock,
                                color: provider.isSwipingUp
                                    ? Colors.white
                                    : Colors.black),
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
                if (provider.isExpanded)
                  Positioned(
                    left: 80,
                    bottom: 53,
                    child: Container(
                      // child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      // AnimatedContainer(
                      //   duration: Duration(milliseconds: 300),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: provider.isSwipingLeft
                      //         ? Colors.blue
                      //         : Colors.transparent,
                      //   ),
                      //   child: Icon(
                      //     Icons.delete_outline,
                      //     size: 36,
                      //     color: provider.isSwipingLeft
                      //         ? Colors.white
                      //         : Colors.black,
                      //   ),
                      // ),
                      child: Icon(Icons.keyboard_arrow_left,
                              color: Colors.grey.shade300, size: 40)
                          .animate()
                          .slideX(begin: 0.5, end: 0, duration: 500.ms),
                      //   ],
                      // ),
                      // MyText(
                      //   text: "Discard",
                      //   fontSize: 12,
                      //   softwrap: false,
                      //   maxLines: 1,
                      //   overflow: TextOverflow.visible,
                      // ),
                      // ]),
                    ).animate().fadeIn(duration: 300.ms),
                  ),
                if (provider.isshowHistoryAndSubtitle)
                  Positioned(
                    bottom: 34,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            analytics.logEvent(
                              name: 'write',
                              parameters: {
                                'content_name': widget.allGameModel
                                    .allGame![widget.index].mainContent
                                    .toString(),
                                'Game_name': widget.gameName,
                                'User_id': getStringAsync(USER_ID),
                              },
                            ).then((_) {
                              print('Logged event: write with parameters:');
                            }).catchError((error) {
                              print('Failed to log event: $error');
                            });
                            facebookAppEvents.logEvent(
                              name: 'write',
                              parameters: {
                                'content_name': widget.allGameModel
                                    .allGame![widget.index].mainContent
                                    .toString(),
                                'Game_name': widget.gameName,
                                'User_id': getStringAsync(USER_ID),
                              },
                            ).then((_) {
                              print('Logged event: write with parameters:');
                            }).catchError((error) {
                              print('Failed to log event: $error');
                            });
                            await stopSpeaking();
                            final bool res = await TaboogamechatPage(
                                    widget.allGameModel,
                                    widget.index,
                                    widget.sessionId,
                                    widget.gameName)
                                .launch(context);
                            if (res == true) {
                              allConversationApiCall();
                              if (provider.isMuted) {
                                await stopSpeaking();
                              }
                            }
                          },
                          child: Container(
                            width: width * (110 / 375),
                            height: height * (60 / 812),
                            // color: Colors.redAccent,
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
                                  softwrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: width * .3),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              showSubtitle = !showSubtitle;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              width: width * (110 / 375),
                              height: height * (60 / 812),
                              // color: Colors.redAccent,
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
                                          ? blackColor
                                          : primaryColor,
                                    ),
                                    MyText(
                                      text: showSubtitle
                                          ? "Show Subtitle"
                                          : "Hide Subtitle",
                                      fontSize: 12,
                                      color: showSubtitle
                                          ? blackColor
                                          : primaryColor,
                                      softwrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                    )
                                  ],
                                ),
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
    );
  }

  void showTextBox() async {
    var provider = Provider.of<PlayTabooScreenProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((val) {
      if (provider.isRecognizingText) {
        provider.setIsLocked(true);
        provider.setIsExpanded(false);
        provider.setIsshowHistoryAndSubtitle(false);
        provider.setIsSwipingUp(false);
      } else {
        showTextBox();
      }
    });
  }

  List<WidgetSpan> buildHighlightedTextSpans(String res) {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    List<WidgetSpan> spans = [];
    List<String> paragraphs = splitAndPreserveDelimiters(res);
    paragraphs = paragraphs.where((p) => p.trim().isNotEmpty).toList();
    // Assign keys for each paragraph
    _paraKeys = List.generate(paragraphs.length, (_) => GlobalKey());
    for (int j = 0; j < paragraphs.length; j++) {
      String paragraph = paragraphs[j].replaceAll(RegExp(r'\*+'), '');
      paragraph = cleanString(paragraph);
      print(paragraph);
      bool isBold = (j == vm.currentParaIndex.value);
      spans.add(
        WidgetSpan(
          child: KeyedSubtree(
            key: _paraKeys[j],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                paragraph,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? Color(0Xff1A1A1A) : Color(0Xff707070),
                  fontSize: isBold ? 17 : 18,
                  fontFamily: "inter",
                  height: 18 / 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      );
    }
    return spans;
  }

  // String cleanTextForTTS(String text) {
  //   String textWithoutdoubleQuat = text.replaceAll("\"", "");
  //   String textWithoutSingleQuat =
  //   textWithoutdoubleQuat.replaceAll(RegExp(r"[‘’']"), "");
  //   return textWithoutSingleQuat.replaceAll(RegExp(r'\*+'), '');
  // }
  String cleanString(String input) {
    input = input.replaceAll("\n\n", " ");
    if (input.startsWith(' ')) {
      return input.substring(1);
    }
    return input;
  }

  String removeEmojisAfterPeriodBeforeNewline(String text) {
    return text.replaceAllMapped(RegExp(r'\.([\s\S]*?)\n+', multiLine: true),
        (match) {
      String segment = match.group(1) ?? "";
      if (segment.trim().isNotEmpty &&
          segment.trim().replaceAll(emojiRegex(), "").isEmpty) {
        segment = segment.replaceAll(emojiRegex(), "");
      }
      return ".${segment}\n";
    });
  }

  List<String> splitAndPreserveDelimiters(String res) {
    List<String> paragraphs = [];
    RegExp regex = RegExp(r'(\n+|\.)');
    Iterable<RegExpMatch> matches = regex.allMatches(res);

    int lastIndex = 0;

    for (RegExpMatch match in matches) {
      String part = res.substring(lastIndex, match.start);
      String delimiter = match.group(0)!;

      if (part.trim().isNotEmpty) {
        paragraphs.add(part + delimiter);
      } else if (paragraphs.isNotEmpty) {
        paragraphs[paragraphs.length - 1] += delimiter;
      }

      lastIndex = match.end;
    }

    if (lastIndex < res.length) {
      String remaining = res.substring(lastIndex).trim();
      if (remaining.isNotEmpty) {
        paragraphs.add(remaining);
      }
    }

    return paragraphs;
  }
}

class BuildMassageScreen extends StatefulWidget {
  BuildMassageScreen({super.key});

  @override
  State<BuildMassageScreen> createState() => _BuildMassageScreenState();
}

class _BuildMassageScreenState extends State<BuildMassageScreen> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              var chatPageVM =
                  Provider.of<PlayTabooScreenVM>(context, listen: false);
              String messageText = chatPageVM.controller.text.trim();
              chatPageVM.controller.clear();
              _focusNode.unfocus();
              Navigator.pop(context, messageText);
              return false;
            },
            child: SafeArea(child: _buildMessageInput(context))));
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: Consumer<PlayTabooScreenVM>(
              builder: (context, vm, child) {
                return TextField(
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 20 / 16,
                    fontFamily: 'inter',
                  ),
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
                    hintStyle: secondaryTextStyle(
                        size: 16, height: 20 / 16, fontFamily: 'inter'),
                    labelStyle: secondaryTextStyle(
                        size: 16, height: 20 / 16, fontFamily: 'inter'),
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
                color: gradientStartColor,
                strokeWidth: 2,
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
                        MyText(
                          text: "Use keyboard's voice typing",
                          fontSize: 14,
                        ),
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
                  FocusScope.of(context).unfocus();
                  // Future.delayed(Duration(seconds:1)).then((e){
                  var chatPageVM =
                      Provider.of<PlayTabooScreenVM>(context, listen: false);
                  String messageText = chatPageVM.controller.text.trim();
                  chatPageVM.controller.clear();
                  Navigator.pop(context, messageText);
                  // });
                  // unmuteSystemSounds();
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
}
