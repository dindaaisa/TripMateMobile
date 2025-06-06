import 'package:flutter/material.dart';

class NavbarAdmin extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavbarAdmin({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: 'Kelola',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Akun',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      selectedFontSize: screenWidth > 375 ? 13 : 11,
      unselectedFontSize: screenWidth > 375 ? 12 : 10,
      iconSize: screenWidth > 375 ? 26 : 23,
      onTap: onTap,
    );
  }
}