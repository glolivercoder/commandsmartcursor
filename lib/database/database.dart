import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<SavedDirectory> saveDirectory(SavedDirectoriesCompanion entry) =>
      into(savedDirectories).insertReturning(entry);

  Future<bool> updateDirectory(SavedDirectoriesCompanion entry) =>
      update(savedDirectories).replace(entry);

  Future<int> deleteDirectory(int id) =>
      (delete(savedDirectories)..where((t) => t.id.equals(id))).go();

  // Git Credentials methods
  Future<List<GitCredential>> getAllGitCredentials() =>
      select(gitCredentials).get();

  Future<GitCredential> addGitCredential(GitCredentialsCompanion entry) =>
      into(gitCredentials).insertReturning(entry);

  Future<bool> updateGitCredential(GitCredentialsCompanion entry) =>
      update(gitCredentials).replace(entry);

  Future<int> deleteGitCredential(int id) =>
      (delete(gitCredentials)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'command_smart.db'));
    return NativeDatabase.createInBackground(file);
  });
} 