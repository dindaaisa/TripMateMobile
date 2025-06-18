import 'package:hive/hive.dart';

part 'kuliner_model.g.dart';

@HiveType(typeId: 7)
class KulinerModel extends HiveObject {
  @HiveField(0)
  String nama;
  @HiveField(1)
  String deskripsi;
  @HiveField(2)
  String kategori;
  @HiveField(3)
  String lokasi;
  @HiveField(4)
  String lokasiDetail;
  @HiveField(5)
  double rating;
  @HiveField(6)
  int jumlahReview;
  @HiveField(7)
  int hargaMulaiDari;
  @HiveField(8)
  String imageBase64;
  @HiveField(9)
  String jamBuka;
  @HiveField(10)
  String jamTutup;

  KulinerModel({
    required this.nama,
    required this.deskripsi,
    required this.kategori,
    required this.lokasi,
    required this.lokasiDetail,
    required this.rating,
    required this.jumlahReview,
    required this.hargaMulaiDari,
    required this.imageBase64,
    required this.jamBuka,
    required this.jamTutup,
  });

  String get formattedRating => rating.toStringAsFixed(1);

  String get formattedHarga {
    if (hargaMulaiDari >= 1000000) {
      return 'Rp ${(hargaMulaiDari / 1000000).toStringAsFixed(1)}jt';
    } else if (hargaMulaiDari >= 1000) {
      return 'Rp ${(hargaMulaiDari / 1000).toStringAsFixed(0)}rb';
    } else {
      return 'Rp $hargaMulaiDari';
    }
  }

  String get jamOperasional => '$jamBuka - $jamTutup';

  String get formattedReview {
    if (jumlahReview >= 1000) {
      return '${(jumlahReview / 1000).toStringAsFixed(1)}k reviews';
    } else {
      return '$jumlahReview reviews';
    }
  }
}