import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/produit_bonne_condition.dart';

class AjoutBonneConditionPage extends StatefulWidget {
  const AjoutBonneConditionPage({Key? key}) : super(key: key);

  @override
  State<AjoutBonneConditionPage> createState() =>
      _AjoutBonneConditionPageState();
}

class _AjoutBonneConditionPageState extends State<AjoutBonneConditionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _rubriqueController = TextEditingController();
  final TextEditingController _essaleController = TextEditingController();
  final TextEditingController _colisController = TextEditingController();

  String _selectedImagePath = '';
  String? _selectedTypeVolume;  // A, B, C
  String? _selectedPositionZone; // x, y, z
  int? _selectedEmplacement;    // 1..6

  @override
  void dispose() {
    _clientController.dispose();
    _rubriqueController.dispose();
    _essaleController.dispose();
    _colisController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImagePath = result.files.single.path!;
      });
    }
  }

  Future<void> _saveProduit() async {
    // 1) Validation des champs
    if (!_formKey.currentState!.validate() ||
        _selectedImagePath.isEmpty ||
        _selectedTypeVolume == null ||
        _selectedPositionZone == null ||
        _selectedEmplacement == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Veuillez remplir tous les champs et sélectionner une image et une position.'),
              ),
            ],
          ),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final box = Hive.box<ProduitBonneCondition>('bonneConditionBox');
    final existeDeja = box.values.any((p) =>
    p.typeVolume == _selectedTypeVolume &&
        p.positionZone == _selectedPositionZone &&
        p.emplacement == _selectedEmplacement);
    if (existeDeja) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.location_off, color: Color(0xFFE74C3C), size: 28),
              SizedBox(width: 12),
              Text(
                'Position déjà prise',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'La position ${_selectedTypeVolume!}-${_selectedPositionZone!}${_selectedEmplacement!} est déjà attribuée.',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // 3) Copier l'image dans un dossier local propre
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDocDir.path}/images_bonne');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final fileName = path.basename(_selectedImagePath);
    final newImagePath =
    path.join(imagesDir.path, '${DateTime.now().millisecondsSinceEpoch}_$fileName');
    await File(_selectedImagePath).copy(newImagePath);

    final produit = ProduitBonneCondition(
      clientName: _clientController.text.trim(),
      rubriqueNumber: _rubriqueController.text.trim(),
      essaleNumber: _essaleController.text.trim(),
      colisCount: int.parse(_colisController.text.trim()),
      imagePath: newImagePath,
      typeVolume: _selectedTypeVolume!,
      positionZone: _selectedPositionZone!,
      emplacement: _selectedEmplacement!,
    );

    await box.add(produit);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Produit ajouté avec succès !'),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter Produit Bonne Condition',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF27AE60),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF27AE60),
                Color(0xFF2ECC71),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
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
                  child: const Row(
                    children: [
                      Icon(Icons.add_box, color: Colors.white, size: 32),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nouveau Produit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Ajoutez un produit en bonne condition',
                              style: TextStyle(
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

                // Form Fields
                _buildFormSection(
                  title: 'Informations Client',
                  icon: Icons.person_outline,
                  children: [
                    _buildTextField(
                      controller: _clientController,
                      label: 'Nom du client',
                      icon: Icons.person,
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ],
                ),

                _buildFormSection(
                  title: 'Détails du Produit',
                  icon: Icons.inventory_2_outlined,
                  children: [
                    _buildTextField(
                      controller: _rubriqueController,
                      label: 'Numéro de rubrique',
                      icon: Icons.category,
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _essaleController,
                      label: "Numéro d'essale",
                      icon: Icons.numbers,
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _colisController,
                      label: 'Nombre de colis',
                      icon: Icons.inventory,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requis';
                        if (int.tryParse(value) == null) return 'Entier requis';
                        return null;
                      },
                    ),
                  ],
                ),

                _buildFormSection(
                  title: 'Image du Produit',
                  icon: Icons.photo_camera_outlined,
                  children: [
                    _buildImagePicker(),
                  ],
                ),

                _buildFormSection(
                  title: 'Localisation',
                  icon: Icons.location_on_outlined,
                  children: [
                    _buildDropdown<String>(
                      label: 'Type Volume',
                      value: _selectedTypeVolume,
                      icon: Icons.straighten,
                      items: const [
                        DropdownMenuItem(value: 'A', child: Text('A (Fort volume)')),
                        DropdownMenuItem(value: 'B', child: Text('B (Volume moyen)')),
                        DropdownMenuItem(value: 'C', child: Text('C (Faible volume)')),
                      ],
                      onChanged: (val) => setState(() => _selectedTypeVolume = val),
                      validator: (value) => value == null ? 'Veuillez sélectionner un type' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown<String>(
                      label: 'Zone (x, y ou z)',
                      value: _selectedPositionZone,
                      icon: Icons.map,
                      items: const [
                        DropdownMenuItem(value: 'x', child: Text('Zone x')),
                        DropdownMenuItem(value: 'y', child: Text('Zone y')),
                        DropdownMenuItem(value: 'z', child: Text('Zone z')),
                      ],
                      onChanged: (val) => setState(() => _selectedPositionZone = val),
                      validator: (value) => value == null ? 'Veuillez sélectionner une zone' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown<int>(
                      label: 'Emplacement (1–6)',
                      value: _selectedEmplacement,
                      icon: Icons.place,
                      items: List.generate(
                        6,
                            (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('Emplacement ${i + 1}'),
                        ),
                      ),
                      onChanged: (val) => setState(() => _selectedEmplacement = val),
                      validator: (value) => value == null ? 'Veuillez choisir un emplacement' : null,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Save Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF27AE60).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveProduit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Enregistrer le Produit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF27AE60), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF27AE60)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF27AE60)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          if (_selectedImagePath.isNotEmpty) ...[
            Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(_selectedImagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library, color: Color(0xFF27AE60)),
                  label: Text(
                    _selectedImagePath.isEmpty ? 'Choisir une image' : 'Changer l\'image',
                    style: const TextStyle(color: Color(0xFF27AE60)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60).withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_selectedImagePath.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              path.basename(_selectedImagePath),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
