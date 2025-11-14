import 'package:flutter/material.dart';
import 'package:projetmobilfinal/pages/accueil.dart';
import '../modele/database.dart';

class AjoutTache extends StatefulWidget {
  const AjoutTache({super.key});

  @override
  State<AjoutTache> createState() => _AjoutTacheState();
}

class _AjoutTacheState extends State<AjoutTache> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();

  int _indexMenu = 1; // On démarre sur l'onglet Bloc-note

  // Ajouter la tâche
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

    Navigator.pop(context, true); // Retour à Accueil + rafraîchissement
  }

  // Gestion navigation footer
  void _changerPage(int index) {
    setState(() {
      _indexMenu = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Accueil()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'ADOU Bloc Notes',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/connexion');
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Ajout de nouvelles notes",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 20),

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
                labelText: "Contenu",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _ajouterTache,
              icon: const Icon(Icons.save),
              label: const Text(
                "Enregistrer",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),

      // ===== FOOTER =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexMenu,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _changerPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: " Notes",
          ),
        ],
      ),
    );
  }
}
