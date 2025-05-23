import 'package:hive/hive.dart';

part 'produit_bonne_condition.g.dart';

@HiveType(typeId: 1)
class ProduitBonneCondition extends HiveObject {
  @HiveField(0)
  String clientName;

  @HiveField(1)
  String rubriqueNumber;

  @HiveField(2)
  String essaleNumber;

  @HiveField(3)
  int colisCount;

  @HiveField(4)
  String imagePath;   // chemin local vers l'image

  @HiveField(5)
  String typeVolume;  // A / B / C

  @HiveField(6)
  String positionZone; // x / y / z

  @HiveField(7)
  int emplacement;     // 1 à 6

  ProduitBonneCondition({
    required this.clientName,
    required this.rubriqueNumber,
    required this.essaleNumber,
    required this.colisCount,
    required this.imagePath,
    required this.typeVolume,
    required this.positionZone,
    required this.emplacement,
  });
}
