import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan ini

// Models
import 'models/user_model.dart';
import 'models/landing_page_model.dart';
import 'models/rencana_model.dart';
import 'models/hotel_model.dart';
import 'models/kamar_model.dart'; // Tambahkan untuk tipe kamar

// Screens umum
import 'package:tripmate_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/login_screen.dart';
import 'package:tripmate_mobile/screens/login_signup/signup_screen.dart';
import 'package:tripmate_mobile/widgets/home_navigation.dart';

// Screens admin
import 'admin/main_admin_screen.dart';
import 'admin/pages/dashboard/dashboard_page.dart';
import 'admin/pages/dashboard/ubah_landing_page.dart';

// Shared global state for location
import 'shared/location_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale date format untuk intl, AGAR DateFormat('d MMM', 'id_ID') tidak error
  await initializeDateFormatting('id_ID', null);

  await Hive.initFlutter();

  // Register Hive adapters
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
  if (!Hive.isAdapterRegistered(AreaAkomodasiModelAdapter().typeId)) {
    Hive.registerAdapter(AreaAkomodasiModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HotelOptionsModelAdapter().typeId)) {
    Hive.registerAdapter(HotelOptionsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(KamarModelAdapter().typeId)) {
    Hive.registerAdapter(KamarModelAdapter());
  }

  // Hapus box untuk development/debug mode (reset data)
  if (kDebugMode) {
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('activeUserBox');
    await Hive.deleteBoxFromDisk('landingPageBox');
    await Hive.deleteBoxFromDisk('rencanaBox');
    await Hive.deleteBoxFromDisk('hotelBox');
    await Hive.deleteBoxFromDisk('hotelOptionsBox');
    await Hive.deleteBoxFromDisk('kamarBox');
    await Hive.deleteBoxFromDisk('lokasiBox');
    await Hive.deleteBoxFromDisk('selectedLocationBox');
  }

  // Open all necessary boxes
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<UserModel>('activeUserBox');
  await Hive.openBox<LandingPageModel>('landingPageBox');
  await Hive.openBox<RencanaModel>('rencanaBox');
  await Hive.openBox<HotelModel>('hotelBox');
  await Hive.openBox<HotelOptionsModel>('hotelOptionsBox');
  await Hive.openBox<KamarModel>('kamarBox');
  final lokasiBox = await Hive.openBox('lokasiBox');
  final selectedLocationBox = await Hive.openBox('selectedLocationBox');

  // Inisialisasi data user (kalau kosong)
  final userBox = Hive.box<UserModel>('users');
  if (userBox.isEmpty) {
    await userBox.addAll([
      UserModel(name: 'Admin', email: 'admin@gmail.com', password: 'admin123', role: 'admin'),
      UserModel(name: 'Dinda Aisa', email: 'user@gmail.com', password: '12345678', role: 'user'),
    ]);
  }

  // Inisialisasi data landing page (kalau kosong)
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
  }

  // Inisialisasi data opsi hotel (kalau kosong)
  final hotelOptionsBox = Hive.box<HotelOptionsModel>('hotelOptionsBox');
  if (hotelOptionsBox.isEmpty) {
    final defaultFacilities = ['Wi-Fi', 'Breakfast', 'Kolam Renang', 'Gym', 'Parkir', 'AC'];
    final defaultBadges = ['Populer', 'Rekomendasi', 'Baru'];
    final defaultTipe = ['Hotel', 'Villa'];

    hotelOptionsBox.put(
      0,
      HotelOptionsModel(
        tipe: defaultTipe,
        badge: defaultBadges,
        facilities: defaultFacilities,
      ),
    );
  }

  // Inisialisasi lokasi (untuk dropdown lokasi pada header) dengan format "Kota, Provinsi"
  if (lokasiBox.get('list') == null || (lokasiBox.get('list') as List).isEmpty) {
    lokasiBox.put('list', [
      "Denpasar, Bali",
      "Jakarta, DKI Jakarta",
      "Bandung, Jawa Barat",
      "Surabaya, Jawa Timur",
      "Medan, Sumatera Utara"
    ]);
  }

  // Inisialisasi lokasi terakhir yang dipilih jika belum ada
  if (selectedLocationBox.get('selected') == null) {
    selectedLocationBox.put('selected', "Denpasar, Bali");
  }
  // Set value ke ValueNotifier global
  LocationState.selectedLocation.value = selectedLocationBox.get('selected') as String;

  // Cek user aktif
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
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
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