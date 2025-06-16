import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../shared/location_state.dart';

class CustomHeader extends StatefulWidget {
  final List<String>? lokasiList;
  const CustomHeader({super.key, this.lokasiList});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  late Future<List<String>> _lokasiListFuture;

  @override
  void initState() {
    super.initState();
    _lokasiListFuture = _fetchLokasiList();
  }

  Future<List<String>> _fetchLokasiList() async {
    if (widget.lokasiList != null) {
      return widget.lokasiList!;
    }
    final box = await Hive.openBox('lokasiBox');
    return List<String>.from(box.get('list', defaultValue: [
      "Denpasar, Bali",
      "Jakarta, DKI Jakarta",
      "Bandung, Jawa Barat"
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Gunakan MediaQuery padding top agar header menempel ke atas device
    final topSafe = MediaQuery.of(context).padding.top;
    final topBarHeight = 0.0; // Hilangkan padding topbar custom, pakai SafeArea saja
    final barHeight = screenWidth * 0.12;
    final searchBoxHeight = screenWidth * 0.08 + 14;

    return FutureBuilder<List<String>>(
      future: _lokasiListFuture,
      builder: (context, snapshot) {
        final locations = snapshot.data ?? ["Denpasar, Bali"];
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: topSafe), // SafeArea
              // Dropdown lokasi dan icon bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
                height: barHeight,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.black),
                        const SizedBox(width: 4),
                        ValueListenableBuilder<String>(
                          valueListenable: LocationState.selectedLocation,
                          builder: (context, selectedLocation, _) {
                            final validDropdownValue = locations.contains(selectedLocation)
                                ? selectedLocation
                                : locations.first;
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: validDropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                items: locations.map((loc) {
                                  return DropdownMenuItem(
                                    value: loc,
                                    child: Text(loc),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  if (value != null) {
                                    LocationState.selectedLocation.value = value;
                                    final selectedLocationBox = await Hive.openBox('selectedLocationBox');
                                    selectedLocationBox.put('selected', value);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _notificationIcon(),
                        const SizedBox(width: 8),
                        _languageIcon(),
                      ],
                    ),
                  ],
                ),
              ),
              // Search bar
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  left: screenWidth * 0.045,
                  right: screenWidth * 0.045,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: searchBoxHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFD3D5DD),
                            width: 0.5,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Temukan pengalaman liburanmu! Ketik sesuatu...',
                          style: TextStyle(
                            color: Color(0xFF8F98A8),
                            fontSize: 11,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: searchBoxHeight + 4,
                      height: searchBoxHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: const Icon(Icons.search, size: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  static Widget _notificationIcon() {
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

  static Widget _languageIcon() {
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