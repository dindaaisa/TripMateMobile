import 'package:hive/hive.dart';

part 'hotel_model.g.dart';

@HiveType(typeId: 3)
class HotelModel extends HiveObject {
  @HiveField(0)
  String nama;

  /// Lokasi utama (wilayah), misal: "Denpasar, Bali"
  @HiveField(1)
  String lokasi;

  /// Rating hotel
  @HiveField(2)
  double rating;

  /// Harga rata-rata/mulai dari (opsional, untuk tampilan awal)
  @HiveField(3)
  int harga;

  /// Tipe hotel, misal: "Hotel", "Villa", dst.
  @HiveField(4)
  String tipe;

  /// Fasilitas utama hotel
  @HiveField(5)
  List<String> fasilitas;

  /// Gambar utama hotel dalam base64
  @HiveField(6)
  String imageBase64;

  /// Badge pada hotel (misal: promo, populer, bebas asap rokok, dll)
  @HiveField(7)
  List<String> badge;

  /// Jumlah review untuk format "4.8 (205 reviews)"
  @HiveField(8)
  int reviewCount;

  /// Lokasi detail, misal: alamat lengkap
  @HiveField(9)
  String lokasiDetail;

  /// Daftar area sekitar/akomodasi (AreaAkomodasiModel)
  @HiveField(10)
  List<AreaAkomodasiModel> areaAkomodasi;

  HotelModel({
    required this.nama,
    required this.lokasi,
    required this.rating,
    required this.harga,
    required this.tipe,
    required this.fasilitas,
    required this.imageBase64,
    required this.badge,
    this.reviewCount = 0,
    required this.lokasiDetail,
    required this.areaAkomodasi,
  });
}

/// Model untuk area sekitar akomodasi/hotel
@HiveType(typeId: 4)
class AreaAkomodasiModel extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  double jarakKm;

  /// Nama ikon (misal: "location_on", "beach_access")
  @HiveField(2)
  String iconName;

  AreaAkomodasiModel({
    required this.nama,
    required this.jarakKm,
    required this.iconName,
  });
}

/// Model untuk opsi dropdown tipe, fasilitas, dan badge hotel
@HiveType(typeId: 5)
class HotelOptionsModel extends HiveObject {
  @HiveField(0)
  List<String> tipe;

  @HiveField(1)
  List<String> facilities;

  @HiveField(2)
  List<String> badge;

  HotelOptionsModel({
    required this.tipe,
    required this.facilities,
    required this.badge,
  });
}