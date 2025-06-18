// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TiketAktivitasModelAdapter extends TypeAdapter<TiketAktivitasModel> {
  @override
  final int typeId = 14;

  @override
  TiketAktivitasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TiketAktivitasModel(
      aktivitasId: fields[0] as String,
      namaTiket: fields[1] as String,
      deskripsi: fields[2] as String,
      harga: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TiketAktivitasModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.aktivitasId)
      ..writeByte(1)
      ..write(obj.namaTiket)
      ..writeByte(2)
      ..write(obj.deskripsi)
      ..writeByte(3)
      ..write(obj.harga);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TiketAktivitasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
