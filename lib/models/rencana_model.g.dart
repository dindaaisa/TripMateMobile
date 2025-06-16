// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rencana_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RencanaModelAdapter extends TypeAdapter<RencanaModel> {
  @override
  final int typeId = 2;

  @override
  RencanaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RencanaModel(
      userId: fields[0] as String,
      name: fields[1] as String,
      origin: fields[2] as String,
      destination: fields[3] as String,
      startDate: fields[4] as String,
      endDate: fields[5] as String,
      sumDate: fields[6] as String,
      people: fields[7] as String,
      imageBase64: fields[8] as String?,
      akomodasi: fields[9] as String?,
      kamarNama: fields[10] as String?,
      biayaAkomodasi: fields[11] as int?,
      transportasi: fields[12] as String?,
      aktivitasSeru: fields[13] as String?,
      kuliner: fields[14] as String?,
      isPaid: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RencanaModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.origin)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.sumDate)
      ..writeByte(7)
      ..write(obj.people)
      ..writeByte(8)
      ..write(obj.imageBase64)
      ..writeByte(9)
      ..write(obj.akomodasi)
      ..writeByte(10)
      ..write(obj.kamarNama)
      ..writeByte(11)
      ..write(obj.biayaAkomodasi)
      ..writeByte(12)
      ..write(obj.transportasi)
      ..writeByte(13)
      ..write(obj.aktivitasSeru)
      ..writeByte(14)
      ..write(obj.kuliner)
      ..writeByte(15)
      ..write(obj.isPaid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RencanaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
