import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';
import 'package:tripmate_mobile/models/tiket_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class AktivitasTersedia extends StatefulWidget {
  final AktivitasModel aktivitas;
  final UserModel? currentUser;

  const AktivitasTersedia({
    Key? key,
    required this.aktivitas,
    this.currentUser,
  }) : super(key: key);

  @override
  State<AktivitasTersedia> createState() => _AktivitasTersediaState();
}

class _AktivitasTersediaState extends State<AktivitasTersedia> {
  late List<DateTime> tanggalPilihan;
  int selectedTanggalIdx = 0;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    tanggalPilihan = List.generate(
      7,
      (i) => DateTime(today.year, today.month, today.day + i),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TiketAktivitasModel>('tiketAktivitasBox').listenable(),
      builder: (context, Box<TiketAktivitasModel> tiketBox, _) {
        // Filter tiket sesuai aktivitasId DAN user aktif bila tersedia
        final List<TiketAktivitasModel> tiketList = tiketBox.values.where((tiket) {
          final cocokAktivitas = tiket.aktivitasId == widget.aktivitas.key.toString();
          final cocokUser = widget.currentUser == null
              ? true
              : (tiket.aktivitasId == widget.currentUser!.email);
          return cocokAktivitas && cocokUser;
        }).toList();

        final formatter = NumberFormat.decimalPattern('id');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tiket yang tersedia",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              // Pilihan tanggal horizontal
              SizedBox(
                height: 54,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tanggalPilihan.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    if (idx == 0) {
                      // Calendar icon
                      return GestureDetector(
                        onTap: () {
                          // Bisa diisi date picker jika ingin
                        },
                        child: Container(
                          width: 54,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFDC2626),
                              width: 1.6,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFDC2626),
                            size: 24,
                          ),
                        ),
                      );
                    } else {
                      final tgl = tanggalPilihan[idx - 1];
                      final hari = DateFormat.EEEE('id_ID').format(tgl); // ex: Senin
                      final tanggal = DateFormat('d MMM', 'id_ID').format(tgl);   // ex: 15 Apr
                      final isSelected = selectedTanggalIdx == (idx - 1);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTanggalIdx = idx - 1;
                          });
                        },
                        child: Container(
                          width: 95,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFDC2626) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFDC2626),
                              width: 1.6,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                hari,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFFDC2626),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                tanggal,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFFDC2626),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 17),
              // Card tiket tersedia
              if (tiketList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text("Belum ada tiket tersedia.")),
                )
              else ...tiketList.map((tiket) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 11,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.10),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Info tiket
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tiket.namaTiket,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Rp ${formatter.format(tiket.harga)}",
                                style: const TextStyle(
                                  color: Color(0xFFDC2626),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              if (tiket.deskripsi.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    tiket.deskripsi,
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Tombol Tambahkan
                        SizedBox(
                          width: 90,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              // Tambah ke rencana atau keranjang, implementasi sesuai kebutuhan
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                            ),
                            child: const Text(
                              'Tambahkan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}