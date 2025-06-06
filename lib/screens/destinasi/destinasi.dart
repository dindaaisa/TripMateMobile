import 'package:flutter/material.dart';
import 'akomodasi.dart';
import 'transportasi.dart';
import 'aktivitas.dart';
import 'kuliner.dart';
import 'paket.dart';
import 'package:tripmate_mobile/widgets/custom_header.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class DestinasiScreen extends StatefulWidget {
  final UserModel currentUser;

  const DestinasiScreen({super.key, required this.currentUser});

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
        return AkomodasiWidget(currentUser: widget.currentUser);
      case 'Transportasi':
        return TransportasiWidget(currentUser: widget.currentUser);
      case 'Aktivitas Seru':
        return AktivitasSeruWidget(currentUser: widget.currentUser);
      case 'Kuliner':
        return KulinerWidget(currentUser: widget.currentUser);
      case 'Paket':
        return PaketWidget(currentUser: widget.currentUser);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final headerImgHeight = screenHeight * 0.22; // Sekitar 22% tinggi layar

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(location: "Denpasar, Bali"),
            Stack(
              children: [
                Image.asset(
                  "assets/pics/destination.jpg",
                  height: headerImgHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: headerImgHeight,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.15),
                ),
                Positioned(
                  left: 18,
                  top: headerImgHeight * 0.35,
                  child: Text(
                    'Mau berlibur kemana?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth > 375 ? 24 : 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              height: 46,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                itemCount: categories.length,
                itemBuilder: (context, idx) {
                  final category = categories[idx];
                  final isSelected = selectedCategory == category['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category['name']!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              size: 17,
                              color: isSelected ? Colors.white : const Color(0xFF8F98A8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category['name']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF8F98A8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 4),
                child: _getSelectedWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}