import 'dart:async';

import 'package:balajiicode/Screens/expired_screen.dart';
import 'package:balajiicode/Screens/login_screen.dart';
import 'package:balajiicode/providers/providers.dart';
import 'package:balajiicode/store/UserStore/UserStore.dart';
import 'package:balajiicode/store/app_store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/JabberAIHomePage/JabberAIHomepage.dart';
import 'Screens/no_internet_screen.dart';
import 'Screens/splash_screen.dart';
import 'Utils/app_common.dart';
import 'Utils/app_config.dart';
import 'Utils/app_constants.dart';
import 'extensions/common.dart';
import 'extensions/shared_pref.dart';
import 'extensions/system_utils.dart';

AppStore appStore = AppStore();
UserStore userStore = UserStore();
late SharedPreferences sharedPreferences;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xff755be8)));
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  setLogInValue();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static String tag = '/MyApp';

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isCurrentlyOnNoInternet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) {
      if (e.contains(ConnectivityResult.none)) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast('Internet is connected');
        }
        log('connected');
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProvider,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        home: getStringAsync(TOKEN).toString().isEmpty
            ?  SplashScreen()
            : JabberAIHomepage(),
        // home:SplashScreen(),
        // home:ExpiredScreen(),
        scrollBehavior: SBehavior(),
        builder: EasyLoading.init(),
      ),
    );
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.orange
      ..backgroundColor = Colors.grey[100]
      ..indicatorColor = Colors.blueAccent
      ..textColor = Colors.grey
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }
}

// class MyApp extends StatelessWidget {
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   bool isCurrentlyOnNoInternet = false;
//    MyApp({super.key});
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   void init() async {
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
//       if (e.contains(ConnectivityResult.none)) {
//         log('not connected');
//         isCurrentlyOnNoInternet = true;
//         push(NoInternetScreen());
//       } else {
//         if (isCurrentlyOnNoInternet) {
//           pop();
//           isCurrentlyOnNoInternet = false;
//           toast('Internet is connected');
//         }
//         log('connected');
//       }
//     });
//   }
//
//
//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//     _connectivitySubscription.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       MultiProvider(
//       providers: appProvider,
//       child: MaterialApp(
//         title: APP_NAME,
//         debugShowCheckedModeBanner: false,
//         home: LoginScreen(),
//
//         // getStringAsync(TOKEN).toString().isEmpty
//         //     ? const SplashScreen()
//         //     : JabberAIHomepage(),
//         builder: EasyLoading.init(),
//       ),
//     );
//   }
//
//   void configLoading() {
//     EasyLoading.instance
//       ..displayDuration = const Duration(milliseconds: 2000)
//       ..indicatorType = EasyLoadingIndicatorType.ring
//       ..loadingStyle = EasyLoadingStyle.custom
//       ..indicatorSize = 45.0
//       ..radius = 10.0
//       ..progressColor = Colors.orange
//       ..backgroundColor = Colors.grey[100]
//       ..indicatorColor = Colors.blueAccent
//       ..textColor = Colors.grey
//       ..maskColor = Colors.blue.withOpacity(0.5)
//       ..userInteractions = false
//       ..dismissOnTap = false;
//     // ..customAnimation = CustomAnimation();
//   }
// }
