import 'dart:ui';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Constants/constantRow.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../ViewModel/TabooGameChatPageVM.dart';
import '../../Widget/appbar.dart';
import '../../main.dart';

class TaboogamechatPage extends StatefulWidget {
  final AllGameModel allGameModel;
  final int index;
  final String sessionId;

  TaboogamechatPage(this.allGameModel, this.index, this.sessionId);

  @override
  State<StatefulWidget> createState() => _TaboogamechatPage();
}

class _TaboogamechatPage extends State<TaboogamechatPage> {
  late ScrollController _scrollController;
  int _previousMessageCount = 0;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Provider.of<TabooGameChatPageVM>(context, listen: false).dynamicData.clear();

    Provider.of<TabooGameChatPageVM>(context, listen: false)
        .setInitialValue(widget.allGameModel, widget.index);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottomIfNeeded(int messageCount) {
    if (messageCount > _previousMessageCount) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    _previousMessageCount = messageCount;
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
        title: "Taboo",
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              EquiDistantRow(
                playstatus: true,
                feedbackstatus: false,
                practicestatus: false,
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 1,
                color: Color(0xffc1c1c1),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      if (isFirst)
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 50),
                          child: Consumer<TabooGameChatPageVM>(
                            builder: (context, vm, child) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: primaryColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 10.0,
                                        ),
                                        child: Column(

                                          children: [
                                            Row(
                                              children: [
                                                MyText(
                                                  text: "${vm.initialdata.keys.first}:",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                                SizedBox(width: 2),
                                                Expanded(
                                                  child: MyText(
                                                    text: "${vm.initialdata.values.first}",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,

                                              children: [
                                                MyText(
                                                  text: "${vm.initialdata.keys.last}:",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                                SizedBox(width: 2),
                                                Flexible(
                                                  child: Text(
                                                    "${vm.initialdata.values.last}"
                                                        .replaceAll('\u200b', ""),
                                                    style: primaryTextStyle(
                                                      weight: FontWeight.w400,
                                                      size: 15,
                                                    ),
                                                    maxLines: null,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Consumer<TabooGameChatPageVM>(
                          builder: (context, vm, child) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToBottomIfNeeded(vm.dynamicData.length);
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: vm.dynamicData.length,
                              itemBuilder: (context, index) {
                                var data = vm.dynamicData[index];
                                return data['server'] == 0
                                    ? Align(
                                  alignment: Alignment.centerRight,
                                  child: _buildMessageBubble(data['data'], true),
                                )
                                    : Align(
                                  alignment: Alignment.centerLeft,
                                  child: _buildMessageBubble(data['data'].toString(), false),
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
              _buildMessageInput(context),
            ],
          ),
          Positioned(
            bottom: 30,
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
    );
  }

  Widget _buildMessageBubble(String message, bool isUserMessage) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isUserMessage ? Color(0xffd3e2f5) : Colors.transparent,
            border: isUserMessage
                ? null
                : Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyText(
            text: message,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Consumer<TabooGameChatPageVM>(
              builder: (context, vm, child) {
                return TextField(
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
              FocusScope.of(context).unfocus();
              var chatPageVM = Provider.of<TabooGameChatPageVM>(context, listen: false);
              String messageText = chatPageVM.controller.text.trim();

              if (isFirst) {
                chatPageVM.dynamicData.insert(0, {
                  'data': "${chatPageVM.initialdata.keys.first}: ${chatPageVM.initialdata.values.first}",
                  'server': 1,
                });
                chatPageVM.dynamicData.insert(1, {
                  'data': "${chatPageVM.initialdata.keys.last}: ${chatPageVM.initialdata.values.last}",
                  'server': 1,
                });

                chatPageVM.chatPageAPI(context, widget.sessionId, messageText);
                isFirst = false;
              } else {
                chatPageVM.chatPageAPI(context, widget.sessionId, messageText);
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