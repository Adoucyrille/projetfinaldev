import 'package:flutter/material.dart';
import '../modele/database.dart';

class AjoutTache extends StatefulWidget {
  const AjoutTache({super.key});

  @override
  State<AjoutTache> createState() => _AjoutTacheState();
}

class _AjoutTacheState extends State<AjoutTache> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();

  Future<void> _ajouterTache() async {
    final titre = _titreController.text.trim();
    final contenu = _contenuController.text.trim();

    if (titre.isEmpty || contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    await DatabaseJohn.instance.addTodo(titre, contenu);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tâche ajoutée avec succès !")),
    );

    Navigator.pop(context); // Retour à la page d’accueil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une Tâche")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: "Titre de la tâche",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contenuController,
              decoration: const InputDecoration(
                labelText: "Contenu / Détails",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _ajouterTache,
              icon: const Icon(Icons.save),
              label: const Text("Enregistrer"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
