import 'dart:ui';

import 'package:flutter_tts/flutter_tts.dart';

class TTSManager {
  static final TTSManager _instance = TTSManager._internal();
  factory TTSManager() => _instance;

  FlutterTts flutterTts = FlutterTts();

  VoidCallback? startHandler;
  VoidCallback? completionHandler;
  void Function(String)? errorHandler;

  TTSManager._internal() {
    flutterTts = FlutterTts();

    // Attach internal handlers to TTS events
    flutterTts.setStartHandler(() {
      if (startHandler != null) {
        startHandler!();
      }
    });

    flutterTts.setCompletionHandler(() {
      if (completionHandler != null) {
        completionHandler!();
      }
    });

    flutterTts.setErrorHandler((msg) {
      if (errorHandler != null) {
        errorHandler!(msg);
      }
    });
  }

  // Methods to set custom handlers
  void setStartHandler(VoidCallback callback) {
    startHandler = callback;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  void setErrorHandler(void Function(String) callback) {
    errorHandler = callback;
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> setLanguage(String language) async {
    await flutterTts.setLanguage(language);
  }

  Future<void> setSpeechRate(double rate) async {
    await flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await flutterTts.setPitch(pitch);
  }

  Future<void> setVolume(double volume) async {
    await flutterTts.setVolume(volume);
  }
}
