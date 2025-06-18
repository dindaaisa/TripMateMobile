import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/pesawat_model.dart';
import 'package:tripmate_mobile/models/mobil_model.dart';

class PreviewTransportasiCard extends StatelessWidget {
  final PesawatModel? pesawat;
  final MobilModel? mobil;
  final VoidCallback? onDeletePesawat;
  final VoidCallback? onDeleteMobil;
  final VoidCallback? onAddMobil;

  const PreviewTransportasiCard({
    Key? key,
    this.pesawat,
    this.mobil,
    this.onDeletePesawat,
    this.onDeleteMobil,
    this.onAddMobil,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [];
    if (pesawat != null) {
      cards.add(_PreviewCardPesawat(
        pesawat: pesawat!,
        onDelete: onDeletePesawat,
      ));
    }
    if (mobil != null) {
      cards.add(_PreviewCardMobil(
        mobil: mobil!,
        onDelete: onDeleteMobil,
      ));
    } else {
      cards.add(_CardAddMobil(
        onAdd: onAddMobil,
      ));
    }

    if (cards.isEmpty) {
      return const SizedBox();
    }

    // Card style: pesawat lebih tinggi (225), mobil lebih rendah (160)
    final double pesawatCardHeight = 230;
    final double mobilCardHeight = 170;

    return cards.length == 1
        ? Center(
            child: SizedBox(
              width: 400,
              height: pesawat != null ? pesawatCardHeight : mobilCardHeight,
              child: cards.first,
            ),
          )
        : SizedBox(
            height: pesawatCardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (ctx, i) => Center(
                child: SizedBox(
                  width: 400,
                  height: i == 0 && pesawat != null ? pesawatCardHeight : mobilCardHeight,
                  child: cards[i],
                ),
              ),
            ),
          );
  }
}

class _PreviewCardPesawat extends StatelessWidget {
  final PesawatModel pesawat;
  final VoidCallback? onDelete;

  const _PreviewCardPesawat({
    Key? key,
    required this.pesawat,
    this.onDelete,
  }) : super(key: key);

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
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _tombolAksi(
                      icon: Icons.delete,
                      label: 'Hapus',
                      color: const Color(0xFFDC2626),
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
    required VoidCallback? onTap,
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

class _PreviewCardMobil extends StatelessWidget {
  final MobilModel mobil;
  final VoidCallback? onDelete;

  const _PreviewCardMobil({
    Key? key,
    required this.mobil,
    this.onDelete,
  }) : super(key: key);

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kiri: Label & gambar mobil
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: mobil.imageBase64.isNotEmpty
                    ? Image.memory(
                        base64Decode(mobil.imageBase64),
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 120,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.directions_car, size: 40),
                      ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Kanan: Informasi dan tombol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mobil.merk,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.event_seat, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${mobil.jumlahPenumpang}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.drive_eta, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      mobil.tipeMobil,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Tombol Hapus saja
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _tombolAksi(
                      icon: Icons.delete,
                      label: 'Hapus',
                      color: const Color(0xFFDC2626),
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
    required VoidCallback? onTap,
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

// Card Add Mobil
class _CardAddMobil extends StatelessWidget {
  final VoidCallback? onAdd;
  const _CardAddMobil({this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle, color: Color(0xFFDC2626)),
          label: const Text(
            "Tambahkan Mobil",
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFDC2626), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}