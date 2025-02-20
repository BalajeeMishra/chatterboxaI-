import 'dart:ui';

import 'package:balajiicode/Constants/ApiURLConstant.dart';
import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Model/TabooGameChatPageModel.dart';
import 'package:balajiicode/ShareAndReview/share_and_review.dart';
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
import 'package:http/http.dart'as http;

final TTSManager ttsManager = TTSManager();
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
  bool _speechEnabled = false;
  double firstSoundLevel = 0.3;
  String _lastWords = '';
  String _previousWords = '';
  String ques = "";
  bool isLoading = false;
  bool apiCalled = false;
  bool isFirstTime = false;
  bool isLoaderShow = false;
  bool isMuted = false;
  String currentSpeechText = "";

  //Screen2 data
  double speechRate = 0.3;
  bool isSpeaking = false;
  String message = '';
  int _lastSpokenIndex = 0;
  String selectedLanguage = 'English';

  // bool _isListening = false;
  bool isSpeechInitialized = false;
  bool isPopAvailable = false;


  bool showSubtitle = false;
  // int timeFordelay = 400;

  //store gif in local var


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

  String previousSentence = "";
  String previousSessionId = "";
  String currentSessionId = "";

// bool isGameComplete = false;

  @override
  void initState() {
    super.initState();

    appStore.setLoading(false);
    print("this is game name : ${widget.gameName}");

    // setState(() {
    //   listeningGif = widget.allGameModel.allGame![widget.index].listeningCharacter.bodyBy
    // });
    setisPop();
    currentSessionId = widget.sessionId;
    previousSessionId = getStringAsync(SESSION_ID);
    //
    print(
        "=============CURRENT SESSION id is ==>" + currentSessionId.toString());
    print("=============PREVIOUS SESSION id is ==>" +
        previousSessionId.toString());

    selectedLanguageForList = userStore.userNativeLanguage;
    englishLevel = userStore.userEnglishProficiency;
    newEnglishLevel = userStore.userEnglishProficiency;
    // print("User NAtive Language is==>" + userStore.userNativeLanguage);
    // print("User English Proficiency is==>" + userStore.userEnglishProficiency);
    ttsManager.setSpeechRate(firstSoundLevel);
    WidgetsBinding.instance.addPostFrameCallback((_) {

    var vm =  Provider.of<PlayTabooScreenVM>(context, listen: false);
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
    startListening = false;
    apiCalled = true;

    appStore.setLastWords("");
      setState(() {
      });

  }
  void setisPop(){
    Future.delayed(Duration(seconds: 4)).then((e){
      isPopAvailable = true;
      setState(() {

      });
    });
  }


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
      // toast(e.toString());
      if(mounted){
        setState(() {});
      }
    });
  }

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
    await ttsManager.setLanguage('en-US');

    await ttsManager.setVolume(1.0);
    // await ttsManager.setSpeechRate(speechRate);
  }

  Future<void> speakText() async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    configureTts();
    String text = vm.tabooGameChatPageModel.response!.aiResponse!.last;
    String updatedText = cleanTextForTTS(text);

    stopSpeaking();
    print("This speak to text called");
    // vm.increseIndexForBoldText(text,timeFordelay);
    if (text.isNotEmpty) {
      _lastWords = updatedText;
      vm.setIsListening(false);
      // await ttsManager.speak(updatedText);
      vm.speakParagraphs(updatedText, ttsManager,0);
      isSpeaking = true;
      setState(() {

      });

      // ttsManager.setCompletionHandler(() {
      //   vm.setIsListening(true);
      //   print("tts completed ${vm.isListening}");
      //   isSpeaking = false;
      //   _lastSpokenIndex = updatedText.length;
      // });
      //
      // ttsManager.setErrorHandler((error) {
      //   vm.setIsListening(true);
      //   isSpeaking = false;
      // });
      //
      // ttsManager.setProgressHandler((word){
      //   // vm.setCurrentWord(word);
      //   vm.setCurrentIndex(vm.currentIndex++);
      // });
    } else {}
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    print("Called stop speaking");
    vm.setIsListening(true);
    vm.setIsBreakLoop(true);
    await ttsManager.stop();
  }

  /// Submit and call next function

  Future<void> adjustSpeechRate(double change) async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);

    _lastWords = appStore.lastWords;

    speechRate = (speechRate + change).clamp(0.2, 2.0);

    await ttsManager.setSpeechRate(speechRate);

    if (isSpeaking || userStore.isTTSPlaying == "YES") {

      stopSpeaking();


      String remainingText = _getRemainingText();

      Future.delayed(Duration(milliseconds: 1000), () async {
        // if (remainingText.isNotEmpty) {
          await ttsManager.setSpeechRate(speechRate);
          await speakText();
          if(mounted){
            setState(() {});
          }
        // }
      });
    }
  }
  int lastTapTime = 0;

  void _onDecreaseRatePressed() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - lastTapTime < 1500) {
      return;
    }

    lastTapTime = currentTime;
    adjustSpeechRate(-0.1);
    if(mounted) {
      setState(() {});
    }
  }


  _onIncreaseRatePressed() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - lastTapTime < 1500) {
      return;
    }
    lastTapTime = currentTime;
    adjustSpeechRate(0.1);
    if(mounted) {
      setState(() {});
    }
  }



  String _getRemainingText() {
    if (_lastSpokenIndex < _lastWords.length) {
      return _lastWords.substring(_lastSpokenIndex);
    }
    return '';
  }

  save() {
    print("Save 1 Called");
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    message = 'Correcting Speech recognition mistakes';
    ttsManager.setStartHandler(() {
     if(mounted){
       setState(() {
         isSpeaking = true;
       });
     }
    });

    ttsManager.setCompletionHandler(() {
      vm.setIsListening(true);
      print('tts completed ${vm.isListening}');
      setState(() {
        isSpeaking = false;
      });
    });

    ttsManager.setErrorHandler((msg) {
      setState(() {
        vm.setIsListening(true);
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
      isMuted,
      "speak",
      widget.gameName,
    );
    // configureTts();
    apiCalled = true;

    _lastWords = appStore.lastWords;
    startListening = false;
    Future.delayed(Duration(seconds: 2), () {
     if(mounted){
       setState(() {
         message = 'Thinking...';
       });
     }
    });
    // // isMuted = getBoolAsync(IS_MUTE);
    if(mounted){
      setState(() {

      });
    }
  }

  save2(String? correctedQues, String? sessionId) async {
    setState(() {
      isSpeaking = true;
    });
    message = 'Correcting Speech recognition mistakes';
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
        isMuted,
        "speak",
        widget.gameName,
      );
      // configureTts();
      apiCalled = true;
      _lastWords = appStore.lastWords;
      userStore.setPreviousSentence(_lastWords);
      startListening = false;
      Future.delayed(Duration(seconds: 2), () {
        if(mounted) {
          setState(() {
          message = 'Thinking...';
        });
        }
      });

      if(mounted){
        setState(() {

        });
      }

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
        isMuted,
        "speak",
        widget.gameName,
      );
      isLoaderShow = false;
      apiCalled = true;
      _lastWords = appStore.lastWords;
      userStore.setPreviousSentence(_lastWords);
      startListening = false;
      // isMuted = getBoolAsync(IS_MUTE);
      if(mounted){
        setState(() {

        });
      }
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
                          .where((language) =>
                          language
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
                      .map((value) =>
                      DropdownMenuItem<String>(
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




  Future<void> updateProficiency(String? englishProficiency,
      String? selectedNLanguage) async {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
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
        vm.setIsListening(true);
        vm.setIsBreakLoop(true);
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
      toast(e.toString());
      appStore.setLoading(false);
      return null;
    }
  }

  @override
  void dispose() {
    stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Consumer<PlayTabooScreenVM>(
      builder: (context,vm,child)=>
       Scaffold(
        // key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            centerTitle: false,
            leading:
            // vm.tabooGameChatPageModel.response == null?SizedBox():
           isPopAvailable? GradientIcon(
                ontap: () async{
                 await ttsManager.stopAndReset();
                  stopSpeaking();
                 await ttsManager.stopAndReset();
                 vm.setIsPlayScreen(false);
                 if (mounted) {
                   pop(true);
                 }
                }, icon: Icons.close
            ):SizedBox(),

            title: GradientText(
              softWrap: true,
              widget.gameName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,height: 20/16, color: Colors.white),

            ),
            actions: [

                Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Text(
                          newEnglishLevel,
                          style:
                          secondaryTextStyle(fontStyle: FontStyle.italic,color: Colors.white),
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
             // if(vm.tabooGameChatPageModel.response != null){
              if(isPopAvailable){
                stopSpeaking();
                vm.setIsPlayScreen(false);
                if(mounted ){
                  pop(true);
                }
                removeKey(SESSION_ID);
              }
             // }
            return false;
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                  child: Consumer<PlayTabooScreenVM>(
                    builder: (context, vm, child) =>
                        Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if(showSubtitle && !isLandscape)
                                    SizedBox(height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.175   ,),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        mainAxisAlignment: !apiCalled
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceBetween,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    8),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    height: height* (212 / 812),
                                                    // width: 320,
                                                    ImageConstant.listening_female                                           ),
                                              ),
                                              if(!vm.isGifDownloaded && vm.isListening)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      8),
                                                  child: Image.asset(
                                                      fit: BoxFit.cover,
                                                      height: height* (212 / 812),
                                                      // width: 320,
                                                      ImageConstant.listening_female
                                                  ),
                                                ),
                                              if(!vm.isGifDownloaded && !vm.isListening)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      8),
                                                  child: Image.asset(
                                                      fit: BoxFit.cover,
                                                      height: height* (212 / 812),
                                                      // width: 320,
                                                      ImageConstant.speaking_female
                                                  ),
                                                ),
                                              if (vm.isListening && vm.listeningGif != null)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      8),
                                                  child: Image.memory(
                                                      fit: BoxFit.cover,
                                                      height: height* (212 / 812),
                                                      // width: 320,
                                                      vm.listeningGif!

                                                  ),
                                                ),
                                              if (!vm.isListening && vm.talkingGif != null)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      8),
                                                  child: Image.memory(
                                                      fit: BoxFit.cover,
                                                      height: height * (212 / 812),
                                                      // width: 320,
                                                      vm.talkingGif!

                                                  ),
                                                ),
                                            ],
                                          ),


                                          // if (vm.isListening && vm.talkingString ==''  && vm.talkingGif == null )
                                          //   ClipRRect(
                                          //     borderRadius: BorderRadius.circular(
                                          //         8),
                                          //     child: Image.asset(
                                          //         fit: BoxFit.cover,
                                          //         height: 212,
                                          //         width: 320,
                                          //         ic_transparent_girlImage2
                                          //     ),
                                          //   ),
                                          // if (!vm.isListening && vm.talkingString =='' && vm.talkingGif == null)
                                          //   ClipRRect(
                                          //     borderRadius: BorderRadius.circular(
                                          //         8),
                                          //     child: Image.asset(
                                          //         fit: BoxFit.cover,
                                          //         height: 212,
                                          //         width: 320,
                                          //         ImageConstant.speaking_female),
                                          //   ),
                                          SizedBox(
                                            height: 13,
                                          ),
                                          if (apiCalled)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [

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
                                                      onTap: () =>
                                                          _onDecreaseRatePressed(),
                                                      child: Image.asset(
                                                        ImageConstant.backward_icon,
                                                        width: 25,
                                                        height: 25,
                                                      )
                                                    ),

                                                    //   onPressed: () => _onDecreaseRatePressed(),
                                                    // ),
                                                    Text(
                                                      "Slow",
                                                      style: secondaryTextStyle(
                                                          size: 12),
                                                    ).onTap(() {
                                                      _onDecreaseRatePressed();
                                                    })
                                                  ],
                                                ),
                                                SizedBox(width: 25,),
                                                Container(
                                                 width: width*0.13,
                                                 height: height * 0.07,                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        // IconButton(
                                                        //   alignment: Alignment.bottomLeft,
                                                        //
                                                        //   padding: EdgeInsets.all(0),
                                                        //   // constraints: BoxConstraints(maxWidth: 0,minWidth: 0),
                                                        //
                                                        //   icon:
                                                        InkWell(
                                                          onTap: () {
                                                            int currentTime = DateTime.now().millisecondsSinceEpoch;

                                                            if (currentTime - lastTapTime < 500) {
                                                              return;
                                                            }

                                                            lastTapTime = currentTime;
                                                            setState(() {
                                                              _lastWords =
                                                                  appStore.lastWords;

                                                              // isMuted= getBoolAsync(IS_MUTE);

                                                              isMuted = !isMuted;
                                                              setValue(IS_MUTE, isMuted);

                                                              if (isMuted) {

                                                                  stopSpeaking();
                                                                                                                       }
                                                              // else if (_lastWords
                                                              //     .isNotEmpty &&
                                                              //     _lastSpokenIndex <
                                                              //         _lastWords
                                                              //             .length) {
                                                              //   // speakText(_lastWords.substring(_lastSpokenIndex));
                                                              //   speakText();
                                                              // }
                                                              else{
                                                                stopSpeaking();
                                                                Future.delayed(Duration(seconds: 1),(){
                                                                  speakText();
                                                                });
                                                              }
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Image.asset(
                                                              !isMuted ? ImageConstant.speaker:ImageConstant.speaker_close,
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                          ),
                                                        ),

                                                        //   onPressed: () => _onDecreaseRatePressed(),
                                                        // ),
                                                        Center(
                                                          child: MyText(
                                                            text:
                                                            !isMuted ? "Mute" : "Unmute",
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .end,
                                                  children: [
                                                    // IconButton(
                                                    //   alignment: Alignment.bottomRight,
                                                    //
                                                    //   // constraints: BoxConstraints(maxWidth: 0,minWidth: 0),
                                                    //   padding: EdgeInsets.all(0),
                                                    //   icon:
                                                    InkWell(
                                                      onTap: () =>
                                                          _onIncreaseRatePressed(),
                                                      child: Image.asset(
                                                        ImageConstant.forward_icon,
                                                        width: 25,
                                                        height: 25,
                                                      )
                                                    ),
                                                    //   onPressed: () => _onIncreaseRatePressed(),
                                                    // ),
                                                    Text(
                                                      "Fast",
                                                      style: secondaryTextStyle(
                                                          size: 12),
                                                    ).onTap(() {
                                                      _onIncreaseRatePressed();
                                                    })
                                                  ],
                                                )
                                              ],
                                            )
                                        ],
                                      )
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  if (isFirstTime)
                                    LoadingWidget(
                                      message: "Listening...",
                                    ),
                                  if (isLoaderShow)
                                    CircularProgressIndicator(
                                        color: primaryColor),
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
                                    ).paddingSymmetric(
                                        horizontal: 16, vertical: 14),
                                  if (apiCalled && !isLoaderShow && !showSubtitle && !isLandscape)
                                    Consumer<PlayTabooScreenVM>(
                                      builder: (context, vm, child) {
                                        return vm.tabooGameChatPageModel
                                            .response == null
                                            ? LoadingWidget(
                                          message: message,
                                        )
                                            : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 0),
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
                                                      .last == null ||
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
                                                        0.38,
                                                    child:
                                                    SingleChildScrollView(
                                                      child:
                                                      // Text(vm.tabooGameChatPageModel.response!.aiResponse!.last)
                                                      RichText(
                                                       textAlign: TextAlign.left,
                                                        text: TextSpan(
                                                          children: buildHighlightedTextSpans(
                                                              vm
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
                            if (!isLoaderShow)
                              Consumer<PlayTabooScreenVM>(
                                  builder: (context, vm, child) {
                                    return vm.tabooGameChatPageModel.response ==
                                        null
                                        ? SizedBox()
                                        : Center(
                                      child: startListening
                                          ? listeningWidget()
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              analytics.logEvent(
                                                name: 'write',
                                                parameters: {
                                                  'content_name': widget
                                                      .allGameModel
                                                      .allGame![widget.index]
                                                      .mainContent
                                                      .toString(),
                                                  'Game_name': widget.gameName,
                                                  'User_id':
                                                  getStringAsync(USER_ID),
                                                },
                                              ).then((_) {
                                                print(
                                                    'Logged event: write with parameters:');
                                              }).catchError((error) {
                                                print(
                                                    'Failed to log event: $error');
                                              });
                                              facebookAppEvents.logEvent(
                                                name: 'write',
                                                parameters: {
                                                  'content_name': widget
                                                      .allGameModel
                                                      .allGame![widget.index]
                                                      .mainContent
                                                      .toString(),
                                                  'Game_name': widget.gameName,
                                                  'User_id':
                                                  getStringAsync(USER_ID),
                                                },
                                              ).then((_) {
                                                print(
                                                    'Logged event: write with parameters:');
                                              }).catchError((error) {
                                                print(
                                                    'Failed to log event: $error');
                                              });
                                              stopSpeaking();
                                              final bool res =
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
                                            child: Container(
                                              width: width* (81/ 375),
                                              height: height * (55/ 812),
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
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 40,),
                                          Container(
                                            child: GestureDetector(
                                              onTap: () async{
                                                  // ShareAndReview().removeAllKeys();
                                                  analytics.logEvent(
                                                    name: 'speak',
                                                    parameters: {
                                                      'content_name': widget
                                                          .allGameModel
                                                          .allGame![widget.index]
                                                          .mainContent
                                                          .toString(),
                                                      'Game_name': widget.gameName,
                                                      'User_id':
                                                      getStringAsync(USER_ID),
                                                    },
                                                  ).then((_) {
                                                    print(
                                                        'Logged event: speak with parameters:');
                                                  }).catchError((error) {
                                                    print(
                                                        'Failed to log event: $error');
                                                  });
                                                  facebookAppEvents.logEvent(
                                                    name: 'speak',
                                                    parameters: {
                                                      'content_name': widget
                                                          .allGameModel
                                                          .allGame![widget.index]
                                                          .mainContent
                                                          .toString(),
                                                      'Game_name': widget.gameName,
                                                      'User_id':
                                                      getStringAsync(USER_ID),
                                                    },
                                                  ).then((_) {
                                                    print(
                                                        'Logged event: speak with parameters:');
                                                  }).catchError((error) {
                                                    print(
                                                        'Failed to log event: $error');
                                                  });
                                                  stopSpeaking();
                                                  _lastWords = "";
                                                 String res = await  Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildMassageScreen()));
                                                   vm.setIsPlayScreen(true);
                                                  _lastWords = res;
                                                   isMuted = false;
                                                   print("Mute state $isMuted");
                                                   speechRate = 0.3;
                                                   ques = _lastWords;
                                                   _lastWords = "";

                                                  setState(() {

                                                  });
                                                  if (ques.isNotEmpty) {
                                                    save2(ques, widget.sessionId);
                                                  }

                                                },
                                              child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                          color: Color(0XFFe0ddf5)),
                                                      child:  Icon(
                                                        Icons.keyboard_voice,
                                                        size: 50,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    MyText(
                                                      text: "Speak",
                                                      fontSize: 12,
                                                    )
                                                  ],
                                                ),
                                            ),
                                          ),
                                          SizedBox(width: 40,),
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                showSubtitle = !showSubtitle;
                                              });
                                            },
                                            child: Container(
                                              // width:72,
                                              // height:60,
                                              width: width* (81/ 375),
                                              height: height * (55/ 812),
                                              // color:Colors.red,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      showSubtitle ? Icons
                                                          .subtitles_off : Icons
                                                          .subtitles,
                                                      size: 35,
                                                      color: showSubtitle ? Colors
                                                          .black : Colors.blue,
                                                    ),
                                                    MyText(
                                                      text: showSubtitle
                                                          ? "Show Subtitle"
                                                          : "Hide Subtitle",
                                                      fontSize: 12,
                                                      color: showSubtitle ? Colors
                                                          .black : Colors.blue,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ).paddingOnly(left: 16, right: 16, bottom: 20),
                                    );
                                  })
                          ],
                        ),
                  )),
            ],
          ),
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

  // Widget _buildMessageInput(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(15),
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: Consumer<PlayTabooScreenVM>(
  //             builder: (context, vm, child) {
  //               vm.controller?.clear();
  //
  //               return TextField(
  //                 cursorColor: primaryColor,
  //                 cursorHeight: 30,
  //                 cursorWidth: 4,
  //                 focusNode: _focusNode,
  //                 controller: vm.controller,
  //                 maxLines: null,
  //                 decoration: InputDecoration(
  //                   isDense: true,
  //                   contentPadding: EdgeInsets.only(
  //                       top: 80, bottom: 0, left: 10, right: 10),
  //                   hintText: "",
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     borderSide: BorderSide(
  //                       color: primaryColor,
  //                       width: 3,
  //                     ),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     borderSide: BorderSide(
  //                       color: primaryColor,
  //                       width: 3,
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             DottedBorder(
  //               color: gradientStartColor,
  //               strokeWidth: 2,
  //               dashPattern: [2, 2],
  //               // strokeCap: StrokeCap.round,
  //               borderType: BorderType.RRect,
  //               radius: Radius.circular(12),
  //               child: ClipRRect(
  //                 child: Container(
  //                   padding: EdgeInsets.only(left: 4, right: 4),
  //                   // decoration: BoxDecoration(border: Border.all()),
  //                   // decoration: boxDecorationWithRoundedCorners(
  //                   //     // backgroundColor: Color(0xFFe0ddf5)
  //                   //
  //                   // ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Image.asset('assets/images/voice.gif', width: 40),
  //                       Text("Use keyboard's voice typing"),
  //                       4.width,
  //                       Icon(
  //                         Icons.help_outlined,
  //                         size: 20,
  //                       ).onTap(() {
  //                         showInstructionDialog();
  //                       }),
  //                       // ShowCaseWidget(builder: (context) {
  //                       //   return Showcase(
  //                       //     key: _one,
  //                       //     title: "How should i Speak?",
  //                       //     description:
  //                       //         "\nPlease locate the Mic icon on your keyboard.\n\n"
  //                       //         "Not seeing a Mic icon?\n\n"
  //                       //         "Reason 1\n"
  //                       //         "(Gboard) Long press comma and open settings. Turn on voice typing inside settings.\n\n"
  //                       //         "Reason 2\n"
  //                       //         "Check your App settings and locate your keyboard App. Make sure you have given microphone permission.\n\n"
  //                       //         "Reason 3\n"
  //                       //         "Inside Keyboard settings, go to Text suggestions and then turn on show suggestion strip.",
  //                       //     // description:_buildRichDescription(),
  //                       //     // RichText(
  //                       //     //   text: TextSpan(
  //                       //     //     children: [
  //                       //     //       TextSpan(
  //                       //     //         text: "Reason 1: ",
  //                       //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  //                       //     //       ),
  //                       //     //       TextSpan(
  //                       //     //         text: "Long press comma and open settings to turn on voice typing.\n\n",
  //                       //     //         style: TextStyle(color: Colors.black),
  //                       //     //       ),
  //                       //     //       TextSpan(
  //                       //     //         text: "Reason 2: ",
  //                       //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  //                       //     //       ),
  //                       //     //       TextSpan(
  //                       //     //         text: "Check your app settings and ensure microphone permission is enabled.\n\n",
  //                       //     //         style: TextStyle(color: Colors.black),
  //                       //     //       ),
  //                       //     //       TextSpan(
  //                       //     //         text: "Reason 3: ",
  //                       //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  //                       //     //       ),
  //                       //     //       TextSpan(
  //                       //     //         text: "Go to text suggestions in keyboard settings and enable 'show suggestion strip'.",
  //                       //     //         style: TextStyle(color: Colors.black),
  //                       //     //       ),
  //                       //     //     ],
  //                       //     //   ),
  //                       //     // ),
  //                       //     //
  //                       //     child: Column(
  //                       //       children: [
  //                       //         Icon(
  //                       //           Icons.help_outlined,
  //                       //           size: 20,
  //                       //         ).onTap(() {
  //                       //           WidgetsBinding.instance.addPostFrameCallback(
  //                       //             (_) => ShowCaseWidget.of(context)
  //                       //                 .startShowCase([_one]),
  //                       //           );
  //                       //         }),
  //                       //         // _buildRichDescription(),
  //                       //       ],
  //                       //     ),
  //                       //   );
  //                       // }),
  //                       4.width,
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ).expand(),
  //             SizedBox(width: 10),
  //             GestureDetector(
  //               onTap: () {
  //                 // FocusScope.of(context).unfocus();
  //                 // unmuteSystemSounds();
  //                 var chatPageVM =
  //                 Provider.of<PlayTabooScreenVM>(context, listen: false);
  //                 String messageText = chatPageVM.controller.text.trim();
  //                 _lastWords = messageText;
  //                 setState(() {
  //                   ques = _lastWords;
  //                   _lastWords = "";
  //                 });
  //                 if (ques.isNotEmpty) {
  //                   save2(ques, widget.sessionId);
  //                 }
  //
  //                 isKeyBoardTapped = false;
  //                 chatPageVM.controller.clear();
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.all(13),
  //                 decoration: BoxDecoration(
  //                   color: primaryColor,
  //                   borderRadius: BorderRadius.circular(40),
  //                 ),
  //                 child: Icon(Icons.send, color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ).paddingTop(10),
  //       ],
  //     ),
  //   );
  // }


//   List<TextSpan> _buildBoldTextWithTime(String res) {
//   var vm =   Provider.of<PlayTabooScreenVM>(context,listen: false);
//     List<TextSpan> spans = [];
//        for (int i = 0; i < vm.textForBold.length; i++) {
//       spans.add(
//         TextSpan(
//           text: '${vm.textForBold[i]['text']} \n',
//           style: TextStyle(
//             fontWeight: vm.textForBold[i]['isActive'] ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       );
//     }
//
//     return spans;
//   }

  List<TextSpan> buildHighlightedTextSpans(String res) {
    var vm = Provider.of<PlayTabooScreenVM>(context, listen: false);
    List<TextSpan> spans = [];
    // String text1 = "Hello I am Kushwanth . 😂 \n\n\n";  // Should remove emoji
    // String text2 = "Hello I am Kushwanth . 😂hii \n"; // Should not remove emoji
    //
    // print(removeEmojisAfterPeriodBeforeNewline(text1)); // "Hello I am Kushwanth . \n"
    // print(removeEmojisAfterPeriodBeforeNewline(text2));
    res = removeEmojisAfterPeriodBeforeNewline(res);
    res = cleanTextForTTS(res);
    List<String> paragraphs = splitAndPreserveDelimiters(res);
    // print("This is inside bold para $paragraphs");
    // List<String> paragraphs = res.split(RegExp(r'\n+'));
    paragraphs = paragraphs.where((p) => p.trim().isNotEmpty).toList();
    // for(int i =0;i<paragraphs.length;i++){
    //  paragraphs[i] += ".";
    // }

    // for (int j = 0; j < paragraphs.length; j++) {
    //   String paragraph = paragraphs[j].replaceAll(RegExp(r'\*\*'), ''); // Clean the paragraph
    //   List<String> words = paragraph.split(' '); // Split paragraph into words
    //
    //   for (int i = 0; i < words.length; i++) {
    //     bool isBold = (j == vm.currentParaIndex);
    //
    //     spans.add(
    //       TextSpan(
    //         text: '${words[i]} ',
    //         style: TextStyle(
    //           fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    //           color: Colors.black,
    //           fontSize: 18,
    //         ),
    //       ),
    //     );
    //   }
    //
    //   spans.add(const TextSpan(text: '\n'));
    // }
    for (int j = 0; j < paragraphs.length; j++) {
      String paragraph = paragraphs[j].replaceAll(RegExp(r'\*+'), '');

      bool isBold = (j== vm.currentParaIndex);
      spans.add(
        TextSpan(

          text: paragraph,
          style: TextStyle(

            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ?Color(0Xff1A1A1A):Color(0Xff707070),
            fontSize: 16,
            fontFamily: "inter",
            height: 20 / 16,

             ),
        ),
      );
      // spans.add(const TextSpan(text: '\n'));
    }
    // spans.add(TextSpan(text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ab alias aspernatur blanditiis commodi delectus deleniti deserunt distinctio, ducimus eaque enim ex fuga fugiat fugit labore minima neque non perspiciatis possimus quibusdam quisquam, quo quos rem repellendus suscipit vel, veniam veritatis voluptatem. Assumenda ducimus expedita iure molestias mollitia, nulla pariatur tenetur?"));

    return spans;
  }
  String cleanTextForTTS(String text) {
    String textWithoutdoubleQuat = text.replaceAll("\"", "");
    String textWithoutSingleQuat = textWithoutdoubleQuat.replaceAll(RegExp(r"[‘’']"), "");

    return textWithoutSingleQuat.replaceAll(RegExp(r'\*+'), '');
  }

  // List<String> splitAndPreserveNewlines(String res) {
  //   List<String> paragraphs = [];
  //   RegExp regex = RegExp(r'(\n+|\.)');
  //   Iterable<RegExpMatch> matches = regex.allMatches(res);
  //
  //   int lastIndex = 0;
  //   for (RegExpMatch match in matches) {
  //     String part = res.substring(lastIndex, match.start).trim();
  //     if (part.isNotEmpty) {
  //       paragraphs.add(part);
  //     }
  //
  //     // Append newline characters to the last part if it's \n or \n\n
  //     String separator = match.group(0)!;
  //     if (separator.contains('\n')) {
  //       paragraphs[paragraphs.length - 1] += separator;
  //     } else {
  //       paragraphs.add(separator);
  //     }
  //
  //     lastIndex = match.end;
  //   }
  //
  //   // Add remaining part if any
  //   if (lastIndex < res.length) {
  //     String remaining = res.substring(lastIndex).trim();
  //     if (remaining.isNotEmpty) {
  //       paragraphs.add(remaining);
  //     }
  //   }
  //
  //   return paragraphs;
  // }


  String removeEmojisAfterPeriodBeforeNewline(String text) {


    return text.replaceAllMapped(RegExp(r'\.([\s\S]*?)\n+', multiLine: true), (match) {
      String segment = match.group(1) ?? "";

      // Check if segment contains only emojis/spaces
      if (segment.trim().isNotEmpty && segment.trim().replaceAll(emojiRegex(), "").isEmpty) {
        segment = segment.replaceAll(emojiRegex(), ""); // Remove emojis
      }

      return ".${segment}\n";
    });
  }

  List<String> splitAndPreserveDelimiters(String res) {
    List<String> paragraphs = [];
    RegExp regex = RegExp(r'(\n+|\.)'); // Match . or one/more \n
    Iterable<RegExpMatch> matches = regex.allMatches(res);

    int lastIndex = 0;

    for (RegExpMatch match in matches) {
      String part = res.substring(lastIndex, match.start);
      String delimiter = match.group(0)!; // Either . or \n

      // Add part with the delimiter attached
      if (part.trim().isNotEmpty) {
        paragraphs.add(part + delimiter);
      } else if (paragraphs.isNotEmpty) {
        // Append delimiter to the last paragraph if part is empty
        paragraphs[paragraphs.length - 1] += delimiter;
      }

      lastIndex = match.end;
    }

    // Add any remaining text after the last match
    if (lastIndex < res.length) {
      String remaining = res.substring(lastIndex).trim();
      if (remaining.isNotEmpty) {
        paragraphs.add(remaining);
      }
    }

    return paragraphs;
  }



// List<TextSpan> _buildBoldTextWithTime(String res) {
  //   var vm = Provider.of<PlayTabooScreenVM>(context,listen: false);
  //   List<TextSpan> spans = [];
  //   res = res.replaceAll(RegExp(r'\*\*'), '');
  //   List<String> words = res.split(' ');
  //
  //   for (int i = 0; i < words.length; i++) {
  //     spans.add(
  //       TextSpan(
  //         text: '${words[i]} ',
  //         style: TextStyle(
  //           fontWeight: i < vm.currentIndex ? FontWeight.bold : FontWeight.normal,
  //         ),
  //       ),
  //     );
  //   }

  //   return spans;
  // }
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
    return Scaffold(body: WillPopScope(onWillPop: () async{
      var chatPageVM =
      Provider.of<PlayTabooScreenVM>(context, listen: false);
      String messageText = chatPageVM.controller.text.trim();
      chatPageVM.controller.clear();
      _focusNode.unfocus();
      Navigator.pop(context,messageText);
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
                    contentPadding: EdgeInsets.only(top: 80, bottom: 0, left: 10, right: 10),
                    hintText: "",
                    hintStyle: secondaryTextStyle(size: 16,height: 20 / 16,fontFamily: 'inter'),
                    labelStyle: secondaryTextStyle(size: 16,height: 20 / 16,fontFamily: 'inter'),
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
                        MyText(text: "Use keyboard's voice typing",fontSize: 14,),
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
                    Navigator.pop(context,messageText);
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
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

  Widget buildReason(String title, String text, String highlight,
      String remaining) {
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
    );}
}
