import 'package:hive/hive.dart';

part 'kamar_model.g.dart';

@HiveType(typeId: 6)
class KamarModel extends HiveObject {
  @HiveField(0)
  String hotelId;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String ukuran;

  @HiveField(3)
  String kapasitas;

  @HiveField(4)
  String tipeKasur;

  @HiveField(5)
  List<String> fasilitas;

  @HiveField(6)
  List<String> badges;

  @HiveField(7)
  int harga;

  @HiveField(8)
  String imageBase64;

  KamarModel({
    required this.hotelId,
    required this.nama,
    required this.ukuran,
    required this.kapasitas,
    required this.tipeKasur,
    required this.fasilitas,
    required this.badges,
    required this.harga,
    required this.imageBase64,
  });
}