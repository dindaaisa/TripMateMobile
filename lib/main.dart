import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

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

  // Registrasi adapter
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(LandingPageModelAdapter().typeId)) {
    Hive.registerAdapter(LandingPageModelAdapter());
  }
  if (!Hive.isAdapterRegistered(RencanaModelAdapter().typeId)) {
    Hive.registerAdapter(RencanaModelAdapter());
  }

  // Hanya hapus data saat debug (opsional)
  if (kDebugMode) {
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('activeUserBox');
    await Hive.deleteBoxFromDisk('landingPageBox');
    await Hive.deleteBoxFromDisk('rencanaBox');
    print("🧹 Semua box dihapus karena mode debug aktif");
  }

  // Buka semua box yang diperlukan
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<UserModel>('activeUserBox');
  await Hive.openBox<LandingPageModel>('landingPageBox');
  await Hive.openBox<RencanaModel>('rencanaBox');

  var userBox = Hive.box<UserModel>('users');
  var landingPageBox = Hive.box<LandingPageModel>('landingPageBox');

  // Tambahkan akun default jika kosong
  if (userBox.isEmpty) {
    await userBox.addAll([
      UserModel(name: 'Admin', email: 'admin@gmail.com', password: 'admin123', role: 'admin'),
      UserModel(name: 'Dinda Aisa', email: 'user@gmail.com', password: '12345678', role: 'user'),
    ]);
    print("✅ Akun default ditambahkan");
  }

  // Tambahkan landing page default
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

  // Tentukan screen awal berdasarkan activeUser
  final activeUserBox = Hive.box<UserModel>('activeUserBox');
  Widget initialScreen = const OnBoardingScreen();

  if (activeUserBox.isNotEmpty) {
    final currentUser = activeUserBox.getAt(0);
    if (currentUser != null) {
      if (currentUser.role == 'admin') {
        initialScreen = const MainAdminScreen();
      } else {
        initialScreen = const HomeNavigation(); // Ambil user di dalam StatefulWidget
      }
    }
  }

  runApp(TripMateApp(initialScreen: initialScreen));
}

class TripMateApp extends StatelessWidget {
  final Widget initialScreen;
  const TripMateApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: initialScreen,
      routes: {
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
