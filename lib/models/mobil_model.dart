import 'package:hive/hive.dart';

part 'mobil_model.g.dart';

@HiveType(typeId: 8)
class MobilModel extends HiveObject {
  @HiveField(0)
  String merk;

  @HiveField(1)
  String jumlahPenumpang; // dari dropdown: '4 Penumpang', '6 Penumpang', dll

  @HiveField(2)
  String tipeMobil; // dari dropdown: 'Otomatis', 'Manual'

  @HiveField(3)
  int hargaSewa; // nama disesuaikan dari "harga" jadi "hargaSewa"

  @HiveField(4)
  String imageBase64; // untuk menyimpan gambar mobil

  MobilModel({
    required this.merk,
    required this.jumlahPenumpang,
    required this.tipeMobil,
    required this.hargaSewa,
    required this.imageBase64,
  });
}