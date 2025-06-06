import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class AkomodasiWidget extends StatelessWidget {
  final UserModel currentUser;

  const AkomodasiWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.16;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel, size: iconSize, color: Colors.red),
          const SizedBox(height: 18),
          Text(
            'Akomodasi untuk ${currentUser.name}',
            style: TextStyle(
              fontSize: screenWidth > 375 ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${currentUser.email}',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 18),
          const Text(
            'Konten akomodasi disesuaikan dengan akun Anda.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}