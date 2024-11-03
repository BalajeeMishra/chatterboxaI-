import 'package:flutter_tts/flutter_tts.dart';

class YourTtsClass {
  FlutterTts flutterTts = FlutterTts();

  Future<void> setLanguage(String language) async {
    String languageCode;

    if (language == 'Hindi') {
      languageCode = 'hi-IN';
    } else if (language == 'English') {
      languageCode = 'en-US';
    } else if (language == 'Bengali') {
      languageCode = 'bn-BD';
    } else if (language == 'Kannada') {
      languageCode = 'kn-IN';
    } else if (language == 'Malayalam') {
      languageCode = 'ml-IN';
    } else if (language == 'Marathi') {
      languageCode = 'mr-IN';
    } else if (language == 'Nepali') {
      languageCode = 'ne-NP';
    } else if (language == 'Punjabi') {
      languageCode = 'pa-IN';
    } else if (language == 'Tamil') {
      languageCode = 'ta-IN';
    } else if (language == 'Telugu') {
      languageCode = 'te-IN';
    } else if (language == 'Urdu') {
      languageCode = 'ur-IN';
    } else if (language == 'Gujarati') {
      languageCode = 'gu-IN';
    } else {
      languageCode = 'en-US';
    }

    await flutterTts.setLanguage(languageCode);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }
}
