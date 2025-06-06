import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';
import '../screens/destinasi/destinasi.dart';
import '../screens/rencana/rencana.dart';
import '../screens/riwayat/riwayat.dart';
import '../screens/profil/profil.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
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

    final List<Widget> screens = [
      DestinasiScreen(currentUser: _currentUser!),
      RencanaScreen(currentUser: _currentUser!),
      RiwayatScreen(currentUser: _currentUser!),
      ProfilScreen(currentUser: _currentUser!),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
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