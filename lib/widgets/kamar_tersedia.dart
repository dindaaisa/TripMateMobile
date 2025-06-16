import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/widgets/tambah_dalam_rencana.dart';
import 'package:tripmate_mobile/screens/rencana/new_planning.dart';

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
  DateTime? rangeStart;
  DateTime? rangeEnd;
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
    rangeStart = tanggalPilihan[0];
    rangeEnd = tanggalPilihan[0];
  }

  void _onTanggalTap(int idx) {
    final tapped = tanggalPilihan[idx];
    setState(() {
      if (rangeStart == null || (rangeStart != null && rangeEnd != null)) {
        // Mulai range baru
        rangeStart = tapped;
        rangeEnd = null;
      } else if (rangeStart != null && rangeEnd == null) {
        if (tapped.isBefore(rangeStart!)) {
          rangeStart = tapped;
          rangeEnd = null;
        } else if (tapped.isAfter(rangeStart!)) {
          rangeEnd = tapped;
        } else {
          // Tap tanggal yang sama -> 1 malam (default)
          rangeEnd = tapped;
        }
      }
    });
  }

  Future<void> _pickTanggalRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 29)),
      initialDateRange: (rangeStart != null && rangeEnd != null)
          ? DateTimeRange(start: rangeStart!, end: rangeEnd!)
          : DateTimeRange(start: tanggalPilihan[0], end: tanggalPilihan[0]),
      locale: const Locale('id', 'ID'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFDC2626)),
        ),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() {
        rangeStart = range.start;
        rangeEnd = range.end;
      });
    }
  }

  /// Hitungan malam = selisih hari + 1 (dua tanggal = dua malam)
  int getJumlahMalam() {
    if (rangeStart == null || rangeEnd == null) return 1;
    final diff = rangeEnd!.difference(rangeStart!).inDays;
    return diff >= 0 ? diff + 1 : 1;
  }

  /// Hitungan hari = jumlah malam + 1
  int getJumlahHari() {
    return getJumlahMalam() + 1;
  }

  bool _isInRange(DateTime day) {
    if (rangeStart == null) return false;
    if (rangeEnd == null) return day == rangeStart;
    return (day.isAtSameMomentAs(rangeStart!) || day.isAtSameMomentAs(rangeEnd!)) ||
        (day.isAfter(rangeStart!) && day.isBefore(rangeEnd!));
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

    final String tanggalStr = (rangeStart == null || rangeEnd == null)
        ? ""
        : "${DateFormat('EEE, dd MMM', 'id_ID').format(rangeStart!)} - ${DateFormat('EEE, dd MMM', 'id_ID').format(rangeEnd!)}";
    final int jumlahMalam = getJumlahMalam();
    final int jumlahHari = getJumlahHari();

    Color getRangeBgColor() => const Color(0xFFDC2626).withOpacity(0.07);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
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
                    onTap: _pickTanggalRange,
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
                  final isSelected = _isInRange(tgl);

                  return GestureDetector(
                    onTap: () => _onTanggalTap(idx - 1),
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
          const SizedBox(height: 12),
          if (rangeStart != null && rangeEnd != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: getRangeBgColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range, size: 18, color: Color(0xFFDC2626)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "$tanggalStr ($jumlahHari Hari, $jumlahMalam Malam)",
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ...semuaKamar.map((kamar) {
            final imgBytes = kamar.imageBase64.isNotEmpty
                ? base64Decode(kamar.imageBase64)
                : null;
            final isSelected = widget.selectedKamarNama != null && widget.selectedKamarNama == kamar.nama;
            final totalHarga = (kamar.harga ?? 0) * jumlahMalam;
            return Container(
              width: double.infinity,
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
                            width: double.infinity,
                            height: 142,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
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
                              'Rp ${formatter.format(kamar.harga)} /mlm',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$jumlahHari Hari, $jumlahMalam Malam",
                              style: const TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Total: Rp ${formatter.format(totalHarga)}",
                              style: const TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: SizedBox(
                              width: 102,
                              height: 33,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (rangeStart == null || rangeEnd == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Pilih tanggal cek-in & cek-out terlebih dahulu."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (widget.onKamarSelected != null) {
                                    widget.onKamarSelected!(kamar.nama);
                                  } else {
                                    final box = Hive.box<RencanaModel>('rencanaBox');
                                    final userPlans = box.values
                                        .where((plan) => plan.userId == widget.currentUser?.email)
                                        .toList();

                                    showTambahDalamRencanaModal(
                                      context: context,
                                      currentUser: widget.currentUser!,
                                      userPlans: userPlans,
                                      onPlanSelected: (RencanaModel selectedPlan) async {
                                        final planStart = DateTime.tryParse(selectedPlan.startDate);
                                        final planEnd = DateTime.tryParse(selectedPlan.endDate);

                                        if (planStart == null || planEnd == null ||
                                            planStart != rangeStart || planEnd != rangeEnd) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Tanggal rencana dan kamar harus sama!"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }

                                        final idx = selectedPlan.key as int;
                                        final updatedPlan = selectedPlan.copyWith(
                                          akomodasi: widget.hotel.nama,
                                          kamarNama: kamar.nama,
                                          biayaAkomodasi: totalHarga,
                                          imageBase64: widget.hotel.imageBase64,
                                          startDate: DateFormat('yyyy-MM-dd').format(rangeStart!),
                                          endDate: DateFormat('yyyy-MM-dd').format(rangeEnd!),
                                          sumDate: "$jumlahHari Hari $jumlahMalam Malam",
                                        );
                                        await box.putAt(idx, updatedPlan);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Kamar telah ditambahkan ke rencana '${selectedPlan.name}'")),
                                          );
                                        }
                                      },
                                      onAddPlanningBaru: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => NewPlanningPageBody(
                                              currentUser: widget.currentUser!,
                                              isNewPlanMode: true,
                                            ),
                                          ),
                                        );
                                      },
                                      selectedStartDate: rangeStart!,
                                      selectedEndDate: rangeEnd!,
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
            );
          }),
        ],
      ),
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