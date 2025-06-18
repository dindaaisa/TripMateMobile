// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aktivitas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AktivitasModelAdapter extends TypeAdapter<AktivitasModel> {
  @override
  final int typeId = 13;

  @override
  AktivitasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AktivitasModel(
      nama: fields[0] as String,
      deskripsi: fields[1] as String,
      tipe: fields[2] as String,
      lokasi: fields[3] as String,
      lokasiDetail: fields[4] as String,
      rating: fields[5] as double,
      jumlahReview: fields[6] as int,
      harga: fields[7] as int,
      imageBase64: fields[8] as String,
      jamBuka: fields[9] as String,
      jamTutup: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AktivitasModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.deskripsi)
      ..writeByte(2)
      ..write(obj.tipe)
      ..writeByte(3)
      ..write(obj.lokasi)
      ..writeByte(4)
      ..write(obj.lokasiDetail)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.jumlahReview)
      ..writeByte(7)
      ..write(obj.harga)
      ..writeByte(8)
      ..write(obj.imageBase64)
      ..writeByte(9)
      ..write(obj.jamBuka)
      ..writeByte(10)
      ..write(obj.jamTutup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AktivitasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
