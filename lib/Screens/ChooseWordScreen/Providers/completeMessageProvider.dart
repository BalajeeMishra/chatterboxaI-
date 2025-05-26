import 'package:balajiicode/Utils/app_common.dart';
import 'package:flutter/material.dart';

import '../../../Model/AllGameModel.dart';
import '../../../Model/TabooGameChatPageModel.dart';
import '../../../Repository/TaboogameChatPageRepository.dart';
import '../../../Services/ApiResponseStatus.dart';
import '../../../main.dart';
enum AnswerAssistState {
  idle,
  active,
  completing,
  encouraging,
}

class AnswerAssistProvider extends ChangeNotifier {
  AnswerAssistState _state = AnswerAssistState.idle;
  TextEditingController correctedUserMessageController = TextEditingController();
  TextEditingController wordController = TextEditingController();


  AnswerAssistState get state => _state;

  void setIdle() {
    _state = AnswerAssistState.idle;
    notifyListeners();
  }

  void setActive() {
    _state = AnswerAssistState.active;
    notifyListeners();
  }

  void setEncouraging() {
    _state = AnswerAssistState.encouraging;
    notifyListeners();
  }
  void setCompleting(){
    _state = AnswerAssistState.completing;
    notifyListeners();
  }

  Future<bool> completeUserMessage( BuildContext context,
      String userMessage,
      String sessionId,
      AllGameModel allGameModel,
      int index,
      String modality)async{

    String? res =  await completingUserMessage(context, userMessage, sessionId, allGameModel, index, modality);
    if (res !='' && res != null){
      correctedUserMessageController.text = res;
      wordController.clear();
      setEncouraging();
      notifyListeners();
      return true;
    }
    else{
      toast("some error occurs");
      setActive();
      return false;
    }


  }
  void clearCorrectedUserMessageController(){
    correctedUserMessageController.clear();
    notifyListeners();
  }

  Future<String?> completingUserMessage(
      BuildContext context,
      String userMessage,
      String sessionId,
      AllGameModel allGameModel,
      int index,
      String modality,
 ) async {

    notifyListeners();
    print("this is game id ${allGameModel.allGame![index].gameId}");
    try {
      var data = {
        "question": userMessage,
        "sessionId": sessionId,
        'gameId': allGameModel.allGame![index].gameId,
        "mainContent": allGameModel.allGame![index].mainContent,
        "modality": modality,
      };

      String response =
      await TabooGameChatPageRepository()
          .correctUserMessageApi( data);
      print("corrected message${response}");
      return response;

    } catch (e) {
      appStore.setLoading(false);
      setActive();
      return '';
      // EasyLoading.dismiss();
      // MySnackBar.showSnackBar(context, e.toString());
    }


  }
}
