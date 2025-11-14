import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Classe qui gère la base de données locale SQLite
class DatabaseJohn {
  // Instance unique (Singleton)
  static final DatabaseJohn instance = DatabaseJohn._init();

  // Référence à la base de données
  static Database? _database;

  // Constructeur privé
  DatabaseJohn._init();

  /// Getter pour accéder à la base de données
  /// Si elle est déjà ouverte, on la réutilise.
  /// Sinon, on l’initialise une seule fois.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  /// Méthode d’initialisation de la base de données
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Création des tables lors de la première ouverture
  Future _createDB(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE utilisateur(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Table des tâches
    await db.execute('''
      CREATE TABLE taches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        contenu TEXT NOT NULL
      )
    ''');
  }

  // ==============================
  //      GESTION DES UTILISATEURS
  // ==============================

  /// Inscription d’un nouvel utilisateur
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db.insert('utilisateur', {
      'username': username,
      'password': password,
    });
  }

  /// Connexion d’un utilisateur
  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'utilisateur',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) return res.first;
    return null;
  }

  // ==============================
  //      GESTION DES TÂCHES
  // ==============================

  /// Ajoute une nouvelle tâche
  Future<int> addTodo(String titre, String contenu) async {
    final db = await database;
    return await db.insert('taches', {
      'titre': titre,
      'contenu': contenu,
    });
  }

  /// Récupère toutes les tâches
  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return await db.query('taches', orderBy: "id DESC");
  }

  /// Supprime une tâche
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('taches', where: 'id = ?', whereArgs: [id]);
  }

  /// 🔥 MODIFICATION D’UNE TÂCHE
  Future<int> updateTodo(int id, String titre, String contenu) async {
    final db = await database;
    return await db.update(
      'taches',
      {
        'titre': titre,
        'contenu': contenu,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
