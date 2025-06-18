import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';
import 'package:tripmate_mobile/widgets/kategori_aktivitas.dart';
import 'package:tripmate_mobile/widgets/card_aktivitas_favorit.dart';
import 'package:tripmate_mobile/widgets/card_aktivitas.dart';

class AktivitasSeruWidget extends StatelessWidget {
  final UserModel currentUser;
  final String? location;
  const AktivitasSeruWidget({super.key, required this.currentUser, this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // 1. Pilihan Kuliner (Kategori)
          const KategoriAktivitas(),
          const SizedBox(height: 24),

          // 2. Aktivitas Terfavorit
          const Text(
            "Aktivitas Terfavorit!",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          const CardAktivitasFavoritHorizontal(),
          const SizedBox(height: 24),

          // 3. Aktivitas List (semua aktivitas)
          const Text(
            "Aktivitas Seru Akhir Pekan!",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          CardAktivitasList(),
        ],
      ),
    );
  }
}