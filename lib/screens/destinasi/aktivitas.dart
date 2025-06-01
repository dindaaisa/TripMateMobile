import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class AktivitasSeruWidget extends StatelessWidget {
  final UserModel currentUser;

  const AktivitasSeruWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Aktivitas Seru untuk ${currentUser.name}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
