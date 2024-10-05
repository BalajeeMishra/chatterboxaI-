
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:flutter/material.dart';

import '../../Constants/appbar.dart';

class PlayTabooScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();

}

class _PlayTabooScreen extends State<PlayTabooScreen>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backCustomAppBar(
          backButtonshow: true,
          centerTile: false,
          onPressed: (){
            Navigator.pop(context);
          },
          title: "Taboo"
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            sameDistantRow(context: context,playstatus: true,feedbackstatus: false,practicestatus: false)
          ],
        ),
      ),
    );
  }

}