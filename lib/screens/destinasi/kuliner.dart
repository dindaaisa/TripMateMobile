import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/kuliner_model.dart';
import 'package:tripmate_mobile/widgets/pilihan_kuliner.dart';
import 'package:tripmate_mobile/widgets/card_kuliner_sekitar.dart';
import 'package:tripmate_mobile/widgets/card_kuliner_terbaik.dart';

class KulinerWidget extends StatefulWidget {
  final UserModel currentUser;
  final String? location; // Lokasi dari destinasi.dart

  const KulinerWidget({
    Key? key,
    required this.currentUser,
    this.location,
  }) : super(key: key);

  @override
  State<KulinerWidget> createState() => _KulinerWidgetState();
}

class _KulinerWidgetState extends State<KulinerWidget> {
  List<KulinerModel> kulinerFiltered = [];

  @override
  void initState() {
    super.initState();
    _loadKuliner();
  }

  Future<void> _loadKuliner() async {
    final box = await Hive.openBox<KulinerModel>('kulinerBox');
    final kulinerList = box.values.toList();
    setState(() {
      kulinerFiltered = widget.location == null
          ? kulinerList
          : kulinerList.where((k) => k.lokasi == widget.location).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter kuliner terbaik (rating di atas 4.5)
    final kulinerTerbaik = kulinerFiltered.where((k) => k.rating > 4.5).toList();

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        // Widget Pilihan Kuliner (kategori)
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 0, 0),
          child: PilihanKuliner(),
        ),
        const SizedBox(height: 10),
        // Judul di atas CardKulinerSekitar
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Lagi lapar? Cek kuliner enak di sekitarmu!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // List kuliner horizontal (menggunakan CardKulinerSekitar)
        SizedBox(
          height: 250,
          child: kulinerFiltered.isEmpty
              ? const Center(child: Text("Tidak ada data kuliner untuk lokasi ini."))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kulinerFiltered.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final kuliner = kulinerFiltered[index];
                    return CardKulinerSekitar(kuliner: kuliner);
                  },
                ),
        ),
        const SizedBox(height: 24),
        // Judul di atas CardKulinerTerbaik
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Nikmati pengalaman makan di tempat terbaik!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // List kuliner terbaik horizontal (menggunakan CardKulinerTerbaik)
        SizedBox(
          height: 250,
          child: kulinerTerbaik.isEmpty
              ? const Center(child: Text("Belum ada kuliner terbaik di lokasi ini."))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kulinerTerbaik.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final kuliner = kulinerTerbaik[index];
                    return CardKulinerTerbaik(kuliner: kuliner);
                  },
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}