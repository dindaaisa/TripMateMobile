// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobil_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MobilModelAdapter extends TypeAdapter<MobilModel> {
  @override
  final int typeId = 8;

  @override
  MobilModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MobilModel(
      merk: fields[0] as String,
      jumlahPenumpang: fields[1] as String,
      tipeMobil: fields[2] as String,
      hargaSewa: fields[3] as int,
      imageBase64: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MobilModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.merk)
      ..writeByte(1)
      ..write(obj.jumlahPenumpang)
      ..writeByte(2)
      ..write(obj.tipeMobil)
      ..writeByte(3)
      ..write(obj.hargaSewa)
      ..writeByte(4)
      ..write(obj.imageBase64);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobilModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
