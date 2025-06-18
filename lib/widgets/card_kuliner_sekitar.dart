import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/kuliner_model.dart';
import 'package:intl/intl.dart';

class CardKulinerSekitar extends StatelessWidget {
  final KulinerModel kuliner;
  const CardKulinerSekitar({
    Key? key,
    required this.kuliner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil lebar layar seperti CardAkomodasiElegan
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 32) / 2.5;

    return SizedBox(
      width: cardWidth,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Sesuaikan dengan CardAkomodasi
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar di atas, menyatu dalam card
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: kuliner.imageBase64.isNotEmpty
                  ? Image.memory(
                      base64Decode(kuliner.imageBase64),
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, color: Colors.grey, size: 40),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kuliner.nama,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.black54),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          kuliner.lokasiDetail,
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFACC15), size: 12),
                      const SizedBox(width: 2),
                      Text(
                        kuliner.formattedRating,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF8F98A8)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${kuliner.jumlahReview} ulasan)",
                        style: const TextStyle(fontSize: 10, color: Color(0xFF8F98A8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Mulai dari Rp ${_formatHarga(kuliner.hargaMulaiDari)}",
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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

  String _formatHarga(int harga) {
    final f = NumberFormat.decimalPattern('id');
    return f.format(harga);
  }
}