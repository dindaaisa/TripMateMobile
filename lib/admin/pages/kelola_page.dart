import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'kelola_pesawat.dart';

class KelolaPage extends StatelessWidget {
  const KelolaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar custom
          Container(
            width: 430,
            height: 80,
            decoration: const ShapeDecoration(
              color: Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('Transportasi'),
                const SizedBox(height: 16),
                scrollRow([
                  GridItem(
                      label: 'Pesawat', svgPath: 'assets/icons/airplane.svg'),
                  GridItem(label: 'Mobil', svgPath: 'assets/icons/car.svg'),
                  GridItem(label: 'Bus', svgPath: 'assets/icons/bus.svg'),
                  GridItem(label: 'Kereta', svgPath: 'assets/icons/train.svg'),
                ]),
                const SizedBox(height: 20),
                sectionTitle('Akomodasi'),
                const SizedBox(height: 16),
                scrollRow([
                  GridItem(label: 'Hotel', svgPath: 'assets/icons/hotel.svg'),
                  GridItem(label: 'Vila', svgPath: 'assets/icons/vila.svg'),
                  GridItem(
                      label: 'Apartemen',
                      svgPath: 'assets/icons/apartemen.svg'),
                ]),
                const SizedBox(height: 20),
                sectionTitle('Tempat'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    GridItem(
                        label: 'Makanan', svgPath: 'assets/icons/makanan.svg'),
                    GridItem(
                        label: 'Atraksi', svgPath: 'assets/icons/atraksi.svg'),
                  ],
                ),
              ],
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

class GridItem extends StatefulWidget {
  final String label;
  final String svgPath;

  const GridItem({Key? key, required this.label, required this.svgPath})
      : super(key: key);

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  void toggleSelected() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSelected ? const Color(0xFFDC2626) : Colors.blueGrey.shade100;
    final iconColor = isSelected ? Colors.white : null;

    return GestureDetector(
      onTap: () {
        toggleSelected();
        if (widget.label == 'Pesawat') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KelolaPesawatPage(),
            ),
          ).then((_) {
            // Reset warna setelah kembali dari halaman KelolaPesawat
            setState(() {
              isSelected = false;
            });
          });
        }
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
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
                widget.svgPath,
                width: 64,
                height: 64,
                color: iconColor,
                placeholderBuilder: (context) =>
                    const CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
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
