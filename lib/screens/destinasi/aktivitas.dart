import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class AktivitasSeruWidget extends StatelessWidget {
  final UserModel currentUser;
  final String? location;

  const AktivitasSeruWidget({super.key, required this.currentUser, this.location});

  @override
  Widget build(BuildContext context) {
    // Ganti dengan tampilan aktivitas seru sesuai kebutuhanmu
    return Center(
      child: Text(
        'Daftar aktivitas seru di $location',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}