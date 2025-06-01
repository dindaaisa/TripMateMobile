import 'package:hive/hive.dart';

part 'rencana_model.g.dart';

@HiveType(typeId: 2) // Pastikan typeId tidak bentrok dengan model Hive lain
class RencanaModel extends HiveObject {
  @HiveField(0)
  String userId; // ID pengguna untuk mengaitkan rencana

  @HiveField(1)
  String name; // Nama rencana

  @HiveField(2)
  String origin; // Titik awal perjalanan

  @HiveField(3)
  String destination; // Tujuan perjalanan

  @HiveField(4)
  String startDate; // Tanggal mulai

  @HiveField(5)
  String endDate; // Tanggal selesai

  @HiveField(6)
  String sumDate; // Total hari perjalanan

  @HiveField(7)
  String people; // Jumlah orang yang ikut

  RencanaModel({
    required this.userId,
    required this.name,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.sumDate,
    required this.people,
  });
}
