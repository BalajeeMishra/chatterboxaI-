import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/widgets.dart';
import 'package:balajiicode/network/rest_api.dart';
import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_common.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import 'JabberAIHomePage/JabberAIHomepage.dart';

class ProfileScreen extends StatefulWidget {
  final String country;
  final String mobileNumber;
  ProfileScreen({required this.country, required this.mobileNumber, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  TextEditingController mNameCont = TextEditingController();
  TextEditingController mAgeCont = TextEditingController();
  List languageList = [
    'Hindi',
    'English',
    'Bengali',
    'Kannada',
    'Malayalam',
    'Marathi',
    'Nepali',
    'Punjabi',
    'Tamil',
    'Telugu',
    'Urdu',
    'Gujarati'
  ];
  String selectedLanguage = 'Hindi';

  @override
  void initState() {
    print("at Profile Screen Mobile Number Is ==>" +
        widget.mobileNumber.toString());
    print("at Profile Screen Country Name  Is ==>" + widget.country.toString());
    super.initState();
  }

  Future<void> save() async {
    hideKeyboard(context);
    Map<String, dynamic> req = {
      'name': mNameCont.text.trim(),
      'age': mAgeCont.text.trim(),
      'nativeLanguage': selectedLanguage,
      'mobileNo': widget.mobileNumber.trim(),
      'country': widget.country.trim(),
    };

    if (mFormKey.currentState!.validate()) {
      appStore.setLoading(true);
      await registerApi(req).then((value) async {
        print('Value' + value.toJson().toString());

        appStore.setLoading(false);
        if (value.accessToken != null) {
          JabberAIHomepage().launch(context);
          // toast('Register')
        } else {
          toast('Contact Admin');
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast('Invalid credentials');

        // toast(e.toString());
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This allows the screen to resize when the keyboard appears
      appBar: appBarWidget('', context: context),
      body: Form(
        key: mFormKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom), // Adjusts the bottom padding for the keyboard
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
              26.height,
              ListView.builder(
                physics: NeverScrollableScrollPhysics(), // Disable scrolling in ListView.builder
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text('First Name',
                              style: secondaryTextStyle(
                                  color: textPrimaryColorGlobal)),
                          2.width,
                          Text('*', style: secondaryTextStyle(color: redColor))
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      4.height,
                      AppTextField(
                        controller: mNameCont,
                        textFieldType: TextFieldType.NAME,
                        isValidationRequired: true,
                        decoration: defaultInputDecoration(context,
                            label: 'Enter name'),
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      16.height,
                      Row(
                        children: [
                          Text('Age',
                              style: secondaryTextStyle(
                                  color: textPrimaryColorGlobal)),
                          2.width,
                          Text('*', style: secondaryTextStyle(color: redColor))
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      4.height,
                      AppTextField(
                        controller: mAgeCont,
                        textFieldType: TextFieldType.NAME,
                        isValidationRequired: true,
                        decoration: defaultInputDecoration(context,
                            label: 'Enter your age'),
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      16.height,
                      Row(
                        children: [
                          Text('Native Language',
                              style: secondaryTextStyle(
                                  color: textPrimaryColorGlobal)),
                          2.width,
                          Text('*', style: secondaryTextStyle(color: redColor))
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      4.height,
                      DropdownButtonFormField(
                        items: languageList
                            .map((value) => DropdownMenuItem<String>(
                          child: Text(value, style: primaryTextStyle()),
                          value: value,
                        ))
                            .toList(),
                        isExpanded: false,
                        isDense: true,
                        borderRadius: radius(),
                        decoration: defaultInputDecoration(context),
                        value: selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AppButton(
        text: 'Confirm',
        width: 358,
        height: 48,
        color: primaryColor,
        onTap: () {
          save();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
