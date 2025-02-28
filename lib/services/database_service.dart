import 'package:drift/drift.dart';
import '../database/database.dart';

class DatabaseService {
  static AppDatabase? _database;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      _database = AppDatabase();
      _initialized = true;
      print('Database initialized successfully!');
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  static AppDatabase get database {
    if (!_initialized) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  static Future<List<SavedDirectory>> getSavedDirectories() async {
    return await database.getAllSavedDirectories();
  }

  static Future<SavedDirectory> saveDirectory(String name, String path) async {
    final now = DateTime.now();
    
    return await database.saveDirectory(
      SavedDirectoriesCompanion.insert(
        name: name,
        path: path,
        savedAt: now.toIso8601String(),
        lastModified: now.toIso8601String(),
      ),
    );
  }

  static Future<int> deleteDirectory(int id) async {
    return await database.deleteDirectory(id);
  }

  static Future<void> updateDirectoryLastModified(int id, String path) async {
    final now = DateTime.now();
    
    await database.updateDirectory(
      SavedDirectoriesCompanion(
        id: Value(id),
        lastModified: Value(now.toIso8601String()),
      ),
    );
  }

  static Future<List<GitCredential>> getGitCredentials() async {
    return await database.getAllGitCredentials();
  }

  static Future<GitCredential> addGitCredentials(
    String name,
    String token, {
    String? clientId,
    String? clientSecret,
    String? apiUrl,
  }) async {
    return await database.addGitCredential(
      GitCredentialsCompanion.insert(
        name: name,
        token: token,
        clientId: Value(clientId),
        clientSecret: Value(clientSecret),
        apiUrl: Value(apiUrl),
      ),
    );
  }

  static Future<int> deleteGitCredentials(int id) async {
    return await database.deleteGitCredential(id);
  }
}