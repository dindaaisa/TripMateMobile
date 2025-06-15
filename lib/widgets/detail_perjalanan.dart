import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';

class DetailPerjalananCard extends StatelessWidget {
  final RencanaModel plan;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DetailPerjalananCard({
    Key? key,
    required this.plan,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  String formatTanggalHari(String t) {
    try {
      final date = DateTime.parse(t);
      final hari = [
        "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"
      ][date.weekday - 1];
      final bulan = [
        "", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
        "Juli", "Agustus", "September", "Oktober", "November", "Desember"
      ];
      return "$hari\n${date.day} ${bulan[date.month]} ${date.year}";
    } catch (_) {
      return t;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (plan.imageBase64 != null && plan.imageBase64!.isNotEmpty) {
      imageWidget = Image.memory(
        base64Decode(plan.imageBase64!),
        width: 125,
        height: 159,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => Container(
          width: 125,
          height: 159,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
        ),
      );
    } else {
      imageWidget = Container(
        width: 125,
        height: 159,
        color: Colors.grey[300],
        child: const Icon(Icons.photo, color: Colors.white, size: 45),
      );
    }

    return Center(
      child: Container(
        width: 370,
        height: 159,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x33000000),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Background putih
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Gambar kiri
            Positioned(
              left: 0,
              top: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: imageWidget,
              ),
            ),
            // Isi konten kanan
            Positioned(
              left: 125,
              top: 0,
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul perjalanan
                    Center(
                      child: Text(
                        plan.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Tanggal berangkat & pulang
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatTanggalHari(plan.startDate),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          " - ",
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            formatTanggalHari(plan.endDate),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Kota asal dan tujuan
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.origin,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 15, color: Color(0xFF8C8C8C)),
                        Expanded(
                          child: Text(
                            plan.destination,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Durasi hari & orang
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 13, color: Color(0xFF8C8C8C)),
                        const SizedBox(width: 4),
                        Text(
                          "${plan.sumDate} Hari 1 Malam",
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.people_outline, size: 13, color: Color(0xFF8C8C8C)),
                        const SizedBox(width: 2),
                        Text(
                          "${plan.people} Orang",
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Tombol Edit & Hapus
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onEdit != null)
                          ElevatedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit, size: 12, color: Colors.white),
                            label: const Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF0AA14),
                              minimumSize: const Size(44, 22),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                  color: Color(0xFFF1AB14),
                                  width: 0.7,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        if (onEdit != null) const SizedBox(width: 8),
                        if (onDelete != null)
                          ElevatedButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, size: 12, color: Colors.white),
                            label: const Text(
                              'Hapus',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              minimumSize: const Size(44, 22),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                  color: Color(0xFFDC2626),
                                  width: 0.7,
                                ),
                              ),
                              elevation: 0,
                            ),
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
}