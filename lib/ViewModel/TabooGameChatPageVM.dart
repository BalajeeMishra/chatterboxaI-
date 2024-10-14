
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants/constant_text.dart';
import '../Model/AllGameModel.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';

class TabooGameChatPageVM  extends ChangeNotifier{

  /// Calling Repository =====================================
  TabooGameChatPageRepository _tabooGameChatPageRepository = TabooGameChatPageRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  TabooGameChatPageVM(this.context);

  /// Creating Variables =======================================>
  TabooGameChatPageModel tabooGameChatPageModel = TabooGameChatPageModel();
  bool apiHitStatus = false;

  String apiSendingData = "Guess word is elevator and taboo words are [Floor,building,Apartment,Rise]";

  TextEditingController controller = TextEditingController();
  var initialdata;


  List<Map<String,dynamic>> dynamicDta = [];

  var dataToPass;


//  text: 'An electric facility that is used for moving up and down of a high rise building',
  seInitialValue(AllGameModel allGameModel, int index){
    String data = "";
    dynamicDta = [];
    for(var i =0;i<allGameModel.allGame![index].detailOfContent!.length;i++) {
      data = (data.length>0)?
      data + ","+allGameModel.allGame![index].detailOfContent![i]:
          data + " "+allGameModel.allGame![index].detailOfContent![i];
      initialdata = {
        "Guess Word":"${allGameModel.allGame![index].mainContent}",
        "Taboo Words": "$data"
      };
    }
    dataToPass = "Guess word is ${allGameModel.allGame![index].mainContent} and taboo words are [${data}] and user hint is an";
    apiHitStatus = false;
    tabooGameChatPageModel = TabooGameChatPageModel();
  }



  Future<void> chatPageAPI(BuildContext context) async {
    if(controller.text == "" || controller.text == null){
      MySnackBar.showSnackBar(context, "Please Enter Your Response");
      return;
    }
    var dataToAdd = dynamicDta.length>0? "${controller.text}":"$dataToPass ${controller.text}";
    var dataAdd =  {
      "server":0,
      "data": controller.text,
    };
    dynamicDta.add(dataAdd);
    notifyListeners();
    EasyLoading.show(status: ConstText.get_LoaderMessage);
    try {
      var data = {
        "question": dataToAdd,
        "userId":"123",
        "session":"1"
      };
      ApiResponse<TabooGameChatPageModel> response = await _tabooGameChatPageRepository.tabooGameChatPageApiCallFunction(data);
      print("Response ::: ${response.data}");
      switch (response.status) {
        case ApiResponseStatus.success:
          controller.text = "";
          var data = {
            "server":1,
            "data": response.data!.response!.aiResponse!.last.characters
          };
          dynamicDta.add(data);
          apiHitStatus = true;
          notifyListeners();
          EasyLoading.dismiss();
          break;
        case ApiResponseStatus.badRequest:
          EasyLoading.dismiss();
          print("${response.error!.responseMsg.toString()}");
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.unauthorized:
          EasyLoading.dismiss();
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.notFound:
          EasyLoading.dismiss();
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.serverError:
          EasyLoading.dismiss();
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        default:
          EasyLoading.dismiss();
          // Handle other cases if needed
          break;
      }
    } catch (e) {
      EasyLoading.dismiss();
      MySnackBar.showSnackBar(context, e.toString());
    }
  }

}

