import 'package:balajiicode/Screens/authentication/phone_login.dart';
import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/Utils/app_common.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/CheckMobileNumberResponse.dart';
import '../../Services/auth_service.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/app_images.dart';
import '../../Widget/text_widget.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/shared_pref.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../JabberAIHomePage/JabberAIHomepage.dart';
import '../profile_screen.dart';
import 'add_phone.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenHeight);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children:[ Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // height: screenHeight*.45,
             child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight*.18,),
                  MyText(
                   text:  'Learn English by\nSpeaking to AI',
                    textAlign: TextAlign.center,
                      color: whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,

                  ),
                  8.height,
                  GestureDetector(
                    onTap: () {},
                    child: MyText(
                      text: 'We Make Talking to AI Fun',
                        color: whiteColor.withOpacity(0.8),
                        fontSize: 14,
                    ),
                  ),
                  // Avatar

                ],
              ),
            ),
            Column(
              children:[
                SizedBox(
                  height: 280,
                  width: 280,
                  child: Image.asset(
                    zapAIAvtar,
                    fit: BoxFit.fill
                  ),
                ),
                Container(
                width: double.infinity,
                // height: screenHeight*.26,
                padding: const EdgeInsets.symmetric(horizontal: 24,),
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
                    const Text(
                      'Zap AI',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    8.height,
                    const Text(
                      'Your AI English Tutor',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    24.height,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Image.asset(
                          google_logo,
                          height: 24,
                        ),
                        label: const MyText(
                          text: 'Login Using Google',
                          fontSize: 16, color: whiteColor
                        ),
                        onPressed: () async{
                          appStore.setLoading(true);
                            final value = await signInWithGoogle(context);
                            if (value == "success") {
                              appStore.setLoading(false);
                              // toast("Successfully login");
                            }
                            else{
                              appStore.setLoading(false);
                              PhoneLogin().launch(context);
                              toast("Some issue occurred while login please try again $value");
                            }
                           appStore.setLoading(false);
                            },
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        MyText(
                            text: "Don't Have A Google Account? ",
                            fontSize: 14,
                            color: Colors.black54,
                        ),
                        GestureDetector(
                          onTap: (){
                           PhoneLogin().launch(context);

                          },
                          child: MyText(
                              text: "Continue With OTP",
                              fontSize: 14,
                              textDecoration: TextDecoration.underline,
                              color: Colors.black54,
                              decorationcolor:  Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    10.height
                  ],
                ),
              ),

              ]
            ),
          ],
        ), Observer(
            builder: (context) {
              // Show the custom Loader based on appStore.isLoading
              return Loader().center().visible(appStore.isLoading);
            },
          ),
      ]
      ),
    );
  }

}
