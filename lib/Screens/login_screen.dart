import 'package:balajiicode/Screens/otp_screen.dart';
import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/confirmation_dialog.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_colors.dart';
import '../extensions/app_button.dart';
import '../extensions/colors.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController mCountryCont = TextEditingController();
  TextEditingController mMobileCont = TextEditingController();
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  String selectedCountry = "";
  String countryCode ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: mFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    top: context.height() *0.07,
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.login,
                            size: 26,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.black,
                          radius: 30,
                        ),
                        16.height,
                        Text(
                          'Login',
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
              40.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select your country',
                      style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                  2.width,
                  Text('*', style: secondaryTextStyle(color: redColor))
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              4.height,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.s,
                    children: [
                      CountryCodePicker(
                        showCountryOnly: true,
                        showFlag: true,
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        showFlagDialog: true,
                        showOnlyCountryWhenClosed: true,
                        alignLeft: false,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: TextStyle(
                            color: Colors.black), // Customize your text style
                        onChanged: (c) {
                          selectedCountry = c.name.toString();
                          print("Selcetd COuntry is ==>" +
                              selectedCountry.toString());
                          // Handle the selected country here
                        },
                      ),
                      Icon(Icons.keyboard_arrow_down_outlined,
                          color: Colors.grey), // Dropdown icon added here
                    ],
                  ),
                ),
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              40.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mobile Number',
                      style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                  2.width,
                  Text('*', style: secondaryTextStyle(color: redColor))
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              4.height,
              AppTextField(
                controller: mMobileCont,
                textFieldType: TextFieldType.PHONE,
                // maxLength: 10,
                isValidationRequired: true,
                inputFormatters: [
                  // LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter a Phone number';
                //   } else if (value.length < 10) {
                //     return 'Phone number must be 10 digits long';
                //   }
                //   return null;
                // },
                decoration: defaultInputDecoration(context,
                    label: 'Enter your mobile number',
                    mPrefix: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CountryCodePicker(
                            // initialSelection: getStringAsync(
                            //     COUNTRY_CODE,
                            //     defaultValue: countryCode!),
                            showCountryOnly: false,
                            showFlag: false,
                            boxDecoration: BoxDecoration(
                                borderRadius: radius(defaultRadius),
                                color: context.scaffoldBackgroundColor),
                            showFlagDialog: true,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            textStyle: primaryTextStyle(),
                            onInit: (c) {
                              // countryCode = c!.dialCode;
                              // setValue(COUNTRY_CODE, c.code);
                            },
                            onChanged: (c) {
                              countryCode= c.dialCode.toString();
                              // countryCode = c.dialCode;
                              // setValue(COUNTRY_CODE, c.code);
                            },
                          ),
                          VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                          16.width,
                        ],
                      ),
                    )),
              ).paddingSymmetric(horizontal: 16, vertical: 4),
              90.height,
            ],
          ),
        ),
      ),
      floatingActionButton: AppButton(
        text: 'Request OTP',
        width: 358,
        height: 48,
        color: primaryColor,
        onTap: () {
          if (mFormKey.currentState!.validate()) {
            OtpScreen(
              country: selectedCountry,
              mobileNumber: countryCode+mMobileCont.text,
            ).launch(context);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
