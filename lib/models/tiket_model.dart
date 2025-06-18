import 'package:hive/hive.dart';

part 'tiket_model.g.dart';

@HiveType(typeId: 14) // Pastikan typeId unik
class TiketAktivitasModel extends HiveObject {
  @HiveField(0)
  String aktivitasId;

  @HiveField(1)
  String namaTiket;

  @HiveField(2)
  String deskripsi;

  @HiveField(3)
  int harga;

  TiketAktivitasModel({
    required this.aktivitasId,
    required this.namaTiket,
    required this.deskripsi,
    required this.harga,
  });

  // Copy constructor untuk editing
  TiketAktivitasModel copyWith({
    String? aktivitasId,
    String? namaTiket,
    String? deskripsi,
    int? harga,
  }) {
    return TiketAktivitasModel(
      aktivitasId: aktivitasId ?? this.aktivitasId,
      namaTiket: namaTiket ?? this.namaTiket,
      deskripsi: deskripsi ?? this.deskripsi,
      harga: harga ?? this.harga,
    );
  }

  // Method untuk mendapatkan harga dalam format rupiah
  String get hargaFormatted {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Method untuk validasi data
  bool get isValid {
    return aktivitasId.isNotEmpty &&
           namaTiket.isNotEmpty &&
           deskripsi.isNotEmpty &&
           harga > 0;
  }

  @override
  String toString() {
    return 'TiketAktivitasModel(namaTiket: $namaTiket, harga: $harga, aktivitasId: $aktivitasId)';
  }

  // Method untuk konversi ke Map (untuk debugging atau export)
  Map<String, dynamic> toMap() {
    return {
      'aktivitasId': aktivitasId,
      'namaTiket': namaTiket,
      'deskripsi': deskripsi,
      'harga': harga,
    };
  }

  // Factory constructor dari Map
  factory TiketAktivitasModel.fromMap(Map<String, dynamic> map) {
    return TiketAktivitasModel(
      aktivitasId: map['aktivitasId'] ?? '',
      namaTiket: map['namaTiket'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      harga: map['harga']?.toInt() ?? 0,
    );
  }
}