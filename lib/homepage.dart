import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medicine_list.dart';
import 'to-do_list.dart';
import 'games.dart';
import 'news.dart';
import 'family_connect.dart';
import 'doctor_appointment.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7AB2D3),
        elevation: 0,
        title: Row(
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
        actions: const [
          Icon(Icons.person, color: Colors.black, size: 30),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Expanded Tip Section
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7AB2D3), Color(0xFF123c5c)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                      "Hello, User! 👋",
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.health_and_safety, color: Colors.white, size: 28),
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

            // Updated Grid View Section
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  List<String> images = [
                    'assets/medicine.png',
                    'assets/to-do_list.png',
                    'assets/mind_games.png',
                    'assets/news.png',
                    'assets/family_connect.png',
                    'assets/doctor_appointment.png',
                  ];

                  List<String> titles = [
                    "Medicine List",
                    "To-Do List",
                    "Mind Games",
                    "News",
                    "Family Connect",
                    "Doctor Appointment",
                  ];

                  // Define the corresponding pages
                  List<Widget> pages = [
                    MedicineListPage(),
                    VoiceTodoScreen(),
                    //  MindGamesPage(),
                    NewsScreen(),
                    //   FamilyConnectPage(),
                    // DoctorAppointmentPage(),
                  ];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[index]),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(images[index], height: 80),
                          const SizedBox(height: 10),
                          Text(
                            titles[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF7AB2D3),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }
}