import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'transportasi/kelola_pesawat.dart';
import 'akomodasi/kelola_hotel.dart';

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

    if (selectedPage == 'Pesawat') {
      return KelolaPesawatPage(
        onBack: () => setState(() => selectedPage = null),
      );
    }
    if (selectedPage == 'Hotel') {
      return KelolaHotel(
        onBack: () => setState(() => selectedPage = null),
      );
    }

    // Menu utama KelolaPage
    return Scaffold(
      body: Column(
        children: [
          // Responsive Header mirip AkunPage
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.06),
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
                    GridItem(label: 'Mobil', svgPath: 'assets/icons/car.svg'),
                    GridItem(label: 'Bus', svgPath: 'assets/icons/bus.svg'),
                    GridItem(label: 'Kereta', svgPath: 'assets/icons/train.svg'),
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
                    GridItem(label: 'Vila', svgPath: 'assets/icons/vila.svg'),
                    GridItem(label: 'Apartemen', svgPath: 'assets/icons/apartemen.svg'),
                  ]),
                  const SizedBox(height: 20),
                  sectionTitle('Tempat'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GridItem(label: 'Makanan', svgPath: 'assets/icons/makanan.svg'),
                      GridItem(label: 'Atraksi', svgPath: 'assets/icons/atraksi.svg'),
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