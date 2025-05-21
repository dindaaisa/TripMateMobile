import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String location;

  const CustomHeader({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // DIBERI TINGGI agar Stack tahu ukurannya
      child: Stack(
        children: [
          // Background putih di atas (untuk status bar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 42,
            child: Container(color: Colors.white),
          ),

          // Bar lokasi & notifikasi
          Positioned(
            top: 42,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
        ],
      ),
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
