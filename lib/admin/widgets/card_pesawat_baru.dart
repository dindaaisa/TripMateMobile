import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/pesawat_model.dart';

class CardPesawatBaru extends StatelessWidget {
  final PesawatModel pesawat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardPesawatBaru({
    super.key,
    required this.pesawat,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (pesawat.imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(pesawat.imageBase64);
      } catch (_) {
        imageBytes = null;
      }
    }

    DateTime waktuBerangkat = pesawat.waktu;
    DateTime waktuTiba = waktuBerangkat.add(Duration(minutes: pesawat.durasi));

    String formatJam(DateTime dt) => DateFormat('HH.mm').format(dt);

    int jam = pesawat.durasi ~/ 60;
    int menit = pesawat.durasi % 60;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom jam + arrow
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatJam(waktuBerangkat),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.flight_takeoff,
                size: 28,
              ),
              const SizedBox(height: 4),
              Container(
                width: 2,
                height: 20,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.flight_land,
                size: 28,
              ),
              const SizedBox(height: 10),
              Text(
                formatJam(waktuTiba),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Kolom isi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pesawat.asal,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Gantikan icon pesawat dengan gambar logo maskapai kecil jika ada
                    if (imageBytes != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.memory(
                          imageBytes,
                          width: 80,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Icon(
                        Icons.flight,
                        size: 16,
                      ),
                    const SizedBox(width: 6),
                    Text(
                      pesawat.nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$jam Jam $menit Menit',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.airline_seat_recline_extra,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      pesawat.kelas,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pesawat.tujuan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp ${NumberFormat("#,###", "id_ID").format(pesawat.harga)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _tombolAksi(
                      icon: Icons.edit,
                      label: 'Edit',
                      color: Colors.orange,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 6),
                    _tombolAksi(
                      icon: Icons.delete,
                      label: 'Hapus',
                      color: Color(0xFFDC2626),
                      onTap: onDelete,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolAksi({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}