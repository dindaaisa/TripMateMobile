import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

// Models
import 'models/user_model.dart';
import 'models/landing_page_model.dart';
import 'models/rencana_model.dart';
import 'models/hotel_model.dart'; // Berisi HotelModel & HotelOptionsModel

// Screens umum
import 'package:tripmate_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/login_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/signup_screen.dart';
import 'package:tripmate_mobile/widgets/home_navigation.dart';

// Screens admin
import 'admin/main_admin_screen.dart';
import 'admin/pages/dashboard/dashboard_page.dart';
import 'admin/pages/dashboard/ubah_landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registrasi adapter model jika belum terdaftar
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(LandingPageModelAdapter().typeId)) {
    Hive.registerAdapter(LandingPageModelAdapter());
  }
  if (!Hive.isAdapterRegistered(RencanaModelAdapter().typeId)) {
    Hive.registerAdapter(RencanaModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HotelModelAdapter().typeId)) {
    Hive.registerAdapter(HotelModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HotelOptionsModelAdapter().typeId)) {
    Hive.registerAdapter(HotelOptionsModelAdapter());
  }

  // Debug: hapus semua box saat pengembangan (opsional)
  if (kDebugMode) {
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('activeUserBox');
    await Hive.deleteBoxFromDisk('landingPageBox');
    await Hive.deleteBoxFromDisk('rencanaBox');
    await Hive.deleteBoxFromDisk('hotelBox');
    await Hive.deleteBoxFromDisk('hotelOptionsBox');
    print("🧹 Semua box dihapus karena mode debug aktif");
  }

  // Buka semua box Hive
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<UserModel>('activeUserBox');
  await Hive.openBox<LandingPageModel>('landingPageBox');
  await Hive.openBox<RencanaModel>('rencanaBox');
  await Hive.openBox<HotelModel>('hotelBox');
  await Hive.openBox<HotelOptionsModel>('hotelOptionsBox');

  // Tambahkan akun default jika belum ada
  final userBox = Hive.box<UserModel>('users');
  if (userBox.isEmpty) {
    await userBox.addAll([
      UserModel(name: 'Admin', email: 'admin@gmail.com', password: 'admin123', role: 'admin'),
      UserModel(name: 'Dinda Aisa', email: 'user@gmail.com', password: '12345678', role: 'user'),
    ]);
    print("✅ Akun default ditambahkan");
  }

  // Tambahkan konten default landing page
  final landingPageBox = Hive.box<LandingPageModel>('landingPageBox');
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

  // Tambahkan data default badge & fasilitas hotel
  final hotelOptionsBox = Hive.box<HotelOptionsModel>('hotelOptionsBox');
  if (hotelOptionsBox.isEmpty) {
    final defaultFacilities = [
      'Wi-Fi',
      'Breakfast',
      'Kolam Renang',
      'Gym',
      'Parkir',
      'AC',
    ];
    final defaultBadges = ['Populer', 'Rekomendasi', 'Baru'];

    hotelOptionsBox.put(
      0,
      HotelOptionsModel(
        badges: defaultBadges,
        facilities: defaultFacilities,
      ),
    );
    print("✅ Opsi badge & fasilitas default ditambahkan");
  }

  /// Simpan daftar fasilitas beserta ikon (untuk digunakan di dropdown admin)
  /// Gunakan map ini dalam screen admin saat membuat dropdown:
  Map<String, IconData> facilitiesMap = {
    'Wi-Fi': Icons.wifi,
    'Breakfast': Icons.free_breakfast,
    'Kolam Renang': Icons.pool,
    'Gym': Icons.fitness_center,
    'Parkir': Icons.local_parking,
    'AC': Icons.ac_unit,
  };

  // Tentukan screen awal berdasarkan user aktif
  final activeUserBox = Hive.box<UserModel>('activeUserBox');
  Widget initialScreen = const OnBoardingScreen();

  if (activeUserBox.isNotEmpty) {
    final currentUser = activeUserBox.getAt(0);
    if (currentUser != null) {
      initialScreen = currentUser.role == 'admin'
          ? const MainAdminScreen()
          : const HomeNavigation();
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
