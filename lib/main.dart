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
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;
  String result = "Choisissez une image";
  Interpreter? interpreter;
  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

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
    
    try {
      // 1. Lire l'image
      final bytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      
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
          input[0][y][x][0] = img.getRed(pixel) / 255.0;
          input[0][y][x][1] = img.getGreen(pixel) / 255.0;
          input[0][y][x][2] = img.getBlue(pixel) / 255.0;
        }
      }
      
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage de l'image
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: image == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 80, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Aucune image sélectionnée"),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            SizedBox(height: 20),
            // Résultat
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                result,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // Bouton
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.photo_library),
                label: Text("Choisir une image", style: TextStyle(fontSize: 18)),
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