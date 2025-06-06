// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HotelModelAdapter extends TypeAdapter<HotelModel> {
  @override
  final int typeId = 3;

  @override
  HotelModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HotelModel(
      nama: fields[0] as String,
      lokasi: fields[1] as String,
      rating: fields[2] as double,
      harga: fields[3] as int,
      tipe: fields[4] as String,
      fasilitas: (fields[5] as List).cast<String>(),
      imageBase64: fields[6] as String,
      badge: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HotelModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.lokasi)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.harga)
      ..writeByte(4)
      ..write(obj.tipe)
      ..writeByte(5)
      ..write(obj.fasilitas)
      ..writeByte(6)
      ..write(obj.imageBase64)
      ..writeByte(7)
      ..write(obj.badge);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotelModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HotelOptionsModelAdapter extends TypeAdapter<HotelOptionsModel> {
  @override
  final int typeId = 4;

  @override
  HotelOptionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HotelOptionsModel(
      tipe: (fields[0] as List).cast<String>(),
      facilities: (fields[1] as List).cast<String>(),
      badge: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HotelOptionsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tipe)
      ..writeByte(1)
      ..write(obj.facilities)
      ..writeByte(2)
      ..write(obj.badge);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotelOptionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
