import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DirectoryProvider with ChangeNotifier {
  String? _currentDirectory;
  String? _githubToken;
  String? _clientId;
  String? _clientSecret;
  late Database _database;

  String? get currentDirectory => _currentDirectory;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'action_workflow.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY,
            directory TEXT,
            github_token TEXT,
            client_id TEXT,
            client_secret TEXT
          )
        ''');
      },
      version: 1,
    );
    await _loadSettings();
  }

  Future<void> setDirectory(String path) async {
    _currentDirectory = path;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setGithubCredentials({
    String? token,
    String? clientId,
    String? clientSecret,
  }) async {
    _githubToken = token;
    _clientId = clientId;
    _clientSecret = clientSecret;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final settings = await _database.query('settings');
    if (settings.isNotEmpty) {
      final setting = settings.first;
      _currentDirectory = setting['directory'] as String?;
      _githubToken = setting['github_token'] as String?;
      _clientId = setting['client_id'] as String?;
      _clientSecret = setting['client_secret'] as String?;
      notifyListeners();
    }
  }

  Future<void> _saveSettings() async {
    await _database.delete('settings');
    await _database.insert('settings', {
      'directory': _currentDirectory,
      'github_token': _githubToken,
      'client_id': _clientId,
      'client_secret': _clientSecret,
    });
  }
}