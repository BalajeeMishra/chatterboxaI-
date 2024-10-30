import 'package:balajiicode/Screens/JabberAIHomePage/JabberAIHomepage.dart';
import 'package:balajiicode/Screens/login_screen.dart';
import 'package:balajiicode/Utils/app_common.dart';
import 'package:balajiicode/Utils/app_constants.dart';
import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/common.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:balajiicode/main.dart';
import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../extensions/app_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: context.height() * 0.75,
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
                  top: 100,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/ic_splash.png',
                        height: 260,
                      ),
                      40.height,
                      Text("Jabber AI",
                          style: boldTextStyle(
                              size: 32,
                              color: Colors.white,
                              fontFamily: 'roboto')),
                      10.height,
                      Text("Your AI English Tutor",
                          style: boldTextStyle(
                              size: 32,
                              color: Colors.white,
                              fontFamily: 'roboto')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: AppButton(
        padding: EdgeInsetsDirectional.all(0),
        width: context.width() * 0.68,
        height: context.height() * 0.056,
        text: 'Sign up',
        color: primaryColor,
        onTap: () {
          LoginScreen().launch(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
