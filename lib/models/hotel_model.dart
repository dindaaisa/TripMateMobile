import 'package:hive/hive.dart';

// models/hotel_model.dart

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
  String tipe; // sebelumnya: badge

  @HiveField(5)
  List<String> fasilitas;

  @HiveField(6)
  String imageBase64;

  @HiveField(7)
  List<String> badge; // baru

  HotelModel({
    required this.nama,
    required this.lokasi,
    required this.rating,
    required this.harga,
    required this.tipe,
    required this.fasilitas,
    required this.imageBase64,
    required this.badge,
  });
}


/// Model untuk opsi tipe, fasilitas, dan badge tambahan hotel
@HiveType(typeId: 4)
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

