import 'package:hive/hive.dart';

part 'hotel_model.g.dart';

@HiveType(typeId: 3)
class HotelModel extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String lokasi;

  @HiveField(2)
  double rating;

  @HiveField(3)
  int harga;

  @HiveField(4)
  String badge;

  @HiveField(5)
  List<String> fasilitas;

  @HiveField(6)
  String imageBase64;

  HotelModel({
    required this.nama,
    required this.lokasi,
    required this.rating,
    required this.harga,
    required this.badge,
    required this.fasilitas,
    required this.imageBase64,
  });
}

/// Model untuk opsi badge dan fasilitas utama
@HiveType(typeId: 4)
class HotelOptionsModel extends HiveObject {
  @HiveField(0)
  List<String> badges;

  @HiveField(1)
  List<String> facilities;

  HotelOptionsModel({
    required this.badges,
    required this.facilities,
  });
}
