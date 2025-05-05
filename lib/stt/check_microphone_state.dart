// import 'package:flutter/services.dart';
//
// class MicStatusListener {
//   static const EventChannel _micStatusChannel = EventChannel('mic_status_channel');
//
//   void startListening(Function(String) onMicStatusChanged) {
//     _micStatusChannel.receiveBroadcastStream().listen((event) {
//       print('Mic status event: $event');
//       if (event == 'mic_off') {
//         onMicStatusChanged('off');
//       } else if (event == 'mic_on') {
//         onMicStatusChanged('on');
//       }
//     });
//   }
// }
