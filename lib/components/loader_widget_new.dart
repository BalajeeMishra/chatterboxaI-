import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryColor,),
          SizedBox(height: 16),
          Text(
            message,
            style: primaryTextStyle(color: primaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
