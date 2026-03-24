import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconnaissance Plantes',
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
    interpreter = await Interpreter.fromAsset('assets/model.tflite');
    String labelData = await rootBundle.loadString('assets/labels.txt');
    labels = labelData.split('\n');
  }

  pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() { image = File(picked.path); });
    classifyImage(File(picked.path));
  }

  classifyImage(File imageFile) async {
    var input = List.filled(1 * 128 * 128 * 3, 0.0).reshape([1, 128, 128, 3]);
    var output = List.filled(1 * 5, 0.0).reshape([1, 5]);
    interpreter!.run(input, output);
    int maxIndex = 0;
    double maxVal = output[0][0];
    for (int i = 1; i < 5; i++) {
      if (output[0][i] > maxVal) {
        maxVal = output[0][i];
        maxIndex = i;
      }
    }
    setState(() { result = labels[maxIndex]; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reconnaissance de Plantes")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image == null ? Text("Aucune image") : Image.file(image!, height: 250),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickImage, child: Text("Choisir une image")),
          ],
        ),
      ),
    );
  }
}