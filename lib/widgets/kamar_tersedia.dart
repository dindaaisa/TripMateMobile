import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';

class KamarTersediaWidget extends StatefulWidget {
  final HotelModel hotel;
  const KamarTersediaWidget({super.key, required this.hotel});

  @override
  State<KamarTersediaWidget> createState() => _KamarTersediaWidgetState();
}

class _KamarTersediaWidgetState extends State<KamarTersediaWidget> {
  late List<DateTime> tanggalPilihan;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    tanggalPilihan = List.generate(4, (i) => now.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id');
    final kamarBox = Hive.box<KamarModel>('kamarBox');
    final semuaKamar = kamarBox.values.where((kamar) => kamar.hotelId == widget.hotel.nama).toList();

    final kamarList = semuaKamar.where((kamar) {
      // Jika ingin filter berdasarkan tanggal, sesuaikan di sini
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pilihan tanggal horizontal
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: tanggalPilihan.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final tgl = tanggalPilihan[i];
              final hari = DateFormat.EEEE('id_ID').format(tgl); // Senin, Selasa, ...
              final tanggal = DateFormat('d MMM', 'id_ID').format(tgl); // 14 Apr
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(color: Colors.red, width: 1.4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.red.withOpacity(0.09), blurRadius: 6)]
                        : [],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (i == 0)
                        const Icon(Icons.calendar_today, color: Colors.red, size: 20),
                      if (i == 0) const SizedBox(height: 2),
                      Text(
                        hari.split(',')[0].substring(0,1).toUpperCase() + hari.substring(1,3),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        tanggal,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // List tipe kamar
        ...kamarList.map((kamar) {
          final imgBytes = kamar.imageBase64.isNotEmpty
              ? base64Decode(kamar.imageBase64)
              : null;
          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: imgBytes != null
                      ? Image.memory(
                          imgBytes,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 130,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              kamar.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Rp ${formatter.format(kamar.harga)}',
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(Icons.square_foot, color: Colors.red, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            '${kamar.ukuran} m²',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.group, color: Colors.grey, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            '${kamar.kapasitas} Tamu',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.bed, color: Colors.grey, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            kamar.tipeKasur,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (kamar.fasilitas.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.smoke_free, color: Colors.grey, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              kamar.fasilitas.first,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      const SizedBox(height: 6),
                      if (kamar.badges.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: kamar.badges
                              .map((badge) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: badge == "Gratis Pembatalan"
                                              ? Colors.red
                                              : const Color(0xFFDC2626),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                      color: badge == "Gratis Pembatalan"
                                          ? Colors.white
                                          : const Color(0xFFF8D6D6),
                                    ),
                                    child: Text(
                                      badge,
                                      style: TextStyle(
                                        color: badge == "Gratis Pembatalan"
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 8),
                          ),
                          onPressed: () {
                            // Aksi tambah kamar
                          },
                          child: const Text(
                            'Tambahkan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
    );
  }
}