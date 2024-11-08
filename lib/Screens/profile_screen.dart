import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/widgets.dart';
import 'package:balajiicode/network/rest_api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_common.dart';
import '../Utils/app_constants.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
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

  final FocusNode nameFocus = FocusNode();
  final FocusNode ageFocus = FocusNode();
  final FocusNode languageFocus = FocusNode();
  final FocusNode englishLevelFocus = FocusNode();

  final dropDownKey = GlobalKey<DropdownSearchState>();

  final List<String> languageList = [
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
  final List<String> englishLevelList = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  String selectedLanguage = 'Hindi';
  String englishLevel = 'Beginner';

  @override
  void initState() {
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
      'engprolevel': englishLevel,
    };

    if (mFormKey.currentState!.validate()) {
      appStore.setLoading(true);

      await registerApi(req).then((value) async {
        appStore.setLoading(false);
        if (value.accessToken != null) {
          setValue(TOKEN, value.accessToken);
          userStore.setToken(value.accessToken.toString());
          setValue(USER_ID, value.newUser!.userId.toString());
          userStore.setUserID(value.newUser!.userId.toString());
          setValue(
              USER_NATIVE_LANGUAGE, value.newUser!.nativeLanguage.toString());
          userStore
              .setUserNativeLanguage(value.newUser!.nativeLanguage.toString());
          await userStore.setLogin(true);
          JabberAIHomepage().launch(context);
        } else {
          toast('Contact Admin');
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: mFormKey,
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          backgroundColor: Colors.black,
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                        16.height,
                        Text(
                          'Personalise your Learning',
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
                physics: NeverScrollableScrollPhysics(),
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
                        focus: nameFocus,
                        controller: mNameCont,
                        nextFocus: ageFocus,
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
                        focus: ageFocus,
                        nextFocus: languageFocus,
                        controller: mAgeCont,
                        textFieldType: TextFieldType.NAME,
                        isValidationRequired: true,
                        decoration: defaultInputDecoration(context,
                            label: 'Enter your age'),
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      16.height,
                      Row(
                        children: [
                          Text('Your Native Language',
                              style: secondaryTextStyle(
                                  color: textPrimaryColorGlobal)),
                          2.width,
                          Text('*', style: secondaryTextStyle(color: redColor))
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      4.height,
                      DropdownSearch<String>(
                        key: dropDownKey,
                        items: (String filter, LoadProps? loadProps) async {
                          if (filter.isEmpty) {
                            return languageList;
                          } else {
                            return languageList
                                .where((language) => language
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()))
                                .toList();
                          }
                        },
                        selectedItem: selectedLanguage,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration:
                                InputDecoration(hintText: 'Search Language'),
                          ),
                          emptyBuilder: (context, searchEntry) {
                            return Text('No Language available').center();
                          },
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            selectedLanguage = value!;

                          });
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: defaultInputDecoration(
                              context), // Applying the decoration here
                        ),
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      16.height,
                      Row(
                        children: [
                          Text('Your English Proficiency',
                              style: secondaryTextStyle(
                                  color: textPrimaryColorGlobal)),
                          2.width,
                          Text('*', style: secondaryTextStyle(color: redColor))
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      4.height,
                      DropdownButtonFormField(
                        items: englishLevelList
                            .map((value) => DropdownMenuItem<String>(
                                  child: Text(value, style: primaryTextStyle()),
                                  value: value,
                                ))
                            .toList(),
                        isExpanded: false,
                        isDense: true,
                        borderRadius: radius(),
                        decoration: defaultInputDecoration(context),
                        value: englishLevel,
                        onChanged: (String? value) {
                          setState(() {
                            englishLevel = value!;
                            if (selectedLanguage.isNotEmpty)
                              toastLeft(
                                  bgColor: primaryColor,
                                  textColor: Colors.white,
                                  "You have chosen $englishLevel.\nAI will talk in your Native language & share few references in $selectedLanguage");
                          });
                        },
                        focusNode: englishLevelFocus,
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                      40.height,

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
        padding: EdgeInsetsDirectional.all(0),
        width: context.width() * 0.68,
        height: context.height() * 0.056,
        color: primaryColor,
        onTap: () {
          save();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
