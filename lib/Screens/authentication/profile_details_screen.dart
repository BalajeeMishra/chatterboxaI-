import 'package:balajiicode/Screens/JabberAIHomePage/JabberAIHomepage.dart';
import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_common.dart';
import '../../Utils/app_config.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/proficiency_consts.dart';
import '../../Widget/text_widget.dart';
import '../../extensions/common.dart';
import '../../extensions/shared_pref.dart';
import '../../main.dart';
import '../../network/rest_api.dart';


class ProfileDetailsScreen extends StatefulWidget {
  final email;
  final country;
  final mobileNumber;
  final name;
  const ProfileDetailsScreen({super.key,required  this.country,  this.mobileNumber = '', this.name='', this.email ='', });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  TextEditingController _nameController = TextEditingController();
  String selectedLanguage = 'Hindi';
  int englishLevel = 1; // 0: Beginner, 1: Intermediate, 2: Advanced
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  String countryCode ="";
  List<Language> filteredLanguages = [];
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    filteredLanguages = languages;
    if(widget.mobileNumber != '') {
      countryCode = extractCountryCode(widget.mobileNumber.toString());
      print("Country code $countryCode");
    }
    if(widget.name != ''){
    _nameController = TextEditingController(text: widget.name);}
  }
  Future<void> save() async {
    hideKeyboard(context);
    String enLevel = getLevel();
    Map<String, dynamic> req = {
      'name': _nameController.text.trim(),
      'nativeLanguage': selectedLanguage,
      'mobileNo': widget.mobileNumber,
      'country': widget.country,
      'engprolevel': enLevel,
      'email':widget.email
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
          setValue(
              USER_ENGLISH_PROFICIENCY, value.newUser!.engprolevel.toString());
          userStore
              .setUserEnglishProficiency(value.newUser!.engprolevel.toString());

          await userStore.setLogin(true);
          JabberAIHomepage().launch(context);
          analytics.logEvent(
            name: 'Registration_complete',
            parameters: {
              'User_id': value.newUser!.userId.toString(),
              'Native_language': value.newUser!.nativeLanguage.toString(),
              'Proficiency': value.newUser!.engprolevel.toString(),
              'country_code': countryCode
            },
          ).then((_) {
            print('Logged event: Registration_complete with parameters:');
          }).catchError((error) {
            print('Failed to log event: $error');
          });
          facebookAppEvents.logEvent(
            name: 'Registration_complete',
            parameters: {
              'User_id': value.newUser!.userId.toString(),
              'Native_language': value.newUser!.nativeLanguage.toString(),
              'Proficiency': value.newUser!.engprolevel.toString(),
              'country_code':countryCode
            },
          ).then((_) {
            print('Logged event: Registration_complete with parameters:');
          }).catchError((error) {
            print('Failed to log event: $error');
          });
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
  String getLevel(){
   switch(englishLevel){
     case 0:
         return "Beginner";
     case 1:
       return "Intermediate";
     case 2:
       return "Advanced";
     default:
       return "Beginner";
   }
  }
  void showLanguagePicker() async {
    // Placeholder for language picker modal
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText(text:'Select Your Native Language', fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black54),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const MyText(text:'Close', color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search For Language',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,

                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredLanguages = languages
                              .where((lang) =>
                          lang.englishName.toLowerCase().contains(value.toLowerCase()) ||
                              lang.nativeName.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredLanguages.length,
                      itemBuilder: (context, index) {
                        final language = filteredLanguages[index];
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:selectedLanguage == language.englishName? Colors.grey.shade100:Colors.transparent,
                              ),
                              child: ListTile(
                                title: Text(language.englishName),
                                trailing: Text(language.nativeName),
                                selected: selectedLanguage == language.englishName,
                                selectedTileColor: Colors.blue.withOpacity(0.1),
                                selectedColor: primaryColor,
                                contentPadding: EdgeInsets.zero,
                                onTap: () =>
                                    Navigator.of(context).pop(language.englishName),
                              ).paddingSymmetric(horizontal: 12),
                            ),
                            Divider(thickness: 0.2,height: 10,)

                          ],
                        ).paddingSymmetric(horizontal: 12);
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
    );
    if (result != null) {
      setState(() {
        selectedLanguage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: mFormKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                  reverse: true,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const MyText(
                                text: 'Hello 👋\nTell Me About\nYourself',
                                textAlign: TextAlign.center,
                                color: whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.asset(
                                  zapai2,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Your Name', style: TextStyle(
                                    fontWeight: FontWeight.bold,color: Colors.black54)),
                                10.height,
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                20.height,
                                const MyText(text: "Select Your Native Language",
                                    fontWeight: FontWeight.bold,color: Colors.black54,),
                                8.height,
                                GestureDetector(
                                  onTap: showLanguagePicker,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(selectedLanguage,
                                            style: const TextStyle(fontSize: 16)),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                                20.height,
                                const MyText(text: 'Your English Proficiency',
                                    fontWeight: FontWeight.bold,color: Colors.black54),
                                8.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    MyText(text: 'Beginner',color: englishLevel==0?primaryColor : textColor,),
                                    MyText(text: 'Intermediate',color: englishLevel==1?primaryColor : textColor,),
                                    MyText(text: 'Advanced',color: englishLevel==2?primaryColor : textColor,),
                                  ],
                                ),
                                Slider(
                                  value: englishLevel.toDouble(),
                                  min: 0,
                                  max: 2,
                                  divisions: 2,
                                  activeColor: Colors.grey.shade200,
                                  inactiveColor: Colors.grey.shade200,
                                  thumbColor: primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      englishLevel = value.toInt();
                                    });
                                  },
                                ),
                                8.height,
                                 Text(
                                 englishLevel==0 ? 'Can understand and use basic everyday expressions and simple phrases.' : englishLevel==1 ? 'Can handle daily conversations and write or speak with some confidence on familiar topics.':'Can communicate fluently and effectively in complex situations, both spoken and written.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                                20.height,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                       save();
                                      // JabberAIHomepage().launch(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Continue',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Language {
  final String englishName;
  final String nativeName;

  Language({required this.englishName, required this.nativeName});
}
