import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart'; // Pastikan import model UserModel

class AkomodasiWidget extends StatelessWidget {
  final UserModel currentUser;

  const AkomodasiWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hotel, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Akomodasi untuk ${currentUser.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${currentUser.email}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          const Text(
            'Konten akomodasi disesuaikan dengan akun Anda.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
