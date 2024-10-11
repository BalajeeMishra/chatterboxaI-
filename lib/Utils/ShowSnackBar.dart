
import 'package:flutter/material.dart';

import '../Widget/text_widget.dart';

class MySnackBar{


  static void showSnackBar(BuildContext context, String text, {int duration = 2}) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Center(
        child: MyText(
          text: text,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
      elevation: 20,
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}