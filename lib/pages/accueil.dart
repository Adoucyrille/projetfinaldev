import 'package:flutter/material.dart';
import '../modele/database.dart';
import '../pages/ajout.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<Accueil> {
  List<Map<String, dynamic>> _taches = [];

  @override
  void initState() {
    super.initState();
    _chargerTaches();
  }

  // Charger les tâches
  Future<void> _chargerTaches() async {
    final data = await DatabaseJohn.instance.getTodos();
    setState(() {
      _taches = data;
    });
  }

  // Supprimer une tâche
  Future<void> _supprimerTache(int id) async {
    await DatabaseJohn.instance.deleteTodo(id);
    await _chargerTaches();
  }

  // 🔥 CONFIRMATION DE SUPPRESSION
  Future<void> _confirmerSuppression(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context); // fermer le popup
                await _supprimerTache(id); // supprimer
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  // 🔥 Modal Bottom Sheet pour modifier une tâche
  void _ouvrirModalModification(Map<String, dynamic> tache) {
    TextEditingController titreController =
        TextEditingController(text: tache['titre']);
    TextEditingController contenuController =
        TextEditingController(text: tache['contenu']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Modifier la tâche",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: titreController,
                decoration: const InputDecoration(
                  labelText: "Titre",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: contenuController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Contenu",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await DatabaseJohn.instance.updateTodo(
                      tache['id'],
                      titreController.text,
                      contenuController.text,
                    );

                    Navigator.pop(context);
                    _chargerTaches();
                  },
                  child: const Text("Enregistrer"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.orange,
         title: const Text('ADOU Bloc Notes', style: TextStyle(color: Colors.white, fontSize: 22),), 
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

      // LISTE DES TÂCHES
      body: _taches.isEmpty
          ? const Center(
              child: Text(
                "Aucune tâche pour le moment",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _taches.length,
              itemBuilder: (context, index) {
                final tache = _taches[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      tache['titre'] ?? "Sans titre",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      tache['contenu'] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // 🔥 Icônes modification + suppression
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _ouvrirModalModification(tache),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmerSuppression(tache['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // BOUTON AJOUTER
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AjoutTache()),
          );

          if (result == true) _chargerTaches();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
