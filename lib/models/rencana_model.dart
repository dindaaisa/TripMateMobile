import 'package:hive/hive.dart';

part 'rencana_model.g.dart';

@HiveType(typeId: 2)
class RencanaModel extends HiveObject {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String origin;
  @HiveField(3)
  final String destination;
  @HiveField(4)
  final String startDate;
  @HiveField(5)
  final String endDate;
  @HiveField(6)
  final String sumDate;
  @HiveField(7)
  final String people;
  @HiveField(8)
  final String? imageBase64;
  @HiveField(9)
  final String? akomodasi;
  @HiveField(10)
  final String? kamarNama;
  @HiveField(11)
  final int? biayaAkomodasi;

  // --- Transportasi (Pesawat) ---
  @HiveField(12)
  final String? transportasi; // Ex: nama pesawat
  @HiveField(13)
  final String? kelasPesawat;
  @HiveField(14)
  final int? hargaPesawat;
  @HiveField(15)
  final String? waktuPesawat; // ISO8601 string
  @HiveField(16)
  final String? asalPesawat;
  @HiveField(17)
  final String? tujuanPesawat;
  @HiveField(18)
  final int? durasiPesawat;
  @HiveField(19)
  final String? imagePesawat;

  // --- Transportasi (Mobil) ---
  @HiveField(23)
  final String? mobil; // Merk mobil
  @HiveField(24)
  final String? tipeMobil;
  @HiveField(25)
  final int? hargaMobil;
  @HiveField(26)
  final String? jumlahPenumpangMobil;
  @HiveField(27)
  final String? imageMobil;

  // --- Lain-lain ---
  @HiveField(20)
  final String? aktivitasSeru;
  @HiveField(21)
  final String? kuliner;
  @HiveField(22)
  bool isPaid;

  RencanaModel({
    required this.userId,
    required this.name,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.sumDate,
    required this.people,
    this.imageBase64,
    this.akomodasi,
    this.kamarNama,
    this.biayaAkomodasi,
    this.transportasi,
    this.kelasPesawat,
    this.hargaPesawat,
    this.waktuPesawat,
    this.asalPesawat,
    this.tujuanPesawat,
    this.durasiPesawat,
    this.imagePesawat,
    this.mobil,
    this.tipeMobil,
    this.hargaMobil,
    this.jumlahPenumpangMobil,
    this.imageMobil,
    this.aktivitasSeru,
    this.kuliner,
    this.isPaid = false,
  });

  RencanaModel copyWith({
    String? userId,
    String? name,
    String? origin,
    String? destination,
    String? startDate,
    String? endDate,
    String? sumDate,
    String? people,
    String? imageBase64,
    String? akomodasi,
    String? kamarNama,
    int? biayaAkomodasi,
    String? transportasi,
    String? kelasPesawat,
    int? hargaPesawat,
    String? waktuPesawat,
    String? asalPesawat,
    String? tujuanPesawat,
    int? durasiPesawat,
    String? imagePesawat,
    String? mobil,
    String? tipeMobil,
    int? hargaMobil,
    String? jumlahPenumpangMobil,
    String? imageMobil,
    String? aktivitasSeru,
    String? kuliner,
    bool? isPaid,
  }) {
    return RencanaModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sumDate: sumDate ?? this.sumDate,
      people: people ?? this.people,
      imageBase64: imageBase64 ?? this.imageBase64,
      akomodasi: akomodasi ?? this.akomodasi,
      kamarNama: kamarNama ?? this.kamarNama,
      biayaAkomodasi: biayaAkomodasi ?? this.biayaAkomodasi,
      transportasi: transportasi ?? this.transportasi,
      kelasPesawat: kelasPesawat ?? this.kelasPesawat,
      hargaPesawat: hargaPesawat ?? this.hargaPesawat,
      waktuPesawat: waktuPesawat ?? this.waktuPesawat,
      asalPesawat: asalPesawat ?? this.asalPesawat,
      tujuanPesawat: tujuanPesawat ?? this.tujuanPesawat,
      durasiPesawat: durasiPesawat ?? this.durasiPesawat,
      imagePesawat: imagePesawat ?? this.imagePesawat,
      mobil: mobil ?? this.mobil,
      tipeMobil: tipeMobil ?? this.tipeMobil,
      hargaMobil: hargaMobil ?? this.hargaMobil,
      jumlahPenumpangMobil: jumlahPenumpangMobil ?? this.jumlahPenumpangMobil,
      imageMobil: imageMobil ?? this.imageMobil,
      aktivitasSeru: aktivitasSeru ?? this.aktivitasSeru,
      kuliner: kuliner ?? this.kuliner,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}