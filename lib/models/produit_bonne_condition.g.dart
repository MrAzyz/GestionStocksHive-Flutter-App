// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produit_bonne_condition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProduitBonneConditionAdapter extends TypeAdapter<ProduitBonneCondition> {
  @override
  final int typeId = 1;

  @override
  ProduitBonneCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProduitBonneCondition(
      clientName: fields[0] as String,
      rubriqueNumber: fields[1] as String,
      essaleNumber: fields[2] as String,
      colisCount: fields[3] as int,
      imagePath: fields[4] as String,
      typeVolume: fields[5] as String,
      positionZone: fields[6] as String,
      emplacement: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProduitBonneCondition obj) {
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
      ..write(obj.typeVolume)
      ..writeByte(6)
      ..write(obj.positionZone)
      ..writeByte(7)
      ..write(obj.emplacement);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProduitBonneConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
