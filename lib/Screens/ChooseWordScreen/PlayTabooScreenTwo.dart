

import 'package:flutter/material.dart';

import '../../Constants/ImageConstant.dart';
import '../../Constants/constantRow.dart';
import '../../Widget/appbar.dart';
import '../../Widget/text_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PlayTabooScreenTwo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PlayTabooScreenTwo();
}

class _PlayTabooScreenTwo extends State<PlayTabooScreenTwo>{

  String data = "After performing these steps, your project should compile successfully. If the issue persists, consider looking for any other plugins or modules that might have version conflicts, or consult the plugin's issue tracker for any related discussions.";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configureTts();
    startSpeaking();
  }

  startSpeaking(){
    Future.delayed(Duration(seconds: 2), () {
       speakText("Welcome to this Page $data");
    });
  }


  FlutterTts flutterTts = FlutterTts();

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  void speakText(String text) async {
    print('Speak text called');
    await flutterTts.speak(text);
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopSpeaking();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
       appBar: backCustomAppBar(
           backButtonshow: true,
           centerTile: false,
           onPressed: (){
             Navigator.pop(context);
           },
           title: "Taboo1"
       ),
       body: SingleChildScrollView(
         child: Column(
           children: [
             SizedBox(
               height: 10,
             ),
             EquiDistantRow(playstatus: true,feedbackstatus: false,practicestatus: false),
             const SizedBox(
               height: 10,
             ),
             const Divider(
               height: 1,
               color: Color(0xffc1c1c1),
             ),
             SizedBox(
               height: 25.0,
             ),
             InkWell(
               onTap: (){

               },
               child: Image(image: AssetImage(ImageConstant.girlsImage)),
             ),
             SizedBox(
               height: 15,
             ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child:  Row(
                children: [
                  Expanded(
                    child: Text(data),
                  )
                ],
              ),
            )
           ],
         ),
       ),
     );
  }

}






