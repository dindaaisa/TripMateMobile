import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';
import 'package:intl/intl.dart';

class CardAktivitasList extends StatelessWidget {
  final void Function(AktivitasModel aktivitas)? onTap;

  const CardAktivitasList({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<AktivitasModel>('aktivitasBox').listenable(),
      builder: (context, Box<AktivitasModel> box, _) {
        if (box.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada aktivitas.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        final aktivitasList = box.values.toList();

        return SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: aktivitasList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final aktivitas = aktivitasList[index];
              return CardAktivitas(
                aktivitas: aktivitas,
                onTap: onTap != null ? () => onTap!(aktivitas) : null,
              );
            },
          ),
        );
      },
    );
  }
}

class CardAktivitas extends StatelessWidget {
  final AktivitasModel aktivitas;
  final VoidCallback? onTap;

  const CardAktivitas({Key? key, required this.aktivitas, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil lebar layar seperti CardAkomodasiElegan/CardKulinerSekitar
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 32) / 2.5;

    ImageProvider getAktivitasImage() {
      if (aktivitas.imageBase64.isNotEmpty) {
        try {
          return MemoryImage(base64Decode(aktivitas.imageBase64));
        } catch (e) {
          return const NetworkImage("https://placehold.co/167x118");
        }
      }
      return const NetworkImage("https://placehold.co/167x118");
    }

    return SizedBox(
      width: cardWidth,
      child: GestureDetector(
        onTap: onTap,
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
                child: aktivitas.imageBase64.isNotEmpty
                    ? Image.memory(
                        base64Decode(aktivitas.imageBase64),
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.local_activity, color: Colors.grey, size: 40),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama aktivitas
                    Text(
                      aktivitas.nama,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Lokasi detail/alamat
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.black54),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            aktivitas.lokasiDetail,
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
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
                        const Icon(Icons.star, color: Color(0xFFFACC15), size: 12),
                        const SizedBox(width: 2),
                        Text(
                          aktivitas.formattedRating,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8F98A8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(${aktivitas.jumlahReview} ulasan)",
                          style: const TextStyle(fontSize: 10, color: Color(0xFF8F98A8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Harga
                    Text(
                      "Mulai dari ${_formatHarga(aktivitas.harga)}",
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
      ),
    );
  }

  String _formatHarga(int harga) {
    final f = NumberFormat.decimalPattern('id');
    return 'Rp ${f.format(harga)}';
  }
}