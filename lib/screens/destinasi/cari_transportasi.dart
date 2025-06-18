import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/pesawat_model.dart';
import 'package:tripmate_mobile/models/mobil_model.dart';
import 'package:tripmate_mobile/widgets/pesawat_tersedia.dart';
import 'package:tripmate_mobile/widgets/mobil_tersedia.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';

class CariTransportasiArgs {
  final String asal;
  final String tujuan;
  final DateTime tanggalBerangkat;
  final DateTime? tanggalPulang;
  final int jumlahPenumpang;
  CariTransportasiArgs({
    required this.asal,
    required this.tujuan,
    required this.tanggalBerangkat,
    this.tanggalPulang,
    required this.jumlahPenumpang,
  });
}

class CariTransportasiPage extends StatefulWidget {
  final CariTransportasiArgs args;
  const CariTransportasiPage({Key? key, required this.args}) : super(key: key);

  @override
  State<CariTransportasiPage> createState() => _CariTransportasiPageState();
}

class _JenisTransportasiItem {
  final String label;
  final IconData icon;
  final double width;
  const _JenisTransportasiItem(this.label, this.icon, {required this.width});
}

class _CariTransportasiPageState extends State<CariTransportasiPage> {
  int? _selectedTransportasi = 0;

  final List<_JenisTransportasiItem> _jenisTransportasi = [
    _JenisTransportasiItem("Pesawat", Icons.flight, width: 112),
    _JenisTransportasiItem("Kereta Api", Icons.train, width: 120),
    _JenisTransportasiItem("Bis", Icons.directions_bus, width: 80),
    _JenisTransportasiItem("Kapal", Icons.directions_boat, width: 88),
    _JenisTransportasiItem("Mobil", Icons.directions_car, width: 86),
    _JenisTransportasiItem("Motor", Icons.motorcycle, width: 92),
  ];

  String get _tanggalRange {
    final d1 = widget.args.tanggalBerangkat;
    final d2 = widget.args.tanggalPulang;
    final hariID = ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"];
    if (d2 != null) {
      return "${hariID[d1.weekday % 7]}-${hariID[d2.weekday % 7]}, "
          "${d1.day}-${d2.day} ${DateFormat('MMM yyyy', 'id_ID').format(d2)}";
    } else {
      return "${hariID[d1.weekday % 7]}, ${d1.day}-${DateFormat('MMM yyyy', 'id_ID').format(d1)}";
    }
  }

  UserModel? currentUser;
  List<RencanaModel>? userPlans;

  @override
  void initState() {
    super.initState();
    // Ambil user aktif dari Hive box (activeUserBox)
    final activeUserBox = Hive.box<UserModel>('activeUserBox');
    if (activeUserBox.isNotEmpty) {
      currentUser = activeUserBox.getAt(0);
    }
    // Ambil rencana yang userId-nya sesuai dengan currentUser.email
    final rencanaBox = Hive.box<RencanaModel>('rencanaBox');
    if (currentUser != null) {
      userPlans = rencanaBox.values
          .where((rencana) => rencana.userId == currentUser!.email)
          .toList();
    } else {
      userPlans = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final screenWidth = MediaQuery.of(context).size.width;

    // Cegah error null check!
    if (currentUser == null || userPlans == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${args.asal} → ${args.tujuan}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: 'Inter',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 1),
                          child: Text(
                            "$_tanggalRange | ${args.jumlahPenumpang} Orang",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              letterSpacing: 0.07,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(_jenisTransportasi.length, (i) {
                  final selected = _selectedTransportasi == i;
                  final Color borderColor = selected
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF8F98A8);
                  final Color bgColor = selected
                      ? const Color(0xFFDC2626)
                      : Colors.white;
                  final Color textColor = selected
                      ? Colors.white
                      : const Color(0xFF8F98A8);
                  final Color iconColor = selected
                      ? Colors.white
                      : const Color(0xFF8F98A8);
                  final item = _jenisTransportasi[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTransportasi = i),
                      child: Container(
                        width: item.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1.0,
                            color: borderColor,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFDC2626).withOpacity(0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              color: iconColor,
                              size: 20,
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFFF6F6F6),
            width: double.infinity,
          ),
          Expanded(
            child: _selectedTransportasi == 0
                // PESAWAT
                ? ValueListenableBuilder(
                    valueListenable: Hive.box<PesawatModel>('pesawatBox').listenable(),
                    builder: (context, Box<PesawatModel> box, _) {
                      final daftarPesawat = box.values
                          .where((p) =>
                              p.asal == widget.args.asal &&
                              p.tujuan == widget.args.tujuan)
                          .toList();
                      return PesawatTersedia(
                        daftarPesawat: daftarPesawat,
                        currentUser: currentUser!,
                        userPlans: userPlans!,
                        selectedStartDate: widget.args.tanggalBerangkat,
                        selectedEndDate: widget.args.tanggalPulang ?? widget.args.tanggalBerangkat,
                        onPlanSelected: (plan) {
                          // TODO: aksi setelah memilih rencana, misal update plan
                        },
                        onAddPlanningBaru: () {
                          // TODO: aksi jika user ingin menambah planning baru
                        },
                      );
                    },
                  )
                // MOBIL
                : _selectedTransportasi == 4
                    ? ValueListenableBuilder(
                        valueListenable: Hive.box<MobilModel>('mobilBox').listenable(),
                        builder: (context, Box<MobilModel> box, _) {
                          final daftarMobil = box.values.toList();
                          return MobilTersedia(
                            daftarMobil: daftarMobil,
                            jumlahPenumpang: widget.args.jumlahPenumpang,
                            userPlans: userPlans!,
                            currentUser: currentUser!,
                            selectedStartDate: widget.args.tanggalBerangkat,
                            selectedEndDate: widget.args.tanggalPulang ?? widget.args.tanggalBerangkat,
                            onPlanSelected: (plan) {
                              // Optional: refresh, update, atau aksi lain setelah plan dipilih
                            },
                            onAddPlanningBaru: () {
                              // Optional: aksi jika ingin tambah planning baru
                            },
                          );
                        },
                      )
                    // TRANSPORTASI LAIN
                    : Container(
                        color: Colors.white,
                        child: const Center(
                          child: Text("Belum ada data transportasi ini"),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}