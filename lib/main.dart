import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/produit_mauvaise_condition.dart';
import 'models/produit_bonne_condition.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  Hive.registerAdapter(ProduitMauvaiseConditionAdapter());
  Hive.registerAdapter(ProduitBonneConditionAdapter());

  await Hive.openBox<ProduitMauvaiseCondition>('mauvaiseConditionBox');
  await Hive.openBox<ProduitBonneCondition>('bonneConditionBox');

  runApp(const GestionStocksApp());
}

class GestionStocksApp extends StatelessWidget {
  const GestionStocksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Stocks (Hive)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
