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

  Future<void> _chargerTaches() async {
    final data = await DatabaseJohn.instance.getTodos();
    setState(() {
      _taches = data;
    });
  }

  Future<void> _supprimerTache(int id) async {
    await DatabaseJohn.instance.deleteTodo(id);
    _chargerTaches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma Liste de Tâches"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
            onPressed: () => Navigator.pushReplacementNamed(context, '/connexion'),
          ),
        ],
      ),
      body: _taches.isEmpty
          ? const Center(child: Text("Aucune tâche pour le moment"))
          : ListView.builder(
              itemCount: _taches.length,
              itemBuilder: (context, index) {
                final tache = _taches[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      tache['titre'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(tache['contenu']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _supprimerTache(tache['id']),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Aller à la page d’ajout et rafraîchir la liste après retour
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AjoutTache()),
          );
          _chargerTaches();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
