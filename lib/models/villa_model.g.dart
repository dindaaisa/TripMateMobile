// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'villa_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AreaVillaModelAdapter extends TypeAdapter<AreaVillaModel> {
  @override
  final int typeId = 10;

  @override
  AreaVillaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AreaVillaModel(
      nama: fields[0] as String,
      jarakKm: fields[1] as double,
      iconName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AreaVillaModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.jarakKm)
      ..writeByte(2)
      ..write(obj.iconName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaVillaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VillaModelAdapter extends TypeAdapter<VillaModel> {
  @override
  final int typeId = 11;

  @override
  VillaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VillaModel(
      nama: fields[0] as String,
      deskripsi: fields[1] as String,
      lokasi: fields[2] as String,
      lokasiDetail: fields[3] as String,
      hargaPerMalam: fields[4] as int,
      rating: fields[5] as double,
      jumlahReview: fields[6] as int,
      fasilitas: (fields[7] as List).cast<String>(),
      jumlahKamar: fields[8] as int,
      kapasitas: fields[9] as int,
      imageBase64: fields[10] as String,
      checkIn: fields[11] as String,
      checkOut: fields[12] as String,
      tipeVilla: fields[13] as String,
      badge: (fields[14] as List).cast<String>(),
      areaVilla: (fields[15] as List).cast<AreaVillaModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, VillaModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.deskripsi)
      ..writeByte(2)
      ..write(obj.lokasi)
      ..writeByte(3)
      ..write(obj.lokasiDetail)
      ..writeByte(4)
      ..write(obj.hargaPerMalam)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.jumlahReview)
      ..writeByte(7)
      ..write(obj.fasilitas)
      ..writeByte(8)
      ..write(obj.jumlahKamar)
      ..writeByte(9)
      ..write(obj.kapasitas)
      ..writeByte(10)
      ..write(obj.imageBase64)
      ..writeByte(11)
      ..write(obj.checkIn)
      ..writeByte(12)
      ..write(obj.checkOut)
      ..writeByte(13)
      ..write(obj.tipeVilla)
      ..writeByte(14)
      ..write(obj.badge)
      ..writeByte(15)
      ..write(obj.areaVilla);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VillaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VillaOptionsModelAdapter extends TypeAdapter<VillaOptionsModel> {
  @override
  final int typeId = 12;

  @override
  VillaOptionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VillaOptionsModel(
      tipeVilla: (fields[0] as List).cast<String>(),
      lokasi: (fields[1] as List).cast<String>(),
      facilities: (fields[2] as List).cast<String>(),
      badge: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, VillaOptionsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tipeVilla)
      ..writeByte(1)
      ..write(obj.lokasi)
      ..writeByte(2)
      ..write(obj.facilities)
      ..writeByte(3)
      ..write(obj.badge);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VillaOptionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
