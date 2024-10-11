


import 'package:balajiicode/Model/HomePageModel.dart';
import 'package:balajiicode/Utils/ShowSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Repository/JabberHomeAIRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Constants/constant_text.dart';

class JabberHomeAIvm extends ChangeNotifier{

  /// Calling Repository =====================================
  JabberHomeAIRepository _jabberHomeAIRepository = JabberHomeAIRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  JabberHomeAIvm(this.context);

  /// Creating Variables =======================================>
  HomePageModel homePageModel = HomePageModel();
  bool apiHitStatus = false;

  seInitialValue(){
    apiHitStatus = false;
    homePageModel = HomePageModel();
  }

  Future<void> homepageAPI(BuildContext context) async {
    EasyLoading.show(status: ConstText.get_LoaderMessage);
    try {
      ApiResponse<HomePageModel> response = await _jabberHomeAIRepository.homePageApiCallFunction();
      print("Response ::: ${response.data}");
      switch (response.status) {
        case ApiResponseStatus.success:
          homePageModel = response.data!;
          print(homePageModel.allGame);
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

