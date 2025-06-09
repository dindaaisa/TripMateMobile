import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';

class DetailAkomodasiHeader extends StatelessWidget {
  final HotelModel hotel;
  const DetailAkomodasiHeader({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final imageBytes = hotel.imageBase64.isNotEmpty ? base64Decode(hotel.imageBase64) : null;

    return Stack(
      children: [
        // Background image
        Container(
          width: double.infinity,
          height: 286,
          decoration: BoxDecoration(
            image: imageBytes != null
                ? DecorationImage(image: MemoryImage(imageBytes), fit: BoxFit.cover)
                : const DecorationImage(
                    image: NetworkImage("https://placehold.co/413x286"),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // Gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 90,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.56),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // BACK & MORE icons, NOT TOO CLOSE TO TOP
        Positioned(
          left: 0,
          right: 0,
          top: 32,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back
                Container(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                // More
                Container(
                  child: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        // Hotel Name
        Positioned(
          left: 16,
          bottom: 44,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            child: Text(
              hotel.nama,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(offset: Offset(0, 2), blurRadius: 10, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),
        // Rating
        Positioned(
          left: 16,
          bottom: 22,
          child: Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
              const SizedBox(width: 4),
              Text(
                "${hotel.rating.toStringAsFixed(1)} (${hotel.reviewCount} reviews)",
                style: const TextStyle(
                  color: Color(0xFF8F98A8),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(offset: Offset(0, 1), blurRadius: 6, color: Colors.black45),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}