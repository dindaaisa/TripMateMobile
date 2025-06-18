// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuliner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KulinerModelAdapter extends TypeAdapter<KulinerModel> {
  @override
  final int typeId = 7;

  @override
  KulinerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KulinerModel(
      nama: fields[0] as String,
      deskripsi: fields[1] as String,
      kategori: fields[2] as String,
      lokasi: fields[3] as String,
      lokasiDetail: fields[4] as String,
      rating: fields[5] as double,
      jumlahReview: fields[6] as int,
      hargaMulaiDari: fields[7] as int,
      imageBase64: fields[8] as String,
      jamBuka: fields[9] as String,
      jamTutup: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KulinerModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.deskripsi)
      ..writeByte(2)
      ..write(obj.kategori)
      ..writeByte(3)
      ..write(obj.lokasi)
      ..writeByte(4)
      ..write(obj.lokasiDetail)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.jumlahReview)
      ..writeByte(7)
      ..write(obj.hargaMulaiDari)
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
      other is KulinerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
