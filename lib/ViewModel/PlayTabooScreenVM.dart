

import 'package:http/http.dart'as http;
import 'package:balajiicode/main.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../Model/AllConversationModel.dart';
import '../Model/AllGameModel.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Screens/ChooseWordScreen/PlayTabooScreen.dart';
import '../Screens/ChooseWordScreen/Providers/PlayTabooScreenProvider.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';
import '../Utils/app_common.dart';
import '../Utils/app_constants.dart';
import '../extensions/shared_pref.dart';
import 'package:flutter/services.dart';
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
  // bool isMuted = false;
  late GameEventManager gameEventManager;

  String selectedLanguage = 'English';

  var dataToPass;
//khush created vars
  bool isListening = true;
  bool isBreakLoop = false;
  bool ifDelayOfASecond = false;
  List<String> textsForTts=[];
    ValueNotifier<int> currentParaIndex = ValueNotifier<int>(-1);

  bool isPlayScreen = true;

  BuildContext globalContext = navigatorKey.currentContext!;

  void setIsPlayScreen(bool val){
    isPlayScreen = val;
    notifyListeners();
  }





  void setCurrentParaIndex(int index){
    currentParaIndex.value = index;
    notifyListeners();
  }


  void setIsListening(bool val){
    isListening = val;
    notifyListeners();
  }
  void setIfDelayOfASecond(bool val){
    ifDelayOfASecond = val;
    notifyListeners();
  }
  void setIsBreakLoop(bool val){
    isBreakLoop = val;
    notifyListeners();
  }


  seInitialValue(AllGameModel allGameModel, int index, String sessionId) {
    setIsPlayScreen(true);
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
    print("iSfIRT ==>" + isFirst.toString());
    // isMuted = isMute;
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
 print("this is game id ${allGameModel.allGame![index].gameId}");
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
              .tabooGameChatPageApiCallFunction(data:data);


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
          print("this is value of isPlaygame : $isPlayScreen");
          if(isPlayScreen){
            speakText(response.data!.response!.aiResponse!.last);
          }

          print("Response data is==>" + response.data!.toJson().toString());
          appStore.setUserResponse(response.data!.response!.userResponse!.last);
          userStore.setTTSPlaying("YES");
          print("is yes" + userStore.isTTSPlaying.toString());

          gameEventManager = GameEventManager(currentSessionId: sessionId);
          if (isFirst == false) {
            await gameEventManager.saveGameEvent(
              contentName: allGameModel.allGame![index].mainContent.toString(),
              gameName: gameName,
              userId: getStringAsync(USER_ID),
              modality: response.data!.response!.modality.toString(),
              daysSinceInstall: await InstallDateHelper.getDaysSinceInstall(),
            );
          }

          break;

        // break;
        case ApiResponseStatus.badRequest:
          appStore.setLoading(false);

          break;
        case ApiResponseStatus.unauthorized:

          appStore.setLoading(false);

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

  }




  void speakText(String text) async {
    print("Into Vm Calling");

    var pro = Provider.of<PlayTabooScreenProvider>(globalContext, listen: false);
    pro.setIsLoaderShow(true);
    // String updatedText = cleanTextForTTS(text);
    appStore.setLastWords(text);
    print("text of speaking $text" );
    // estimateTTSDuration(updatedText, 0.3);
    splitTextIntoList(text);

    await cloudTtsService.speakTexts(textsForTts);


  }



  void splitTextIntoList(String text){
    text = cleanTextForTTS(text);
    textsForTts = text.split(RegExp(r'(?:\n+|\.)'));
    textsForTts = textsForTts.where((p) => p.trim().isNotEmpty).toList();
    print("this is paragraph$textsForTts");
    notifyListeners();
  }


  Uint8List? listeningGif;
  Uint8List? talkingGif;
  String talkingString = "";
  String listeningString = "";

  bool isGifDownloaded = false; // Flag to check if GIFs are downloaded

  void clearUint8list() {
    listeningGif = null;
    talkingGif = null;
    isGifDownloaded = false; // Reset flag
    notifyListeners();
  }

  Future<void> saveGifs() async {
    Uint8List? listening = await saveGif(listeningString);
    Uint8List? talking = await saveGif(talkingString);

    if (listening != null && talking != null) {
      listeningGif = listening;
      talkingGif = talking;
      isGifDownloaded = true; // Mark as downloaded
      print("All GIFs downloaded successfully.");
    } else {
      isGifDownloaded = false; // If any fails, keep it false
      print("Failed to download one or both GIFs.");
    }
    notifyListeners();
  }

  Future<Uint8List?> saveGif(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("GIF downloaded from $url");
        return response.bodyBytes;
      }
    } catch (e) {
      print("Error downloading GIF from $url: $e");
    }
    return null;
  }

  String cleanTextForTTS(String text) {
    String textWithoutEmojis = text.replaceAll(emojiRegex(), "");
    String textWithoutDoubleQuotes = textWithoutEmojis.replaceAll("\"", "");
    String cleanedText = textWithoutDoubleQuotes.replaceAll(RegExp(r'\*+'), "");
    print("this is cleaned text $cleanedText");
    return cleanedText;

  }

}



