import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class ProfilScreen extends StatelessWidget {
  final UserModel currentUser;

  const ProfilScreen({super.key, required this.currentUser});

  void _showLogoutConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final box = Hive.box<UserModel>('activeUserBox');
      await box.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout berhasil')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        children: [
          // Header, full sampai ke atas layar
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + screenWidth * 0.06,
              bottom: screenWidth * 0.06,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Profil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          // Konten Profil
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.07),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(currentUser.role),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _showLogoutConfirmation(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}