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
      backgroundColor: const Color(0xFFF5F5F5), // Sama dengan rencana.dart
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
              padding: const EdgeInsets.all(16), // Konsisten dengan rencana.dart
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
        child: Text(
          title, 
          style: const TextStyle(
            fontSize: 18, // Sama dengan rencana.dart
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 12), // Konsisten spacing
      if (trips.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 14),
          child: Center(
            child: Text(
              "Belum ada perjalanan.", 
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ...trips.map((trip) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ModernRiwayatCard(plan: trip), // Gunakan card yang sama
          )),
    ];
  }
}

// Card yang sama dengan ModernRencanaCard tapi untuk riwayat
class ModernRiwayatCard extends StatelessWidget {
  final RencanaModel plan;

  const ModernRiwayatCard({
    super.key,
    required this.plan,
  });

  String formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      final hari = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"][date.weekday - 1];
      return "$hari, ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} ${date.year.toString().substring(2)}";
    } catch (_) {
      return tanggal;
    }
  }

  // Method untuk menggabungkan multiple items dengan koma
  String _combineItems(List<String?> items) {
    final validItems = items.where((item) => item != null && item.trim().isNotEmpty).toList();
    return validItems.isEmpty ? "-" : validItems.join(", ");
  }

  // Method untuk mendapatkan status badge berdasarkan tanggal
  Widget _getStatusBadge() {
    final now = DateTime.now();
    final start = DateTime.tryParse(plan.startDate);
    final end = DateTime.tryParse(plan.endDate);

    if (start != null && end != null) {
      if (start.isAfter(now)) {
        // Trip mendatang
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Mendatang",
            style: TextStyle(
              fontSize: 10,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else if (end.isBefore(now)) {
        // Trip selesai
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Selesai",
            style: TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else {
        // Trip sedang berjalan
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Sedang Berjalan",
            style: TextStyle(
              fontSize: 10,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Gabungkan transportasi dan mobil jika keduanya ada
    final transportasiItems = <String?>[];
    if (plan.transportasi != null && plan.transportasi!.trim().isNotEmpty) {
      transportasiItems.add(plan.transportasi);
    }
    if (plan.mobil != null && plan.mobil!.trim().isNotEmpty) {
      transportasiItems.add(plan.mobil);
    }
    final transportasiText = _combineItems(transportasiItems);

    // Gabungkan aktivitas dan kuliner jika keduanya ada
    final aktivitasItems = <String?>[];
    if (plan.aktivitasSeru != null && plan.aktivitasSeru!.trim().isNotEmpty) {
      aktivitasItems.add(plan.aktivitasSeru);
    }
    if (plan.kuliner != null && plan.kuliner!.trim().isNotEmpty) {
      aktivitasItems.add(plan.kuliner);
    }
    final aktivitasText = _combineItems(aktivitasItems);

    final akomodasi = (plan.akomodasi == null || plan.akomodasi!.trim().isEmpty) ? "-" : plan.akomodasi!;

    // Perhitungan total biaya
    final int total = (plan.biayaAkomodasi ?? 0) + (plan.hargaPesawat ?? 0) + (plan.hargaMobil ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar persegi di sebelah kiri
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              height: 100,
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
          
          // Konten di sebelah kanan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dengan status badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${plan.name} (${plan.sumDate})",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _getStatusBadge(),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Informasi dengan icon dalam satu baris
                  if (akomodasi != "-")
                    _buildInfoRow(
                      icon: Icons.business,
                      text: akomodasi,
                      color: const Color(0xFF666666),
                    ),
                  
                  if (transportasiText != "-")
                    _buildInfoRow(
                      icon: Icons.flight,
                      text: transportasiText,
                      color: const Color(0xFF666666),
                    ),
                  
                  if (aktivitasText != "-")
                    _buildInfoRow(
                      icon: Icons.restaurant,
                      text: aktivitasText,
                      color: const Color(0xFF666666),
                    ),
                  
                  const SizedBox(height: 4),
                  
                  // Tanggal dan jumlah orang
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    text: "${formatTanggal(plan.startDate)} - ${formatTanggal(plan.endDate)}",
                    color: const Color(0xFF666666),
                  ),
                  
                  _buildInfoRow(
                    icon: Icons.people,
                    text: "${plan.people} orang",
                    color: const Color(0xFF666666),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Total biaya
                  _buildInfoRow(
                    icon: Icons.attach_money,
                    text: "Total: Rp ${NumberFormat.decimalPattern('id').format(total)}",
                    color: const Color(0xFFDC2626),
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
