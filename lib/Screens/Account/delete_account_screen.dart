import 'dart:convert';
import 'dart:ui';

import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Screens/authentication/login_screen.dart';
import 'package:balajiicode/Screens/splash_screen.dart';
import 'package:balajiicode/Services/auth_service.dart';
import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/extensions/colors.dart';
import 'package:balajiicode/extensions/common.dart';
import 'package:balajiicode/extensions/extension_util/context_extensions.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Model/error_model.dart';
import '../../Services/ApiResponseStatus.dart';
import '../../Services/network/http_client.dart';
import '../../Utils/app_common.dart';
import '../../Utils/app_constants.dart';
import '../../Utils/app_images.dart';
import '../../Widget/text_widget.dart';
import '../../main.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String name;
  DeleteAccountScreen({required this.name});
  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool isDeleted = false;
  bool isLoading = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Enable button after 5 seconds
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        isButtonEnabled = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: ImageFiltered(
              imageFilter: isLoading
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(),
              child: AppBar(
                title: MyText(
                  text: "Delete Account",
                  color: lightRedColor,
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: lightRedColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                24.height,
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // The main container
                    Container(
                      width: context.width(),
                      height: context.height() * 0.12,
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
                          MyText(
                            text: widget.name,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1a1a1a),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      child: SizedBox(
                        height: 84,
                        width: 84,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(profile_logo),
                        ),
                      ),
                    ),
                  ],
                ),
                24.height,
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstant.trash,
                    ),
                    16.width,
                    Expanded(
                        child: MyText(
                      text: !isDeleted
                          ? "Are You Sure You Want To Delete Your Account?"
                          : "Your Account Has Been Deleted",
                      color: Color(0xffff7171),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                  ],
                ),
                Divider(
                  color: lightGrey,
                  thickness: 1.0,
                  indent: 8.0,
                  endIndent: 8.0,
                ),
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      columnWidths: {
                        0: FixedColumnWidth(
                            24), // Set a fixed width for the bullet points
                        1: FlexColumnWidth(), // Let the text take the remaining space
                      },
                      children: [
                        if (!isDeleted)
                          _buildRow("You Will Be Signed Out First."),
                        if (!isDeleted)
                          _buildRow(
                            "Your Account Deletion Will Start Once You Are Signed Out.",
                          ),
                        if (!isDeleted)
                          _buildRow(
                            "Your Account Will Be Deleted Within 10 Minutes.",
                          ),
                        if (isDeleted) _buildRow("You will be signed Out Now."),
                        if (isDeleted)
                          _buildRow(
                              "Deletion Process should be complete in 10 minutes.")
                      ],
                    ),
                  ],
                ),
                Spacer(),
                if (!isDeleted)
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            deleteuser();
                          }
                        : () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor:
                          isButtonEnabled ? lightRedColor : Color(0xffFFA8A8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: MyText(
                      text: "Delete Account",
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                16.height,
                OutlinedButton(
                  onPressed: () {
                    !isDeleted
                        ? pop()
                        : Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: MyText(
                    text: isDeleted ? "Okay" : "Cancel",
                    color: blackColor,
                    fontSize: 16,
                  ),
                ),
                16.height
              ],
            ),
          ),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.2),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(redColor),
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 16),
                      MyText(
                        text: "Account Deletion In Progress",
                        color: redColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            )
        ]));
  }

  TableRow _buildRow(String text) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 10),
          child: Icon(Icons.circle, size: 9, color: Colors.black),
        ), // Larger bullet point
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MyText(
            text: text,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void deleteuser() async {
    setState(() {
      isLoading = true;
    });
    try {
      appStore.setLoading(true);
      final response = await ApiClass.delete("api/user/delete", isHeader: true);
      print("This is inside home page api ${response.body}");
      final ApiResponseStatus status = mapStatusCode(response.statusCode);
      if (status == ApiResponseStatus.success) {
        removeKey(TOKEN);
        removeKey(IS_LOGIN);
        removeKey(USER_ID);
        removeKey(USER_NATIVE_LANGUAGE);
        removeKey(USER_ENGLISH_PROFICIENCY);
        userStore.clearUserData();
        setState(() {
          isLoading = false;
          isDeleted = true;
        });
        toast("Successfully Deleted");
      } else {
        setState(() {
          isLoading = false;
          isDeleted = false;
        });
        toast("Can\'t Delete User");
      }
      appStore.setLoading(false);
    } catch (e) {
      setState(() {
        isLoading = false;
        isDeleted = false;
      });
      toast('Can\'t Delete User');
      throw e.toString();
    }
  }
}
