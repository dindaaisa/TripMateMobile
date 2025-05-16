import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart';

// Screens
import 'package:tripmate_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/login_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/signup_screen.dart';
import 'package:tripmate_mobile/screens/navigation_bar.dart';
import 'package:tripmate_mobile/screens/destinasi/destinasi.dart';
import 'package:tripmate_mobile/screens/rencana/rencana.dart';
import 'package:tripmate_mobile/screens/riwayat/riwayat.dart';
import 'package:tripmate_mobile/screens/profil/profil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  var userBox = await Hive.openBox<UserModel>('users');

  // Debug print
  print("Jumlah user di Hive saat startup: ${userBox.length}");

  if (userBox.isEmpty) {
    await userBox.addAll([
      UserModel(
        name: 'Admin',
        email: 'admin@gmail.com',
        password: 'admin123',
        role: 'admin',
      ),
      UserModel(
        name: 'Dinda Aisa',
        email: 'user1',
        password: '12345678',
        role: 'user',
      ),
    ]);
    print("Akun default berhasil ditambahkan (${userBox.length} total user)");
  }

  runApp(const TripMateApp());
}

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
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
