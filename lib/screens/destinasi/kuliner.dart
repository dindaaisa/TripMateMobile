import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class KulinerWidget extends StatelessWidget {
  final UserModel currentUser;

  const KulinerWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Kuliner Favorit untuk ${currentUser.name}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
