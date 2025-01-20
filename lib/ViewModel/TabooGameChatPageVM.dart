import 'package:flutter/material.dart';

import '../Model/AllGameModel.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';
import '../Utils/app_common.dart';
import '../Utils/app_constants.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';

class TabooGameChatPageVM extends ChangeNotifier {
  /// Calling Repository =====================================
  final TabooGameChatPageRepository _tabooGameChatPageRepository =
      TabooGameChatPageRepository();

  BuildContext context;

  /// Onload Events Declare Here ======================================
  TabooGameChatPageVM(this.context);

  /// Creating Variables =======================================
  TabooGameChatPageModel tabooGameChatPageModel = TabooGameChatPageModel();
  bool apiHitStatus = false;
  TextEditingController controller = TextEditingController();
  var initialdata;
  List<Map<String, dynamic>> dynamicData = [];
  int? gameCount = 0;
  late GameEventManager gameEventManager;

  void updateTransactionData(List<Map<String, dynamic>> transactions,
      AllGameModel allGameModel, int index) {
    String data = allGameModel.allGame![index].detailOfContent!.join(", ");

    dynamicData = [...transactions];

    notifyListeners();

  }

  Future<void> chatPageAPI(
      BuildContext context,
      String sessionId,
      String messageText,
      AllGameModel allGameModel,
      int index,
      String modality,
      String gameName) async {
    if (messageText.isEmpty) {
      MySnackBar.showSnackBar(context, "Please Enter Your Response");
      return;
    }

    dynamicData.add({
      "server": 0,
      "data": messageText,
    });
    notifyListeners();

    appStore.setLoading(true);

    try {
      var data = {
        'gameId': allGameModel.allGame![index].gameId,
        "sessionId": sessionId,
        "question": messageText,
        "mainContent": allGameModel.allGame![index].mainContent,
        "modality": modality,
      };

      ApiResponse<TabooGameChatPageModel> response =
          await _tabooGameChatPageRepository
              .tabooGameChatPageApiCallFunction(data);

      switch (response.status) {
        case ApiResponseStatus.success:
          controller.clear();
          dynamicData.add({
            "server": 1,
            "data": response.data!.response!.aiResponse!.last.characters,
          });
          apiHitStatus = true;
          gameCount = response.data!.response!.count;

          notifyListeners();
          gameEventManager = GameEventManager(currentSessionId: sessionId);

          await gameEventManager.saveGameEvent(
            contentName: allGameModel.allGame![index].mainContent.toString(),
            gameName: gameName,
            userId: getStringAsync(USER_ID),
            modality: response.data!.response!.modality.toString(),
            daysSinceInstall: await InstallDateHelper.getDaysSinceInstall(),
          );
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


