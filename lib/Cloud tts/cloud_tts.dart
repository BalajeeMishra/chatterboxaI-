// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:googleapis_auth/auth_io.dart';
//
// class GoogleCloudTTSService {
//   // Audio player instance
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   // Service account credentials
//   late ServiceAccountCredentials _credentials;
//   late AuthClient _client;
//   bool _isInitialized = false;
//
//   // Initialize the service with credentials
//   Future<void> initialize() async {
//     if (_isInitialized) return;
//
//     try {
//       // Load service account JSON from assets
//       // NOTE: You should store this file in your assets and reference it in pubspec.yaml
//       // final jsonString = await rootBundle.loadString('assets/service_account.json');
//
//       // Or use a hardcoded string (not recommended for production, just for testing)
//       const jsonString = '''
// {
//   "type": "service_account",
//   "project_id": "dialogflow-first-test",
//   "private_key_id": "c1e3eb14b1488707f4696ee55b4cfc15f2d1950f",
//   "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC0Kyg4U9mYDstm\\neDpSYXXVT1RqMZd6j+Qt/MfB2wqs40rQcw1yO1OzQi1tZoQTre+YjrnosWikIBvN\\nnIW+9nD5rs05YQ4JFZEqfNwZ4Vkzkpp7bp6Xocz421imcnYEDzujCWWn2iJOw3ze\\nXARzGHvCW/SlQWQ8ZgB+Ge+X7/ROV4Putr35UaovZbAJyqE9N+ZGtiBa55Q9abkC\\nn6YkKK9n+ky5qIBWwaxzRY6/FDcau3DmkLqQBVYsQwxC2fGT/rHcNCJ349SBYYq1\\nDSZPGlWu0jcKTqdDZkt0s98lR2qfIQJld7d6GKrnNw3OmcFZZv6bYSgdrB14G+aZ\\nxrM3hXg/AgMBAAECggEADrL0rupxtr0CQuPCh6++4CkpjxkTrY1UGvJkI8CTVY6d\\nBHZWiFV8cIQQ1mZGQUrFYPIdYHV/lDWwaa0q9kJUmPJLeQfI5YcrwZvP4zv7k0Bo\\njR3LH5OKTbAA7WIqQbjdGeHtjW0NCSsGzXy+ujCAVwI56p+ephTWVnNsP5Of9Xd9\\ncmNGwuAeCl2Y+8OUlOXFfsnY7GwwDgakxLsIq8D+jjfS6Gusw3Gc9DLNPrUaYtSr\\nSDQ0R5eC5510qn5uwmdtvtwHtXKFWUp+7XuoLz9juU7p/yyeecMHUtO++ElvTwuX\\nXelkACKhwdxdphUy6l3KuxhMtEvVRRtMFjGM+dg9GQKBgQDwtIVx5hbONEgM6PPv\\n5fad+Kfr3mfJZ3uhifQhx3MpA0BWIzKspjR/Hr4CkhQRh2ricw4Bceu9i57vpK/H\\nlV5zOp61RxnZZ6YdNyF8Vdih0Lf98lvKrinamFBgh/xmQCmRtDCuQyaI7/3GIfll\\nIbFLaWYtM52ZK8UxcWEfKngGWQKBgQC/nefLyuQPHcX+iyR6sDBe0i9BVDAZYOuz\\nGXbnJ33qNeopxkFb4A+m1vR/nXmki5RhHbZkoyATclEoAeZGlgqqAnH+MVAJCtE9\\n8wEOyXxrWoho0xHIwDkb9GmZ0vAVKVK5sQquVNkIitwx9KzjeufdRSmRXmyip//c\\nuNtFs8vQVwKBgQCr4VxA/vpd+LtSbK50KhQ2ra7LIR+flAOWUHpB/LhhGu9AExZG\\nbtChzYQFNeaatcY/OcVQhta9nQu7ODBFJoYxZjSaYdE1i2v1BL8ml+5/bhlUf1HI\\noyFD9OvAYpp7MWn9n1v7s/u6YRUn/G6oJq0BmpvZvzfUforrSXj+1kaq0QKBgQCM\\nI/WSU5oGADV9W9BbNp65yqkq82KWPQ9FFpuipXxune3bjZbhlfZ8g/ufldGQaVEk\\n0fFCmxdrgZEfXHxJJZU5D77FNNWfN10fHKmqYevwK+9WEwCPvR5HdrMBAIf8QhOx\\noWz5YS62E7DFjHghixMm/l1PZyq2r33utPgRe1TV0wKBgQC3pEcv5DEv+esSiY13\\nHR4gLNMS1UE6TBakwapDlTAskhonkxZxCzh8s9Ebenn0x/rXyznWu3Z/lRsAf5X5\\n4Aa4Cd8nvujsEfmvhdQ+p6I/tmecY9xnc64q1TIJTg16RTLCVgXujmRQ+tkmWPGB\\n7/czI92pUzyMLT6B/4vtxhfrRw==\\n-----END PRIVATE KEY-----\\n",
//   "client_email": "zapai-tts@dialogflow-first-test.iam.gserviceaccount.com",
//   "client_id": "114914950090296504875",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/zapai-tts%40dialogflow-first-test.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// }
// ''';
//
//       final Map<String, dynamic> jsonData = json.decode(jsonString);
//
//       // Create credentials
//       _credentials = ServiceAccountCredentials.fromJson(jsonData);
//
//       // Create an authenticated HTTP client
//       _client = await clientViaServiceAccount(
//           _credentials,
//           ['https://www.googleapis.com/auth/cloud-platform']
//       );
//
//       _isInitialized = true;
//     } catch (e) {
//       print('Error initializing TTS service: $e');
//       rethrow;
//     }
//   }
//
//   // Method to convert text to speech
//   Future<void> speakText(String text, {
//     String languageCode = 'en-US',
//     String voiceName = 'en-US-Chirp3-HD-Achernar',
//     String gender = 'FEMALE',
//     double speakingRate = 0.8,
//     double pitch = 0.0,
//   }) async {
//     try {
//       // Make sure service is initialized
//       if (!_isInitialized) {
//         await initialize();
//       }
//
//       // Create temporary file for audio
//       final directory = await getTemporaryDirectory();
//       final filePath = '${directory.path}/tts_output.mp3';
//
//       // Get audio data from Google Cloud TTS
//       final audioData = await _getAudioFromAPI(
//         text,
//         languageCode: languageCode,
//         voiceName: voiceName,
//         gender: gender,
//         speakingRate: speakingRate,
//         pitch: pitch,
//       );
//
//       // Write to file
//       final file = File(filePath);
//       await file.writeAsBytes(audioData);
//
//       // Play the audio
//       await _audioPlayer.setFilePath(filePath);
//       // await _audioPlayer.
//       await _audioPlayer.play();
//       await file.delete();
//     } catch (e) {
//       print('Error in TTS: $e');
//       rethrow;
//     }
//   }
//
//   // Method to stop audio playback
//   void stop() {
//     _audioPlayer.stop();
//   }
//
//   // Method to get audio data from Google Cloud TTS API with service account auth
//   Future<List<int>> _getAudioFromAPI(String text, {
//     required String languageCode,
//     required String voiceName,
//     required String gender,
//     required double speakingRate,
//     required double pitch,
//   }) async {
//     final url = 'https://texttospeech.googleapis.com/v1/text:synthesize';
//
//     final payload = {
//       'input': {
//         'text': text,
//       },
//       'voice': {
//         'languageCode': languageCode,
//         'name': voiceName,
//       },
//       'audioConfig': {
//         'audioEncoding': 'LINEAR16',
//         "sampleRateHertz": 24000,
//         'effectsProfileId': [
//           'small-bluetooth-speaker-class-device' // <-- added effects profile
//         ],
//         'speakingRate': speakingRate,
//         'pitch': pitch,
//       }
//     };
//
//     final response = await _client.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(payload),
//     );
//
//     if (response.statusCode == 200) {
//       final responseJson = jsonDecode(response.body);
//       final audioContent = responseJson['audioContent'];
//       return base64Decode(audioContent);
//     } else {
//       throw Exception('Failed to get TTS: ${response.body}');
//     }
//   }
//
//
//
//   // Dispose resources
//   void dispose() {
//     _audioPlayer.dispose();
//     _client.close();
//   }
// }
//
// // Example usage in a Flutter widget
// class TTSExample extends StatefulWidget {
//   @override
//   _TTSExampleState createState() => _TTSExampleState();
// }
//
// class _TTSExampleState extends State<TTSExample> {
//   final GoogleCloudTTSService _ttsService = GoogleCloudTTSService();
//   final TextEditingController _textController = TextEditingController();
//   bool _isLoading = false;
//   String _selectedVoice = 'en-US-Neural2-F';
//
//   // Available voices - these are some of the most realistic ones
//   final List<Map<String, String>> _voices = [
//     {'name': 'en-US-Neural2-F', 'display': 'US Female 1 (Most Natural)'},
//     {'name': 'en-US-Neural2-J', 'display': 'US Female 2'},
//     {'name': 'en-US-Neural2-M', 'display': 'US Male 1'},
//     {'name': 'en-US-Neural2-D', 'display': 'US Male 2'},
//     {'name': 'en-GB-Neural2-F', 'display': 'UK Female'},
//     {'name': 'en-GB-Neural2-B', 'display': 'UK Male'},
//     {'name': 'en-AU-Neural2-A', 'display': 'Australian Female'},
//     {'name': 'en-AU-Neural2-B', 'display': 'Australian Male'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _textController.text = "Text-to-speech (TTS) technology has transformed the way we interact with digital content, offering a bridge between written information and audible communication. By converting text into natural-sounding speech, TTS makes content more accessible to a wider audience, including people with visual impairments or reading difficulties. However, achieving human-like voice quality often requires careful selection of voices, proper tuning of sample rates, and sometimes the use of advanced features like SSML (Speech Synthesis Markup Language). Choosing the right settings and voices can make a huge difference between robotic-sounding output and a fluid, natural listening experience.";
//     _initializeTTS();
//   }
//
//   Future<void> _initializeTTS() async {
//     try {
//       await _ttsService.initialize();
//     } catch (e) {
//       print('Failed to initialize TTS: $e');
//       // Show error dialog or snackbar to user
//     }
//   }
//
//   @override
//   void dispose() {
//     _ttsService.dispose();
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Realistic TTS with Google Cloud')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Enter text to convert to realistic speech',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _textController,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: 'Type something to hear in a natural voice...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             Text('Select Voice:'),
//             DropdownButtonFormField<String>(
//               value: _selectedVoice,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               items: _voices.map((voice) {
//                 return DropdownMenuItem(
//                   value: voice['name'],
//                   child: Text(voice['display']!),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedVoice = value!;
//                 });
//               },
//             ),
//
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading
//                   ? null
//                   : () async {
//                 if (_textController.text.isNotEmpty) {
//                   setState(() {
//                     _isLoading = true;
//                   });
//
//                   try {
//                     final String gender = _selectedVoice.contains('-F') ||
//                         _selectedVoice.contains('-A') ||
//                         _selectedVoice.contains('-J')
//                         ? 'FEMALE' : 'MALE';
//
//                     await _ttsService.speakText(
//                       _textController.text,
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: $e'))
//                     );
//                   } finally {
//                     setState(() {
//                       _isLoading = false;
//                     });
//                   }
//                 }
//               },
//               child: _isLoading
//                   ? SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2.0),
//               )
//                   : Text('Speak'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 15),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextButton.icon(
//               onPressed: () {
//                 _ttsService.stop();
//               },
//               icon: Icon(Icons.stop_circle, color: Colors.red),
//               label: Text('Stop'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }