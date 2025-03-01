import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF7AB2D3),
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.jpg',
              height: 50,
              width: 50,
            ),
            SizedBox(width: 10),
            Text(
              'Care Companion',
              style: GoogleFonts.carattere(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123c5c),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/elder people.png',
                  height: 180,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome Back,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123c5c),
                ),
              ),
              Text(
                'Where Love and Care meet!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF123c5c),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Phone Number', Icons.phone),
              _buildPasswordField('Password', Icons.lock),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Signup Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7AB2D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}