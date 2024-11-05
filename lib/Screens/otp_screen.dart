import 'dart:async';

import 'package:balajiicode/Screens/JabberAIHomePage/JabberAIHomepage.dart';
import 'package:balajiicode/Screens/profile_screen.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:telephony/telephony.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_common.dart';
import '../Utils/app_constants.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/loader_widget.dart';
import '../extensions/otp_text_field.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../network/rest_api.dart';

class OtpScreen extends StatefulWidget {
  final String country;
  final String mobileNumber;
  final String? verificationId;

  OtpScreen({required this.country, required this.mobileNumber,this.verificationId, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<OTPTextFieldState> otpTextFieldKey = GlobalKey<OTPTextFieldState>();

  // final TextEditingController _otpController = TextEditingController();
  Telephony telephony = Telephony.instance;

  String otpCode = '';
  int _start = 30;
  bool _canResendOTP = false;
  Timer? _timer;
  bool isResend = false;
  String resendVerificationId = '';
  String? appSignature;

  @override
  void initState() {
    print("Mobile NUmber Is ==>" + widget.mobileNumber.toString());
    print("Country Name  Is ==>" + widget.country.toString());

    super.initState();
    init();
  }
  init() async {
    // requestSmsPermissions();
    appStore.setLoading(false);
    startTimer();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address);
        print(message.body);

        String sms = message.body.toString();

        if (message.body!.contains('yourFirebaseProjectName.firebaseapp.com')) {
          String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
          // _otpController.set(otpcode.split(""));
          Future.delayed(Duration(milliseconds: 100), () {
            otpTextFieldKey.currentState?.updateOTP(otpcode);
          });
          print("Otp  is  ==> " + otpCode.toString());
          setState(() {
            // refresh UI
          });
        } else {
          print("error");
        }
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

    print("Number is " + number.toString());

    await resendOTP(
      context,
      number,
      widget.mobileNumber!,
    ).then((value) {}).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> submit() async {
    print("Otp Code is -->"+ otpCode.toString());
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

  Widget otpInputField() {
    return OTPTextField(
      key: otpTextFieldKey,
      pinLength: 6,
      fieldWidth: context.width() * 0.1,
      onChanged: (s) {
        otpCode = s;
        print("OTP on ChnageCODE ==>" + otpCode.toString());

      },
      onCompleted: (pin) {
        otpCode = pin;
        print("OTP CODE ==>" + otpCode.toString());
        setState(() {

        },);
        // submit();
        // submit();
        // UserDetails().launch(context);
      },
    ).center();
  }

  Future<void> mobileNumberCheck() async {
    Map<String, dynamic> req = {
      'mobileNo': widget.mobileNumber.trim(),
    };

    try {
      final value = await mobileNumberCheckApi(req);
      print(value.toJson());
      print("Access Token: ${value.accessToken}");

      if (value.accessToken != null) {
        print("Inside If");
        setValue(TOKEN, value.accessToken);
        userStore.setToken(value.accessToken.toString());
        setValue(USER_ID, value.user!.sId.toString());
        userStore.setUserID(value.user!.sId.toString());
        setValue(USER_NATIVE_LANGUAGE, value.user!.nativeLanguage.toString());
        userStore.setUserNativeLanguage(value.user!.nativeLanguage.toString());
        await userStore.setLogin(true);
        JabberAIHomepage().launch(context);
        setState(() {});

      }
    } catch (e) {
      print("Error: $e");
      if (e.toString() == "User doesn't exist") {
        ProfileScreen(
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
    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBarWidget('', context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: context.height() * 0.28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff755be8),
                          primaryColor,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: context.height() * 0.07,
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.password,
                            size: 26,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.black,
                          radius: 30,
                        ),
                        16.height,
                        Text(
                          'Enter OTP',
                          style: boldTextStyle(
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        50.height,
                        Text('Verify Phone Number',
                            style: boldTextStyle(size: 22)),
                        Text('${'We have sent the code verification to'} ',
                            // ''
                            // '${widget.phoneNumber!}',
                            style: secondaryTextStyle()),
                        20.height,
                        // PinFieldAutoFill(
                        //   codeLength: 6,
                        //   onCodeChanged: (code) {
                        //     setState(() {
                        //       otpCode = code; // Update the 1 code manually if needed
                        //     });
                        //   },
                        // ),
                        otpInputField(),

                        20.height,
                        StatefulBuilder(builder: (context, setState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Didn't receive OTP?",
                                  style: primaryTextStyle()),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      _canResendOTP ? 'Resend' : '',
                                      style: primaryTextStyle(color: primaryColor),
                                    ).paddingLeft(4),
                                    if (!_canResendOTP)
                                      Container(
                                        width: 120,
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
                          );
                        }),
                        90.height,
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ),
                  Observer(
                    builder: (context) {
                      return Loader().center().visible(appStore.isLoading);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: AppButton(
          text: 'Confirm',
          padding: EdgeInsetsDirectional.all(0),
          width: context.width() * 0.68,
          height: context.height() * 0.056,
          color: primaryColor,
          onTap: () {
            submit();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
