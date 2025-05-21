import 'package:flutter/material.dart';
import 'akomodasi.dart';
import 'transportasi.dart';
import 'aktivitas.dart';
import 'kuliner.dart';
import 'paket.dart';
import 'package:tripmate_mobile/widgets/custom_header.dart';

class DestinasiScreen extends StatefulWidget {
  const DestinasiScreen({super.key});

  @override
  State<DestinasiScreen> createState() => _DestinasiScreenState();
}

class _DestinasiScreenState extends State<DestinasiScreen> {
  String selectedCategory = 'Akomodasi';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Akomodasi', 'icon': Icons.hotel},
    {'name': 'Transportasi', 'icon': Icons.flight},
    {'name': 'Aktivitas Seru', 'icon': Icons.surfing},
    {'name': 'Kuliner', 'icon': Icons.restaurant},
    {'name': 'Paket', 'icon': Icons.inventory_2},
  ];

  Widget _getSelectedWidget() {
    switch (selectedCategory) {
      case 'Akomodasi':
        return const AkomodasiWidget();
      case 'Transportasi':
        return const TransportasiWidget();
      case 'Aktivitas Seru':
        return const AktivitasSeruWidget();
      case 'Kuliner':
        return const KulinerWidget();
      case 'Paket':
        return const PaketWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Custom header (dengan tinggi 140)
            const CustomHeader(location: "Denpasar, Bali"),

            // ✅ Gambar dan overlay
            Stack(
              children: [
                Image.asset(
                  "assets/pics/destination.jpg",
                  height: 182,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 182,
                  color: Colors.black.withOpacity(0.15),
                ),
                Positioned(
                  left: 15,
                  top: 63,
                  child: Text(
                    'Mau berlibur kemana?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Menu kategori horizontal
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((category) {
                  final isSelected = selectedCategory == category['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category['name']!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFDC2626) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF8F98A8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category['icon'] as IconData,
                              size: 16,
                              color: isSelected ? Colors.white : const Color(0xFF8F98A8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category['name']!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF8F98A8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ✅ Konten berdasarkan kategori, isi penuh sisa layar
            Expanded(
              child: _getSelectedWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
