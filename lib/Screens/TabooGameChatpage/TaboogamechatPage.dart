import 'dart:ui';
import 'package:balajiicode/Screens/ChooseWordScreen/ChooseWords.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Constants/ImageConstant.dart';
import '../../Constants/constantRow.dart';
import '../../Model/AllGameModel.dart';
import '../../Utils/app_colors.dart';
import '../../ViewModel/TabooGameChatPageVM.dart';
import '../../Widget/appbar.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';

class TaboogamechatPage extends StatefulWidget {
  AllGameModel allGameModel;
  int index;
  String sessionId;
  TaboogamechatPage(this.allGameModel, this.index, this.sessionId);

  @override
  State<StatefulWidget> createState() => _TaboogamechatPage();
}

class _TaboogamechatPage extends State<TaboogamechatPage> {
  String sessionId = "";
  late ScrollController _scrollController;
  int _previousMessageCount = 0; // Track the previous message count

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Provider.of<TabooGameChatPageVM>(context, listen: false)
        .seInitialValue(widget.allGameModel, widget.index);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottomIfNeeded(int messageCount) {
    if (messageCount > _previousMessageCount) {
      // Scroll only if new messages are added
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
                                      // color: Color(0xffd3e2f5),
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
                                                text:
                                                    "${vm.initialdata.keys.first}:",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  text:
                                                      "${vm.initialdata.values.first}",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text:
                                                    "${vm.initialdata.keys.last}:",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  "${vm.initialdata.values.last}"
                                                      .replaceAll('\u200b', ""),
                                                  softWrap: true,
                                                  style: primaryTextStyle(
                                                    weight: FontWeight.w400,
                                                    size: 15,
                                                  ),
                                                  maxLines: null,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ).expand(),
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

                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Consumer<TabooGameChatPageVM>(
                          builder: (context, vm, child) {
                            // Update scroll when new messages are added
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToBottomIfNeeded(vm.dynamicDta.length);
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: vm.dynamicDta.length,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = vm.dynamicDta[index];
                                return data['server'] == 0
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 50, right: 5, top: 10),
                                        child: Align(
                                          alignment: Alignment
                                              .centerRight, // Align to right for user's messages
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7, // Limit width to 70% of screen
                                            ),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xffd3e2f5),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 10.0,
                                                ),
                                                child: MyText(
                                                  text: "${data['data']}",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, right: 50.0, top: 10),
                                        child: Align(
                                          alignment: Alignment
                                              .centerLeft, // Align to left for server messages
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7, // Limit width to 70% of screen
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                  width: 2,
                                                  color: primaryColor,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 10.0,
                                                ),
                                                child: MyText(
                                                  text: "${data['data']}",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            );
                          },
                        ),
                      ),
                      // Your other widgets can go here as needed.
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10.0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Consumer<TabooGameChatPageVM>(
                          builder: (context, vm, child) {
                            return TextField(
                              controller: vm.controller,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Enter Your Answer",
                                hintStyle:
                                    secondaryTextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade300),
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
                          Provider.of<TabooGameChatPageVM>(context,
                                  listen: false)
                              .chatPageAPI(context, widget.sessionId);
                          Provider.of<TabooGameChatPageVM>(context,
                                  listen: false)
                              .controller
                              .clear();
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
                      ),
                    ],
                  ),
                ),
              )
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
}
