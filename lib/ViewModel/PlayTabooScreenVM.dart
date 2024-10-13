
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants/constant_text.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Repository/TaboogameChatPageRepository.dart';
import '../Screens/ChooseWordScreen/PlayTabooScreenTwo.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';

class PlayTabooScreenVM extends ChangeNotifier{

  /// Calling Repository =====================================
  TabooGameChatPageRepository _tabooGameChatPageRepository = TabooGameChatPageRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  PlayTabooScreenVM(this.context);

  /// Creating Variables =======================================>
  TabooGameChatPageModel tabooGameChatPageModel = TabooGameChatPageModel();
  bool apiHitStatus = false;


  Future<void> chatPageAPI(BuildContext context,String dataGet) async {
    EasyLoading.show(status: ConstText.get_LoaderMessage);
    try {
      var data = {
        "question": dataGet,
        "userId":"123",
        "session":"1"
      };
      ApiResponse<TabooGameChatPageModel> response = await _tabooGameChatPageRepository.tabooGameChatPageApiCallFunction(data);
      print("Response ::: ${response.data}");
      switch (response.status) {
        case ApiResponseStatus.success:
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayTabooScreenTwo(response.data!.response!.aiResponse!.last)));
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