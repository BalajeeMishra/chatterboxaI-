import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import '../extensions/extension_util/int_extensions.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/setting_item_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
// import '../models/language_data_model.dart';
// import '../models/progress_setting_model.dart';
// import '../models/reminder_model.dart';
// import '../models/user_response.dart';
// import '../network/rest_api.dart';
import '../network/rest_api.dart';
import 'app_config.dart';
import 'app_constants.dart';

class DiagonalPathClipperTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height - 50)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

Widget outlineIconButton(BuildContext context,
    {required String text, String? icon, Function()? onTap, Color? textColor}) {
  return OutlinedButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // if (icon != null) ImageIcon(AssetImage(icon), color: appStore.isDarkMode ? Colors.white : primaryColor, size: 24),
        if (icon != null) SizedBox(width: 8),
        Text(text, style: primaryTextStyle(color: textColor ?? null, size: 14)),
      ],
    ),
    onPressed: onTap ?? () {},
    style: OutlinedButton.styleFrom(
      // side: BorderSide(color: textColor ?? (appStore.isDarkMode ? Colors.white38 : primaryColor), style: BorderStyle.solid),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

Widget cachedImage(String? url,
    {double? height,
    Color? color,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool usePlaceholderIfUrlEmpty = true,
    double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      progressIndicatorBuilder: (context, url, progress) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(ic_placeholder,
            height: height,
            width: width,
            fit: BoxFit.cover,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset(ic_placeholder,
          height: height,
          width: width,
          fit: BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

toast(String? value,
    {ToastGravity? gravity,
    length = Toast.LENGTH_SHORT,
    Color? bgColor,
    Color? textColor}) {
  Fluttertoast.showToast(
    msg: value.validate(),
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}
toastLeft(String? value,
    {ToastGravity? gravity,
      length = Toast.LENGTH_SHORT,
      Color? bgColor,
      Color? textColor}) {
  Fluttertoast.showToast(
    msg: value.validate(),
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
    webPosition: "left",
  );
}

setLogInValue() {
  userStore.setLogin(getBoolAsync(IS_LOGIN));
  if (userStore.isLoggedIn) {
    userStore.setToken(getStringAsync(TOKEN));
    userStore.setUserID(getStringAsync(USER_ID));
    userStore.setUserNativeLanguage(getStringAsync(USER_NATIVE_LANGUAGE));




  }
}

// String parseHtmlString(String? htmlString) {
//   return parse(parse(htmlString).body!.text).documentElement!.text;
// }

// String parseDocumentDate(DateTime dateTime, [bool includeTime = false]) {
//   if (includeTime) {
//     return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
//   } else {
//     return DateFormat('dd MMM, yyyy').format(dateTime);
//   }
// }

Duration parseDuration(String durationString) {
  List<String> components = durationString.split(':');

  int hours = int.parse(components[0]);
  int minutes = int.parse(components[1]);
  int seconds = int.parse(components[2]);

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

progressDateStringWidget(String date) {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime dateTime = DateTime.parse(date);
  var dateValue = dateFormat.format(dateTime);
  return dateValue;
}

Future<void> launchUrls(String url, {bool forceWebView = false}) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
      .catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

Widget mBlackEffect(double? width, double? height, {double? radiusValue = 16}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: radius(radiusValue),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.2),
          Colors.black.withOpacity(0.2),
          Colors.black.withOpacity(0.4),
          Colors.black.withOpacity(0.4),
        ],
      ),
    ),
    alignment: Alignment.bottomLeft,
  );
}

Widget mOption(String img, String title, Function? onCall) {
  return SettingItemWidget(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    title: title,
    leading:
        Image.asset(img, width: 20, height: 20, color: textPrimaryColorGlobal),
    // trailing: appStore.selectedLanguageCode == 'ar' ? Icon(Icons.chevron_left, color: grayColor) : Icon(Icons.chevron_right, color: grayColor),
    onTap: () async {
      onCall!.call();
    },
  );
}

Widget mSuffixTextFieldIconWidget(String? img) {
  return Image.asset(img.validate(), height: 20, width: 20, color: Colors.grey)
      .paddingAll(14);
}

String parseDocumentDate(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return "${difference.inSeconds} sec ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} min ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hrs ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}
String formatDateTime(DateTime dateTime) {
  DateTime localDateTime = dateTime.toLocal();

  return DateFormat('hh:mm a dd MMM yyyy').format(localDateTime);
}

String getGreetingMessage() {
  final DateTime now = DateTime.now();
  final int hour = now.hour;

  if (hour >= 5 && hour < 12) {
    return 'Good Morning ☀️';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon 🌞';
  } else
    return 'Good Evening 🌇';
}

String getDynamicDescription(String createdAt) {
  final createdDate = DateTime.parse(createdAt).toUtc().add(Duration(hours: 5, minutes: 30)); // Convert UTC to IST
  final today = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30)); // Current time in IST

  final todayDate = DateTime(today.year, today.month, today.day);
  final createdAtDate = DateTime(createdDate.year, createdDate.month, createdDate.day);

  final differenceInDays = todayDate.difference(createdAtDate).inDays;

  if (differenceInDays == 0) {
    return 'Today’s Prescription';
  } else if (differenceInDays == 1) {
    return 'Yesterday’s Prescription';
  } else {
    return '${createdDate.day} ${getMonthName(createdDate.month)} Prescription';
  }
}


String getDynamicHistoryDescription(String createdAt) {
  final createdDate = DateTime.parse(createdAt).toUtc();
  final today = DateTime.now().toUtc();

  final todayDate = DateTime(today.year, today.month, today.day);
  final createdAtDate = DateTime(createdDate.year, createdDate.month, createdDate.day);

  final differenceInDays = todayDate.difference(createdAtDate).inDays;

  if (differenceInDays == 0) {
    return 'Today';
  } else if (differenceInDays == 1) {
    return 'Yesterday';
  } else {
    return '${createdDate.day} ${getMonthName(createdDate.month)} ';
  }
}

String getMonthName(int month) {
  const monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[month];
}
String trimPhoneNumber(String fullNumber) {
  // Check if the number starts with '+91' and remove it
  if (fullNumber.startsWith('+91')) {
    return fullNumber.substring(3); // Remove the first 3 characters (+91)
  }
  return fullNumber; // Return the number as-is if it doesn't start with +91
}