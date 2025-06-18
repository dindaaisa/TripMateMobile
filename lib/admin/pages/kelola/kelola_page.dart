import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'transportasi/kelola_pesawat.dart';
import 'transportasi/kelola_mobil.dart';
import 'tempat/kelola_kuliner.dart';
import 'akomodasi/kelola_hotel.dart';
import 'akomodasi/kelola_villa.dart';
import 'tempat/kelola_aktivitas.dart';

class KelolaPage extends StatefulWidget {
  const KelolaPage({Key? key}) : super(key: key);

  @override
  State<KelolaPage> createState() => _KelolaPageState();
}

class _KelolaPageState extends State<KelolaPage> {
  String? selectedPage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Routing ke halaman sesuai kategori yang diklik
    switch (selectedPage) {
      case 'Pesawat':
        return KelolaPesawatPage(
          onBack: () => setState(() => selectedPage = null),
        );
      case 'Mobil':
        return KelolaMobilPage(
          onBack: () => setState(() => selectedPage = null),
        );
      case 'Kuliner':
        return KelolaKuliner(
          onBack: () => setState(() => selectedPage = null),
        );
      case 'Hotel':
        return KelolaHotel(
          onBack: () => setState(() => selectedPage = null),
        );
      case 'Villa':
        return KelolaVillaPage(
          onBack: () => setState(() => selectedPage = null),
        );
      case 'Aktivitas':
        return KelolaAktivitas(
          onBack: () => setState(() => selectedPage = null),
        );
    }

    // Menu utama KelolaPage
    return Scaffold(
      body: Column(
        children: [
          // Header merah mentok ke atas
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: screenWidth * 0.06,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Kelola',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.045),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Transportasi'),
                  const SizedBox(height: 16),
                  scrollRow([
                    GridItem(
                      label: 'Pesawat',
                      svgPath: 'assets/icons/airplane.svg',
                      onTap: () => setState(() => selectedPage = 'Pesawat'),
                    ),
                    GridItem(
                      label: 'Mobil',
                      svgPath: 'assets/icons/car.svg',
                      onTap: () => setState(() => selectedPage = 'Mobil'),
                    ),
                    GridItem(
                      label: 'Bus',
                      svgPath: 'assets/icons/bus.svg',
                      // onTap: () => setState(() => selectedPage = 'Bus'),
                    ),
                    GridItem(
                      label: 'Kereta',
                      svgPath: 'assets/icons/train.svg',
                      // onTap: () => setState(() => selectedPage = 'Kereta'),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  sectionTitle('Akomodasi'),
                  const SizedBox(height: 16),
                  scrollRow([
                    GridItem(
                      label: 'Hotel',
                      svgPath: 'assets/icons/hotel.svg',
                      onTap: () => setState(() => selectedPage = 'Hotel'),
                    ),
                    GridItem(
                      label: 'Villa',
                      svgPath: 'assets/icons/vila.svg',
                      onTap: () => setState(() => selectedPage = 'Villa'),
                    ),
                    GridItem(
                      label: 'Apartemen',
                      svgPath: 'assets/icons/apartemen.svg',
                      // onTap: () => setState(() => selectedPage = 'Apartemen'),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  sectionTitle('Tempat'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GridItem(
                        label: 'Kuliner',
                        svgPath: 'assets/icons/makanan.svg',
                        onTap: () => setState(() => selectedPage = 'Kuliner'),
                      ),
                      GridItem(
                        label: 'Aktivitas',
                        svgPath: 'assets/icons/atraksi.svg',
                        onTap: () => setState(() => selectedPage = 'Aktivitas'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return SizedBox(
      width: double.infinity,
      height: 19,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget scrollRow(List<Widget> children) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    );
  }
}

class GridItem extends StatelessWidget {
  final String label;
  final String svgPath;
  final VoidCallback? onTap;

  const GridItem({
    Key? key,
    required this.label,
    required this.svgPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = screenWidth / 4.2;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                svgPath,
                width: size * 0.5,
                height: size * 0.5,
                placeholderBuilder: (context) =>
                    const CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}