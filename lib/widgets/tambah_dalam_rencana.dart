import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import '../models/pesawat_model.dart';
import '../models/kamar_model.dart';
import '../models/mobil_model.dart';

void showTambahDalamRencanaModal({
  required BuildContext context,
  required UserModel currentUser,
  required List<RencanaModel> userPlans,
  required void Function(RencanaModel) onPlanSelected,
  VoidCallback? onAddPlanningBaru,
  required DateTime selectedStartDate,
  required DateTime selectedEndDate,
  PesawatModel? selectedPesawat,
  KamarModel? selectedKamar,
  MobilModel? selectedMobil,
  String? akomodasiNama,
  String? imageAkomodasi,
  int? totalHargaAkomodasi,
  String? sumAkomodasiDate,
}) {
  // Filter rencana yang belum dibayar saja
  final unpaidPlans = userPlans.where((plan) => 
    plan.isPaid == false || plan.isPaid == null
  ).toList();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // Header & Close
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tambahkan item ke rencana perjalanan",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 10),
              
              // Ringkasan item yang dipilih
              if (selectedMobil != null)
                Column(
                  children: [
                    const Text("Mobil yang dipilih:", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${selectedMobil.merk} | ${selectedMobil.tipeMobil}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text("Kapasitas: ${selectedMobil.jumlahPenumpang} orang"),
                          Text("Harga: Rp ${selectedMobil.hargaSewa.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              
              if (selectedPesawat != null)
                Column(
                  children: [
                    const Text("Pesawat yang dipilih:", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${selectedPesawat.nama} | ${selectedPesawat.kelas}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text("${selectedPesawat.asal} → ${selectedPesawat.tujuan}"),
                          Text("Harga: Rp ${selectedPesawat.harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              
              if (selectedKamar != null && akomodasiNama != null)
                Column(
                  children: [
                    const Text("Akomodasi yang dipilih:", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            akomodasiNama,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text("Kamar: ${selectedKamar.nama}"),
                          Text("Harga: Rp ${(totalHargaAkomodasi ?? selectedKamar.harga).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              
              // Tombol tambah planning baru
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Tambah Planning Baru', style: TextStyle(fontSize: 15, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (onAddPlanningBaru != null) onAddPlanningBaru();
                  },
                ),
              ),
              const SizedBox(height: 20),
              
              // Info jumlah rencana yang tersedia
              if (unpaidPlans.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Tersedia ${unpaidPlans.length} rencana yang belum dibayar",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Daftar rencana perjalanan yang belum dibayar
              if (unpaidPlans.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Semua rencana sudah dibayar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Rencana yang sudah dibayar dapat dilihat di halaman Riwayat.\nSilakan buat rencana baru untuk menambahkan item.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              
              if (unpaidPlans.isNotEmpty)
                ...unpaidPlans.map(
                  (plan) => Container(
                    margin: const EdgeInsets.only(bottom: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11),
                          ),
                          child: plan.imageBase64 != null && plan.imageBase64!.isNotEmpty
                              ? Image.memory(
                                  base64Decode(plan.imageBase64!),
                                  width: 90,
                                  height: 95,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    width: 90,
                                    height: 95,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, color: Colors.red),
                                  ),
                                )
                              : Container(
                                  width: 90,
                                  height: 95,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.photo, color: Colors.white),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plan.sumDate,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 12, color: Color(0xFFDC2626)),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${plan.startDate} - ${plan.endDate}",
                                      style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Status badge untuk rencana belum dibayar
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Belum Dibayar",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Color(0xFFDC2626), size: 32),
                          onPressed: () async {
                            try {
                              final box = Hive.box<RencanaModel>('rencanaBox');
                              final planKey = plan.key;
                              if (planKey == null) throw Exception("Plan key not found");

                              RencanaModel updatedPlan = plan;
                              
                              // PERBAIKAN: Hanya update field sesuai kategori, jangan timpa data lain
                              if (selectedMobil != null) {
                                // Hanya update field mobil, pertahankan semua data lainnya
                                updatedPlan = plan.copyWith(
                                  mobil: selectedMobil.merk,
                                  tipeMobil: selectedMobil.tipeMobil,
                                  hargaMobil: selectedMobil.hargaSewa,
                                  jumlahPenumpangMobil: selectedMobil.jumlahPenumpang,
                                  imageMobil: selectedMobil.imageBase64,
                                  // TIDAK update field lain seperti akomodasi, transportasi, dll
                                );
                              } 
                              else if (selectedPesawat != null) {
                                // Hanya update field transportasi/pesawat
                                int jumlahPenumpang = 1;
                                if (plan.people.isNotEmpty) {
                                  final n = int.tryParse(plan.people.trim());
                                  if (n != null && n > 0) jumlahPenumpang = n;
                                }
                                int totalHarga = selectedPesawat.harga * jumlahPenumpang;
                                
                                updatedPlan = plan.copyWith(
                                  transportasi: selectedPesawat.nama,
                                  kelasPesawat: selectedPesawat.kelas,
                                  hargaPesawat: totalHarga,
                                  asalPesawat: selectedPesawat.asal,
                                  tujuanPesawat: selectedPesawat.tujuan,
                                  waktuPesawat: selectedPesawat.waktu.toIso8601String(),
                                  durasiPesawat: selectedPesawat.durasi,
                                  imagePesawat: selectedPesawat.imageBase64,
                                  // TIDAK update field lain seperti akomodasi, mobil, dll
                                );
                              } 
                              else if (selectedKamar != null && akomodasiNama != null) {
                                // Hanya update field akomodasi
                                updatedPlan = plan.copyWith(
                                  akomodasi: akomodasiNama,
                                  kamarNama: selectedKamar.nama,
                                  biayaAkomodasi: totalHargaAkomodasi ?? selectedKamar.harga,
                                  // PENTING: Pertahankan imageBase64 existing jika tidak ada image akomodasi baru
                                  imageBase64: imageAkomodasi ?? plan.imageBase64,
                                  // TIDAK update startDate dan endDate kecuali diperlukan
                                  // startDate: selectedStartDate.toIso8601String().substring(0, 10),
                                  // sumDate: sumAkomodasiDate,
                                );
                              }

                              // Simpan perubahan ke Hive
                              await box.put(planKey, updatedPlan);

                              Navigator.pop(ctx);
                              onPlanSelected(updatedPlan);

                              // Tampilkan pesan sukses
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    selectedMobil != null
                                        ? "Mobil berhasil ditambahkan ke rencana '${plan.name}'"
                                        : selectedPesawat != null
                                            ? "Transportasi berhasil ditambahkan ke rencana '${plan.name}'"
                                            : "Akomodasi berhasil ditambahkan ke rencana '${plan.name}'"
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } catch (e) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Gagal menambahkan item ke rencana: ${e.toString()}"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
