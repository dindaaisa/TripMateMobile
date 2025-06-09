import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class TransportasiWidget extends StatelessWidget {
  final UserModel currentUser;
  final String? location;

  const TransportasiWidget({super.key, required this.currentUser, this.location});

  @override
  Widget build(BuildContext context) {
    // Ganti dengan tampilan transportasi sesuai kebutuhanmu
    return Center(
      child: Text(
        'Fitur transportasi di $location',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}