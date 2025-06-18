import 'package:hive/hive.dart';

part 'aktivitas_model.g.dart';

@HiveType(typeId: 13) // Pastikan typeId unik
class AktivitasModel extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String deskripsi;

  @HiveField(2)
  String tipe; // Budaya, Atraksi, Alam

  @HiveField(3)
  String lokasi; // Surabaya, Bali, Jogja

  @HiveField(4)
  String lokasiDetail;

  @HiveField(5)
  double rating;

  @HiveField(6)
  int jumlahReview;

  @HiveField(7)
  int harga;

  @HiveField(8)
  String imageBase64;
  
  @HiveField(9)
  String jamBuka;
  
  @HiveField(10)
  String jamTutup;

  AktivitasModel({
    required this.nama,
    required this.deskripsi,
    required this.tipe,
    required this.lokasi,
    required this.lokasiDetail,
    required this.rating,
    required this.jumlahReview,
    required this.harga,
    required this.imageBase64,
    this.jamBuka = '08:00',
    this.jamTutup = '17:00',
  });

  // Getter untuk mendapatkan icon berdasarkan tipe
  String get tipeIcon {
    switch (tipe.toLowerCase()) {
      case 'budaya':
        return '🏛️';
      case 'atraksi':
        return '🎢';
      case 'alam':
        return '🌿';
      default:
        return '📍';
    }
  }

  // Getter untuk format harga
  String get formattedHarga {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Getter untuk format rating
  String get formattedRating {
    return rating.toStringAsFixed(1);
  }
  
  // Getter untuk jam operasional
  String get jamOperasional {
    return '$jamBuka - $jamTutup';
  }

  @override
  String toString() {
    return 'AktivitasModel(nama: $nama, tipe: $tipe, lokasi: $lokasi, rating: $rating, harga: $harga)';
  }
}