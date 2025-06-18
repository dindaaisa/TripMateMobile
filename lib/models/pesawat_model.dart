import 'package:hive/hive.dart';

part 'pesawat_model.g.dart';

@HiveType(typeId: 9)
class PesawatModel extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String asal;

  @HiveField(2)
  String tujuan;

  @HiveField(3)
  String kelas;

  @HiveField(4)
  int harga;


  @HiveField(5)
  DateTime waktu;
  
  @HiveField(6)
  int durasi;

  @HiveField(7)
  String imageBase64;

  PesawatModel({
    required this.nama,
    required this.asal,
    required this.tujuan,
    required this.kelas,
    required this.harga,
    required this.waktu,
    required this.durasi,
    required this.imageBase64,
  });
}