// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kamar_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KamarModelAdapter extends TypeAdapter<KamarModel> {
  @override
  final int typeId = 6;

  @override
  KamarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KamarModel(
      hotelId: fields[0] as String,
      nama: fields[1] as String,
      ukuran: fields[2] as String,
      kapasitas: fields[3] as String,
      tipeKasur: fields[4] as String,
      fasilitas: (fields[5] as List).cast<String>(),
      badges: (fields[6] as List).cast<String>(),
      harga: fields[7] as int,
      imageBase64: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KamarModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.hotelId)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.ukuran)
      ..writeByte(3)
      ..write(obj.kapasitas)
      ..writeByte(4)
      ..write(obj.tipeKasur)
      ..writeByte(5)
      ..write(obj.fasilitas)
      ..writeByte(6)
      ..write(obj.badges)
      ..writeByte(7)
      ..write(obj.harga)
      ..writeByte(8)
      ..write(obj.imageBase64);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KamarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
