import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Utils/ShowSnackBar.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text_ultra/speech_to_text_ultra.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_images.dart';
import '../../ViewModel/PlayTabooScreenVM.dart';
import '../../Widget/appbar.dart';
import '../../components/loader_widget_new.dart';
import '../../main.dart';
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
  bool isLoading = false;
  bool receivedValue = false;

  @override
  void initState() {
    super.initState();
    appStore.setLoading(false);
    startListening = false;

    // _initSpeech(); // Initialize speech recognition in initState
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      setState(() {
        startListening = true;
      });
      _startListening();
    }else{
      startListening = false;

    }
  }

  void _startListening() async {
    await _speechToText.listen(
      localeId: 'en_US',
      onResult: _onSpeechResult,
    );
  }

  void _stopListening() async {
    await _speechToText.stop();

    if (mounted) {
      setState(() {
        startListening = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;

      if (_lastWords.isNotEmpty) {
        ques = _lastWords;
        sessionId = Uuid().v4();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayTabooScreenTwo(
              widget.allGameModel,
              widget.index,
              ques,
              sessionId,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  void _navigateToSecondScreen() async {
    // setState(() {
    //   isLoading = true; // Start loading
    // });

    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingWidget(message: "Thinking about your response..."),
      ),
    );

    await Future.delayed(Duration(seconds: 2));



    final bool? res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayTabooScreenTwo(
            widget.allGameModel,
            widget.index,
            ques,
            sessionId,
          ),
        ));



    if (res == true) {
      setState(() {
        startListening = false;
        print("Result is ==> $res");
      });
    } else {
      print("No result returned from PlayTabooScreenTwo.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                              height: 16.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: Image.asset(
                                  fit: BoxFit.cover,
                                  height: 195,
                                  width: 246,
                                  ic_transparent_girlImage2),
                            ),
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
                          GestureDetector(
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
                                Icon(
                                  Icons.chat,
                                  size: 36,
                                ),
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
                          GestureDetector(
                            onTap: () {
                              _initSpeech();
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.keyboard_voice,
                                  size: 36,
                                ),
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _stopListening();
                setState(() {
                  _lastWords = "";
                  startListening = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  size: 24,
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ).paddingTop(50),
            SizedBox(width: 10),

            Expanded(
              child: startListening
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottiefile/recordaudio.json',
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          // Lottie.asset(
                          //   'assets/lottiefile/recordaudio.json',
                          //   height: 60,
                          //   fit: BoxFit.contain,
                          // ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(ImageConstant.pitch1),
                          height: 50,
                        ),
                        SizedBox(width: 5),
                        Image(
                          image: AssetImage(ImageConstant.pitch2),
                          height: 50,
                        ),
                        SizedBox(width: 5),
                        Image(
                          image: AssetImage(ImageConstant.pitch3),
                          height: 50,
                        ),
                      ],
                    ),
            ),
            SizedBox(width: 10),

            GestureDetector(
              onTap: () {
                _stopListening();

                ques = _lastWords;
                setState(() {
                  _lastWords = "";
                });
                if (ques.isNotEmpty) {
                  sessionId = Uuid().v4();

                  _navigateToSecondScreen();
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  size: 24,
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ).paddingTop(46),
          ],
        ).paddingSymmetric(horizontal: 30),
      ),
    );
  }
}
