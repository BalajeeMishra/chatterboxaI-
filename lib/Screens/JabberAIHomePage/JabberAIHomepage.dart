import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Screens/expired_screen.dart';
import 'package:balajiicode/Utils/app_common.dart';
import 'package:balajiicode/Screens/ChooseWordScreen/ChooseWords.dart';
import 'package:balajiicode/extensions/app_text_field.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../Utils/app_colors.dart';
import '../../ViewModel/JabberHomeAIvm.dart';
import '../../Widget/text_widget.dart';
import '../../components/double_back_to_close_app.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/text_styles.dart';
import '../../main.dart';
import '../../network/rest_api.dart';

class JabberAIHomepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JabberAIHomepage();
}

class _JabberAIHomepage extends State<JabberAIHomepage> {
  bool isStatus = false;
  List<Map<String, dynamic>> datalist = [
    {
      "title": "Taboo",
      "subtitle":
          "Make AI guess same word multiple times using different hints",
      "image": ImageConstant.tabooimage
    },
    {
      "title": "Who wants to be a Shakespeare",
      "subtitle":
          "9 Levels. Win each level by using a flashed word in an appropriate setence",
      "image": ImageConstant.shakespere
    },
    {
      "title": "Co-script a story",
      "subtitle":
          "Two charaters experience something spooky. Help AI complete the plot",
      "image": ImageConstant.scripstory
    },
    {
      "title": "Roleplays",
      "subtitle": "Practice real life conversation",
      "image": ImageConstant.roleplay
    },
    {
      "title": "Guess the word",
      "subtitle": "You guess a word by asking AI questions",
      "image": ImageConstant.guessworld
    },
    {
      "title": "Debate challenge",
      "subtitle": "You vs AI.One winner",
      "image": ImageConstant.debatechallenge
    },
  ];
  @override
  void initState() {
    super.initState();
    checkStatus();
    appStore.setLoading(false);
    Provider.of<JabberHomeAIvm>(context, listen: false).seInitialValue();
    Provider.of<JabberHomeAIvm>(context, listen: false).homepageAPI(context);
  }

  Future<void> checkStatus() async {
    Map<String, dynamic> req = {
      'playingstatus': true,
    };
    await statusCheckApi(req, userId: userStore.userId).then((value) async {
      isStatus = value.updateduser!.playingstatus!;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff755be8),
                primaryColor,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        center: true,
        showBack: false,
        color: primaryColor,
        '',
        context: context,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image(image: AssetImage(ImageConstant.micImage)),
            // SizedBox(
            //   width: 5.0,
            // ),
            Text(
              "Jabber AI",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            )
          ],
        ).center(),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          elevation: 4,
          backgroundColor: secondaryColor,
          content: Text('Tap back again to leave',
              style: primaryTextStyle(color: Colors.white)),
        ),
        child: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              await Provider.of<JabberHomeAIvm>(context, listen: false)
                  .seInitialValue();
              await Provider.of<JabberHomeAIvm>(context, listen: false)
                  .homepageAPI(context);
            },
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Consumer<JabberHomeAIvm>(
                    builder: (context, vm, child) {
                      return vm.apiHitStatus
                          ? vm.homePageModel.allGame == null
                              ? Center(
                                  child: MyText(
                                    text: 'No Game Found',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: vm.homePageModel.allGame!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = vm.homePageModel.allGame![index];
                                    Color containerColor = (index % 2 == 0)
                                        ? Color(0xffd3e2f5)
                                        : Color(0xffe4d7f1);

                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (isStatus == false) {
                                                  ExpiredScreen()
                                                      .launch(context);
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChooseWordScreen(
                                                                  data.sId!)));
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: containerColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${data.gameName}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "${data.description}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            height: 100,
                                                            width: 100,
                                                            child: cachedImage(
                                                                data.gameIcon)

                                                            // WebViewWidget(
                                                            //     controller: WebViewHelper.getWebView(
                                                            //         url: data.gameIcon!,
                                                            //         onPageFinished: (url) {})
                                                            //
                                                            // ),
                                                            )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 15.0,
                                            )
                                          ],
                                        ));
                                  })
                          : SizedBox();
                    },
                  ),
                ),
                Observer(
                  builder: (context) {
                    // Show the custom Loader based on appStore.isLoading
                    return Loader().center().visible(appStore.isLoading);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
