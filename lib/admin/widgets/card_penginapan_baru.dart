import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';

class CardPenginapanBaru extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Map<String, IconData> facilitiesMap;

  const CardPenginapanBaru({
    super.key,
    required this.hotel,
    required this.facilitiesMap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id');
    final imageBytes = hotel.imageBase64.isNotEmpty ? base64Decode(hotel.imageBase64) : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar hotel
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes,
                    width: 130,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 130,
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
          ),

          // Konten kanan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama hotel
                  Text(
                    hotel.nama,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${hotel.rating.toStringAsFixed(1)} (205 reviews)',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Fasilitas
                  Wrap(
                    spacing: 6,
                    children: hotel.fasilitas.take(4).map((fasilitas) {
                      IconData icon = facilitiesMap[fasilitas] ?? Icons.check_circle_outline;
                      return Icon(icon, size: 16, color: Colors.grey[700]);
                    }).toList(),
                  ),
                  const SizedBox(height: 6),

                  // Tipe
                  Row(
                    children: [
                      const Icon(Icons.hotel, size: 14, color: Color(0xFFDC2626)),
                      const SizedBox(width: 4),
                      Text(
                        hotel.tipe,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Lokasi
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.lokasi,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Badge
                  if (hotel.badge.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: hotel.badge.map((badge) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.5, color: Color(0xFFDC2626)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 6),

                  // Harga
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Mulai dari ',
                          style: TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
                        ),
                        TextSpan(
                          text: 'Rp ${formatter.format(hotel.harga)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tombol Edit & Hapus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        icon: Icons.edit,
                        label: 'Edit',
                        color: const Color(0xFFF0AA14),
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 6),
                      _buildActionButton(
                        icon: Icons.delete,
                        label: 'Hapus',
                        color: const Color(0xFFDC2626),
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
