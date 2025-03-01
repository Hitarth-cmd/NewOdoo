import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isError = false; // For error message display

  // Default Credentials
  final String defaultPhone = "8799403503";
  final String defaultPassword = "dhruv";

  void _login() {
    if (_phoneController.text == defaultPhone && _passwordController.text == defaultPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _isError = true; // Show error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7AB2D3),
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.jpg',
              height: 50,
              width: 50,
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
              const SizedBox(height: 20),
              const Text(
                'Welcome Back,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123c5c),
                ),
              ),
              const Text(
                'Where Love and Care meet!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF123c5c),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField('Phone Number', Icons.phone, _phoneController, false),
              _buildTextField('Password', Icons.lock, _passwordController, true),

              if (_isError)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 5),
                  child: Text(
                    "Invalid phone number or password!",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7AB2D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _login,
                  child: const Text(
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

  Widget _buildTextField(String hintText, IconData icon, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
