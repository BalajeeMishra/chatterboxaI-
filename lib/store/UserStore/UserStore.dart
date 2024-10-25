import 'dart:convert';
// import '../../models/progress_setting_model.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import '../../extensions/shared_pref.dart';
// import '../../models/user_response.dart';
import '../../utils/app_constants.dart';

part 'UserStore.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  String userId = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String fName = '';

  @observable
  String lName = '';

  @observable
  String designation = '';

  @observable
  bool isMobileVerify = false;

  @observable
  String profileImage = '';

  @observable
  String token = '';



  @observable
  String username = '';

  @observable
  String displayName = '';

  @observable
  String phoneNo = '';


  @observable
  String currencyPosition = '';


  @observable
  String privacyPolicy = "";


  @observable
  bool isPlaying = false;




  @action
  Future<void> setPhoneNo(String val, {bool isInitialization = false}) async {
    phoneNo = val;
    if (!isInitialization) await setValue(PHONE_NUMBER, val);
  }





  @action
  Future<void> setToken(String val, {bool isInitialization = false}) async {
    token = val;
    if (!isInitialization) await setValue(TOKEN, val);
  }


  @action
  Future<void> setUserID(String val, {bool isInitialization = false}) async {
    userId = val;
    if (!isInitialization) await setValue(USER_ID, val);
  }

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGIN, val);
  }


  @action
  Future<void> setFirstName(String val, {bool isInitialization = false}) async {
    fName = val;
    if (!isInitialization) await setValue(FIRSTNAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitialization = false}) async {
    lName = val;
    if (!isInitialization) await setValue(LASTNAME, val);
  }



  @action
  Future<void> clearUserData() async {
    fName = '';
    lName = '';
    profileImage = '';
    token = '';
    username = '';
    displayName = '';
    phoneNo = '';





  }
}
