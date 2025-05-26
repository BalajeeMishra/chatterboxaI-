import 'package:balajiicode/Screens/authentication/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../extensions/extension_util/widget_extensions.dart';
import '../Model/CheckMobileNumberResponse.dart';
import '../Screens/JabberAIHomePage/JabberAIHomepage.dart';
import '../Screens/authentication/add_phone.dart';
import '../Screens/otp_screen.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


Future<void> loginWithOTP(
  BuildContext context,
  String phoneNumber,
  String mobileNo,
String country,
) async {
  appStore.setLoading(true);

  return await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {
      appStore.setLoading(false);
      if (e.code == 'invalid-phone-number') {
        toast('The provided Phone number is not valid.');
        throw 'The provided Phone number is not valid.';
      } else {
        toast(e.toString());
        throw e.toString();
      }
    },
    timeout: Duration(minutes: 1),
    codeSent: (String verificationId, int? resendToken) async {
      finish(context);
      // OtpScreen(
      //   country: country,
      //   verificationId: verificationId,
      //   mobileNumber: phoneNumber,
      // ).launch(context);
      print("validate otp $country");
      OTPVerification(
        country: country,
        verificationId: verificationId,
        mobileNumber: phoneNumber,
      ).launch(context);

    },
    codeAutoRetrievalTimeout: (String verificationId) {
      //
    },
  );
}

Future deleteUser() async {
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
  }
}

Future deleteUserFirebase() async {
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
  }
}

Future<void> logout(BuildContext context, {Function? onLogout}) async {
  await removeKey(IS_LOGIN);
  await removeKey(USER_ID);
  await removeKey(PHONE_NUMBER);
  await removeKey(TOKEN);
  userStore.clearUserData();
  userStore.setLogin(false);
  userStore.setToken('');
  onLogout?.call();
}



Future<String> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return "No google user";

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await checkForEmail(googleAuth.idToken!,context);
    return 'success';

  } catch (e) {
    print("Google sign-in error: $e");
    return '$e';
  }
}
Future  checkForEmail(String? idToken, BuildContext context) async{
  Map<String, dynamic> req = {
    'idToken':idToken ??'',
  };

  try {
    final CheckPhoneNumberResponse value = await emailCheckApi(req);


    if (value.accessToken != null) {
      setValue(TOKEN, value.accessToken);
      userStore.setToken(value.accessToken.toString());
      setValue(USER_ID, value.user!.sId.toString());
      userStore.setUserID(value.user!.sId.toString());
      setValue(USER_NATIVE_LANGUAGE, value.user!.nativeLanguage.toString());
      userStore.setUserNativeLanguage(value.user!.nativeLanguage.toString());
      setValue(USER_ENGLISH_PROFICIENCY, value.user!.engprolevel.toString());
      userStore.setUserEnglishProficiency(value.user!.engprolevel.toString());
      // setValue(DAYS_SINCE_INSTALL, value.user!.createdAt.toString());
      // userStore.setDaysSinceInstall(value.user!.createdAt.toString());
      await userStore.setLogin(true);
      JabberAIHomepage().launch(context);
      return value;
    }
    else{
      AddPhoneDetails(user: value.user!).launch(context);
    }
  } catch (e) {

    appStore.setLoading(false);


  }
}
