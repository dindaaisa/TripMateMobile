import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/widgets/custom_header.dart';
import 'package:tripmate_mobile/screens/destinasi/akomodasi.dart';
import 'package:tripmate_mobile/screens/destinasi/transportasi.dart';
import 'package:tripmate_mobile/screens/destinasi/aktivitas.dart';
import 'package:tripmate_mobile/screens/destinasi/kuliner.dart';
import 'package:tripmate_mobile/screens/destinasi/paket.dart';
import 'package:tripmate_mobile/shared/location_state.dart';

class DestinasiScreen extends StatefulWidget {
  final UserModel currentUser;
  final String initialCategory;
  const DestinasiScreen({
    Key? key,
    required this.currentUser,
    this.initialCategory = 'Akomodasi',
  }) : super(key: key);

  @override
  State<DestinasiScreen> createState() => _DestinasiScreenState();
}

class _DestinasiScreenState extends State<DestinasiScreen> {
  late String selectedCategory;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Akomodasi', 'icon': Icons.hotel},
    {'name': 'Transportasi', 'icon': Icons.flight},
    {'name': 'Aktivitas Seru', 'icon': Icons.surfing},
    {'name': 'Kuliner', 'icon': Icons.restaurant},
    {'name': 'Paket', 'icon': Icons.inventory_2},
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScrollToSelected();
    });
  }

  void _autoScrollToSelected() {
    final idx = categories.indexWhere((cat) => cat['name'] == selectedCategory);
    if (idx != -1) {
      _scrollController.animateTo(
        idx * 130.0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _getSelectedWidget(String selectedLocation) {
    switch (selectedCategory) {
      case 'Akomodasi':
        return AkomodasiWidget(currentUser: widget.currentUser, location: selectedLocation);
      case 'Transportasi':
        return TransportasiWidget(currentUser: widget.currentUser, location: selectedLocation);
      case 'Aktivitas Seru':
        return AktivitasSeruWidget(currentUser: widget.currentUser, location: selectedLocation);
      case 'Kuliner':
        return KulinerWidget(currentUser: widget.currentUser, location: selectedLocation);
      case 'Paket':
        return PaketWidget(currentUser: widget.currentUser, location: selectedLocation);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final headerImgHeight = screenHeight * 0.22;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
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
                    'Mau berlibur \nkemana?',
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
              height: 40, // lebih kecil, sesuai gambar
              width: double.infinity,
              child: ListView.builder(
                controller: _scrollController,
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _autoScrollToSelected();
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 104,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFDC2626) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF8F98A8),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category['icon'] as IconData,
                              size: 18,
                              color: isSelected ? Colors.white : const Color(0xFF8F98A8),
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                category['name']!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : const Color(0xFF8F98A8),
                                ),
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
              child: ValueListenableBuilder<String>(
                valueListenable: LocationState.selectedLocation,
                builder: (context, selectedLocation, _) {
                  return _getSelectedWidget(selectedLocation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}