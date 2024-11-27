import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/decorations.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/system_utils.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_common.dart';
import '../Utils/app_images.dart';
import '../extensions/widgets.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
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
        center: true,
        // showBack: true,
        backWidget: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ).onTap(() {
          finish(context);
        }),
        color: primaryColor,
        '',
        context: context,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image(image: AssetImage(ImageConstant.micImage)),
            // SizedBox(
            //   width: 5.0,
            // ),
            Text(
              "Contact Us",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ).paddingRight(38)
          ],
        ).center(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Have a Feedback?',
            style: primaryTextStyle(),
          ),
          16.height,
          Text(
            'Want to raise a complaint?',
            style: primaryTextStyle(),
          ),
          16.height,
          Text(
            'Want to enquire about partnership?',
            style: primaryTextStyle(),
          ),
          16.height,
          Text(
            'Want to delete your account?',
            style: primaryTextStyle(),
          ),
          // 4.height,
          Text(
            'Please raise a request and we wil delete all your data in 3 days.',
            style: secondaryTextStyle(
                size: 12, color: Colors.black.withOpacity(0.6)),
          ),
          24.height,
          Image.asset(ic_whatsapp_fill, height: 40, width: 40).onTap((){
            launchUrls('https://wa.me/918300111204');

          }).center(),
          24.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 2,
                    color: Color(0xff755be8),

                  ),
                ),
                child: Text(
                  'Our Privacy policy ',
                  style: secondaryTextStyle(
                    size: 14,
                  ),
                ).paddingOnly(left: 12,right: 12,top: 4,bottom: 4),
              ),
            ],
          ).onTap((){
            launchUrls('https://zapai.chat/privacy-policy');
          }). center(),
        ],
      ).paddingAll(20),
    );
  }
}
