// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing_page_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LandingPageModelAdapter extends TypeAdapter<LandingPageModel> {
  @override
  final int typeId = 1;

  @override
  LandingPageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LandingPageModel(
      title: fields[0] as String,
      description: fields[1] as String,
      imageBytes: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, LandingPageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LandingPageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
