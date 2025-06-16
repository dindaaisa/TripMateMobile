import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';

class RiwayatPage extends StatelessWidget {
  final String currentUserId;
  const RiwayatPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final rencanaBox = Hive.box<RencanaModel>('rencanaBox');
    final now = DateTime.now();

    // Ambil semua rencana user yang sudah dibayar
    final List<RencanaModel> userTrips = rencanaBox.values
        .where((r) => r.userId == currentUserId && r.isPaid)
        .toList();

    // Kategori trip
    final List<RencanaModel> upcomingTrips = userTrips.where((r) {
      final start = DateTime.tryParse(r.startDate);
      return start != null && start.isAfter(now);
    }).toList();

    final List<RencanaModel> finishedTrips = userTrips.where((r) {
      final end = DateTime.tryParse(r.endDate);
      return end != null && end.isBefore(now);
    }).toList();

    final List<RencanaModel> ongoingTrips = userTrips.where((r) {
      final start = DateTime.tryParse(r.startDate);
      final end = DateTime.tryParse(r.endDate);
      return start != null && end != null && (start.isBefore(now) || start.isAtSameMomentAs(now)) && (end.isAfter(now) || end.isAtSameMomentAs(now));
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + screenWidth * 0.06,
              bottom: screenWidth * 0.06,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Riwayat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              children: [
                ..._riwayatSection("Trip yang Sedang Berjalan", ongoingTrips),
                ..._riwayatSection("Trip Mendatangmu", upcomingTrips),
                ..._riwayatSection("Trip yang Sudah Kamu Jalani", finishedTrips),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _riwayatSection(String title, List<RencanaModel> trips) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      if (trips.isEmpty)
        const Padding(
          padding: EdgeInsets.only(left: 4, top: 12, bottom: 14),
          child: Text("Belum ada perjalanan.", style: TextStyle(color: Colors.grey)),
        ),
      ...trips.map((trip) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RencanaCardView(plan: trip),
          )),
    ];
  }
}

class RencanaCardView extends StatelessWidget {
  final RencanaModel plan;
  const RencanaCardView({super.key, required this.plan});

  String formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      final hari = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"][date.weekday - 1];
      return "$hari, ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} ${date.year.toString().substring(2)}";
    } catch (_) {
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final akomodasi = (plan.akomodasi == null || plan.akomodasi!.trim().isEmpty) ? "-" : plan.akomodasi!;
    final transportasi = (plan.transportasi == null || plan.transportasi!.trim().isEmpty) ? "-" : plan.transportasi!;
    final aktivitasSeru = (plan.aktivitasSeru == null || plan.aktivitasSeru!.trim().isEmpty) ? "-" : plan.aktivitasSeru!;
    final kuliner = (plan.kuliner == null || plan.kuliner!.trim().isEmpty) ? "-" : plan.kuliner!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              height: 120,
              child: plan.imageBase64 != null && plan.imageBase64!.isNotEmpty
                  ? Image.memory(
                      base64Decode(plan.imageBase64!),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, color: Colors.red, size: 30),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.photo, color: Colors.white, size: 30),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.hotel, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          akomodasi,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.flight, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          transportasi,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.surfing, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          aktivitasSeru,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.restaurant, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kuliner,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Text(
                        "${formatTanggal(plan.startDate)} - ${formatTanggal(plan.endDate)}",
                        style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, size: 12, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Text(
                        '${plan.people} orang',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tambahkan total harga
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Text(
                        'Total: Rp ${NumberFormat.decimalPattern('id').format(plan.biayaAkomodasi ?? 0)}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF666666), fontWeight: FontWeight.w600),
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
}