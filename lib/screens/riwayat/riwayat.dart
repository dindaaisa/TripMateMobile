import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class RiwayatScreen extends StatelessWidget {
  final UserModel currentUser;

  const RiwayatScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: screenWidth * 0.14, // responsive height
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Text(
            'Riwayat milik: ${currentUser.name}',
            style: TextStyle(fontSize: screenWidth > 375 ? 16 : 15),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}