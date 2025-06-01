import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class RiwayatScreen extends StatelessWidget {
  final UserModel currentUser;

  const RiwayatScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Riwayat milik: ${currentUser.name}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
