import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart'; // Model + Adapter Hive kamu

// Screens
import 'package:tripmate_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/login_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/signup_screen.dart';
import 'package:tripmate_mobile/screens/home/destinasi.dart'; // ganti dari akomodasi
import 'package:tripmate_mobile/screens/home/rencana.dart';
import 'package:tripmate_mobile/screens/home/riwayat.dart';
import 'package:tripmate_mobile/screens/home/profil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Registrasi Adapter
  Hive.registerAdapter(UserModelAdapter());

  // Buka box
  await Hive.openBox<UserModel>('users');

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
        '/home': (context) => const DestinasiScreen(),
        '/rencana': (context) => const RencanaScreen(),
        '/riwayat': (context) => const RiwayatScreen(),
        '/profil': (context) => const ProfilScreen(),
      },
    );
  }
}
