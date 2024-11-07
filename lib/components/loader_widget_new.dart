import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String message = 'Correcting Speech recognition mistakes';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = 'Thinking...';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWidget(message: message),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment. center,
        children: [
          CircularProgressIndicator(color: primaryColor),
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

