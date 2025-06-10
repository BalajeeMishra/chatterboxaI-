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
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserMessageScrollController();

  }
  void setUserMessageScrollController() {
    final provider = Provider.of<AnswerAssistProvider>(context, listen: false);
    provider.correctedUserMessageController.addListener(() {
      // Scroll to bottom when text changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }
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
                      Stack(
                        children: [
                          Image.asset(circle,width: 25,),
                          Center(child: Image.asset(chatTypingGit,width: 24,)),
                        ],
                      )
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      if(provider.state == AnswerAssistState.encouraging) GestureDetector(
                        onTap: (){
                          provider.setActive();
                          provider.setIsAlreadyResponded(true);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(tilt, width: 30),
                            0.width,
                            textGradient(
                                "You're Doing Good! Try Saying It Out Loud"),
                            0.width,
                            Stack(
                              children: [
                                Image.asset(circle,width: 25,),
                                Center(child: Image.asset(chatTypingGit,width: 25,)),
                              ],
                            )
                          ],
                        ),
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
                      Scrollbar(
                        thumbVisibility: true,
                        child: TextField(
                          controller: provider.correctedUserMessageController,
                          scrollController: scrollController,
                          readOnly: true,
                          maxLines: 3, // allow unlimited growth
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontFamily: "inter", fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Spoken words here...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ).withGradient(),
                      ),


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
            if(pro.isAlreadyResponded){
              pro.setEncouraging();
            }else{
              pro.clearCorrectedUserMessageController();
              pro.setCompleting();
              bool res =  await  pro.completeUserMessage(context,widget.userMessage,widget.sessionId,widget.gameModel,widget.index,widget.modality);
              if(res){
                // var provider = Provider.of<PlayTabooScreenProvider>(context,listen: false);
                // provider.setIsOnLockedAndRestartListening(false);
                // provider.setpreviousSpokenTextWhenStateIsLocked('');
              }
            }
          }
          else if(pro.state == AnswerAssistState.encouraging){
            pro.setActive();
            pro.setIsAlreadyResponded(true);
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

