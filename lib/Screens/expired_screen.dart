import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:flutter/material.dart';
import '../Constants/ImageConstant.dart';
import '../Utils/app_colors.dart';
import '../extensions/app_button.dart';
import '../extensions/text_styles.dart';

class ExpiredScreen extends StatefulWidget {
  const ExpiredScreen({super.key});

  @override
  State<ExpiredScreen> createState() => _ExpiredScreenState();
}

class _ExpiredScreenState extends State<ExpiredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: AssetImage(ImageConstant.micImage)),
            SizedBox(width: 5.0),
            Text(
              "Jabber AI",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
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
            width: double.infinity,
            height: double.infinity,
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 70,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/ic_splash.png',
                      height: 260,
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Your Trial Period has Expired",
                      style: boldTextStyle(
                          size: 22, color: Colors.white, fontFamily: 'roboto'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "You may contact us for\nsubscription",
                      style: boldTextStyle(
                          size: 22, color: Colors.white, fontFamily: 'roboto'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 40.0), // 40 pixels from the bottom
              child: AppButton(
                // text: '',
                textColor: Colors.black,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contact us on WhatsApp',
                      style: boldTextStyle(),
                    ),
                    16.width,
                    Image.asset(ic_whatsapp,height: 35, width: 35),

                  ],
                ),
                onTap: () {
                  // launchUrls(url);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
