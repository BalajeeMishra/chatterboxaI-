import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../Screens/otp_screen.dart';
import '../extensions/constants.dart';
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
      OtpScreen(
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
  userStore.clearUserData();
  userStore.setLogin(false);
  onLogout?.call();
}
