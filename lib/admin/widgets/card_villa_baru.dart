import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/villa_model.dart';

class CardVillaBaru extends StatelessWidget {
  final VillaModel villa;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Map<String, IconData> facilitiesMap;

  const CardVillaBaru({
    super.key,
    required this.villa,
    required this.facilitiesMap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id');
    final imageBytes = villa.imageBase64.isNotEmpty ? base64Decode(villa.imageBase64) : null;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - (screenWidth * 0.03 * 2);
    final imageWidth = cardWidth * 0.38;
    final imageHeight = 150.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar villa
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
                      child: const Icon(Icons.villa, size: 40, color: Colors.grey),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama villa
                    Text(
                      villa.nama,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Rating + reviews (hanya tampilkan jika ada)
                    if (villa.rating > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, size: 15, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            "${villa.rating.toStringAsFixed(1)} (${villa.jumlahReview} reviews)",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    if (villa.rating > 0) const SizedBox(height: 4),

                    // Fasilitas (max 4)
                    if (villa.fasilitas.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: villa.fasilitas.take(4).map((fasilitas) {
                          IconData icon = facilitiesMap[fasilitas] ?? Icons.check_circle_outline;
                          return Icon(icon, size: 16, color: Colors.grey[700]);
                        }).toList(),
                      ),
                    if (villa.fasilitas.isNotEmpty) const SizedBox(height: 4),

                    // Tipe Villa (hanya tampilkan jika ada)
                    if (villa.tipeVilla.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.villa, size: 15, color: Color(0xFFDC2626)),
                          const SizedBox(width: 4),
                          Text(
                            villa.tipeVilla,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (villa.tipeVilla.isNotEmpty) const SizedBox(height: 4),

                    // Kapasitas dan Jumlah Kamar (hanya tampilkan jika ada)
                    if (villa.kapasitas > 0 || villa.jumlahKamar > 0)
                      Row(
                        children: [
                          if (villa.kapasitas > 0) ...[
                            const Icon(Icons.people, size: 15, color: Color(0xFFDC2626)),
                            const SizedBox(width: 4),
                            Text(
                              "${villa.kapasitas} Orang",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFDC2626),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (villa.kapasitas > 0 && villa.jumlahKamar > 0)
                            const Text(" • ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          if (villa.jumlahKamar > 0) ...[
                            const Icon(Icons.bed, size: 15, color: Color(0xFFDC2626)),
                            const SizedBox(width: 4),
                            Text(
                              "${villa.jumlahKamar} Kamar",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFDC2626),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    if (villa.kapasitas > 0 || villa.jumlahKamar > 0) const SizedBox(height: 4),

                    // Lokasi utama
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 15, color: Colors.red),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            villa.lokasi,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Lokasi detail (alamat lengkap) - hanya tampilkan jika ada
                    if (villa.lokasiDetail.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.place, size: 13, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                villa.lokasiDetail,
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Area villa - hanya tampilkan jika ada
                    if (villa.areaVilla.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ...villa.areaVilla.take(1).map(
                                    (area) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_iconDataFromName(area.iconName), size: 13, color: Colors.grey),
                                          const SizedBox(width: 2),
                                          Text(
                                            "${area.nama} (${area.jarakKm.toStringAsFixed(1)} km)",
                                            style: const TextStyle(fontSize: 10, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (villa.areaVilla.length > 1)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text("...", style: TextStyle(fontSize: 13, color: Colors.grey)),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Badge & Harga
                    const Spacer(),

                    // Badge - hanya tampilkan jika ada
                    if (villa.badge.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: villa.badge.map((badge) {
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
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Harga - hanya tampilkan jika ada
                    if (villa.hargaPerMalam > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Mulai dari ',
                                style: TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
                              ),
                              TextSpan(
                                text: 'Rp ${formatter.format(villa.hargaPerMalam)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

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
      ),
    );
  }

  static IconData _iconDataFromName(String name) {
    switch (name) {
      case "location_on":
        return Icons.location_on;
      case "beach_access":
        return Icons.beach_access;
      case "shopping_bag":
        return Icons.shopping_bag;
      case "restaurant":
        return Icons.restaurant;
      case "park":
        return Icons.park;
      case "museum":
        return Icons.museum;
      case "local_activity":
        return Icons.local_activity;
      case "store":
        return Icons.store;
      default:
        return Icons.location_on;
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 15),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}