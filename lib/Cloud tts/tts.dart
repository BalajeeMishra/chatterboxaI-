import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:balajiicode/Screens/ChooseWordScreen/PlayTabooScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';

import '../Screens/ChooseWordScreen/PlayTabooScreen.dart';
import '../ViewModel/PlayTabooScreenVM.dart';
import '../main.dart';

class GoogleCloudTTSService {

  late ServiceAccountCredentials _credentials;
  late AuthClient _client;
  bool _isInitialized = false;


  // Instead of text queue, now AUDIO file paths queue
  final Queue<String> _audioFileQueue = Queue();
  List<String> ttsFilePaths = [];
  bool _isPlayingQueue = false;
  double audioSpeed = 0.9;
  int currentParaIndex = 0 ;
  BuildContext globalContext = navigatorKey.currentContext!;




  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const jsonString = '''{
        "type": "service_account",
        "project_id": "dialogflow-first-test",
        "private_key_id": "c1e3eb14b1488707f4696ee55b4cfc15f2d1950f",
        "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC0Kyg4U9mYDstm\\neDpSYXXVT1RqMZd6j+Qt/MfB2wqs40rQcw1yO1OzQi1tZoQTre+YjrnosWikIBvN\\nnIW+9nD5rs05YQ4JFZEqfNwZ4Vkzkpp7bp6Xocz421imcnYEDzujCWWn2iJOw3ze\\nXARzGHvCW/SlQWQ8ZgB+Ge+X7/ROV4Putr35UaovZbAJyqE9N+ZGtiBa55Q9abkC\\nn6YkKK9n+ky5qIBWwaxzRY6/FDcau3DmkLqQBVYsQwxC2fGT/rHcNCJ349SBYYq1\\nDSZPGlWu0jcKTqdDZkt0s98lR2qfIQJld7d6GKrnNw3OmcFZZv6bYSgdrB14G+aZ\\nxrM3hXg/AgMBAAECggEADrL0rupxtr0CQuPCh6++4CkpjxkTrY1UGvJkI8CTVY6d\\nBHZWiFV8cIQQ1mZGQUrFYPIdYHV/lDWwaa0q9kJUmPJLeQfI5YcrwZvP4zv7k0Bo\\njR3LH5OKTbAA7WIqQbjdGeHtjW0NCSsGzXy+ujCAVwI56p+ephTWVnNsP5Of9Xd9\\ncmNGwuAeCl2Y+8OUlOXFfsnY7GwwDgakxLsIq8D+jjfS6Gusw3Gc9DLNPrUaYtSr\\nSDQ0R5eC5510qn5uwmdtvtwHtXKFWUp+7XuoLz9juU7p/yyeecMHUtO++ElvTwuX\\nXelkACKhwdxdphUy6l3KuxhMtEvVRRtMFjGM+dg9GQKBgQDwtIVx5hbONEgM6PPv\\n5fad+Kfr3mfJZ3uhifQhx3MpA0BWIzKspjR/Hr4CkhQRh2ricw4Bceu9i57vpK/H\\nlV5zOp61RxnZZ6YdNyF8Vdih0Lf98lvKrinamFBgh/xmQCmRtDCuQyaI7/3GIfll\\nIbFLaWYtM52ZK8UxcWEfKngGWQKBgQC/nefLyuQPHcX+iyR6sDBe0i9BVDAZYOuz\\nGXbnJ33qNeopxkFb4A+m1vR/nXmki5RhHbZkoyATclEoAeZGlgqqAnH+MVAJCtE9\\n8wEOyXxrWoho0xHIwDkb9GmZ0vAVKVK5sQquVNkIitwx9KzjeufdRSmRXmyip//c\\nuNtFs8vQVwKBgQCr4VxA/vpd+LtSbK50KhQ2ra7LIR+flAOWUHpB/LhhGu9AExZG\\nbtChzYQFNeaatcY/OcVQhta9nQu7ODBFJoYxZjSaYdE1i2v1BL8ml+5/bhlUf1HI\\noyFD9OvAYpp7MWn9n1v7s/u6YRUn/G6oJq0BmpvZvzfUforrSXj+1kaq0QKBgQCM\\nI/WSU5oGADV9W9BbNp65yqkq82KWPQ9FFpuipXxune3bjZbhlfZ8g/ufldGQaVEk\\n0fFCmxdrgZEfXHxJJZU5D77FNNWfN10fHKmqYevwK+9WEwCPvR5HdrMBAIf8QhOx\\noWz5YS62E7DFjHghixMm/l1PZyq2r33utPgRe1TV0wKBgQC3pEcv5DEv+esSiY13\\nHR4gLNMS1UE6TBakwapDlTAskhonkxZxCzh8s9Ebenn0x/rXyznWu3Z/lRsAf5X5\\n4Aa4Cd8nvujsEfmvhdQ+p6I/tmecY9xnc64q1TIJTg16RTLCVgXujmRQ+tkmWPGB\\n7/czI92pUzyMLT6B/4vtxhfrRw==\\n-----END PRIVATE KEY-----\\n",
        "client_email": "zapai-tts@dialogflow-first-test.iam.gserviceaccount.com",
        "client_id": "114914950090296504875",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/zapai-tts%40dialogflow-first-test.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }''';

      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _credentials = ServiceAccountCredentials.fromJson(jsonData);
      _client = await clientViaServiceAccount(
          _credentials, ['https://www.googleapis.com/auth/cloud-platform']
      );

