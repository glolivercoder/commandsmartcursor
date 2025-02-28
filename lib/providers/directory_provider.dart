import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../database/database.dart';

class DirectoryProvider with ChangeNotifier {
  String? _currentDirectory;
  String? _githubToken;
  String? _clientId;
  String? _clientSecret;

  String? get currentDirectory => _currentDirectory;

  Future<void> setDirectory(String path) async {
    _currentDirectory = path;
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
    notifyListeners();
  }
}