import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/authentication/add_phone.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../Constants/ImageConstant.dart';
import '../Services/auth_service.dart';
import '../Utils/app_common.dart';
import '../Utils/app_images.dart';
import '../Widget/text_widget.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import 'otp_verification_screen.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  String selectedCountry = 'India';

  String selectedCode = '+91';

  String flagEmoji = '🇮🇳';
  GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
  TextEditingController mMobileCont = TextEditingController();

  Future<void> sendOTP() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    String number = '$selectedCode${mMobileCont.text.trim()}';
    if (!number.startsWith('+')) {
      number = '$mMobileCont ${mMobileCont.text.trim()}';
    }

    await loginWithOTP(
      context,
      number,
      mMobileCont.text.trim(),
      selectedCountry,
    ).then((value) {}).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  void showPicker(double screenHeight) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: screenHeight * .79,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country.name;
          selectedCode = "+${country.phoneCode}";
          flagEmoji = country.flagEmoji;
          print(flagEmoji);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenHeight);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true, // Scroll to bottom when keyboard opens
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: phoneKey,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: screenHeight * .18),
                            MyText(
                              text: 'Register Your\nAccount',
                              textAlign: TextAlign.center,
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            8.height,
                            MyText(
                              text: "Enter Your Phone Number",
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            50.height,
                            Column(
                              children: [
                                SizedBox(
                                  height: 280,
                                  width: 280,
                                  child:
                                      Image.asset(zapAIAvtar, fit: BoxFit.fill),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: 'Enter Your Mobile Number',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                      16.height,
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showPicker(screenHeight);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 14),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade400),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  MyText(text: flagEmoji),
                                                  MyText(
                                                      text: selectedCode,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  const Icon(
                                                      Icons.arrow_drop_down),
                                                ],
                                              ),
                                            ),
                                          ),
                                          8.width,
                                          Expanded(
                                            child: AppTextField(
                                              keyboardType: TextInputType.phone,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a Phone number';
                                                } else if (value.length < 10) {
                                                  return 'Phone number must be 10 digits long';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: '900000XXXX',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              textFieldType:
                                                  TextFieldType.PHONE,
                                              controller: mMobileCont,
                                            ),
                                          ),
                                        ],
                                      ),
                                      16.height,
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (phoneKey.currentState!
                                                .validate()) {
                                              sendOTP();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Observer(
                          builder: (context) {
                            return Loader()
                                .center()
                                .visible(appStore.isLoading);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