      audioPlayer.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed) {
          var pro = Provider.of<PlayTabooScreenVM>(globalContext, listen: false);
          pro.setIsListening(true);
          pro.setIfDelayOfASecond(true);
          await Future.delayed(Duration(milliseconds: 750));
          print("Delay for a second called");
          pro.setIfDelayOfASecond(false);
          await _playNextInQueue();
        }
      });

      _isInitialized = true;
    } catch (e) {
      print('Error initializing TTS service: $e');
      rethrow;
    }
  }

  // Future<void> _playNextInQueue() async {
  //   var pro = Provider.of<PlayTabooScreenVM>(globalContext, listen: false);
  //
  //   if (_audioFileQueue.isEmpty) {
  //     pro.setIsListening(true);
  //     _isPlayingQueue = false;
  //     return;
  //   }
  //
  //   final nextFilePath = _audioFileQueue.removeFirst();
  //   await _audioPlayer.setFilePath(nextFilePath);
  //   pro.setIsListening(false);
  //   print("this is speedh${_audioPlayer.speed}");
  //   await _audioPlayer.setSpeed(audioSpeed);
  //   pro.setCurrentParaIndex(pro.currentParaIndex++);
  //   print("this is current index ${pro.currentParaIndex++}");
  //   await _audioPlayer.play();
  //
  // }
  Future<void> _playNextInQueue() async {
    var pro = Provider.of<PlayTabooScreenVM>(globalContext, listen: false);

    // If queue is empty, wait briefly (e.g., up to 2 seconds), checking every 200ms
    int retries = 50; // 10 * 200ms = 2 seconds
    while (_audioFileQueue.isEmpty && retries > 0 && _isPlayingQueue) {
      await Future.delayed(Duration(milliseconds: 200));
      retries--;
    }

    if (_audioFileQueue.isEmpty) {
      // Still empty after retries: stop
      pro.setIsListening(true);
      _isPlayingQueue = false;
      return;
    }

    final nextFilePath = _audioFileQueue.removeFirst();
    await audioPlayer.setSpeed(audioSpeed);
    await audioPlayer.setFilePath(nextFilePath);
    pro.setIsListening(false);

    pro.setCurrentParaIndex(pro.currentParaIndex + 1);
    await audioPlayer.play();
  }

  Future<void> speakTexts(List<String> texts, {
    String languageCode = 'en-US',
    String voiceName = 'en-US-Chirp3-HD-Achernar',
    String gender = 'FEMALE',
    double speakingRate = 0.8,
    double pitch = 0.0,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    await deleteFiles(ttsFilePaths);
    print("length of filepath ${ttsFilePaths.length}");
    ttsFilePaths.clear();
    _audioFileQueue.clear();

    final directory = await getTemporaryDirectory();
    for (int i=0;i<texts.length;i++) {
      final filePath = '${directory.path}/tts_output_${DateTime.now().millisecondsSinceEpoch}.mp3';
      if(i==1){
        if (!_isPlayingQueue) {
          _isPlayingQueue = true;
          var pro = Provider.of<PlayTabooScreenProvider>(globalContext, listen: false);
          pro.setIsLoaderShow(false);
          await _playNextInQueue();
        }
      }
      final audioData = await _getAudioFromAPI(
        texts[i],
        languageCode: languageCode,
        voiceName: voiceName,
        gender: gender,
        speakingRate: speakingRate,
        pitch: pitch,
      );
      final file = File(filePath);
      await file.writeAsBytes(audioData);
      _audioFileQueue.add(filePath);
      ttsFilePaths.add(filePath);

    }


  }
  void speekSaved()async{
    _audioFileQueue.clear();
    for(int i=0;i<ttsFilePaths.length;i++){
      _audioFileQueue.add(ttsFilePaths[i]);
      if(i==1){
        if (!_isPlayingQueue) {
          _isPlayingQueue = true;

          await _playNextInQueue();
        }
      }
    }
  }

  void stop() {
    audioPlayer.stop();
    var pro = Provider.of<PlayTabooScreenVM>(globalContext, listen: false);
    pro.setCurrentParaIndex(-1);
    _audioFileQueue.clear();
    _isPlayingQueue = false;

  }


  Future<List<int>> _getAudioFromAPI(String text, {
    required String languageCode,
    required String voiceName,
    required String gender,
    required double speakingRate,
    required double pitch,
  }) async {
    final url = 'https://texttospeech.googleapis.com/v1/text:synthesize';

    final payload = {
      'input': {'text': text},
      'voice': {'languageCode': languageCode, 'name': voiceName},
      'audioConfig': {
        'audioEncoding': 'LINEAR16',
        "sampleRateHertz": 24000,
        'effectsProfileId': ['small-bluetooth-speaker-class-device'],
        'speakingRate': speakingRate,
        'pitch': pitch,
      }
    };

    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final audioContent = responseJson['audioContent'];
      return base64Decode(audioContent);
    } else {
      throw Exception('Failed to get TTS: ${response.body}');
    }
  }


  Future<void> deleteFiles(List<String> filePaths) async {
    for (String path in filePaths) {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
        print("Deleted: $path");
      } else {
        print("File not found: $path");
      }
    }
  }


  void dispose() {
    audioPlayer.dispose();
    _client.close();
  }
}
