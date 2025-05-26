import 'dart:ui';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_common.dart';
import '../../ViewModel/TabooGameChatPageVM.dart';
import '../../Widget/appbar.dart';
import '../../Widget/text_gradient.dart';
import '../../extensions/common.dart';
import '../../main.dart';
import '../../network/rest_api.dart';

class TaboogamechatPage extends StatefulWidget {
  final AllGameModel allGameModel;
  final int index;
  final String sessionId;
  String gameName;

  TaboogamechatPage(
      this.allGameModel, this.index, this.sessionId, this.gameName,
      {super.key});

  @override
  State<StatefulWidget> createState() => _TaboogamechatPage();
}

class _TaboogamechatPage extends State<TaboogamechatPage>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  int _previousMessageCount = 0;
  bool isFirst = true;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController = ScrollController();
    Provider.of<TabooGameChatPageVM>(context, listen: false)
        .dynamicData
        .clear();

    allConversationApiCall();
  }

  void allConversationApiCall() async {
    await allConversationApi(widget.sessionId).then((value) async {
      if (widget.index == null) {
        return;
      }
      if (value.completeConversation != null) {
        List<Map<String, dynamic>> combinedMessages = [];

        List<String> userResponses =
            value.completeConversation!.userResponse ?? [];
        List<String> aiResponses = value.completeConversation!.aiResponse ?? [];

        int maxLength = userResponses.length > aiResponses.length
            ? userResponses.length
            : aiResponses.length;
        for (int i = 0; i < maxLength; i++) {
          if (i < userResponses.length) {
            String userReply = userResponses[i];
            String userLastWord = userReply.split('Reply is').last.trim();
            combinedMessages.add({'data': userLastWord, 'server': 0});
          }

          if (i < aiResponses.length) {
            String aiReply = aiResponses[i];
            combinedMessages.add({'data': aiReply, 'server': 1});
          }
        }
        if (combinedMessages.isNotEmpty) {
          isFirst = false;
          setState(() {});
        }

        Provider.of<TabooGameChatPageVM>(context, listen: false)
            .updateTransactionData(
                combinedMessages, widget.allGameModel, widget.index);
      } else {}
    }).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString());
      setState(() {});
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _textController.dispose();
    // _focusNode.dispose();

    super.dispose();
  }

  void _scrollToBottomIfNeeded(int messageCount) {
    if (messageCount > _previousMessageCount) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          // Schedule the scroll after the keyboard is closed
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration(milliseconds: 200), () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          });
        }
      });
    }
    _previousMessageCount = messageCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          leading:  InkWell(onTap:()=>pop(),child: Icon(Icons.arrow_back).withGradient()),

          title: Text(
            softWrap: true,
            "Chat History",
            style: const TextStyle(),

          ).withGradient(),

        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:16,right:16,bottom:10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Expanded(
                          child:
                          Consumer<TabooGameChatPageVM>(
                            builder: (context, vm, child) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollToBottomIfNeeded(vm.dynamicData.length);
                              });

                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: vm.dynamicData.length,
                                itemBuilder: (context, index) {
                                  var data = vm.dynamicData[index];
                                  return data['server'] != 0
                                      ? Align(
                                          alignment: Alignment.centerRight,
                                          child: _buildMessageBubble(
                                              data['data'], true),
                                        )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: _buildMessageBubble(
                                              data['data'].toString(), false),
                                        );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // _buildMessageInput(context),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 220,
              child: Observer(
                builder: (context) {
                  return Lottie.asset(
                    'assets/lottiefile/loader.json',
                    height: 180,
                    fit: BoxFit.contain,
                  ).center().visible(appStore.isLoading);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isUserMessage) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Container(
          padding: EdgeInsets.only(left: isUserMessage?20.0:0,right: 20, bottom: 24.0,top:10),
          decoration: BoxDecoration(
            color: isUserMessage ? Color(0xff2496DF) : Colors.transparent,

            borderRadius: BorderRadius.circular(10),
          ),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: _buildBoldText(message),
              style: TextStyle(
                height: 20/16,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                fontFamily: "inter",
                color: isUserMessage ? Colors.white : Colors.black,
              ),
            ),
          )
          // ;MyText(
          //   text: message,
          //   fontWeight: FontWeight.w400,
          //   fontSize: 15,
          // ),
          ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Consumer<TabooGameChatPageVM>(
              builder: (context, vm, child) {
                return TextField(
                  onTap: _scrollToBottom,
                  // focusNode: _focusNode,
                  controller: vm.controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Enter Your Answer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple.shade300),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              var chatPageVM =
                  Provider.of<TabooGameChatPageVM>(context, listen: false);
              String messageText = chatPageVM.controller.text.trim();

              if (isFirst) {
                chatPageVM.dynamicData.insert(0, {
                  'data':
                      "${chatPageVM.initialdata.keys.first}: ${chatPageVM.initialdata.values.first}",
                  'server': 1,
                });
                chatPageVM.dynamicData.insert(1, {
                  'data':
                      "${chatPageVM.initialdata.keys.last}: ${chatPageVM.initialdata.values.last}",
                  'server': 1,
                });

                chatPageVM.chatPageAPI(context, widget.sessionId, messageText,
                    widget.allGameModel, widget.index, 'write',widget.gameName,isFirst);
                isFirst = false;
                setState(() {});
              } else {
                chatPageVM.chatPageAPI(context, widget.sessionId, messageText,
                    widget.allGameModel, widget.index, 'write',widget.gameName,isFirst);
              }
              chatPageVM.controller.clear();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

List<TextSpan> _buildBoldText(String response) {
  List<String> parts = response.split("**");
  List<TextSpan> textSpans = [];
  for (int i = 0; i < parts.length; i++) {
    if (i % 2 == 0) {
      textSpans.add(TextSpan(text: parts[i]));
    } else {
      textSpans.add(TextSpan(
        text: parts[i],
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    }
  }
  return textSpans;
}

