import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/mobil_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/widgets/tambah_dalam_rencana.dart';

class MobilTersedia extends StatelessWidget {
  final List<MobilModel> daftarMobil;
  final int jumlahPenumpang;
  final List<RencanaModel> userPlans;
  final UserModel currentUser;
  final DateTime selectedStartDate;
  final DateTime selectedEndDate;
  final VoidCallback? onAddPlanningBaru;
  final void Function(RencanaModel)? onPlanSelected;

  const MobilTersedia({
    Key? key,
    required this.daftarMobil,
    required this.jumlahPenumpang,
    required this.userPlans,
    required this.currentUser,
    required this.selectedStartDate,
    required this.selectedEndDate,
    this.onAddPlanningBaru,
    this.onPlanSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtered = daftarMobil.where((mobil) {
      final kapasitas = int.tryParse(
        mobil.jumlahPenumpang.split(' ').first
      ) ?? 0;
      return kapasitas >= jumlahPenumpang;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            "Tidak ada mobil yang sesuai.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        final mobil = filtered[index];
        return _MobilCard(
          mobil: mobil,
          onTambah: (mobilSelected) {
            showTambahDalamRencanaModal(
              context: context,
              currentUser: currentUser,
              userPlans: userPlans, // PASTIKAN INI DARI HIVE!
              onPlanSelected: onPlanSelected ?? (_) {},
              onAddPlanningBaru: onAddPlanningBaru,
              selectedStartDate: selectedStartDate,
              selectedEndDate: selectedEndDate,
              selectedPesawat: null,
              selectedKamar: null,
              selectedMobil: mobilSelected,
              akomodasiNama: null,
              imageAkomodasi: null,
              totalHargaAkomodasi: null,
              sumAkomodasiDate: null,
            );
          },
        );
      },
    );
  }
}

class _MobilCard extends StatelessWidget {
  final MobilModel mobil;
  final void Function(MobilModel) onTambah;

  const _MobilCard({
    Key? key,
    required this.mobil,
    required this.onTambah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFormat = NumberFormat.decimalPattern('id');

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Merk mobil & info button
            Row(
              children: [
                Expanded(
                  child: Text(
                    mobil.merk,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Color(0xFFBDBDBD)),
                  onPressed: () {
                    // TODO: tampilkan detail info mobil jika diperlukan
                  },
                ),
              ],
            ),
            const SizedBox(height: 3),
            // Row: Foto mobil, fitur, harga, tombol
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar mobil
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 180,
                    height: 130,
                    color: Colors.grey[100],
                    child: mobil.imageBase64.isNotEmpty
                        ? Image.memory(
                            base64Decode(mobil.imageBase64),
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, st) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.directions_car, color: Colors.red, size: 32),
                            ),
                          )
                        : const Icon(Icons.directions_car, size: 32, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                // Fitur mobil, harga, dan tombol
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Penumpang
                      Row(
                        children: [
                          const Icon(Icons.group_outlined, color: Color(0xFF8F98A8), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            mobil.jumlahPenumpang,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8F98A8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Transmisi
                      Row(
                        children: [
                          const Icon(Icons.settings, color: Color(0xFF8F98A8), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            mobil.tipeMobil,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8F98A8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Harga dan button: rata kanan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Rp ${moneyFormat.format(mobil.hargaSewa)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Color(0xFFDC2626),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const TextSpan(
                                      text: "/hari",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 36,
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: () => onTambah(mobil),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDC2626),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "Tambahkan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}