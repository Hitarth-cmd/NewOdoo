import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceTodoScreen extends StatefulWidget {
  @override
  _VoiceTodoScreenState createState() => _VoiceTodoScreenState();
}

class _VoiceTodoScreenState extends State<VoiceTodoScreen> {
  final List<String> tasks = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = "";
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  /// 🎤 Start or Stop Listening
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
        },
        listenFor: Duration(seconds: 5),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);

    // Add recognized text as task
    if (_lastWords.isNotEmpty) {
      setState(() {
        tasks.add(_lastWords);
      });
    }
  }

  /// 🗣 Speak out tasks
  Future<void> _speakTasks() async {
    if (tasks.isEmpty) {
      await _flutterTts.speak("No tasks found.");
    } else {
      await _flutterTts.speak("Your tasks are: ${tasks.join(', ')}");
    }
  }

  /// 🗑 Delete Task
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice To-Do List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _isListening ? _stopListening : _startListening,
                child: Icon(_isListening ? Icons.mic_off : Icons.mic),
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _speakTasks,
                child: Icon(Icons.volume_up),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}