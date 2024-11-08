

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewHelper {
  static WebViewController getWebView({Function(String)? onPageFinished, required String url}) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {
          },
          onPageFinished: onPageFinished,
          onWebResourceError: (WebResourceError error) {
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}