import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/loader_widget.dart';
import 'package:balajiicode/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../Model/AllGameModel.dart';
import '../Constants/constant_text.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';

class PlayTabooScreenVM extends ChangeNotifier {
  /// Calling Repository =====================================
  TabooGameChatPageRepository _tabooGameChatPageRepository =
      TabooGameChatPageRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  PlayTabooScreenVM(this.context);
  TextEditingController controller = TextEditingController();

  /// Creating Variables =======================================>
  TabooGameChatPageModel tabooGameChatPageModel = TabooGameChatPageModel();
  bool apiHitStatus = false;
  List<Map<String, dynamic>> dynamicDta = [];

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
      data = (data.length > 0)
          ? data + "," + allGameModel.allGame![index].detailOfContent![i]
          : data + " " + allGameModel.allGame![index].detailOfContent![i];
    }
    // dataToPass =
    //     "Guess word is ${allGameModel.allGame![index].mainContent} and taboo words are [${data}] and user hint is an";
      dataToPass ="";
    apiHitStatus = false;
    tabooGameChatPageModel = TabooGameChatPageModel();
  }

  Future<void> clearAiResponse() async {
    tabooGameChatPageModel.response?.aiResponse?.last = "";
    notifyListeners(); // Notify listeners to update the UI
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> chatPageAPI(
      BuildContext context, String dataGet, String sessionId,AllGameModel allGameModel, int index) async {
    if (dataGet == "" || dataGet == null) {
      MySnackBar.showSnackBar(context, "Please speak first!");
      return;
    }

    var dataToAdd = dynamicDta.length > 0 ? "$dataGet" : "$dataToPass $dataGet";

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
      print(sessionId);
      var data = {"question": dataToAdd, "userId": userStore.userId, "session": sessionId, "firstword":allGameModel.allGame![index].mainContent};
      print(data);
      print("balajee mishra");
      ApiResponse<TabooGameChatPageModel> response =
          await _tabooGameChatPageRepository
              .tabooGameChatPageApiCallFunction(data);
      print("Response ::: ${response.data}");
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

          // EasyLoading.dismiss();
          speakText(response.data!.response!.aiResponse!.last);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayTabooScreenTwo(response.data!.response!.aiResponse!.last)));
          break;
        // tabooGameChatPageModel = response.data!;
        // notifyListeners();
        // EasyLoading.dismiss();

        // break;
        case ApiResponseStatus.badRequest:
          appStore.setLoading(false);

          // EasyLoading.dismiss();
          print("${response.error!.responseMsg.toString()}");
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.unauthorized:
          // EasyLoading.dismiss();
          appStore.setLoading(false);

          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.notFound:
          // EasyLoading.dismiss();
          appStore.setLoading(false);

          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.serverError:
          // EasyLoading.dismiss();
          appStore.setLoading(false);

          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        default:
          appStore.setLoading(false);

          // EasyLoading.dismiss();
          // Handle other cases if needed
          break;
      }
    } catch (e) {
      appStore.setLoading(false);

      print(e);
      print("hellooo");
      // EasyLoading.dismiss();
      MySnackBar.showSnackBar(context, e.toString());
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
    print('Speak text called at Play TabooVM Screen');
    appStore.setLastWords(text);

    print("Data is set or not" + appStore.lastWords.toString());
    await flutterTts.speak(text);
  }
}
