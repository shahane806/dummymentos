import 'package:flutter/material.dart';
import 'package:scanningapp/screens/directory_structure.dart';
import 'package:scanningapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      print("Stored email: $email");

      // Ensure the widget is still mounted before navigation
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                email != null ? FileExplorerApp() : LoginScreen()),
      );
    } catch (e) {
      print('Error accessing SharedPreferences: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splashLogo.png',
              width: screenWidth * 0.4,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error, size: 50, color: Colors.red),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Docs Management',
              style: TextStyle(
                fontSize: 24,
                color: Color(0XFF1998d5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
