import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';
import 'package:tripmate_mobile/widgets/detail_aktivitas_header.dart';
import 'package:tripmate_mobile/widgets/detail_aktivitas_rinci.dart';
import 'package:tripmate_mobile/widgets/aktivitas_tersedia.dart';

class DetailAktivitasPage extends StatelessWidget {
  final AktivitasModel aktivitas;
  const DetailAktivitasPage({Key? key, required this.aktivitas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hapus SafeArea dari sini!
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DetailAktivitasHeader(aktivitas: aktivitas),
          ),
          SliverToBoxAdapter(
            child: SafeArea( // Letakkan SafeArea di konten saja jika mau
              top: false,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: DetailAktivitasRinci(aktivitas: aktivitas),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea( // Letakkan SafeArea di konten saja jika mau
              top: false,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: AktivitasTersedia(aktivitas: aktivitas),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}