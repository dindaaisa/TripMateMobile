import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../shared/location_state.dart';

class CustomHeader extends StatefulWidget {
  final List<String>? lokasiList;
  final void Function(String)? onSearchChanged;
  final void Function(String)? onSearchSubmitted;

  /// onSearchChanged: realtime update saat user ketik
  /// onSearchSubmitted: ketika user submit/search
  const CustomHeader({
    super.key,
    this.lokasiList,
    this.onSearchChanged,
    this.onSearchSubmitted,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  late Future<List<String>> _lokasiListFuture;
  final TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topSafe = MediaQuery.of(context).padding.top;
    final barHeight = screenWidth * 0.12;
    final searchBoxHeight = screenWidth * 0.08 + 10;

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
              // Search bar (rapih dan fungsi search)
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
                      child: SizedBox(
                        height: searchBoxHeight,
                        child: TextField(
                          controller: _searchController,
                          onChanged: widget.onSearchChanged,
                          onSubmitted: widget.onSearchSubmitted,
                          textInputAction: TextInputAction.search,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Temukan pengalaman liburanmu! Ketik sesuatu...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8F98A8),
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                            contentPadding: const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 6),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFFD3D5DD),
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFFD3D5DD),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: searchBoxHeight,
                      child: Material(
                        color: const Color(0xFFDC2626),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                          ),
                          onTap: () {
                            if (widget.onSearchSubmitted != null) {
                              widget.onSearchSubmitted!(_searchController.text);
                            }
                          },
                          child: Container(
                            width: searchBoxHeight + 8,
                            height: searchBoxHeight,
                            alignment: Alignment.center,
                            child: const Icon(Icons.search, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
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