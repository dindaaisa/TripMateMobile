import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class TransportasiWidget extends StatelessWidget {
  final UserModel currentUser;

  const TransportasiWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Text(
        'Transportasi untuk ${currentUser.name}',
        style: TextStyle(fontSize: screenWidth > 375 ? 16 : 15),
      ),
    );
  }
}