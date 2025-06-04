import 'dart:convert';
import 'package:flutter/material.dart';
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
    final imageBytes = base64Decode(hotel.imageBase64);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Gambar hotel dari atas ke bawah
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.memory(
              imageBytes,
              width: 120,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama hotel
                  Text(
                    hotel.nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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

                  // Badge
                  Row(
                    children: [
                      const Icon(Icons.hotel, size: 14, color: Color(0xFFDC2626)),
                      const SizedBox(width: 4),
                      Text(
                        hotel.badge,
                        style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
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
                ],
              ),
            ),
          ),

          // Kolom kanan (harga dan tombol)
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Harga
                RichText(
                  text: TextSpan(
                    text: 'Mulai dari\n',
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 10,
                    ),
                    children: [
                      TextSpan(
                        text: 'Rp ${hotel.harga}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),

                // Tombol edit dan hapus
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                )
              ],
            ),
          )
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
          border: Border.all(color: color.withOpacity(0.8), width: 0.5),
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
