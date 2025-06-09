import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';

class CardTipeKamar extends StatelessWidget {
  final KamarModel kamar;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Map<String, IconData> facilitiesMap;

  const CardTipeKamar({
    super.key,
    required this.kamar,
    required this.facilitiesMap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id');
    final imageBytes = kamar.imageBase64.isNotEmpty ? base64Decode(kamar.imageBase64) : null;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.28 + 38;
    final imageHeight = screenWidth * 0.34 + 70;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 10),
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
          // Gambar tipe kamar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: imageWidth,
                    height: imageHeight,
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
                  // Nama tipe kamar
                  Text(
                    kamar.nama,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),

                  // Ukuran & Kapasitas
                  Row(
                    children: [
                      const Icon(Icons.square_foot, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        "${kamar.ukuran} m²",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${kamar.kapasitas} tamu",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Fasilitas
                  Wrap(
                    spacing: 6,
                    children: kamar.fasilitas.take(4).map((fasilitas) {
                      IconData icon = facilitiesMap[fasilitas] ?? Icons.check_circle_outline;
                      return Icon(icon, size: 16, color: Colors.grey[700]);
                    }).toList(),
                  ),
                  const SizedBox(height: 7),

                  // Tipe Kasur
                  Row(
                    children: [
                      const Icon(Icons.king_bed, size: 14, color: Color(0xFFDC2626)),
                      const SizedBox(width: 4),
                      Text(
                        kamar.tipeKasur,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Badges kamar (multi)
                  if (kamar.badges.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: kamar.badges.map((badge) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.5, color: Color(0xFFDC2626)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.red[50],
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),

                  // Harga
                  Text(
                    'Rp ${formatter.format(kamar.harga)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 9),

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