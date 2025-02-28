import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'database_service.dart';

class DirectoryWatcherService {
  static final Map<String, StreamSubscription<FileSystemEvent>> _watchers = {};

  static Future<void> startWatching(int id, String path) async {
    if (_watchers.containsKey(path)) {
      await _watchers[path]?.cancel();
    }

    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        _watchers[path] = directory.watch(recursive: true).listen((event) async {
          // Atualiza a data de última modificação no banco de dados
          await DatabaseService.updateDirectoryLastModified(id, path);
        });
      }
    } catch (e) {
      debugPrint('Erro ao monitorar diretório: $e');
    }
  }

  static Future<void> stopWatching(String path) async {
    await _watchers[path]?.cancel();
    _watchers.remove(path);
  }

  static Future<void> stopAllWatchers() async {
    for (final watcher in _watchers.values) {
      await watcher.cancel();
    }
    _watchers.clear();
  }
} 