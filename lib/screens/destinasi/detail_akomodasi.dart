import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/widgets/detail_akomodasi_header.dart';
import 'package:tripmate_mobile/widgets/detail_akomodasi_fasilitas_area.dart';
import 'package:tripmate_mobile/widgets/kamar_tersedia.dart';

class DetailAkomodasi extends StatelessWidget {
  final HotelModel hotel;
  const DetailAkomodasi({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailAkomodasiHeader(hotel: hotel),
            DetailAkomodasiFacilityArea(hotel: hotel),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Kamar yang tersedia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KamarTersediaWidget(hotel: hotel),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}