import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/widgets.dart';
import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/colors.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import 'JabberAIHomePage/JabberAIHomepage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  TextEditingController mNameCont = TextEditingController();
  TextEditingController mAgeCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', context: context),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 260,
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
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 26,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black,
                      radius: 30,
                    ),
                    16.height,
                    Text(
                      'Profile',
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
          60.height,
          Row(
            children: [
              Text('First Name',
                  style: secondaryTextStyle(color: textPrimaryColorGlobal)),
              2.width,
              Text('*', style: secondaryTextStyle(color: redColor))
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 4),
          4.height,
          AppTextField(
            controller: mNameCont,
            textFieldType: TextFieldType.NAME,
            isValidationRequired: true,
            // focus: mFirstNameFocus,
            // nextFocus: mLastNameFocus,
            decoration: defaultInputDecoration(context, label: 'Enter name'),
          ).paddingSymmetric(horizontal: 16, vertical: 4),
          16.height,
          Row(
            children: [
              Text('Age',
                  style: secondaryTextStyle(color: textPrimaryColorGlobal)),
              2.width,
              Text('*', style: secondaryTextStyle(color: redColor))
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 4),
          4.height,
          AppTextField(
            controller: mAgeCont,
            textFieldType: TextFieldType.NAME,
            isValidationRequired: true,
            // focus: mLastNameFocus,
            // nextFocus: mDesignationFocus,
            decoration:
                defaultInputDecoration(context, label: 'Enter your age'),
          ).paddingSymmetric(horizontal: 16, vertical: 4),
        ],
      ),
      floatingActionButton: AppButton(
        text: 'Confirm',
        width: 358,
        height: 48,
        color: primaryColor,
        onTap: () {
          JabberAIHomepage().launch(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
