// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produit_mauvaise_condition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProduitMauvaiseConditionAdapter
    extends TypeAdapter<ProduitMauvaiseCondition> {
  @override
  final int typeId = 0;

  @override
  ProduitMauvaiseCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProduitMauvaiseCondition(
      clientName: fields[0] as String,
      rubriqueNumber: fields[1] as String,
      essaleNumber: fields[2] as String,
      colisCount: fields[3] as int,
      imagePath: fields[4] as String,
      containerNumber: fields[5] as String,
      designation: fields[6] as String,
      observation: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProduitMauvaiseCondition obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.clientName)
      ..writeByte(1)
      ..write(obj.rubriqueNumber)
      ..writeByte(2)
      ..write(obj.essaleNumber)
      ..writeByte(3)
      ..write(obj.colisCount)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.containerNumber)
      ..writeByte(6)
      ..write(obj.designation)
      ..writeByte(7)
      ..write(obj.observation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProduitMauvaiseConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
