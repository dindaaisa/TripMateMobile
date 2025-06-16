import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';
import 'package:hive/hive.dart';
// Tambahkan import berikut:
import 'package:tripmate_mobile/screens/rencana/konfirmasi_pembayaran.dart';

class KonfirmasiRencanaPage extends StatelessWidget {
  final RencanaModel rencana;

  const KonfirmasiRencanaPage({super.key, required this.rencana});

  @override
  Widget build(BuildContext context) {
    final hotelBox = Hive.isBoxOpen('hotelBox')
        ? Hive.box<HotelModel>('hotelBox')
        : null;
    final kamarBox = Hive.isBoxOpen('kamarBox')
        ? Hive.box<KamarModel>('kamarBox')
        : null;

    HotelModel? hotel;
    KamarModel? kamar;

    if (hotelBox != null && rencana.akomodasi != null) {
      try {
        hotel = hotelBox.values.firstWhere((h) => h.nama == rencana.akomodasi);
      } catch (_) {}
    }
    if (hotel != null && kamarBox != null && rencana.kamarNama != null) {
      try {
        kamar = kamarBox.values.firstWhere(
          (k) => k.hotelId == hotel!.key.toString() && k.nama == rencana.kamarNama,
        );
      } catch (_) {}
    }

    final formatter = NumberFormat.decimalPattern('id');

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      extendBody: true,
      body: Stack(
        children: [
          Column(
            children: [
              // HEADER -- SAMA PERSIS DENGAN new_planning.dart
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 46, bottom: 24, left: 0, right: 0),
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      "Konfirmasi Rencana",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // ISI CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        '${rencana.name} (${rencana.sumDate} Hari${int.tryParse(rencana.sumDate) != null && int.parse(rencana.sumDate) > 1 ? ' ${(int.parse(rencana.sumDate) - 1)} Malam' : ''})',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Akomodasi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: hotel?.imageBase64 != null && hotel!.imageBase64.isNotEmpty
                                ? Image.memory(
                                    base64Decode(hotel!.imageBase64),
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.cover,
                                  )
                                : rencana.imageBase64 != null && rencana.imageBase64!.isNotEmpty
                                    ? Image.memory(
                                        base64Decode(rencana.imageBase64!),
                                        width: 95,
                                        height: 95,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 95,
                                        height: 95,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.hotel, color: Colors.white, size: 36),
                                      ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel?.nama ?? rencana.akomodasi ?? "-",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                if (hotel != null)
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber[700], size: 15),
                                      const SizedBox(width: 2),
                                      Text(
                                        "${hotel.rating.toStringAsFixed(1)} (${hotel.reviewCount} reviews)",
                                        style: const TextStyle(
                                          color: Color(0xFF8F98A8),
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (hotel != null) ...[
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.hotel, color: Color(0xFFDC2626), size: 15),
                                      const SizedBox(width: 3),
                                      Text(
                                        hotel.tipe,
                                        style: const TextStyle(
                                          color: Color(0xFFDC2626),
                                          fontSize: 11.5,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: Color(0xFF8C8C8C)),
                                      const SizedBox(width: 3),
                                      Text(
                                        hotel.lokasi,
                                        style: const TextStyle(
                                          color: Color(0xFF8C8C8C),
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (kamar != null) ...[
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.meeting_room, size: 14, color: Color(0xFF8C8C8C)),
                                      const SizedBox(width: 3),
                                      Text(
                                        "1 x ${kamar.nama}",
                                        style: const TextStyle(
                                          color: Color(0xFF8C8C8C),
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (kamar.tipeKasur.isNotEmpty)
                                    Row(
                                      children: [
                                        const Icon(Icons.king_bed, size: 14, color: Color(0xFF8C8C8C)),
                                        const SizedBox(width: 3),
                                        Flexible(
                                          child: Text(
                                            kamar.tipeKasur,
                                            style: const TextStyle(
                                              color: Color(0xFF8C8C8C),
                                              fontSize: 11,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (kamar.badges.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3, bottom: 2),
                                      child: Row(
                                        children: kamar.badges.take(1).map((badge) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                            margin: const EdgeInsets.only(right: 6),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  width: 0.5,
                                                  color: Color(0xFFDC2626),
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              badge,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 17, color: Colors.black54),
                          const SizedBox(width: 3),
                          const Text(
                            "Total",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "1 x Rp ${formatter.format(rencana.biayaAkomodasi ?? 0)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, size: 17, color: Colors.black54),
                          const SizedBox(width: 4),
                          const Text(
                            "Total Akomodasi",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Rp ${formatter.format(rencana.biayaAkomodasi ?? 0)}",
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Spacer agar bar reserve tidak mepet card
              const SizedBox(height: 26),
            ],
          ),
          // BarReserve floating di bawah, dengan SafeArea supaya tidak mepet home bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 12),
              top: false,
              child: BarReserve(
                total: rencana.biayaAkomodasi ?? 0,
                onKonfirmasi: () {
                  // Navigasi ke halaman konfirmasi pembayaran
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KonfirmasiPembayaranPage(rencana: rencana),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarReserve extends StatelessWidget {
  final int total;
  final VoidCallback? onKonfirmasi;

  const BarReserve({super.key, required this.total, this.onKonfirmasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 25,
            child: GestureDetector(
              onTap: onKonfirmasi,
              child: Container(
                width: 180,
                height: 42,
                decoration: ShapeDecoration(
                  color: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Konfirmasi Pembayaran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 37,
            child: Text(
              'Rp ${NumberFormat.decimalPattern('id').format(total)}',
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}