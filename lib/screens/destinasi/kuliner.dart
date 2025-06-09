import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class KulinerWidget extends StatelessWidget {
  final UserModel currentUser;
  final String? location;

  const KulinerWidget({super.key, required this.currentUser, this.location});

  @override
  Widget build(BuildContext context) {
    // Ganti dengan tampilan kuliner sesuai kebutuhanmu
    return Center(
      child: Text(
        'Daftar kuliner di $location',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}