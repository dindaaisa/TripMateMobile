import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'models/user_model.dart';
import 'models/landing_page_model.dart';
import 'models/rencana_model.dart';

// Screens umum
import 'package:tripmate_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/login_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/signup_screen.dart';
import 'package:tripmate_mobile/widgets/home_navigation.dart';

// Screens admin
import 'admin/main_admin_screen.dart';
import 'admin/pages/dashboard_page.dart';
import 'admin/pages/ubah_landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Registrasi adapter jika belum
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(LandingPageModelAdapter().typeId)) {
    Hive.registerAdapter(LandingPageModelAdapter());
  }

  // Buka box hanya jika belum dibuka
  if (!Hive.isBoxOpen('users')) {
    await Hive.openBox<UserModel>('users');
  }
  if (!Hive.isBoxOpen('landingPageBox')) {
    await Hive.openBox<LandingPageModel>('landingPageBox');
  }

  var userBox = Hive.box<UserModel>('users');
  var landingPageBox = Hive.box<LandingPageModel>('landingPageBox');

  if (userBox.isEmpty) {
    userBox.addAll([
      UserModel(name: 'Admin', email: 'admin@gmail.com', password: 'admin123', role: 'admin'),
      UserModel(name: 'Dinda Aisa', email: 'user1', password: '12345678', role: 'user'),
    ]);
    print("✅ Akun default ditambahkan");
  }

  if (landingPageBox.isEmpty) {
    landingPageBox.putAll({
      0: LandingPageModel(
        title: 'Siap jalan-jalan dan ciptakan pengalaman seru?',
        description: 'Dengan TripMate, atur perjalananmu jadi lebih gampang dan menyenangkan.',
        imageBytes: null,
      ),
      1: LandingPageModel(
        title: 'Rencanain trip tanpa ribet bareng TripMate!',
        description: 'Cukup beberapa langkah, dan liburan impianmu siap dijalankan.',
        imageBytes: null,
      ),
    });
    print("✅ Konten default landing page ditambahkan");
  }

  Hive.registerAdapter(RencanaModelAdapter());
  await Hive.openBox<RencanaModel>('rencanaBox');

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
        '/home': (context) => const HomeNavigation(),
        '/adminHome': (context) => const MainAdminScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/ubahLandingPage': (context) => const UbahLandingPage(),
      },
    );
  }
}