import 'package:balajiicode/providers/providers.dart';
import 'package:balajiicode/store/UserStore/UserStore.dart';
import 'package:balajiicode/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/JabberAIHomePage/JabberAIHomepage.dart';
import 'Screens/TabooGameChatpage/TaboogamechatPage.dart';
import 'Screens/splash_screen.dart';
import 'Utils/app_config.dart';

AppStore appStore = AppStore();
UserStore userStore = UserStore();
late SharedPreferences sharedPreferences;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xff755be8)));
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch SharedPreferences instance before running the app
  sharedPreferences = await SharedPreferences.getInstance();

  // sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key); // To retrieve a String
  }

  @override
  Widget build(BuildContext context) {
    String? userToken = sharedPreferences.getString('accessToken');
    print("balajee mishra");
    print(userToken);
    return MultiProvider(
      providers: appProvider,
      child: MaterialApp(
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        home:  userToken == null ? const SplashScreen() : JabberAIHomepage(),
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
