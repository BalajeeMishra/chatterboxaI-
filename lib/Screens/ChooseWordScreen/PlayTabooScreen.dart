import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Utils/ShowSnackBar.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text_ultra/speech_to_text_ultra.dart';
import '../../Model/AllGameModel.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../Widget/appbar.dart';
import '../TabooGameChatpage/TaboogamechatPage.dart';
import 'PlayTabooScreenTwo.dart';
import 'package:uuid/uuid.dart';

class PlayTabooScreen extends StatefulWidget {
  AllGameModel allGameModel;
  int index;

  PlayTabooScreen(this.allGameModel, this.index);

  @override
  State<StatefulWidget> createState() => _PlayTabooScreen();
}

class _PlayTabooScreen extends State<PlayTabooScreen> {
  bool startListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String ques = "";
  String sessionId = "";

  @override
  void initState() {
    super.initState();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      setState(() {
        startListening = true;
      });
      _startListening();
    }
  }

  // Each time to start a speech recognition session
  void _startListening() async {
   await _speechToText.listen(
        localeId: 'en_US', // e.g., 'en_US'
        onResult: _onSpeechResult);
    // setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      startListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      print(result);
      print("hello");
      _lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backCustomAppBar(
          backButtonshow: true,
          centerTile: false,
          onPressed: () {
            Navigator.pop(context);
          },
          title: "Taboo"),
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
                        EquiDistantRow(
                            playstatus: true,
                            feedbackstatus: false,
                            practicestatus: false),
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
                                      text:
                                          '\"${widget.allGameModel.allGame![widget.index].mainContent}"',
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
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: ListView.builder(
                                    itemCount: widget
                                        .allGameModel
                                        .allGame![widget.index]
                                        .detailOfContent!
                                        .length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var data = widget
                                          .allGameModel
                                          .allGame![widget.index]
                                          .detailOfContent![index];
                                      return MyText(
                                        text: '${data},',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      );
                                    }),
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
                  child: startListening
                      ? listeningWidget()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                sessionId = Uuid().v4();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaboogamechatPage(
                                            widget.allGameModel,
                                            widget.index,
                                            sessionId)));
                              },
                              child: Column(
                                children: [
                                  Image(
                                      image:
                                          AssetImage(ImageConstant.chatIcon)),
                                  MyText(
                                    text: "Write",
                                    fontSize: 12,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            InkWell(
                              onTap: () {
                                _initSpeech();
                              },
                              child: Column(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          ImageConstant.microphoneIcon)),
                                  MyText(
                                    text: "Speak",
                                    fontSize: 12,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  listeningWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: InkWell(
              onTap: () {
                _stopListening();
                setState(() {
                  _lastWords = "";
                  startListening = false;
                });
              },
              child: Image(image: AssetImage(ImageConstant.IconCancel)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          startListening
              ? Expanded(
                  child: Lottie.asset('assets/lottiefile/recordaudio.json'),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Row(
                    children: [
                      Image(image: AssetImage(ImageConstant.pitch1)),
                      Image(image: AssetImage(ImageConstant.pitch2)),
                      Image(image: AssetImage(ImageConstant.pitch3)),
                    ],
                  ),
                ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: InkWell(
              onTap: () {
                _stopListening();

                ques = _lastWords;
                setState(() {
                  _lastWords = "";
                });
                if (ques.isNotEmpty) {
                  sessionId = Uuid().v4();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayTabooScreenTwo(
                              widget.allGameModel,
                              widget.index,
                              ques,
                              sessionId)));
                }
              },
              child: Image(image: AssetImage(ImageConstant.doneButton)),
            ),
          )
        ],
      ),
    );
  }
}
