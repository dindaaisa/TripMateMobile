import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';

class CardAkomodasi extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback? onTap; // <--- Tambahkan onTap

  const CardAkomodasi({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    ImageProvider getHotelImage() {
      if (hotel.imageBase64.isNotEmpty) {
        try {
          return MemoryImage(base64Decode(hotel.imageBase64));
        } catch (e) {
          return const NetworkImage("https://placehold.co/167x118");
        }
      }
      return const NetworkImage("https://placehold.co/167x118");
    }

    final formatter = NumberFormat.decimalPattern('id');
    final hargaFormatted = "Rp ${formatter.format(hotel.harga)}";

    return GestureDetector(
      onTap: onTap, // <--- Panggil onTap saat card ditekan
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto hotel
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image(
                image: getHotelImage(),
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama hotel
                  Text(
                    hotel.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Lokasi
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.black54),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          hotel.lokasi,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Rating & review
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Color(0xFFFFC107)),
                      const SizedBox(width: 2),
                      Text(
                        "${hotel.rating.toStringAsFixed(1)} (${hotel.reviewCount} reviews)",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8F98A8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Harga (formatted)
                  Text(
                    hargaFormatted,
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}