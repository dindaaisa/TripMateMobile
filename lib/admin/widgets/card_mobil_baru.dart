import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/mobil_model.dart';

class CardMobilBaru extends StatelessWidget {
  final MobilModel mobil;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardMobilBaru({
    Key? key,
    required this.mobil,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
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
                const SizedBox(height: 10),
                // Harga
                Text(
                  'Rp ${formatHarga(mobil.hargaSewa)}/hari',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(height: 12),
                // Tombol Edit & Hapus (disamakan dengan CardPesawatBaru)
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