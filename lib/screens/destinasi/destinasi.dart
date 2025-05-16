import 'package:flutter/material.dart';
import 'akomodasi.dart'; // Import konten kategori Akomodasi
import 'transportasi.dart';
import 'aktivitas.dart';
import 'kuliner.dart';
import 'paket.dart';

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
      body: Stack(
        children: [
          // Header image
          Positioned(
            top: 137,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/destination.jpg",
              height: 182,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Positioned(
            top: 137,
            left: 0,
            right: 0,
            child: Container(
              height: 182,
              color: Colors.black.withOpacity(0.15),
            ),
          ),

          // Text overlay
          Positioned(
            top: 200,
            left: 15,
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


          // Search bar
          Positioned(
            top: 98,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFD3D5DD), width: 0.5),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Temukan pengalaman liburanmu! Ketik sesuatu...',
                      style: TextStyle(
                        color: Color(0xFF8F98A8),
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  child: const Icon(Icons.search, size: 16, color: Colors.white),
                ),
              ],
            ),
          ),

          // Custom AppBar
          Positioned(
            top: 42,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40, // <--- Ubah dari 31 ke 40 (atau 36 minimal)
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 18, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Denpasar, Bali",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      notificationIcon(),
                      const SizedBox(width: 8),
                      languageIcon(),
                    ],
                  )
                ],
              ),
            ),
          ),


          // Status Bar background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 42,
            child: Container(color: Colors.white),
          ),

          // CATEGORY BAR
          Positioned(
            top: 330,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
          ),

          // CONTENT
          Positioned(
            top: 380,
            left: 0,
            right: 0,
            bottom: 0,
            child: _getSelectedWidget(),
          ),
        ],
      ),
    );
  }

  //Tinggal di call
  Widget notificationIcon() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        children: [
          const Icon(Icons.notifications, size: 24),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 2),
      const Text(
        "Notifikasi",
        style: TextStyle(fontSize: 8),
      ),
    ],
  );
}

Widget languageIcon() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.language, size: 24),
      SizedBox(height: 2),
      Text(
        "Indonesia",
        style: TextStyle(fontSize: 8),
      ),
    ],
  );
}

}
