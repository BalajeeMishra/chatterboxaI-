
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants/constant_text.dart';
import '../Model/AllGameModel.dart';
import '../Repository/AllGameModelRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';

class AllGameVm extends ChangeNotifier {

  /// Calling Repository =====================================
  AllGameRepository _allGameRepository = AllGameRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  AllGameVm(this.context);

  /// Creating Variables =======================================>
  AllGameModel homePageModel = AllGameModel();
  bool apiHitStatus = false;


  seInitialValue(){
    apiHitStatus = false;
    homePageModel = AllGameModel();
  }

  Future<void> allGamePageAPI(BuildContext context,String data) async {
    EasyLoading.show(status: ConstText.get_LoaderMessage);
    try {
      ApiResponse<AllGameModel> response = await _allGameRepository.allGameApiCallFunction(data);
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