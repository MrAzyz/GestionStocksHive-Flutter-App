import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produit_bonne_condition.dart';
import 'ajout_bonne_condition_page.dart';

class BonneConditionPage extends StatefulWidget {
  const BonneConditionPage({Key? key}) : super(key: key);

  @override
  State<BonneConditionPage> createState() => _BonneConditionPageState();
}

class _BonneConditionPageState extends State<BonneConditionPage> {
  @override
  Widget build(BuildContext context) {
    final Box<ProduitBonneCondition> box =
    Hive.box<ProduitBonneCondition>('bonneConditionBox');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE8F5E8),
            ],
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<ProduitBonneCondition> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27AE60).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Aucun produit en bonne condition',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ajoutez votre premier produit en bonne condition',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF27AE60).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Produits en Bonne Condition',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${box.values.length} produit${box.values.length > 1 ? 's' : ''} disponible${box.values.length > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        final ProduitBonneCondition produit = box.getAt(index)!;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF27AE60).withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: produit.imagePath.isNotEmpty
                                    ? Image.file(
                                  File(produit.imagePath),
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  color: const Color(0xFF27AE60).withOpacity(0.1),
                                  child: const Icon(
                                    Icons.inventory_2,
                                    color: Color(0xFF27AE60),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              produit.clientName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            subtitle: Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    Icons.category_outlined,
                                    'Rubrique: ${produit.rubriqueNumber}',
                                  ),
                                  const SizedBox(height: 4),
                                  _buildInfoRow(
                                    Icons.numbers,
                                    'Essale: ${produit.essaleNumber}',
                                  ),
                                  const SizedBox(height: 4),
                                  _buildInfoRow(
                                    Icons.straighten,
                                    'Volume: ${produit.typeVolume}',
                                  ),
                                  const SizedBox(height: 4),
                                  _buildInfoRow(
                                    Icons.location_on_outlined,
                                    'Zone: ${produit.positionZone}${produit.emplacement}',
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange[600],
                                            size: 28,
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Confirmer la suppression',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                        'Voulez-vous vraiment supprimer ce produit ?',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.grey[600],
                                          ),
                                          child: const Text('Annuler'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Supprimer'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await produit.delete();
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF27AE60).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AjoutBonneConditionPage(),
              ),
            );
          },
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF27AE60),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
