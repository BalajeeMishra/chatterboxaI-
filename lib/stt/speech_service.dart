// speech_to_text.dart
import 'package:flutter/services.dart';

class SpeechToText {
  static const MethodChannel _channel = MethodChannel('speech_to_text');
  static const EventChannel _eventChannel = EventChannel('speech_to_text_stream');

  Stream<SpeechRecognitionResult>? _stream;

  Future<bool> startListening() async {
    try {
      return await _channel.invokeMethod('startListening');
    } on PlatformException catch (e) {
      print("Failed to start listening: ${e.message}");
      return false;
    }
  }

  Future<bool> stopListening() async {
    try {
      return await _channel.invokeMethod('stopListening');
    } on PlatformException catch (e) {
      print("Failed to stop listening: ${e.message}");
      return false;
    }
  }

  Stream<SpeechRecognitionResult> get onResults {
    _stream ??= _eventChannel.receiveBroadcastStream().map((event) {
      final map = event as Map<dynamic, dynamic>;
      return SpeechRecognitionResult.fromMap(map);
    });
    return _stream!;
  }
}

class SpeechRecognitionResult {
  final String status; // listening, recognizing, stopped, error
  final String? text;
  final String? message;

  SpeechRecognitionResult({
    required this.status,
    this.text,
    this.message,
  });

  factory SpeechRecognitionResult.fromMap(Map<dynamic, dynamic> map) {
    return SpeechRecognitionResult(
      status: map['status'] as String,
      text: map['text'] as String?,
      message: map['message'] as String?,
    );
  }
}