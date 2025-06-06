import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class PaketWidget extends StatelessWidget {
  final UserModel currentUser;

  const PaketWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Text(
        'Paket Wisata untuk ${currentUser.name}',
        style: TextStyle(fontSize: screenWidth > 375 ? 16 : 15),
      ),
    );
  }
}