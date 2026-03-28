
// FICHIER PRINCIPAL (main.dart)
// Projet : Reconnaissance d'espèces végétales
// Point d'entrée de l'application Flutter


// Import des bibliothèques Flutter pour l'interface utilisateur
import 'package:flutter/material.dart';

// Import du fichier contenant l'écran principal de reconnaissance
import 'package:plant_species_recognition/PlantSpeciesRecognition.dart';


// POINT D'ENTRÉE DE L'APPLICATION


/// La fonction main() est le point de départ de toute application Dart.
/// Le signe '=>' est une syntaxe raccourcie pour une fonction à une ligne.
/// runApp() lance l'application et construit l'arborescence des widgets.
void main() => runApp(App());


// CLASSE PRINCIPALE DE L'APPLICATION


/// Classe App : widget racine de l'application.
/// StatelessWidget signifie que ce widget est immuable :
/// ses propriétés ne changent pas après sa création.
class App extends StatelessWidget {

  /// Méthode build : construit l'interface utilisateur.
  /// Elle est appelée une fois au démarrage.
  @override
  Widget build(BuildContext context) {
    
    // MaterialApp : widget de base pour une application Flutter
    // Il fournit les fonctionnalités Material Design :
    // - Thème
    // - Navigation
    // - Localisation
    // - Routes
    return MaterialApp(
      // home : widget affiché à l'écran au démarrage
      // PlantSpeciesRecognition est l'écran principal de l'application
      home: PlantSpeciesRecognition()
    );
  }
}
