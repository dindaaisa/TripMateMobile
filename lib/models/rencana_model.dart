import 'package:hive/hive.dart';

part 'rencana_model.g.dart';

@HiveType(typeId: 2) // Ganti typeId sesuai kebutuhan, asal tidak bentrok
class RencanaModel extends HiveObject {
  @HiveField(0)
  String userId; // untuk mengaitkan rencana dengan pengguna

  @HiveField(1)
  String name;

  @HiveField(2)
  String origin;

  @HiveField(3)
  String destination;

  @HiveField(4)
  String startDate;

  @HiveField(5)
  String endDate;

  @HiveField(6)
  String sumDate;

  @HiveField(7)
  String people;

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
