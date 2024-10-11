

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
            print("PDF ON onProgress - $progress");
          },
          onPageStarted: (String url) {
            print("PDF ON onPageStarted - $url");
          },
          onPageFinished: onPageFinished,
          onWebResourceError: (WebResourceError error) {
            print("PDF ON onWebResourceError - $error, ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}