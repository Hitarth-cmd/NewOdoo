import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class SOSButton extends StatefulWidget {
  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  List<String> savedNumbers = [];
  bool isSOSActivated = false;

  @override
  void initState() {
    super.initState();
    _loadSavedNumbers();
    requestSMSPermission();
  }

  Future<void> requestSMSPermission() async {
    PermissionStatus status = await Permission.sms.request();
    if (status.isDenied) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text("This app needs SMS permission to send emergency alerts."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSavedNumbers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedNumbers = prefs.getStringList('sosNumbers') ?? [];
      isSOSActivated = savedNumbers.isNotEmpty;
    });
  }

  Future<void> _saveNumbers(List<String> numbers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sosNumbers', numbers);
    setState(() {
      savedNumbers = numbers;
      isSOSActivated = true;
    });
  }

  void _openNumberScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNumbersScreen()),
    );
    if (result != null && result is List<String>) {
      _saveNumbers(result);
    }
  }

  void _sendSOSMessage() async {
    PermissionStatus status = await Permission.sms.status;
    if (!status.isGranted) {
      requestSMSPermission();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool isCancelled = false;

        Future.delayed(Duration(seconds: 5), () async {
          if (!isCancelled) {
            Navigator.of(dialogContext).pop();
            _sendSMS();
          }
        });

        return AlertDialog(
          title: Text("SOS Alert"),
          content: Text("Message will be sent in 5 seconds. Cancel if not needed."),
          actions: [
            TextButton(
              onPressed: () {
                isCancelled = true;
                Navigator.of(dialogContext).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _sendSMS() async {
    String message = "Your elder is in trouble! 🔴";
    String numbers = savedNumbers.join(";");

    final Uri smsUri = Uri.parse("sms:$numbers?body=${Uri.encodeFull(message)}");

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      print("❌ Could not launch SMS app, using alternative method...");
      _sendSMSAlternative(numbers, message);
    }
  }

  void _sendSMSAlternative(String numbers, String message) {
    final intent = AndroidIntent(
      action: "android.intent.action.SENDTO",
      data: "smsto:$numbers",
      arguments: {"sms_body": message},
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    intent.launch().catchError((e) {
      print("❌ Error launching SMS intent: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isSOSActivated) {
          _sendSOSMessage();
        } else {
          _openNumberScreen();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(
        "SOS",
        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// AddNumbersScreen Implementation
class AddNumbersScreen extends StatefulWidget {
  @override
  _AddNumbersScreenState createState() => _AddNumbersScreenState();
}

class _AddNumbersScreenState extends State<AddNumbersScreen> {
  final List<TextEditingController> controllers = [TextEditingController(), TextEditingController()];

  void _addNumberField() {
    if (controllers.length < 3) {
      setState(() {
        controllers.add(TextEditingController());
      });
    }
  }

  void _submitNumbers() {
    List<String> numbers = controllers.map((controller) => controller.text.trim()).where((num) => num.isNotEmpty).toList();
    if (numbers.length >= 2) {
      Navigator.pop(context, numbers);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter at least 2 numbers")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Emergency Contacts")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ...controllers.map((controller) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Enter Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
            )),
            SizedBox(height: 10),
            if (controllers.length < 3)
              ElevatedButton(
                onPressed: _addNumberField,
                child: Text("Add Another Number"),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitNumbers,
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
