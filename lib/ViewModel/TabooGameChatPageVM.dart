import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants/constant_text.dart';
import '../Model/AllGameModel.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';

class TabooGameChatPageVM extends ChangeNotifier {
  /// Calling Repository =====================================
  TabooGameChatPageRepository _tabooGameChatPageRepository = TabooGameChatPageRepository();

  BuildContext context;

  /// Onload Events Declare Here ======================================
  TabooGameChatPageVM(this.context);

  /// Creating Variables =======================================
  TabooGameChatPageModel tabooGameChatPageModel = TabooGameChatPageModel();
  bool apiHitStatus = false;

  String apiSendingData = "Guess word is elevator and taboo words are [Floor, building, Apartment, Rise]";

  TextEditingController controller = TextEditingController();
  var initialdata;
  List<Map<String, dynamic>> dynamicData = [];

  // Initialize values
  void setInitialValue(AllGameModel allGameModel, int index) {
    String data = allGameModel.allGame![index].detailOfContent!.join(", ");
    initialdata = {
      "Guess Word": "${allGameModel.allGame![index].mainContent}",
      "Taboo Words": data,
    };
    apiHitStatus = false;
    tabooGameChatPageModel = TabooGameChatPageModel();
    notifyListeners();
  }

  Future<void> chatPageAPI(BuildContext context, String sessionId, String messageText) async {
    if (messageText.isEmpty) {
      MySnackBar.showSnackBar(context, "Please Enter Your Response");
      return;
    }

    // Add user input to dynamicData
    dynamicData.add({
      "server": 0,
      "data": messageText,
    });
    notifyListeners();

    appStore.setLoading(true);

    try {
      var data = {
        "userId": userStore.userId,
        "session": sessionId,
        "question": messageText,
      };


      ApiResponse<TabooGameChatPageModel> response = await _tabooGameChatPageRepository.tabooGameChatPageApiCallFunction(data);
      print("Response ::: ${response.data}");

      switch (response.status) {
        case ApiResponseStatus.success:
          controller.clear();
          dynamicData.add({
            "server": 1,
            "data": response.data!.response!.aiResponse!.last.characters,
          });
          apiHitStatus = true;
          notifyListeners();
          break;

        case ApiResponseStatus.badRequest:
        case ApiResponseStatus.unauthorized:
        case ApiResponseStatus.notFound:
        case ApiResponseStatus.serverError:
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;

        default:
          break;
      }
    } catch (e) {
      MySnackBar.showSnackBar(context, e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

}