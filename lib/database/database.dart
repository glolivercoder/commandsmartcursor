import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class SavedDirectories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get savedAt => text()();
  TextColumn get lastModified => text()();
}

class GitCredentials extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get token => text()();
  TextColumn get clientId => text().nullable()();
  TextColumn get clientSecret => text().nullable()();
  TextColumn get apiUrl => text().nullable()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Usar a pasta projetosalvos na raiz do projeto
    final dbFolder = Directory('projetosalvos');
    if (!dbFolder.existsSync()) {
      dbFolder.createSync();
    }
    
    final file = File(p.join(dbFolder.path, 'command_smart.db'));
    print('Database path: ${file.path}'); // Debug print
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [SavedDirectories, GitCredentials])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Saved Directories methods
  Future<List<SavedDirectory>> getAllSavedDirectories() =>
      select(savedDirectories).get();

  Stream<List<SavedDirectory>> watchAllSavedDirectories() =>
      select(savedDirectories).watch();

  Future<SavedDirectory> saveDirectory(SavedDirectoriesCompanion entry) async {
    final savedDir = await into(savedDirectories).insertReturning(entry);
    await _backupDatabase();
    return savedDir;
  }

  Future<bool> updateDirectory(SavedDirectoriesCompanion entry) async {
    final result = await update(savedDirectories).replace(entry);
    await _backupDatabase();
    return result;
  }

  Future<int> deleteDirectory(int id) async {
    final result = await (delete(savedDirectories)..where((t) => t.id.equals(id))).go();
    await _backupDatabase();
    return result;
  }

  // Git Credentials methods
  Future<List<GitCredential>> getAllGitCredentials() =>
      select(gitCredentials).get();

  Future<GitCredential> addGitCredential(GitCredentialsCompanion entry) =>
      into(gitCredentials).insertReturning(entry);

  Future<bool> updateGitCredential(GitCredentialsCompanion entry) =>
      update(gitCredentials).replace(entry);

  Future<int> deleteGitCredential(int id) =>
      (delete(gitCredentials)..where((t) => t.id.equals(id))).go();

  // Backup method
  Future<void> _backupDatabase() async {
    try {
      final mainDbFolder = Directory('projetosalvos');
      final backupDir = Directory('projetosalvosBKP');
      
      // Garantir que ambas as pastas existam
      if (!mainDbFolder.existsSync()) {
        mainDbFolder.createSync();
      }
      if (!backupDir.existsSync()) {
        backupDir.createSync();
      }

      // Copiar todos os arquivos da pasta principal para o backup
      final mainFiles = mainDbFolder.listSync();
      for (var entity in mainFiles) {
        if (entity is File) {
          final fileName = p.basename(entity.path);
          final backupFile = File(p.join(backupDir.path, fileName));
          await entity.copy(backupFile.path);
        }
      }
      
      print('Database and files backup created at: ${backupDir.path}');
    } catch (e) {
      print('Error creating database backup: $e');
    }
  }
} 