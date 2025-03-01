import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'homepage.dart';

class VerifyOTPPage extends StatefulWidget {
  const VerifyOTPPage({super.key});

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final TextEditingController _otpController = TextEditingController();
  final String _predefinedOTP = "123456"; // Set your predefined OTP
  bool _isOTPValid = true; // For showing validation errors

  void _verifyOTP() {
    if (_otpController.text == _predefinedOTP) {
      // OTP matches, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        _isOTPValid = false; // Show error
      });
    }
  }

  void _resendOTP() {
    print("Resending OTP...");
    // Logic to resend OTP
  }

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
                color: Color(0xFF123c5c),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
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
            Text(
              'Verify OTP',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123c5c),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the OTP sent to your phone number.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF123c5c),
              ),
            ),
            const SizedBox(height: 20),

            // OTP Input Field
            PinCodeTextField(
              appContext: context,
              length: 6, // 6 digit OTP
              obscureText: false,
              animationType: AnimationType.fade,
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(
                fontSize: 18,
                color: Color(0xFF123c5c),
                fontWeight: FontWeight.bold,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 45,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.grey[200],
                selectedFillColor: Colors.grey[300],
                activeColor: Color(0xFF7AB2D3),
                inactiveColor: Colors.grey,
                selectedColor: Color(0xFF123c5c),
              ),
              controller: _otpController,
              onChanged: (value) {
                setState(() {
                  _isOTPValid = true; // Reset error when user types
                });
              },
            ),

            // Error message
            if (!_isOTPValid)
              const Padding(
                padding: EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  "Incorrect OTP. Please try again.",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            const SizedBox(height: 20),

            // VERIFY OTP Button
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
                onPressed: _verifyOTP,
                child: const Text(
                  'VERIFY OTP',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Resend OTP
            Center(
              child: GestureDetector(
                onTap: _resendOTP,
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
