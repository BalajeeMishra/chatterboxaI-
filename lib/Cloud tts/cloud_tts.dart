// import 'dart:ui';
// import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
//
// class TTSManager {
//   static final TTSManager _instance = TTSManager._internal();
//   factory TTSManager() => _instance;
//
//   TtsUniversal? tts;
//
//   VoidCallback? startHandler;
//   VoidCallback? completionHandler;
//   void Function(String)? errorHandler;
//   void Function(String)? progressHandler;
//
//   TTSManager._internal() {
//     _initTTS();
//   }
//
//   // Initialize TTS
//   Future<void> _initTTS() async {
//     tts = TtsUniversal();
//
//     // Initialize the configuration for all providers
//      TtsGoogle.init(
//          withLogs:true,
//          apiKey: ''
//     );
//   }
//
//   Future<void> awaitSpeakCompletion(bool value) async {
//     // No direct equivalent, but you can manage state manually if needed
//   }
//
//   void setStartHandler(VoidCallback callback) {
//     startHandler = callback;
//   }
//
//   void setCompletionHandler(VoidCallback callback) {
//     completionHandler = callback;
//   }
//
//   void setErrorHandler(void Function(String) callback) {
//     errorHandler = callback;
//   }
//
//   void setProgressHandler(void Function(String) callback) {
//     progressHandler = callback;
//   }
//
//   Future<void> speak(String text) async {
//     try {
//       final voicesResponse = await TtsUniversal.getVoices();
//       final voices = voicesResponse.voices;
//
//       // Select an English voice
//       final voice = voices.firstWhere(
//             (v) => v.locale.code.startsWith("en-"),
//         orElse: () => voices.first,
//       );
//
//       final ttsParams = TtsParamsUniversal(
//         voice: voice,
//         audioFormat: AudioOutputFormatUniversal.mp3_64k,
//         text: text,
//         rate: 'medium',
//         pitch: 'default',
//       );
//
//       final ttsResponse = await TtsUniversal.convertTts(ttsParams);
//
//       // Use audioBytes to play or store the audio
//       final audioBytes = ttsResponse.audio.buffer.asByteData();
//       print('Audio generated: ${audioBytes.lengthInBytes} bytes');
//
//       startHandler?.call();
//
//       // Simulate progress handler
//       progressHandler?.call("Speaking...");
//
//       completionHandler?.call();
//     } catch (e) {
//       errorHandler?.call(e.toString());
//     }
//   }
//
//   Future<void> stop() async {
//     // No direct equivalent for stopping, but you could handle this manually
//   }
//
//   Future<void> stopAndReset() async {
//     tts = null;
//     await _initTTS();
//   }
//
//   Future<void> setLanguage(String language) async {
//     // Language is handled in the voice selection
//   }
//
//   Future<void> setSpeechRate(double rate) async {
//     // Handled via TtsParamsUniversal
//   }
//
//   Future<void> setPitch(double pitch) async {
//     // Handled via TtsParamsUniversal
//   }
//
//   Future<void> setVolume(double volume) async {
//     // No direct equivalent, but you could adjust audio playback volume
//   }
//
//   Future<void> setVoice() async {
//     final voicesResponse = await TtsUniversal.getVoices();
//     final voices = voicesResponse.voices;
//
//     final voice = voices.firstWhere(
//           (v) => v.locale.code.startsWith("en-"),
//       orElse: () => voices.first,
//     );
//
//     print("Selected voice: ${voice.name}");
//   }
// }
