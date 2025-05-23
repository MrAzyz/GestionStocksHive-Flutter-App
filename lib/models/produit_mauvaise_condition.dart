import 'package:hive/hive.dart';

part 'produit_mauvaise_condition.g.dart';

@HiveType(typeId: 0)
class ProduitMauvaiseCondition extends HiveObject {
  @HiveField(0)
  String clientName;

  @HiveField(1)
  String rubriqueNumber;

  @HiveField(2)
  String essaleNumber;

  @HiveField(3)
  int colisCount;

  @HiveField(4)
  String imagePath; // chemin local vers l'image

  @HiveField(5)
  String containerNumber;

  @HiveField(6)
  String designation;

  @HiveField(7)
  String observation;

  ProduitMauvaiseCondition({
    required this.clientName,
    required this.rubriqueNumber,
    required this.essaleNumber,
    required this.colisCount,
    required this.imagePath,
    required this.containerNumber,
    required this.designation,
    required this.observation,
  });
}
