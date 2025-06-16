import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';
import '../screens/destinasi/destinasi.dart';
import '../screens/rencana/rencana.dart';
import '../screens/riwayat/riwayat.dart';
import '../screens/profil/profil.dart';

class HomeNavigation extends StatefulWidget {
  final int initialTabIndex;
  const HomeNavigation({super.key, this.initialTabIndex = 0});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  UserModel? _currentUser;
  String? _destinasiInitialCategory;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
    _checkUserLogin();
  }

  void _checkUserLogin() async {
    final box = await Hive.openBox<UserModel>('activeUserBox');
    if (box.isEmpty) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } else {
      setState(() {
        _currentUser = box.getAt(0);
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 0) _destinasiInitialCategory = null;
    });
  }

  // Untuk dipanggil dari child, misal RencanaScreen/NewPlanningPageBody, agar langsung buka kategori tertentu di Destinasi
  void openDestinasiTab(String initialCategory) {
    setState(() {
      _selectedIndex = 0;
      _destinasiInitialCategory = initialCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading || _currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Widget getScreen(int index) {
      switch (index) {
        case 0:
          return DestinasiScreen(
            currentUser: _currentUser!,
            initialCategory: _destinasiInitialCategory ?? 'Akomodasi',
          );
        case 1:
          return RencanaScreen(
            currentUser: _currentUser!,
            onCategoryTap: openDestinasiTab,
          );
        case 2:
          return RiwayatPage(currentUserId: _currentUser!.email);
        case 3:
          return ProfilScreen(currentUser: _currentUser!);
        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      body: getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFDC2626),
        unselectedItemColor: Colors.grey,
        selectedFontSize: screenWidth > 375 ? 13 : 11,
        unselectedFontSize: screenWidth > 375 ? 12 : 10,
        iconSize: screenWidth > 375 ? 26 : 23,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Destinasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Rencana',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}