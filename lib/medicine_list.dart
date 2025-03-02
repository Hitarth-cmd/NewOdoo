import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({super.key});

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  final List<Map<String, dynamic>> _medicines = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = "";

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'medicine_channel',
          channelName: 'Medicine Reminders',
          channelDescription: 'Notification channel for medicine reminders',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );
  }

  void _scheduleNotification(String medicineName, String time) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'medicine_channel',
        title: 'Medicine Reminder',
        body: 'Time to take $medicineName ($time)',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
        _processVoiceCommand(_spokenText);
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _processVoiceCommand(String command) {
    List<String> times = ["morning", "afternoon", "night"];
    List<String> days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];

    String medicineName = "";
    String selectedTime = "Morning"; // Default time
    List<String> selectedDays = [];

    List<String> words = command.toLowerCase().split(" ");

    // Extract medicine name (Assumes first few words are the name)
    int stopIndex = words.indexWhere((word) => times.contains(word));
    if (stopIndex == -1) stopIndex = words.length; // No time found, use entire speech as name
    medicineName = words.sublist(0, stopIndex).join(" ").trim();

    // Extract time
    for (String word in words) {
      if (times.contains(word)) {
        selectedTime = word[0].toUpperCase() + word.substring(1); // Capitalize first letter
        break;
      }
    }

    // Extract days
    for (String word in words) {
      if (days.contains(word)) {
        selectedDays.add(word[0].toUpperCase() + word.substring(1)); // Capitalize first letter
      }
    }

    if (medicineName.isNotEmpty) {
      _addMedicine(medicineName, selectedTime, selectedDays);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added: $medicineName at $selectedTime on ${selectedDays.join(", ")}')),
      );
    }
  }

  void _addMedicine(String name, String time, List<String> days) {
    setState(() {
      _medicines.add({
        "name": name,
        "time": time,
        "days": days.isNotEmpty ? days : ["Everyday"],
      });
    });
    _scheduleNotification(name, time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7AB2D3),
        title: const Text("Medicine List"),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _isListening ? _stopListening : _startListening,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _MedicineListPageState();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _medicines.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(_medicines[index]["name"]),
              subtitle: Text("Time: ${_medicines[index]["time"]}\nDays: ${_medicines[index]["days"].join(", ")}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _medicines.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}