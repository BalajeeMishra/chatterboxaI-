import 'package:balajiicode/main.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import '../Model/AllConversationModel.dart';
import '../Model/AllGameModel.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';
import '../Utils/app_common.dart';
import '../Utils/app_constants.dart';
import '../components/tts.dart';
import '../extensions/shared_pref.dart';

class PlayTabooScreenVM extends ChangeNotifier {
  /// Calling Repository =====================================
  final TabooGameChatPageRepository _tabooGameChatPageRepository =
      TabooGameChatPageRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  PlayTabooScreenVM(this.context);
  TextEditingController controller = TextEditingController();

  /// Creating Variables =======================================>
  TabooGameChatPageModel tabooGameChatPageModel = TabooGameChatPageModel();
  bool apiHitStatus = false;
  List<Map<String, dynamic>> dynamicDta = [];
  bool isMuted = false;
  late GameEventManager gameEventManager;

  String selectedLanguage = 'English';

  var dataToPass;

  seInitialValue(AllGameModel allGameModel, int index, String sessionId) {
    String data = "";
    print(
        "this is detailed of content ${allGameModel.allGame![index].detailOfContent!.length}");
    dynamicDta = [];
    for (var i = 0;
        i < allGameModel.allGame![index].detailOfContent!.length;
        i++) {
      data = (data.isNotEmpty)
          ? "$data,${allGameModel.allGame![index].detailOfContent![i]}"
          : "$data ${allGameModel.allGame![index].detailOfContent![i]}";
    }
    dataToPass = "";
    apiHitStatus = false;
    tabooGameChatPageModel = TabooGameChatPageModel();
  }

  Response convertToResponse(CompleteConversation completeConversation) {
    return Response(
      aiResponse: completeConversation.aiResponse,
    );
  }

  Future<void> clearAiResponse() async {
    tabooGameChatPageModel.response?.aiResponse?.last = "";
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 100));
  }

  void updateResponse(CompleteConversation completeConversation) {
    tabooGameChatPageModel.response = convertToResponse(completeConversation);

    notifyListeners();
  }

  Future<void> chatPageAPI(
      BuildContext context,
      String dataGet,
      String sessionId,
      AllGameModel allGameModel,
      int index,
      bool isFirst,
      bool isMute,
      String modality,
      String gameName) async {
    isMuted = isMute;
    if (dataGet == "") {
      MySnackBar.showSnackBar(context, "Please speak first!");
      return;
    }

    var dataToAdd = dynamicDta.isNotEmpty ? dataGet : "$dataToPass $dataGet";

    var dataAdd = {
      "server": 0,
      "data": dataGet,
    };

    dynamicDta.add(dataAdd);
    notifyListeners();
    appStore.setLoading(true);

    try {
      var data = {
        "question": dataToAdd,
        "sessionId": sessionId,
        'gameId': allGameModel.allGame![index].gameId,
        "mainContent": allGameModel.allGame![index].mainContent,
        "modality": modality,
      };

      ApiResponse<TabooGameChatPageModel> response =
          await _tabooGameChatPageRepository
              .tabooGameChatPageApiCallFunction(data);
      switch (response.status) {
        case ApiResponseStatus.success:
          dataGet = "";
          var data = {
            "server": 1,
            "data": response.data!.response!.aiResponse!.last.characters
          };
          dynamicDta.add(data);
          apiHitStatus = true;
          tabooGameChatPageModel = response.data!;
          notifyListeners();
          speakText(response.data!.response!.aiResponse!.last);
          print("Response data is==>" + response.data!.toJson().toString());
          appStore.setUserResponse(response.data!.response!.userResponse!.last);
          userStore.setTTSPlaying("YES");
          print("is yes" + userStore.isTTSPlaying.toString());

          // if (!isFirstCall) {
          //   speakText(response.data!.response!.aiResponse!.last);
          // } else {
          //   isFirstCall = false;
          // }
          // print("Is First call$isFirstCall");
          print("Is Mute ??/$isMuted");

          if (isMuted) {
            stopSpeaking();
          }
          gameEventManager = GameEventManager(currentSessionId: sessionId);

          await gameEventManager.saveGameEvent(
            contentName: allGameModel.allGame![index].mainContent.toString(),
            gameName: gameName,
            userId: getStringAsync(USER_ID),
            modality: response.data!.response!.modality.toString(),
            daysSinceInstall: await InstallDateHelper.getDaysSinceInstall(),
          );


          break;

        // break;
        case ApiResponseStatus.badRequest:
          appStore.setLoading(false);

          // EasyLoading.dismiss();
          // MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.unauthorized:
          // EasyLoading.dismiss();
          appStore.setLoading(false);

          // MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.notFound:
          // EasyLoading.dismiss();
          appStore.setLoading(false);

          // MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.serverError:
          // EasyLoading.dismiss();
          appStore.setLoading(false);

          // MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        default:
          appStore.setLoading(false);

          // EasyLoading.dismiss();
          // Handle other cases if needed
          break;
      }
    } catch (e) {
      appStore.setLoading(false);

      // EasyLoading.dismiss();
      // MySnackBar.showSnackBar(context, e.toString());
    }
    appStore.setLoading(false);
  }

  final TTSManager ttsManager = TTSManager();
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
    // if (userStore.userNativeLanguage.isNotEmpty && userStore.userEnglishProficiency =="Beginner") {
    //   selectedLanguage = userStore.userNativeLanguage;
    //   setTtsLanguage(selectedLanguage);
    // }else{
    //   print("Amrican");
    //   await ttsManager.setLanguage('en-US');
    //   // await flutterTts.se;
    //
    //
    // }
    await ttsManager.setLanguage('en-US');

    // print("Selectd Language is ==>"+selectedLanguage.toString());

    await ttsManager.setSpeechRate(0.3);
    await ttsManager.setVolume(1.0);
  }

  void speakText(String text) async {
    print("Into Vm Calling");
    configureTts();
    String updatedText = cleanTextForTTS(text);
    appStore.setLastWords(text);

    await ttsManager.speak(updatedText);
  }

  Future<void> stopSpeaking() async {
    await ttsManager.stop();
  }
}

String cleanTextForTTS(String text) {
  String textWithoutEmojis = text.replaceAll(emojiRegex(), "");

  return textWithoutEmojis.replaceAll('**', '');
}
