import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';

class DetailAktivitasRinci extends StatelessWidget {
  final AktivitasModel aktivitas;
  const DetailAktivitasRinci({Key? key, required this.aktivitas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sesuaikan dengan field pada model. Ganti jika Anda punya field jamBuka/jamTutup/hariBuka yang berbeda
    final jamBuka = aktivitas.jamBuka ?? "-";
    final jamTutup = aktivitas.jamTutup ?? "-";
    final lokasiDetail = aktivitas.lokasiDetail;
    final deskripsi = aktivitas.deskripsi ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Aktivitas",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          // Baris jam buka
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.access_time, size: 18, color: Color(0xFF8F98A8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Buka | Setiap Hari $jamBuka-$jamTutup",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Baris lokasi detail
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 18, color: Color(0xFF8F98A8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lokasiDetail,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Baris deskripsi singkat
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.widgets, size: 18, color: Color(0xFF8F98A8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  deskripsi,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}