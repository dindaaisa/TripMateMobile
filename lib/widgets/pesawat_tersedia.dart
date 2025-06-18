import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pesawat_model.dart';
import 'package:tripmate_mobile/widgets/tambah_dalam_rencana.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';

class PesawatTersedia extends StatelessWidget {
  final List<PesawatModel> daftarPesawat;
  final UserModel currentUser;
  final List<RencanaModel> userPlans;
  final DateTime selectedStartDate;
  final DateTime selectedEndDate;
  final void Function(RencanaModel)? onPlanSelected;
  final VoidCallback? onAddPlanningBaru;

  const PesawatTersedia({
    Key? key,
    required this.daftarPesawat,
    required this.currentUser,
    required this.userPlans,
    required this.selectedStartDate,
    required this.selectedEndDate,
    this.onPlanSelected,
    this.onAddPlanningBaru,
  }) : super(key: key);

  String getBandaraCode(String value) {
    if (value.toLowerCase().contains("jakarta")) return "CGK";
    if (value.toLowerCase().contains("surabaya")) return "SUB";
    if (value.toLowerCase().contains("denpasar")) return "DPS";
    if (value.toLowerCase().contains("yogyakarta")) return "JOG";
    if (value.toLowerCase().contains("bandung")) return "BDO";
    if (value.toLowerCase().contains("semarang")) return "SRG";
    if (value.toLowerCase().contains("serang")) return "BXT";
    if (value.toLowerCase().contains("mataram")) return "AMI";
    if (value.toLowerCase().contains("kupang")) return "KOE";
    return value.length >= 3 ? value.substring(0, 3).toUpperCase() : value.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (daftarPesawat.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "Tidak ada penerbangan tersedia.",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: daftarPesawat.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        final pesawat = daftarPesawat[index];
        return _PesawatCard(
          pesawat: pesawat,
          getBandaraCode: getBandaraCode,
          onTambah: (selectedPesawat) {
            showTambahDalamRencanaModal(
              context: context,
              currentUser: currentUser,
              userPlans: userPlans,
              onPlanSelected: (plan) => onPlanSelected?.call(plan),
              onAddPlanningBaru: onAddPlanningBaru,
              selectedStartDate: selectedStartDate,
              selectedEndDate: selectedEndDate,
              selectedPesawat: selectedPesawat, // <-- Tambahkan argumen ini!
            );
          },
        );
      },
    );
  }
}

class _PesawatCard extends StatelessWidget {
  final PesawatModel pesawat;
  final void Function(PesawatModel)? onTambah;
  final String Function(String) getBandaraCode;

  const _PesawatCard({
    Key? key,
    required this.pesawat,
    required this.onTambah,
    required this.getBandaraCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFormat = NumberFormat("#,###", "id_ID");
    final waktuBerangkat = pesawat.waktu;
    final waktuTiba = waktuBerangkat.add(Duration(minutes: pesawat.durasi));
    final jamBerangkat = DateFormat('HH.mm').format(waktuBerangkat);
    final jamTiba = DateFormat('HH.mm').format(waktuTiba);
    final durasiText = pesawat.durasi >= 60
        ? "${pesawat.durasi ~/ 60} Jam ${pesawat.durasi % 60} Menit"
        : "${pesawat.durasi % 60} Menit";

    const greyColor = Color(0xFFBDBDBD);
    const greyText = Color(0xFF8F98A8);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 52,
                    height: 32,
                    child: pesawat.imageBase64.isNotEmpty
                        ? Image.memory(
                            base64Decode(pesawat.imageBase64),
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, st) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.flight, color: Colors.red, size: 24),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.flight, color: Colors.grey, size: 22),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pesawat.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: greyColor),
                  onPressed: () {},
                  tooltip: "Lihat detail maskapai",
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jamBerangkat,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      getBandaraCode(pesawat.asal),
                      style: const TextStyle(
                        fontSize: 12,
                        color: greyText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: greyColor,
                                width: 2.5,
                              ),
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 3,
                              color: greyColor,
                            ),
                          ),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.5),
                        child: Text(
                          durasiText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      jamTiba,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      getBandaraCode(pesawat.tujuan),
                      style: const TextStyle(
                        fontSize: 12,
                        color: greyText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.luggage, size: 18, color: greyColor),
                SizedBox(width: 4),
                Text(
                  "30 Kg",
                  style: TextStyle(
                    fontSize: 13,
                    color: greyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 14),
                Icon(Icons.no_food, size: 18, color: greyColor),
                SizedBox(width: 4),
                Text(
                  "Tidak Termasuk Sarapan",
                  style: TextStyle(
                    fontSize: 13,
                    color: greyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Rp ${moneyFormat.format(pesawat.harga)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFFDC2626),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const TextSpan(
                            text: "/orang",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    SizedBox(
                      height: 36,
                      width: 125,
                      child: ElevatedButton(
                        onPressed: () => onTambah?.call(pesawat),
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}