import 'package:flutter/material.dart';
import 'pages/connexion.dart';
import 'pages/inscription.dart';
import 'pages/accueil.dart';
import 'pages/ajout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADOU Bloc Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 🔹 Première page au lancement
      initialRoute: '/accueil',
      routes: {
        '/connexion': (context) => const Connexion(),
        '/inscription': (context) => const Inscription(),
        '/accueil': (context) => const Accueil(),
        '/ajout': (context) => const AjoutTache(),

      },
    );
  }
}
