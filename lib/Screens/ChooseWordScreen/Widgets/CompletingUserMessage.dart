import 'package:balajiicode/Model/AllGameModel.dart';
import 'package:balajiicode/Screens/ChooseWordScreen/Providers/PlayTabooScreenProvider.dart';
import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/Widget/text_gradient.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../Widget/text_gradient.dart';
import '../../../Widget/text_widget.dart';
import '../Providers/completeMessageProvider.dart';

class CompletingUserMessage extends StatefulWidget {
  final String  userMessage;
  final String sessionId;
  final AllGameModel gameModel;
  final int index;
  final String modality;
  const CompletingUserMessage({super.key, required this.userMessage, required this.sessionId, required this.gameModel, required this.index, required this.modality});

  @override
  State<CompletingUserMessage> createState() => _CompletingUserMessageState();
}

class _CompletingUserMessageState extends State<CompletingUserMessage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Container(
          child: Consumer<AnswerAssistProvider>(
            builder: (context, provider, _) {
                if(provider.state == AnswerAssistState.idle) {
                  return Opacity(opacity:.4,child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      textGradient('Complete My Answer'),
                      8.width,
                      Image.asset(chatTyping, width: 20, height: 20)
                    ],
                  ));
                }
                if(provider.state == AnswerAssistState.active) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedActivationMask(child: textGradient('Complete My Answer')),
                      8.width,
                      Image.asset(chatTyping, width: 20, height: 20)
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      if(provider.state == AnswerAssistState.encouraging) Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(tilt, width: 20),
                          3.width,
                          textGradient(
                              "You're Doing Good! Try Saying It Out Loud"),
                          3.width,
                          Image.asset(chatTyping, width: 20,)
                        ],
                      ),
                      if(provider.state == AnswerAssistState.completing)Row(
                          mainAxisAlignment: MainAxisAlignment.end, children: [
                        textGradient('Completing Answer...'),
                        8.width,
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ).withGradient(),
                        )
                      ]),
                      10.height,
                      TextField(
                        readOnly: true,
                        controller: provider.correctedUserMessageController,
                        onChanged: (val) {
                          // _stopListening();
                        },
                        onTap: () {
                          // _stopListening();
                        },
                        maxLines: 3,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(fontFamily: "inter", fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Spoken words here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ).withGradient()
                    ],
                  );
                }
            }
          ),
        );
      }
    );
  }

  Widget textGradient(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () async{
          final pro = Provider.of<AnswerAssistProvider>(context, listen: false);
          if(pro.state == AnswerAssistState.idle){

          }
          else if(pro.state == AnswerAssistState.active){
            pro.clearCorrectedUserMessageController();
            pro.setCompleting();
          bool res =  await  pro.completeUserMessage(context,widget.userMessage,widget.sessionId,widget.gameModel,widget.index,widget.modality);
          if(res){
            // var provider = Provider.of<PlayTabooScreenProvider>(context,listen: false);
            // provider.setIsOnLockedAndRestartListening(false);
            // provider.setpreviousSpokenTextWhenStateIsLocked('');
            }
          }
          else if(pro.state == AnswerAssistState.encouraging){

          }else{
            // AnswerAssistState.encouraging
          }
        },
          child: MyText(
            text: text,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ).withGradient(),

    );
  }
}

