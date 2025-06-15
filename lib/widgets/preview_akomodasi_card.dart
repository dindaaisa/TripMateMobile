import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/akomodasi_preview_model.dart';

class PreviewAkomodasiCard extends StatelessWidget {
  final AkomodasiPreviewModel preview;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const PreviewAkomodasiCard({
    super.key,
    required this.preview,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Lebar gambar sesuai garis oranye, bisa disesuaikan
    const double imageWidth = 145;
    // Padding kanan lebih kecil, agar hanya ada sedikit ruang putih di kanan
    const double contentRightPadding = 14; // kecil, tapi tetap ada space
    const double contentLeftPadding = 14;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0x20000000),
            blurRadius: 13,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar kiri, penuh sampai garis oranye
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: preview.imageBase64.isNotEmpty
                  ? Image.memory(
                      base64Decode(preview.imageBase64),
                      width: imageWidth,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: imageWidth,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.hotel, size: 50, color: Colors.grey),
                    ),
            ),
            // Konten kanan, padding kanan kecil supaya mentok ke garis biru (tapi masih ada sedikit spasi)
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(contentLeftPadding, 15, contentRightPadding, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama hotel + info icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            preview.namaHotel,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.5,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
                      ],
                    ),
                    // Rating & reviews
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFF0AA14), size: 17),
                          const SizedBox(width: 3),
                          Text(
                            "${preview.rating}",
                            style: const TextStyle(
                                color: Color(0xFFF0AA14),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              "(${preview.reviewCount} reviews)",
                              style: const TextStyle(
                                color: Color(0xFF8F98A8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Hotel merah
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.hotel, color: Color(0xFFDC2626), size: 18),
                          const SizedBox(width: 6),
                          Text(
                            preview.tipeHotel,
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Lokasi
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Color(0xFF8C8C8C), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              preview.lokasi,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8C8C8C),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Kamar
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.meeting_room, color: Color(0xFF8C8C8C), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "1 x ${preview.namaKamar}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8C8C8C),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tipe kasur
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.king_bed, color: Color(0xFF8C8C8C), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              preview.sizeKasur,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8C8C8C),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge
                    if (preview.badges.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 2),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 2,
                          children: preview.badges
                              .map((b) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Color(0xFFDC2626), width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      b,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFDC2626),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    // Button Hapus/Edit
                    Padding(
                      padding: const EdgeInsets.only(top: 9),
                      child: Row(
                        children: [
                          if (onEdit != null)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0AA14),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                              label: const Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: onEdit,
                            ),
                          if (onEdit != null && onDelete != null) const SizedBox(width: 8),
                          if (onDelete != null)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                              label: const Text(
                                "Hapus",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: onDelete,
                            ),
                        ],
                      ),
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
}