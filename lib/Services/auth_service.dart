import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../extensions/extension_util/widget_extensions.dart';
import '../Screens/otp_screen.dart';
import '../authentication/otp_verification_screen.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
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
  userStore.clearUserData();
  userStore.setLogin(false);
  onLogout?.call();
}



Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print("Google sign-in error: $e");
    return null;
  }
}
