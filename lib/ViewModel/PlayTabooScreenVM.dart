import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/loader_widget.dart';
import 'package:balajiicode/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../Model/AllConversationModel.dart';
import '../Model/AllGameModel.dart';
import '../Constants/constant_text.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';

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
  bool isFirstCall = true;

  var dataToPass;

  // setInitailData(){
  //   tabooGameChatPageModel = TabooGameChatPageModel();
  // }

  seInitialValue(AllGameModel allGameModel, int index, String sessionId) {
    String data = "";
    dynamicDta = [];
    for (var i = 0;
        i < allGameModel.allGame![index].detailOfContent!.length;
        i++) {
      data = (data.isNotEmpty)
          ? "$data,${allGameModel.allGame![index].detailOfContent![i]}"
          : "$data ${allGameModel.allGame![index].detailOfContent![i]}";
    }
    // dataToPass =
    //     "Guess word is ${allGameModel.allGame![index].mainContent} and taboo words are [${data}] and user hint is an";
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
    tabooGameChatPageModel.response = convertToResponse(
        completeConversation);
    // if (completeConversation.aiResponse != null && completeConversation.aiResponse != null) {
    //   // var data = {
    //   //   "server": 1,
    //   //   "data":completeConversation. aiResponse!.last.characters
    //   // };
    //   // dynamicDta.add(data);
    //   // apiHitStatus = true;
    //   // tabooGameChatPageModel.response = tabooGameChatPageModel.response!;
    //
    //   dynamicDta.add({
    //     "server": 1,
    //     "data":completeConversation. aiResponse!.last.characters
    //
    //   });
    // }
    notifyListeners();
  }

  Future<void> chatPageAPI(BuildContext context, String dataGet,
      String sessionId, AllGameModel allGameModel, int index,bool isFirst) async {

    isFirstCall =isFirst;
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
    // Loader().center();
    // EasyLoading.show(status: ConstText.get_LoaderMessage);
    try {
      var data = {
        "question": dataToAdd,
        // "userId": userStore.userId,
        "sessionId": sessionId,
        'gameId':allGameModel.allGame![index].gameId,
        "mainContent": allGameModel.allGame![index].mainContent
      };
      print("DAT$data");
      ApiResponse<TabooGameChatPageModel> response =
          await _tabooGameChatPageRepository
              .tabooGameChatPageApiCallFunction(data);
      // print("RES{PONS"+response.status.toString());
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
          if (!isFirstCall) {
            speakText(response.data!.response!.aiResponse!.last);
          } else {
            isFirstCall = false;
          }
          print("Is First call$isFirstCall");
          // EasyLoading.dismiss();
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayTabooScreenTwo(response.data!.response!.aiResponse!.last)));
          break;
        // tabooGameChatPageModel = response.data!;
        // notifyListeners();
        // EasyLoading.dismiss();

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

  FlutterTts flutterTts = FlutterTts();

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  void speakText(String text) async {
    appStore.setLastWords(text);

    await flutterTts.speak(text);
  }
}
