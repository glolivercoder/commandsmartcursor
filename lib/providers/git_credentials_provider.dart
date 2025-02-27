import 'package:flutter/material.dart';
import '../models/git_credentials.dart';
import '../services/database_service.dart';

class GitCredentialsProvider with ChangeNotifier {
  GitCredentials? _currentCredentials;
  GitCredentials? get currentCredentials => _currentCredentials;

  Future<void> loadCredentials() async {
    final credentials = await DatabaseService.getGitCredentials();
    if (credentials.isNotEmpty) {
      _currentCredentials = credentials.first;
      notifyListeners();
    }
  }

  Future<void> setCurrentCredentials(GitCredentials credentials) async {
    _currentCredentials = credentials;
    notifyListeners();
  }
}