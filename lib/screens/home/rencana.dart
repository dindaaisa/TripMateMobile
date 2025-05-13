import 'package:flutter/material.dart';

class RencanaScreen extends StatelessWidget {
  const RencanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana'),
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Rencana Kosong'),
      ),
    );
  }
}
