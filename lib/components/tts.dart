import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';

class TTSManager {
  static final TTSManager _instance = TTSManager._internal();
  factory TTSManager() => _instance;

  FlutterTts flutterTts = FlutterTts();

  VoidCallback? startHandler;
  VoidCallback? completionHandler;
  void Function(String)? errorHandler;
  void Function(String)? progressHandler; // Fixed the type here

  TTSManager._internal() {
    flutterTts = FlutterTts();

    // Start handler
    flutterTts.setStartHandler(() {
      if (startHandler != null) startHandler!();
    });

    // Completion handler
    flutterTts.setCompletionHandler(() {
      if (completionHandler != null) completionHandler!();
    });

    // Error handler
    flutterTts.setErrorHandler((msg) {
      if (errorHandler != null) errorHandler!(msg);
    });

    // Progress handler for real-time word tracking
    flutterTts.setProgressHandler((String text, int start, int end, String word) {
      if (progressHandler != null) progressHandler!(word);
    });
  }

  // Methods to set custom handlers
  Future<void> awaitSpeakCompletion(bool value) async {
    await flutterTts.awaitSpeakCompletion(value);
  }

  void setStartHandler(VoidCallback callback) {
    startHandler = callback;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  void setErrorHandler(void Function(String) callback) {
    errorHandler = callback;
  }

  void setProgressHandler(void Function(String) callback) {  // Corrected this method
    progressHandler = callback;
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
  Future<void> stopAndReset() async {
    await flutterTts.stop();
    flutterTts = FlutterTts();
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
