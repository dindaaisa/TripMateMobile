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
  @HiveField(12)
  final String? transportasi;
  @HiveField(13)
  final String? aktivitasSeru;
  @HiveField(14)
  final String? kuliner;

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
    this.aktivitasSeru,
    this.kuliner,
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
    String? aktivitasSeru,
    String? kuliner,
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
      aktivitasSeru: aktivitasSeru ?? this.aktivitasSeru,
      kuliner: kuliner ?? this.kuliner,
    );
  }
}