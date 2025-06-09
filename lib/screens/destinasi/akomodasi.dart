import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/widgets/card_akomodasi.dart';
import 'package:tripmate_mobile/widgets/banner_akomodasi.dart';
import 'package:tripmate_mobile/widgets/card_akomodasi_elegan.dart';
import 'package:tripmate_mobile/widgets/card_tipe_akomodasi.dart';
import 'package:tripmate_mobile/screens/destinasi/detail_akomodasi.dart'; // Import detail page

class AkomodasiWidget extends StatelessWidget {
  final UserModel currentUser;
  final String? location;

  const AkomodasiWidget({super.key, required this.currentUser, this.location});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 32) / 2.5;

    return ValueListenableBuilder(
      valueListenable: Hive.box<HotelModel>('hotelBox').listenable(),
      builder: (context, Box<HotelModel> box, _) {
        final List<HotelModel> hotels = location == null
            ? box.values.toList()
            : box.values.where((hotel) => hotel.lokasi == location).toList();

        if (hotels.isEmpty) {
          return const Center(
            child: Text('Belum ada penginapan di lokasi ini.'),
          );
        }

        // Filter hotel elegan (harga > 500000)
        final List<HotelModel> eleganHotels = hotels.where((hotel) => hotel.harga > 500000).toList();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul di atas card hotel utama
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 6, top: 18),
                child: Text(
                  "Yuk, rasakan suasana baru!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              // List Card Hotel (horizontal)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: hotels.length,
                    separatorBuilder: (context, idx) => const SizedBox(width: 14),
                    itemBuilder: (context, idx) {
                      final hotel = hotels[idx];
                      return SizedBox(
                        width: cardWidth,
                        child: CardAkomodasi(
                          hotel: hotel,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailAkomodasi(hotel: hotel),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const BannerAkomodasi(),

              // Card Akomodasi Elegan (horizontal)
              if (eleganHotels.isNotEmpty) ...[
                const SizedBox(height: 22),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    "Staycation elegan yang bikin betah!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                CardAkomodasiElegan(hotels: eleganHotels),
              ],

              // Card Tipe Akomodasi (grid)
              const SizedBox(height: 28),
              const CardTipeAkomodasi(),

              const SizedBox(height: 28),
            ],
          ),
        );
      },
    );
  }
}