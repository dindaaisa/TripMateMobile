import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';

class DetailAkomodasiFacilityArea extends StatelessWidget {
  final HotelModel hotel;
  const DetailAkomodasiFacilityArea({super.key, required this.hotel});

  IconData _iconFasilitas(String fasilitas) {
    final f = fasilitas
        .toLowerCase()
        .replaceAll(RegExp(r'[\s\-_\/]'), ''); // hilangkan spasi, dash, underscore, slash
    switch (f) {
      case 'wifi':
        return Icons.wifi;
      case 'kolamrenang':
        return Icons.pool;
      case 'ac':
        return Icons.ac_unit;
      case 'restoran':
        return Icons.restaurant;
      case 'parkir':
        return Icons.local_parking;
      case 'gym':
        return Icons.fitness_center;
      case 'breakfast':
      case 'sarapan':
        return Icons.free_breakfast;
      default:
        return Icons.check_circle_outline;
    }
  }

  IconData _iconArea(String? iconName, {bool isAddress = false}) {
    if (isAddress) return Icons.location_on;
    switch (iconName) {
      case "beach_access":
        return Icons.beach_access;
      case "shopping_bag":
        return Icons.shopping_bag;
      case "restaurant":
        return Icons.restaurant;
      case "park":
        return Icons.park;
      case "museum":
        return Icons.museum;
      case "local_activity":
        return Icons.local_activity;
      case "store":
        return Icons.store;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fasilitas utama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fasilitas Utama',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ...hotel.fasilitas.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          _iconFasilitas(f),
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          f,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Area akomodasi (alamat + area sekitar)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Area Akomodasi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                // Lokasi detail / alamat utama
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 17),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hotel.lokasiDetail,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Area sekitar (max 4, seperti desain)
                ...hotel.areaAkomodasi.take(4).map(
                  (area) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Icon(
                          _iconArea(area.iconName),
                          color: const Color(0xFF8C8C8C),
                          size: 17,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            area.nama,
                            style: const TextStyle(
                              color: Color(0xFF8C8C8C),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 49,
                          child: Text(
                            "${area.jarakKm.toStringAsFixed(2)} km",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF8C8C8C),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
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
}