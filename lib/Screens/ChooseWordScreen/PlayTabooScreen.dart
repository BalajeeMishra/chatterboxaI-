
import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


import '../../Widget/appbar.dart';
import 'PlayTabooScreenTwo.dart';

class PlayTabooScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();

}

class _PlayTabooScreen extends State<PlayTabooScreen>{
  bool startListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';


  @override
  void initState() {
    super.initState();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if(_speechEnabled){
      setState(() {
        startListening = true;
      });
      _startListening();
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        localeId: 'en_US', // e.g., 'en_US'
        onResult: _onSpeechResult
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backCustomAppBar(
          backButtonshow: true,
          centerTile: false,
          onPressed: (){
            //Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayTabooScreenTwo()));
          },
          title: "Taboo"
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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
                          Image(image: AssetImage(ImageConstant.girlsImage)),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: "Your Word:",
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),


                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: '\"Elevator"',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: "Taboo Words:",
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),


                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: 'lift,floor,building,up,down',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: "Go ahead and give your clue!",
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),


                                  ],
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: _lastWords,
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),


                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   Center(
                   child: startListening?
                   listeningWidget():
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Column(
                         children: [
                           Image(image: AssetImage(ImageConstant.chatIcon)),
                           MyText(text: "Write",fontSize: 12,)
                         ],
                       ),
                       SizedBox(
                         width: 40,
                       ),
                       InkWell(
                         onTap: (){
                           _initSpeech();
                         },
                         child: Column(
                           children: [
                             Image(image: AssetImage(ImageConstant.microphoneIcon)),
                             MyText(text: "Speak",fontSize: 12,)
                           ],
                         ),
                       )
                     ],
                   ),
                 )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }


  listeningWidget(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: (){
              _stopListening();
              setState(() {
                startListening = false;
              });
            },
            child: Image(image: AssetImage(ImageConstant.IconCancel)),
          ),
          Image(image: AssetImage(ImageConstant.pitch1)),
          Image(image: AssetImage(ImageConstant.pitch2)),
          Image(image: AssetImage(ImageConstant.pitch3)),
           InkWell(
             onTap: (){
               _stopListening();
                 setState(() {
                   startListening = false;
                 });
             },
             child:  Image(image: AssetImage(ImageConstant.doneButton)),
           )

        ],
      ),
    );
  }

}

