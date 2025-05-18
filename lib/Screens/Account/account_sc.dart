import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:balajiicode/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/proficiency_consts.dart';
import '../../Widget/appbar.dart';
import '../../extensions/constants.dart';
import '../../extensions/decorations.dart';
import '../../extensions/text_styles.dart';
import '../../extensions/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FocusNode languageFocus = FocusNode();
  final FocusNode englishLevelFocus = FocusNode();

  final dropDownKey = GlobalKey<DropdownSearchState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("this is height and width $height $width");
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: backCustomAppBar(
        backButtonshow: true,
        centerTile: true,
        onPressed: () {
          Navigator.pop(context,true);
        },
        title:  "Account",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Expanded(
              flex: 1,
              child:
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // The main container
                  Container(
                    width: context.width(),
                    height: context.height() * 0.19,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Greeting text
                        Text(
                          "Hello,",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "Khushvant",
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -30,
                    left: context.width() * 0.9/ 2 - 50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(profile_logo),
                    ),
                  ),
                ],
              ),
              // Column(
              //   children: [
              //     Positioned(
              //       top: -50,
              //       left: 110,
              //       child: CircleAvatar(
              //         radius: 50,
              //         backgroundImage: AssetImage(ic_transparent_girlImage), // Replace with your image path
              //       ),
              //     ),
              //     Container(
              //       width: context.width(),
              //       height: context.height()*.2,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(8)
              //       ),
              //       child: Column(
              //         children: [
              //           SizedBox(
              //             height: context.height()*.1,
              //           ),
              //           Expanded(
              //             child: Text(
              //                   "Hello,\nJane Doe",
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //                 ),
              //           ),
              //         ],
              //       ),
              //     ),
              //
              //
              //     // SizedBox(height: 10,),
              //     // Positioned(
              //     //
              //     //   child: Text(
              //     //     "Hello,\nJane Doe",
              //     //     textAlign: TextAlign.center,
              //     //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //     //   ),
              //     // ),
              //   ],
              // ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    // Registered Mobile Number
                    Row(
                      children: [
                        Text(
                          "Registered Mobile Number",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(

                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),

                            ),
                            height: 52,
                            width: 53,
                            child: Center(child: Text("+91",style: TextStyle(fontSize: 17),)),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: TextFormField(
                              initialValue: "876432XXXX",
                              enabled: false,
                              style: TextStyle(
                                  fontSize: 17
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

                              ),
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Your Native Language',
                            style: secondaryTextStyle(
                                color: textPrimaryColorGlobal)),
                        2.width,
                        Text('*', style: secondaryTextStyle(color: redColor))
                      ],
                    ).paddingSymmetric(horizontal: 0, vertical: 4),
                    4.height,
                    // DropdownSearch<String>(
                    //   key: dropDownKey,
                    //   items: (String filter, LoadProps? loadProps) async {
                    //     if (filter.isEmpty) {
                    //       return languageList;
                    //     } else {
                    //       return languageList
                    //           .where((language) => language
                    //           .toLowerCase()
                    //           .contains(filter.toLowerCase()))
                    //           .toList();
                    //     }
                    //   },
                    //   selectedItem: selectedLanguage,
                    //   popupProps: PopupProps.menu(
                    //     showSearchBox: true,
                    //     searchFieldProps: TextFieldProps(
                    //       decoration:
                    //       InputDecoration(hintText: 'Search Language'),
                    //     ),
                    //     emptyBuilder: (context, searchEntry) {
                    //       return Text('No Language available').center();
                    //     },
                    //   ),
                    //   onChanged: (String? value) {
                    //     setState(() {
                    //       selectedLanguage = value!;
                    //     });
                    //   },
                    //   decoratorProps: DropDownDecoratorProps(
                    //     decoration: defaultInputDecoration(
                    //         context), // Applying the decoration here
                    //   ),
                    // ).paddingSymmetric(horizontal: 0, vertical: 4),
                    16.height,
                    Row(
                      children: [
                        Text('Your English Proficiency',
                            style: secondaryTextStyle(
                                color: textPrimaryColorGlobal)),
                        2.width,
                        Text('*', style: secondaryTextStyle(color: redColor))
                      ],
                    ).paddingSymmetric(horizontal: 0, vertical: 4),
                    4.height,
                    DropdownButtonFormField(
                      items: englishLevelList
                          .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: primaryTextStyle()),
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
                          if (selectedLanguage.isNotEmpty) {
                            toastLeft(
                                durationInSeconds: 7,
                                bgColor: primaryColor,
                                textColor: Colors.white,
                                "You have chosen $englishLevel.\nAI will talk in your Native language & share few references in $selectedLanguage");
                          }
                        });
                      },
                      focusNode: englishLevelFocus,
                    ).paddingSymmetric(horizontal: 0, vertical: 4),
                    SizedBox(height: 32),
                    _buildActionButton(privacy_logo, "Privacy Policy"),
                    _buildActionButton(whatsapp_logo, "Contact The Developer"),
                    SizedBox(height: 16),

                    Text(
                      "We Are An Early App. Help The Developer By Sharing Your Feedback On How We Can Improve Your Experience! Thank You.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 32),

                    Container(
                      height:  context.height()*0.067,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.logout,color: Colors.white,),
                        label: Text("Sign Out",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: context.height()*0.067,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Warning Message
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Important: Deleting Your Account Is Permanent. All Your Progress And Data Will Be Erased And Cannot Be Recovered.",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
        ),
      ],
    );
  }

  Widget _buildActionButton(String image, String label) {
    return Container(
      height: context.height()*0.08,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),

      ),
      child: ListTile(
        leading: Image.asset(image,width: 24,height: 24,),
        title: Text(label),
        onTap: () {},
      ),
    );
  }
}