import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../Constants/constant_text.dart';
import '../Model/AllGameModel.dart';
import '../Repository/AllGameModelRepository.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/ShowSnackBar.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';

class AllGameVm extends ChangeNotifier {
  /// Calling Repository =====================================
  AllGameRepository _allGameRepository = AllGameRepository();

  BuildContext context;

  /// Onload Events Declear Here ======================================
  AllGameVm(this.context);

  /// Creating Variables =======================================>
  AllGameModel homePageModel = AllGameModel();
  bool apiHitStatus = false;

  seInitialValue() {
    apiHitStatus = false;
    homePageModel = AllGameModel();
  }

  Future<void> allGamePageAPI(BuildContext context, String data) async {
    appStore.setLoading(true);



    // EasyLoading.show(status: ConstText.get_LoaderMessage);
    try {
      ApiResponse<AllGameModel> response =
          await _allGameRepository.allGameApiCallFunction(data);
      print("Response ::: ${response.data}");
      switch (response.status) {
        case ApiResponseStatus.success:
          homePageModel = response.data!;
          print(homePageModel.allGame);
          apiHitStatus = true;
          notifyListeners();
          EasyLoading.dismiss();
          appStore.setLoading(false);

          break;
        case ApiResponseStatus.badRequest:
          EasyLoading.dismiss();
          appStore.setLoading(false);

          print("${response.error!.responseMsg.toString()}");
          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.unauthorized:
          EasyLoading.dismiss();
          appStore.setLoading(false);

          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.notFound:
          EasyLoading.dismiss();
          appStore.setLoading(false);

          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        case ApiResponseStatus.serverError:
          EasyLoading.dismiss();
          appStore.setLoading(false);

          MySnackBar.showSnackBar(context, response.error!.responseMsg!);
          break;
        default:
          EasyLoading.dismiss();
          appStore.setLoading(false);

          // Handle other cases if needed
          break;
      }
    } catch (e) {
      appStore.setLoading(false);
      EasyLoading.dismiss();
      MySnackBar.showSnackBar(context, e.toString());
    }
    appStore.setLoading(false);
  }
}
