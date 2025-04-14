import 'package:balajiicode/stt/speech_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechToText _speech = SpeechToText();
  String _text = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    _speech.onResults.listen((result) {
      setState(() {
        _status = result.status;
        if (result.text != null) {
          _text = result.text!;
        }
        if (result.status == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message ?? 'Error occurred')),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech to Text')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Status: $_status'),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: Text(_text),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startListening,
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: _stopListening,
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startListening() async {
    final hasPermission = await _speech.startListening();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission not granted')),
      );
    }
  }

  void _stopListening() {
    _speech.stopListening();
  }
}