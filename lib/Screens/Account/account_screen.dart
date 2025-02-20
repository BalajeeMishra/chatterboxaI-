import 'dart:convert';

import 'package:balajiicode/Screens/Account/delete_account_screen.dart';
import 'package:balajiicode/Services/network/http_client.dart';
import 'package:balajiicode/ShareAndReview/share_and_review.dart';
import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/common.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:share_plus/share_plus.dart';
import '../../Model/error_model.dart';
import '../../Services/ApiResponseStatus.dart';
import '../../Utils/app_common.dart';
import '../../Widget/appbar.dart';
import '../../Widget/text_gradient.dart';
import '../../extensions/loader_widget.dart';
import '../../main.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  
  final dropDownKey = GlobalKey<DropdownSearchState>();
  String name = '';
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      getCurrUser();

    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: GradientText(
          "Account",
          style: TextStyle(fontWeight: FontWeight.bold),
          softWrap: false,
          ),
        centerTitle: true,
        leading:  GradientIcon(ontap: (){
          pop();
        }, icon: Icons.close),

      ),

      body: Stack(
        children:[ Padding(
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
                          MyText(
                            text: "Hello,",
                            fontSize: 20,
                          ),
                          MyText(
                            text:name,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
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

              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                   scrollDirection: Axis.vertical,
                   child: Column(
                     children: [
                       16.height,
                       _buildActionButton(share_logo, "Share The App", '',shareDialoge: true),
                       16.height,
                       _buildActionButton(privacy_logo, "Privacy Policy",'https://zapai.chat/privacy-policy'),
                       _buildActionButton(whatsapp_logo, "Contact The Developer",'https://wa.me/916266276582'),
                      16.height,

                       MyText(
                        text:  "We Are An Early App. Help The Developer By Sharing Your Feedback On How We Can Improve Your Experience! Thank You.",
                        textAlign: TextAlign.center,
                        fontSize: 12,fontWeight: FontWeight.bold, color: Colors.black,
                       ),

                       32.height,
                       Container(
                         height: context.height()*0.067,
                         child: OutlinedButton.icon(
                           onPressed: () {
                             DeleteAccountScreen(name:name).launch(context);
                           },
                           icon: Icon(Icons.delete, color: redColor),
                           label: MyText(
                             text:  "Delete Account",
                             color: redColor,
                           ),
                           style: OutlinedButton.styleFrom(
                             minimumSize: Size(double.infinity, 50),
                             side: BorderSide(color: redColor),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                           ),
                         ),
                       ),
                       16.height,
                       // Warning Message
                       Row(
                         children: [
                           Icon(Icons.warning, color:redColor),
                           SizedBox(width: 8),
                           Expanded(
                             child: MyText(
                              text:  "Important: Deleting Your Account Is Permanent. All Your Progress And Data Will Be Erased And Cannot Be Recovered.",
                              color: Colors.grey, fontSize: 12,
                             ),
                           ),
                         ],
                       ),
                       16.height,
                     ],
                   ),
                 ),
              )
            ],
          ),
        ),
          Observer(
            builder: (context) {
              // Show the custom Loader based on appStore.isLoading
              return Loader().center().visible(appStore.isLoading);
            },
          ),
    ]
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(text: label, fontSize: 16),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: MyText(text: value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
        ),
      ],
    );
  }

  Widget _buildActionButton(String image, String label,String url,{bool shareDialoge = false}) {
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
        title: MyText(text: label),

      ),
    ).onTap((){
      if(shareDialoge){
        ShareAndReview().share();
      }
      else{
        launchUrls(url);
      }
    });
  }

  void getCurrUser() async{
    try {
      appStore.setLoading(true);
      final response = await ApiClass.get("api/user/currentuser", isHeader: true);
      print("This is inside home page api ${response.body}");
      final ApiResponseStatus status = mapStatusCode(response.statusCode);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (status == ApiResponseStatus.success) {
        final data = responseData["user"]["name"];
         name = data;
        setState(() {

        });
       print(data);
      } else {
        final error = ErrorModal.fromJson(responseData);
        print(error);
      }
      appStore.setLoading(false);
    } catch (e) {
      toast('Cant Load User Profile');
      throw e.toString();

    }
  }



}