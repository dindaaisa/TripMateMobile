import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/widgets/card_akomodasi.dart';
import 'package:tripmate_mobile/screens/destinasi/detail_akomodasi.dart'; // Import detail screen

class CardAkomodasiElegan extends StatelessWidget {
  final List<HotelModel> hotels;
  const CardAkomodasiElegan({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 32) / 2.5;

    if (hotels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
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
    );
  }
}