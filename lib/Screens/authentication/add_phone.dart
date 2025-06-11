import 'package:balajiicode/Screens/authentication/profile_details_screen.dart';
import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart'as user;
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Constants/ImageConstant.dart';
import '../../Model/CheckMobileNumberResponse.dart';
import '../../Utils/app_images.dart';
import '../../Widget/text_widget.dart';
import '../../extensions/app_text_field.dart';


class AddPhoneDetails extends StatefulWidget {
  final User user;

  const AddPhoneDetails({super.key, required this.user,});

  @override
  State<AddPhoneDetails> createState() => _AddPhoneDetailsState();
}

class _AddPhoneDetailsState extends State<AddPhoneDetails> with WidgetsBindingObserver {
  String selectedCountry = 'India';
  String selectedCode = '+91';
  String flagEmoji='🇮🇳';
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
  void showPicker(double screenHeight) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: screenHeight*.79,
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
          flagEmoji   =  country.flagEmoji;
          print(flagEmoji);
        });
      },
    );
  }
 bool isKeyboardVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newKeyboardVisible = bottomInset > 0.0;

    if (newKeyboardVisible != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = newKeyboardVisible;
      });

      if (isKeyboardVisible) {
        print("🔼 Keyboard Opened");
        // Perform your action here
      } else {
        print("🔽 Keyboard Closed");
        // Perform your action here
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child:
             Form(
              key: phoneKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(!isKeyboardVisible)SizedBox(height: screenHeight * 0.02),
                      MyText(
                        text: 'Hey\n${widget.user.name ?? "User"} 👋',
                        textAlign: TextAlign.center,
                        color: whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      if(!isKeyboardVisible) 8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            text: 'Not You? ',
                            color: whiteColor.withOpacity(0.8),
                            fontSize: 14,
                          ),
                          Image.asset(google_logo, height: 15, width: 15),
                          5.width,
                          GestureDetector(
                            onTap: () async{
                              final GoogleSignIn googleSignIn = GoogleSignIn();
                              await googleSignIn.signOut();
                              await user.FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: MyText(
                              text: 'Change Account',
                              color: whiteColor,
                              fontSize: 14,
                              textDecoration: TextDecoration.underline,
                              decorationcolor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: isKeyboardVisible?230:270,
                        width: isKeyboardVisible?230:270,
                        child: Image.asset(
                          zapai2,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: screenHeight*.32,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        MyText(text:flagEmoji),
                                        MyText(
                                          text: selectedCode, fontWeight: FontWeight.bold,color: Colors.black54),
                                        const Icon(Icons.arrow_drop_down,color: Colors.black54,),
                                      ],
                                    ),
                                  ),
                                ),
                                8.width,
                                Expanded(
                                  child: AppTextField(

                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                    if (value!.length < 10) {
                                        return 'Phone number must be 10 digits long';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: '900000XXXX',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    textFieldType: TextFieldType.PHONE,
                                    controller: phoneController,
                                  ),
                                ),
                              ],
                            ),
                           16.height,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                if(phoneKey.currentState!.validate()){
                                  String number = '$selectedCode${phoneController.text}';
                                  print(number);
                                  // if (!number.startsWith('+')) {
                                  //   number = '$selectedCode ${phoneController.text.trim()}';
                                  // }
                                  ProfileDetailsScreen(
                                    country: selectedCountry,
                                    email: widget.user.email,
                                    mobileNumber: number,
                                    name: widget.user.name,
                                  ).launch(context);
                                }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ),
                            15.height,
                            GestureDetector(
                              onTap: (){
                                ProfileDetailsScreen(name: widget.user.name, country: selectedCountry,).launch(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(ImageConstant.forward_icon, height: 15, width: 15,color: Colors.black54,),
                                  8.width,
                                  const MyText(
                                    text: 'Skip This Step',
                                    textDecoration: TextDecoration.underline,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),

    );
  }
}