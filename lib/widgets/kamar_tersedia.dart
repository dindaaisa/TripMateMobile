import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/widgets/tambah_dalam_rencana.dart';

class KamarTersediaWidget extends StatefulWidget {
  final HotelModel hotel;
  final UserModel? currentUser;
  final String? selectedKamarNama;
  final Function(String)? onKamarSelected;

  const KamarTersediaWidget({
    super.key,
    required this.hotel,
    this.currentUser,
    this.selectedKamarNama,
    this.onKamarSelected,
  });

  @override
  State<KamarTersediaWidget> createState() => _KamarTersediaWidgetState();
}

class _KamarTersediaWidgetState extends State<KamarTersediaWidget> {
  late List<DateTime> tanggalPilihan;
  int selectedIndex = 0;
  late DateTime today;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    tanggalPilihan = List.generate(
      30,
      (i) => DateTime(today.year, today.month, today.day).add(Duration(days: i)),
    );
  }

  Future<void> _pickTanggalLewatKalender() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalPilihan[selectedIndex],
      firstDate: today,
      lastDate: today.add(const Duration(days: 29)),
      locale: const Locale('id', 'ID'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFDC2626)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final idx = tanggalPilihan.indexWhere(
        (t) =>
            t.year == picked.year &&
            t.month == picked.month &&
            t.day == picked.day,
      );
      if (idx != -1) {
        setState(() => selectedIndex = idx);
        _scrollController.jumpTo(idx * 74.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id');
    final kamarBox = Hive.box<KamarModel>('kamarBox');
    final semuaKamar = kamarBox.values
        .where((kamar) => kamar.hotelId == widget.hotel.key.toString())
        .toList();

    if (semuaKamar.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("Tidak ada kamar tersedia di akomodasi ini")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 84,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: tanggalPilihan.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, idx) {
              if (idx == 0) {
                return GestureDetector(
                  onTap: _pickTanggalLewatKalender,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFDC2626),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.calendar_today,
                        color: Color(0xFFDC2626),
                        size: 32,
                      ),
                    ),
                  ),
                );
              } else {
                final tgl = tanggalPilihan[idx - 1];
                final hari = DateFormat.E('id_ID').format(tgl);
                final tanggal = DateFormat('d MMM', 'id_ID').format(tgl);
                final isSelected = selectedIndex == (idx - 1);

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = idx - 1);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDC2626) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFDC2626),
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: const Color(0x44DC2626),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hari,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFFDC2626),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tanggal,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFFDC2626),
                            fontSize: 13,
                            fontFamily: 'Inter',
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
        const SizedBox(height: 24),
        ...semuaKamar.map((kamar) {
          final imgBytes = kamar.imageBase64.isNotEmpty
              ? base64Decode(kamar.imageBase64)
              : null;
          final isSelected = widget.selectedKamarNama != null && widget.selectedKamarNama == kamar.nama;
          return Center(
            child: Container(
              width: 355,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDC2626).withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.09),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                  if (isSelected)
                    const BoxShadow(
                      color: Color(0x33DC2626),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                ],
                border: isSelected
                    ? Border.all(color: const Color(0xFFDC2626), width: 1.6)
                    : null,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: imgBytes != null
                        ? Image.memory(
                            imgBytes,
                            width: 355,
                            height: 142,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 355,
                            height: 142,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 60, color: Colors.grey),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                kamar.nama,
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFFDC2626) : Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Rp ${formatter.format(kamar.harga)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFFDC2626) : const Color(0xFFDC2626),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _rowIconText(
                          icon: Icons.square_foot,
                          text: "${kamar.ukuran} m²",
                          color: const Color(0xFFDC2626),
                        ),
                        _rowIconText(
                          icon: Icons.people,
                          text: "${kamar.kapasitas} Tamu",
                          color: const Color(0xFF8C8C8C),
                        ),
                        _rowIconText(
                          icon: Icons.king_bed,
                          text: kamar.tipeKasur.isNotEmpty ? kamar.tipeKasur : "-",
                          color: const Color(0xFF8C8C8C),
                        ),
                        if (kamar.fasilitas.contains("Bebas Asap Rokok"))
                          _rowIconText(
                            icon: Icons.smoke_free,
                            text: "Bebas Asap Rokok",
                            color: const Color(0xFF8C8C8C),
                          ),
                        if (kamar.badges.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 0),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 2,
                              children: kamar.badges.take(2).map((badge) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SizedBox(
                              width: 102,
                              height: 33,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (widget.onKamarSelected != null) {
                                    // Mode pilih kamar pada rencana (akan pop context)
                                    widget.onKamarSelected!(kamar.nama);
                                  } else {
                                    // Mode tambah ke rencana (pop up style modern)
                                    final box = Hive.box<RencanaModel>('rencanaBox');
                                    final userPlans = box.values
                                        .where((plan) => plan.userId == widget.currentUser?.email)
                                        .toList();

                                    showTambahDalamRencanaModal(
                                      context: context,
                                      currentUser: widget.currentUser!,
                                      userPlans: userPlans,
                                      onPlanSelected: (RencanaModel selectedPlan) async {
                                        final idx = selectedPlan.key as int;
                                        final updatedPlan = selectedPlan.copyWith(
                                          akomodasi: widget.hotel.nama,
                                          kamarNama: kamar.nama,
                                          biayaAkomodasi: kamar.harga,
                                          imageBase64: widget.hotel.imageBase64,
                                        );
                                        await box.putAt(idx, updatedPlan);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Kamar telah ditambahkan ke rencana '${selectedPlan.name}'")),
                                          );
                                        }
                                      },
                                      onAddPlanningBaru: () {
                                        // TODO: Tambah logic jika ingin navigasi ke halaman tambah planning baru
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _rowIconText({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}