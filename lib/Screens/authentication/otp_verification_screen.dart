import 'dart:async';

import 'package:balajiicode/Screens/authentication/profile_details_screen.dart';
import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/app_images.dart';
import '../../Widget/text_widget.dart';
import '../../extensions/common.dart';
import '../../extensions/otp_text_field.dart';
import '../../extensions/shared_pref.dart';
import '../../extensions/text_styles.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../JabberAIHomePage/JabberAIHomepage.dart';

class OTPVerification extends StatefulWidget {
  final String country;
  final String mobileNumber;
  final String? verificationId;

  const OTPVerification({
    Key? key,
    required this.country,
    required this.mobileNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  String otpCode = '';
  int _start = 30;
  bool _canResendOTP = false;
  Timer? _timer;
  bool isResend = false;
  String resendVerificationId = '';
  String? appSignature;
  Telephony telephony = Telephony.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<OTPTextFieldState> otpTextFieldKey = GlobalKey<OTPTextFieldState>();

  @override
  void initState() {
    super.initState();
    print(widget.country);
    init();
  }

  init() async {
    // requestSmsPermissions();
    appStore.setLoading(false);
    startTimer();

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        String sms = message.body.toString();

        if (message.body!.contains('yourFirebaseProjectName.firebaseapp.com')) {
          String otpcode = sms.replaceAll(RegExp(r'[^0-9]'), '');
          // _otpController.set(otpcode.split(""));
          Future.delayed(Duration(milliseconds: 100), () {
            otpTextFieldKey.currentState?.updateOTP(otpcode);
          });
          setState(() {
            // refresh UI
          });
        } else {}
      },
      listenInBackground: false,
    );
    // Start listening for SMS code
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void startTimer() {
    _start = 60;
    _canResendOTP = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        _start--;
        if (mounted) {
          setState(() {});
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _canResendOTP = true;
          });
        }
      }
    });
  }

  void resendOtpFunction() {
    if (_canResendOTP) {
      isResend = true;
      reSendOTP();
      startTimer();
    } else {
      toast('You cannot resend OTP yet. Please wait.');
    }
  }

  Future<void> resendOTP(
    BuildContext context,
    String phoneNumber,
    String mobileNo,
  ) async {
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
        resendVerificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //
      },
    );
  }

  Future<void> reSendOTP({bool isResend = false}) async {
    hideKeyboard(context);
    // appStore.setLoading(true);

    String number = widget.mobileNumber.toString();

    await resendOTP(
      context,
      number,
      widget.mobileNumber,
    ).then((value) {}).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> submit() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId:
            isResend ? resendVerificationId : widget.verificationId!,
        smsCode: otpCode);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      mobileNumberCheck();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'Invalid verification code. Please try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this phone number.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }
      toast(errorMessage);
    } catch (e) {
      toast('An error occurred: ${e.toString()}');
    } finally {
      appStore.setLoading(false);
    }
  }

  Future<void> mobileNumberCheck() async {
    Map<String, dynamic> req = {
      'mobileNo': widget.mobileNumber.trim(),
    };

    try {
      final value = await mobileNumberCheckApi(req);

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
        setState(() {});
      }
    } catch (e) {
      if (e.toString() == "User doesn't exist") {
        ProfileDetailsScreen(
          country: widget.country,
          mobileNumber: widget.mobileNumber,
        ).launch(context);
        setState(() {});
      }
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenHeight);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  reverse: true,
                  physics: isKeyboardOpen
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: screenHeight * .18),
                          MyText(
                            text: 'Enter Verification\nCode',
                            textAlign: TextAlign.center,
                            color: whiteColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          8.height,
                          MyText(
                            text:
                                'An OTP(One Time Password) Has Been\n Sent To Your Phone Number.',
                            textAlign: TextAlign.center,
                            color: whiteColor.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ],
                      ),
                      20.height,
                      Column(
                        children: [
                          SizedBox(
                            height: 270,
                            width: 270,
                            child: Image.asset(zapAIAvtar, fit: BoxFit.fill),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                10.height,
                                Row(
                                  children: [
                                    Text(
                                      'Code Sent To ${widget.mobileNumber}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    5.width,
                                    const Icon(Icons.edit, color: primaryColor),
                                  ],
                                ),
                                24.height,
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: otpInputField(),
                                ),
                                16.height,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Continue',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                                8.height,
                                Row(
                                  children: [
                                    MyText(
                                      text: "Didn't Get The Code? ",
                                      fontSize: 14,
                                    ),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Text(
                                            _canResendOTP ? 'Resend' : '',
                                            style: primaryTextStyle(
                                                color: primaryColor),
                                          ).paddingLeft(4),
                                          if (!_canResendOTP)
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text('$_start seconds',
                                                  style: primaryTextStyle(
                                                      color: primaryColor)),
                                            ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (_canResendOTP) {
                                          resendOtpFunction();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                10.height,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget otpInputField() {
    return OTPTextField(
      // key: otpTextFieldKey,

      pinLength: 6,
      fieldWidth: context.width() * 0.1,
      onChanged: (s) {
        otpCode = s;
      },
      onCompleted: (pin) {
        otpCode = pin;
        setState(
          () {},
        );
      },
    ).center();
  }
}
