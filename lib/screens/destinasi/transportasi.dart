import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class TransportasiWidget extends StatelessWidget {
  final UserModel currentUser;

  const TransportasiWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Transportasi untuk ${currentUser.name}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
