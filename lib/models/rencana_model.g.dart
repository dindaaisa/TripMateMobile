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
      kelasPesawat: fields[13] as String?,
      hargaPesawat: fields[14] as int?,
      waktuPesawat: fields[15] as String?,
      asalPesawat: fields[16] as String?,
      tujuanPesawat: fields[17] as String?,
      durasiPesawat: fields[18] as int?,
      imagePesawat: fields[19] as String?,
      mobil: fields[23] as String?,
      tipeMobil: fields[24] as String?,
      hargaMobil: fields[25] as int?,
      jumlahPenumpangMobil: fields[26] as String?,
      imageMobil: fields[27] as String?,
      aktivitasSeru: fields[20] as String?,
      kuliner: fields[21] as String?,
      isPaid: fields[22] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RencanaModel obj) {
    writer
      ..writeByte(28)
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
      ..write(obj.kelasPesawat)
      ..writeByte(14)
      ..write(obj.hargaPesawat)
      ..writeByte(15)
      ..write(obj.waktuPesawat)
      ..writeByte(16)
      ..write(obj.asalPesawat)
      ..writeByte(17)
      ..write(obj.tujuanPesawat)
      ..writeByte(18)
      ..write(obj.durasiPesawat)
      ..writeByte(19)
      ..write(obj.imagePesawat)
      ..writeByte(23)
      ..write(obj.mobil)
      ..writeByte(24)
      ..write(obj.tipeMobil)
      ..writeByte(25)
      ..write(obj.hargaMobil)
      ..writeByte(26)
      ..write(obj.jumlahPenumpangMobil)
      ..writeByte(27)
      ..write(obj.imageMobil)
      ..writeByte(20)
      ..write(obj.aktivitasSeru)
      ..writeByte(21)
      ..write(obj.kuliner)
      ..writeByte(22)
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
