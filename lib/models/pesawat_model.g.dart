// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pesawat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PesawatModelAdapter extends TypeAdapter<PesawatModel> {
  @override
  final int typeId = 9;

  @override
  PesawatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PesawatModel(
      nama: fields[0] as String,
      asal: fields[1] as String,
      tujuan: fields[2] as String,
      kelas: fields[3] as String,
      harga: fields[4] as int,
      waktu: fields[5] as DateTime,
      durasi: fields[6] as int,
      imageBase64: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PesawatModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.asal)
      ..writeByte(2)
      ..write(obj.tujuan)
      ..writeByte(3)
      ..write(obj.kelas)
      ..writeByte(4)
      ..write(obj.harga)
      ..writeByte(5)
      ..write(obj.waktu)
      ..writeByte(6)
      ..write(obj.durasi)
      ..writeByte(7)
      ..write(obj.imageBase64);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PesawatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
