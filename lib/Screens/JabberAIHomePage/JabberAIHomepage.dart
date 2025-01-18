import 'package:balajiicode/Utils/app_common.dart';
import 'package:balajiicode/Screens/ChooseWordScreen/ChooseWords.dart';
import 'package:balajiicode/Utils/app_constants.dart';
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
import '../../extensions/shared_pref.dart';
import '../../extensions/text_styles.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../Account/account_screen.dart';

class JabberAIHomepage extends StatefulWidget {
  const JabberAIHomepage({super.key});

  @override
  State<StatefulWidget> createState() => _JabberAIHomepage();
}

class _JabberAIHomepage extends State<JabberAIHomepage> {
  bool isStatus = false;

  @override
  void initState() {
    super.initState();
    checkStatus();
    appStore.setLoading(false);
    Provider.of<JabberHomeAIvm>(context, listen: false).seInitialValue();
    Provider.of<JabberHomeAIvm>(context, listen: false).homepageAPI(context);
  }

  Future<void> checkStatus() async {
    await statusCheckApi(userId: getStringAsync(USER_ID)).then((value) async {
      isStatus = value.playingstatus!;
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
        actions: [
          IconButton(
              onPressed: () {
                AccountScreen().launch(context);
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ))
        ],
        '',
        context: context,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Zap AI",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ).paddingLeft(48)
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
                                              onTap: () async {
                                                // if (isStatus == false) {
                                                //   ExpiredScreen()
                                                //       .launch(context);
                                                // } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChooseWordScreen(
                                                                data.sId!,
                                                                data.gameName!)));

                                                analytics.logEvent(
                                                  name: 'game_selection',
                                                  parameters: {
                                                    'Game_name': data.gameName!,
                                                    'User_id':
                                                        getStringAsync(USER_ID),
                                                    'days_since_install':
                                                        await InstallDateHelper
                                                            .getDaysSinceInstall()
                                                  },
                                                ).then((_) {
                                                  print(
                                                      'Logged event: game_selection with parameters: Game_name=${data.gameName!}, User_id=${getStringAsync(USER_ID)}');
                                                }).catchError((error) {
                                                  print(
                                                      'Failed to log event: $error');
                                                });
                                                facebookAppEvents.logEvent(
                                                  name: 'game_selection',
                                                  parameters: {
                                                    'Game_name': data.gameName!,
                                                    'User_id':
                                                        getStringAsync(USER_ID),
                                                    'days_since_install':
                                                        await InstallDateHelper
                                                            .getDaysSinceInstall()
                                                  },
                                                ).then((_) {
                                                  print(
                                                      'Logged Facebook event: game_selection with parameters: Game_name=${data.gameName!}, User_id=${getStringAsync(USER_ID)}');
                                                }).catchError((error) {
                                                  print(
                                                      'Failed to log event: $error');
                                                });

                                                // }
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
                                                        SizedBox(
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
