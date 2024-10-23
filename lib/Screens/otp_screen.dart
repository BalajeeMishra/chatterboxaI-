import 'package:balajiicode/Screens/profile_screen.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../Utils/app_colors.dart';
import '../extensions/app_button.dart';
import '../extensions/loader_widget.dart';
import '../extensions/otp_text_field.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';

class OtpScreen extends StatefulWidget {
  final String  country;
  final String mobileNumber;
   OtpScreen({required this.country,required this.mobileNumber, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  GlobalKey<OTPTextFieldState> otpTextFieldKey = GlobalKey<OTPTextFieldState>();



  @override
  void initState() {
    print("Mobile NUmber Is ==>" + widget.mobileNumber.toString());
    print("Country Name  Is ==>" + widget.country.toString());

    super.initState();
  }


  Widget otpInputField() {
    return OTPTextField(

      key: otpTextFieldKey,
      pinLength: 6,
      fieldWidth: context.width() * 0.1,
      onChanged: (s) {
        // otpCode = s;
      },
      onCompleted: (pin) {
        // otpCode = pin;
        // submit();
        // submit();
        // UserDetails().launch(context);
      },
    ).center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: context.height() *0.28,
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
                  top: context.height() *0.07,
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
                      Text('Verify Phone Number', style: boldTextStyle(size: 22)),
                      Text(
                          '${'We have sent the code verification to'} ',
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
                            Text("Didn't receive OTP?", style: primaryTextStyle()),
                            // GestureDetector(
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         _canResendOTP ? 'Resend' : '',
                            //         style: primaryTextStyle(color: primaryColor),
                            //       ).paddingLeft(4),
                            //       if (!_canResendOTP)
                            //         Container(
                            //           width: 120,
                            //           alignment: Alignment.center,
                            //           child: Text('$_start seconds',
                            //               style: primaryTextStyle(
                            //                   color: primaryColor)),
                            //         ),
                            //     ],
                            //   ),
                            //   onTap: () {
                            //     if (_canResendOTP) {
                            //       resendOtpFunction();
                            //       setState(() {});
                            //     }
                            //   },
                            // ),
                            //
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
        width: 358,
        height: 48,
        color: primaryColor,
        onTap: () {
          ProfileScreen(country: widget.country,mobileNumber: widget.mobileNumber,).launch(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
