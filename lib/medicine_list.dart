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
  stt.SpeechToText _speech = stt.SpeechToText();
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
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _addMedicine(String name, String time, List<String> days) {
    setState(() {
      _medicines.add({
        "name": name,
        "time": time,
        "days": days,
      });
    });
    _scheduleNotification(name, time);
  }

  void _showAddMedicineDialog() {
    TextEditingController medicineNameController = TextEditingController();
    String selectedTime = "Morning";
    List<String> selectedDays = [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Medicine"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicineNameController,
                decoration: const InputDecoration(labelText: "Medicine Name"),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedTime,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue!;
                  });
                },
                items: ["Morning", "Afternoon", "Night"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Wrap(
                children: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                    .map((day) {
                  return ChoiceChip(
                    label: Text(day),
                    selected: selectedDays.contains(day),
                    onSelected: (selected) {
                      setState(() {
                        selected ? selectedDays.add(day) : selectedDays.remove(day);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addMedicine(medicineNameController.text, selectedTime, selectedDays);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
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
            onPressed: _showAddMedicineDialog,
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