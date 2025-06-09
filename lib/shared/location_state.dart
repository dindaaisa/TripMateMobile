import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Global untuk menyimpan lokasi yang sedang dipilih user
class LocationState {
  // ValueNotifier untuk listen perubahan lokasi di seluruh app
  static ValueNotifier<String> selectedLocation = ValueNotifier<String>("");

  /// Ambil daftar lokasi dari Hive box "lokasiBox"
  static List<String> getLocations() {
    final box = Hive.box('lokasiBox');
    final list = box.get('list');
    if (list is List && list.isNotEmpty) {
      return List<String>.from(list);
    }
    return [];
  }

  /// Set lokasi pilihan user ke Hive dan ValueNotifier
  static void setSelectedLocation(String location) {
    final box = Hive.box('selectedLocationBox');
    box.put('selected', location);
    selectedLocation.value = location;
  }

  /// Inisialisasi lokasi awal dari Hive
  static Future<void> initSelectedLocation() async {
    final box = await Hive.openBox('selectedLocationBox');
    final lokasi = box.get('selected');
    if (lokasi is String && lokasi.isNotEmpty) {
      selectedLocation.value = lokasi;
    } else {
      // fallback: pilih lokasi pertama (jika daftar lokasi tidak kosong)
      final locList = getLocations();
      if (locList.isNotEmpty) {
        selectedLocation.value = locList.first;
        box.put('selected', locList.first);
      }
    }
  }
}