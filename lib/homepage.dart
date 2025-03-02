import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medicine_list.dart';
import 'to-do_list.dart';
import 'news.dart';
import 'games.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Companion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSettings = false;
  int _selectedIndex = 0;

  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = "";

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        _toggleSettings();
      }
    });
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
        if (_spokenText.contains('medicine')) {
          _navigateTo(MedicineListPage());
        } else if (_spokenText.contains('list')) {
          _navigateTo(VoiceTodoScreen());
        } else if (_spokenText.contains('games')) {
          _navigateTo(GameScreen());
        } else if (_spokenText.contains('news')) {
          _navigateTo(NewsScreen());
        }
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7AB2D3),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/Logo.jpg',
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              'Care Companion',
              style: GoogleFonts.carattere(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF123c5c),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7AB2D3), Color(0xFF123c5c)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, Dhruv! 👋",
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.health_and_safety, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Stay hydrated and drink at least 8 glasses of water daily!",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Grid View
            Expanded(
              flex: 3,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  List<String> images = [
                    'assets/medicine.png',
                    'assets/to-do_list.png',
                    'assets/mind_games.png',
                    'assets/news.png'
                  ];
                  List<String> titles = ["Medicine List", "To-Do List", "Mind Games", "News"];
                  List<Widget> pages = [
                    MedicineListPage(),
                    VoiceTodoScreen(),
                    GameScreen(),
                    NewsScreen()
                  ];

                  return GestureDetector(
                    onTap: () => _navigateTo(pages[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(images[index], height: 80),
                          const SizedBox(height: 10),
                          Text(titles[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF7AB2D3),
        selectedItemColor: const Color(0xFF123c5c),
        unselectedItemColor: const Color(0xFF123c5c),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Color(0xFF123c5c)), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, color: Color(0xFF123c5c)), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Color(0xFF123c5c)), label: 'Settings'),
        ],
      ),

      // Adjusted floating action buttons location
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 80), // Padding added from bottom
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the SOS Button screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SOSButtonPage()),
                );
              },
              backgroundColor: Colors.red,
              child: Text(
                'SOS', // Text replaced for SOS
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 80), // Padding added from bottom
            child: FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              backgroundColor: const Color(0xFF7AB2D3), // Microphone color
              child: Icon(
                _isListening ? Icons.mic: Icons.mic_off,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SOS Button Screen (you can adjust this as needed)
class SOSButtonPage extends StatefulWidget {
  @override
  _SOSButtonPageState createState() => _SOSButtonPageState();
}

class _SOSButtonPageState extends State<SOSButtonPage> {
  List<String> savedNumbers = [];
  bool isSOSActivated = false;
  bool showCancelButton = false;
  late Timer _timer;
  int _countdown = 5; // 5 seconds countdown

  // Load saved SOS numbers from SharedPreferences
  Future<void> _loadSavedNumbers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedNumbers = prefs.getStringList('sosNumbers') ?? [];
      isSOSActivated = savedNumbers.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedNumbers();
  }

  // Start the 5-second countdown for SOS activation
  void _startSOS() {
    setState(() {
      showCancelButton = true;
      _countdown = 5;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _sendSOSMessage();
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _cancelSOS() {
    setState(() {
      _timer.cancel();
      showCancelButton = false;
    });
  }

  // Send the SOS SMS to saved numbers
  void _sendSOSMessage() {
    String message = "This is an emergency. Please help!";
    if (savedNumbers.isNotEmpty) {
      for (String number in savedNumbers) {
        launch('sms:$number?body=$message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text("SOS Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Square button for activating SOS with border radius 10
            ElevatedButton(
              onPressed: _startSOS,
              child: const Text('Activate SOS'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Border radius set to 10
                ),
                padding: const EdgeInsets.all(40), // Adjust padding for a square shape
                backgroundColor: Colors.red,
              ),
            ),
            if (showCancelButton)
              Column(
                children: [
                  Text("$_countdown seconds remaining to cancel", style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _cancelSOS,
                    child: const Text('Cancel SOS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
