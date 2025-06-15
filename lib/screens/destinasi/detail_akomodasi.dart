import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/widgets/detail_akomodasi_header.dart';
import 'package:tripmate_mobile/widgets/detail_akomodasi_fasilitas_area.dart';
import 'package:tripmate_mobile/widgets/kamar_tersedia.dart';
import 'package:hive/hive.dart';

class DetailAkomodasiScreen extends StatelessWidget {
  final String hotelNama;
  final String? kamarNama; // nullable
  final UserModel? currentUser;

  const DetailAkomodasiScreen({
    super.key,
    required this.hotelNama,
    this.kamarNama,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data hotel dari Hive berdasarkan hotelNama
    final hotelBox = Hive.box<HotelModel>('hotelBox');
    final hotel = hotelBox.values.firstWhere(
      (h) => h.nama == hotelNama,
      orElse: () => throw Exception("Hotel tidak ditemukan"),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailAkomodasiHeader(hotel: hotel),
            DetailAkomodasiFacilityArea(hotel: hotel),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kamar yang tersedia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KamarTersediaWidget(
                hotel: hotel,
                currentUser: currentUser,
                selectedKamarNama: kamarNama,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}