import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../database/database.dart';

class GitCredentialsProvider with ChangeNotifier {
  List<GitCredential> _credentials = [];
  GitCredential? _selectedCredential;

  List<GitCredential> get credentials => _credentials;
  GitCredential? get selectedCredential => _selectedCredential;

  Future<void> loadCredentials() async {
    _credentials = await DatabaseService.getGitCredentials();
    if (_credentials.isNotEmpty) {
      _selectedCredential = _credentials.first;
    }
    notifyListeners();
  }

  Future<void> addCredential(String name, String token, {String? clientId, String? clientSecret, String? apiUrl}) async {
    final credential = await DatabaseService.addGitCredentials(
      name,
      token,
      clientId: clientId,
      clientSecret: clientSecret,
      apiUrl: apiUrl,
    );
    _credentials.add(credential);
    if (_selectedCredential == null) {
      _selectedCredential = credential;
    }
    notifyListeners();
  }

  Future<void> deleteCredential(int id) async {
    await DatabaseService.deleteGitCredentials(id);
    _credentials.removeWhere((cred) => cred.id == id);
    if (_selectedCredential?.id == id) {
      _selectedCredential = _credentials.isNotEmpty ? _credentials.first : null;
    }
    notifyListeners();
  }

  void selectCredential(GitCredential credential) {
    _selectedCredential = credential;
    notifyListeners();
  }
}