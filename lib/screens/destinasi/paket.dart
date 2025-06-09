import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class PaketWidget extends StatelessWidget {
  final UserModel currentUser;
  final String? location;

  const PaketWidget({super.key, required this.currentUser, this.location});

  @override
  Widget build(BuildContext context) {
    // Ganti dengan tampilan paket wisata sesuai kebutuhanmu
    return Center(
      child: Text(
        'Paket wisata di $location',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}