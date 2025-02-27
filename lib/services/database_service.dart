import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/git_credentials.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'actionworkflow.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE git_credentials (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            token TEXT NOT NULL,
            client_id TEXT,
            client_secret TEXT,
            api_url TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE saved_directories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            path TEXT NOT NULL,
            saved_at DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE saved_directories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              path TEXT NOT NULL,
              saved_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
          ''');
        }
      }
    );
  }

  static Future<List<GitCredentials>> getGitCredentials() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('git_credentials');
    return List.generate(maps.length, (i) => GitCredentials.fromMap(maps[i]));
  }

  static Future<int> addGitCredentials(GitCredentials credentials) async {
    final db = await database;
    return await db.insert('git_credentials', credentials.toMap());
  }

  static Future<int> updateGitCredentials(GitCredentials credentials) async {
    final db = await database;
    return await db.update(
      'git_credentials',
      credentials.toMap(),
      where: 'id = ?',
      whereArgs: [credentials.id],
    );
  }

  static Future<int> deleteGitCredentials(int id) async {
    final db = await database;
    return await db.delete(
      'git_credentials',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getSavedDirectories() async {
    final db = await database;
    return await db.query('saved_directories', orderBy: 'saved_at DESC');
  }

  static Future<int> saveDirectory(String name, String path) async {
    final db = await database;
    final now = DateTime.now();
    final formattedName = '${name}_${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return await db.insert('saved_directories', {
      'name': formattedName,
      'path': path,
      'saved_at': now.toIso8601String(),
    });
  }

  static Future<int> deleteDirectory(int id) async {
    final db = await database;
    return await db.delete(
      'saved_directories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}