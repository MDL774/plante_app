import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconnaissance Plantes',
      theme: ThemeData(primarySwatch: Colors.green),
<<<<<<< HEAD
      home: Home(),
=======
      home: HomeScreen(),
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  String _result = "Choisissez une image";
  bool _isLoading = false;
  Interpreter? _interpreter;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

<<<<<<< HEAD
  loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model.tflite');
      String labelData = await rootBundle.loadString('assets/labels.txt');
      labels = labelData.split('\n').where((l) => l.isNotEmpty).toList();
      print("✅ Modèle chargé avec succès!");
      print("📋 Labels: $labels");
    } catch (e) {
      print("❌ Erreur chargement modèle: $e");
      setState(() {
        result = "Erreur: modèle non chargé";
      });
    }
  }

  pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    
    setState(() {
      image = File(picked.path);
      result = "Analyse en cours...";
    });
    
    classifyImage(File(picked.path));
  }

  classifyImage(File imageFile) async {
    if (interpreter == null) {
      setState(() => result = "Modèle non chargé");
      return;
    }
    
=======
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      String labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n').where((l) => l.isNotEmpty).toList();
      print(" Modèle chargé: ${_labels.length} classes");
    } catch (e) {
      print(" Erreur: $e");
      setState(() => _result = "Erreur chargement modèle");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _isLoading = true;
      _result = "Analyse en cours...";
    });

    await _classifyImage(File(picked.path));
    setState(() => _isLoading = false);
  }

  Future<void> _classifyImage(File imageFile) async {
    if (_interpreter == null) {
      setState(() => _result = "Modèle non chargé");
      return;
    }

>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
    try {
      // 1. Lire l'image
      final bytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
<<<<<<< HEAD
      
      if (originalImage == null) {
        setState(() => result = "Erreur: impossible de lire l'image");
        return;
      }
      
      print("✅ Image chargée: ${originalImage.width}x${originalImage.height}");
      
      // 2. Redimensionner à 128x128 (vérifie la taille utilisée par ton modèle)
      int inputSize = 128; // ← à adapter si ton modèle utilise 224
      img.Image resizedImage = img.copyResize(originalImage, width: inputSize, height: inputSize);
      
      // 3. Créer le tensor d'entrée
      var input = List.filled(1 * inputSize * inputSize * 3, 0.0)
          .reshape([1, inputSize, inputSize, 3]);
      
      // 4. Remplir le tensor avec les pixels normalisés
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          int pixel = resizedImage.getPixel(x, y);
=======
      if (originalImage == null) {
        setState(() => _result = "Erreur lecture image");
        return;
      }

      // 2. Redimensionner à 128x128 (vérifie la taille de ton modèle)
      int inputSize = 224;
      img.Image resized = img.copyResize(originalImage, width: inputSize, height: inputSize);

      // 3. Créer le tensor d'entrée
      var input = List.filled(1 * inputSize * inputSize * 3, 0.0)
          .reshape([1, inputSize, inputSize, 3]);

      // 4. Remplir avec les pixels (normalisation entre 0 et 1)
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          int pixel = resized.getPixel(x, y);
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
          input[0][y][x][0] = img.getRed(pixel) / 255.0;
          input[0][y][x][1] = img.getGreen(pixel) / 255.0;
          input[0][y][x][2] = img.getBlue(pixel) / 255.0;
        }
      }
<<<<<<< HEAD
      
      print("✅ Tensor créé, début inférence...");
      
      // 5. Exécuter le modèle
      var output = List.filled(1 * labels.length, 0.0).reshape([1, labels.length]);
      interpreter!.run(input, output);
      
      // 6. Afficher les probabilités
      print("📊 Probabilités:");
      for (int i = 0; i < labels.length; i++) {
        print("   ${labels[i]}: ${(output[0][i] * 100).toStringAsFixed(1)}%");
      }
      
      // 7. Trouver la meilleure prédiction
      int maxIndex = 0;
      double maxVal = output[0][0];
      for (int i = 1; i < labels.length; i++) {
        if (output[0][i] > maxVal) {
          maxVal = output[0][i];
          maxIndex = i;
        }
      }
      
      // 8. Afficher le résultat
      setState(() {
        result = "${labels[maxIndex]} (${(maxVal * 100).toStringAsFixed(1)}%)";
      });
      
      print("✅ Prédiction finale: ${labels[maxIndex]}");
      
    } catch (e) {
      print("❌ Erreur lors de l'analyse: $e");
      setState(() => result = "Erreur: $e");
=======

      // 5. Exécuter le modèle
      var output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
      _interpreter!.run(input, output);

      // 6. Trouver la meilleure prédiction
      int bestIndex = 0;
      double bestValue = output[0][0];
      for (int i = 1; i < _labels.length; i++) {
        if (output[0][i] > bestValue) {
          bestValue = output[0][i];
          bestIndex = i;
        }
      }

      // 7. Afficher le résultat
      setState(() {
        _result = "${_labels[bestIndex]} (${(bestValue * 100).toStringAsFixed(1)}%)";
      });

    } catch (e) {
      print(" Erreur: $e");
      setState(() => _result = "Erreur: $e");
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reconnaissance de Plantes"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
<<<<<<< HEAD
            // Affichage de l'image
=======
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
<<<<<<< HEAD
                child: image == null
=======
                child: _image == null
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
<<<<<<< HEAD
                            Icon(Icons.image, size: 80, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Aucune image sélectionnée"),
=======
                            Icon(Icons.image, size: 60, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Aucune image"),
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
                        child: Image.file(image!, fit: BoxFit.cover),
=======
                        child: Image.file(_image!, fit: BoxFit.cover),
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
                      ),
              ),
            ),
            SizedBox(height: 20),
<<<<<<< HEAD
            // Résultat
=======
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
<<<<<<< HEAD
              child: Text(
                result,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // Bouton
=======
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      _result,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
            ),
            SizedBox(height: 20),
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
<<<<<<< HEAD
                onPressed: pickImage,
                icon: Icon(Icons.photo_library),
                label: Text("Choisir une image", style: TextStyle(fontSize: 18)),
=======
                onPressed: _isLoading ? null : _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text("Choisir une image"),
>>>>>>> 2489d5aab99c2034dbc23de3c807c67f3c086f80
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
