import 'package:flutter/material.dart';
import 'package:tripmate_mobile/widgets/custom_header.dart';
import 'new_planning.dart'; // Pastikan file ini punya class NewPlanningPageBody dengan parameter onSave

class RencanaScreen extends StatelessWidget {
  const RencanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            CustomHeader(location: "Denpasar, Bali"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: TambahRencana(),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahRencana extends StatelessWidget {
  const TambahRencana({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rencana Perjalanan Kamu!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kumpulkan semua rencana seru di satu tempat!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPlanningPageBody(
                      onSave: (Map<String, String> data, int? id) {
                        // Gantilah bagian ini sesuai logika penyimpanan datamu
                        print('Data disimpan: $data, ID: $id');
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 20, color: Colors.white),
              label: const Text(
                'Tambah Rencana Baru',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
