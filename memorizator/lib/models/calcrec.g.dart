// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calcrec.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalcRecAdapter extends TypeAdapter<CalcRec> {
  @override
  final int typeId = 1;

  @override
  CalcRec read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalcRec(
      fields[0] as DateTime,
      fields[1] as String,
      fields[3] as double,
      fields[11] as double,
      fields[12] as String,
      fields[2] as int,
      fields[13] as String,
      codeName: fields[4] as String?,
      barcode: fields[5] as String?,
      latitude: fields[6] as double?,
      longitude: fields[7] as double?,
      place: fields[10] as String?,
      listPhotoPath: (fields[8] as List?)?.cast<String>(),
      rateMap: (fields[9] as Map?)?.cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalcRec obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(11)
      ..write(obj.rating)
      ..writeByte(12)
      ..write(obj.comment)
      ..writeByte(13)
      ..write(obj.customName)
      ..writeByte(4)
      ..write(obj.codeName)
      ..writeByte(5)
      ..write(obj.barcode)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(10)
      ..write(obj.place)
      ..writeByte(8)
      ..write(obj.listPhotoPath)
      ..writeByte(9)
      ..write(obj.rateMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalcRecAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
