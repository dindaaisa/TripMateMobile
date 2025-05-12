import 'package:flutter/material.dart';
import 'package:tripmate_mobile/screens/onboarding_screen.dart';
import 'package:tripmate_mobile/screens/login_screen.dart';
import 'package:tripmate_mobile/screens/signup_screen.dart';

void main() {
  runApp(const TripMateApp());
}

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // karena desain putih
      initialRoute: '/',
      routes: {
          '/': (context) => const OnBoardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
        },
    );
  }
}
