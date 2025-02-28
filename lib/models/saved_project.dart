import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class SavedProject {
  final int id;
  final String name;
  final String path;
  final DateTime savedAt;
  final DateTime? lastModified;
  final Map<String, dynamic> directoryStructure;

  SavedProject({
    required this.id,
    required this.name,
    required this.path,
    required this.savedAt,
    this.lastModified,
    required this.directoryStructure,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'saved_at': savedAt.toIso8601String(),
      'last_modified': lastModified?.toIso8601String(),
      'directory_structure': jsonEncode(directoryStructure),
    };
  }

  factory SavedProject.fromMap(Map<String, dynamic> map) {
    return SavedProject(
      id: map['id'],
      name: map['name'],
      path: map['path'],
      savedAt: DateTime.parse(map['saved_at']),
      lastModified: map['last_modified'] != null
          ? DateTime.parse(map['last_modified'])
          : null,
      directoryStructure: map['directory_structure'] != null
          ? jsonDecode(map['directory_structure'])
          : {},
    );
  }

  static Future<Map<String, dynamic>> generateDirectoryStructure(String rootPath) async {
    final Map<String, dynamic> structure = {};
    final Directory dir = Directory(rootPath);
    
    if (!await dir.exists()) {
      return structure;
    }

    try {
      await for (final FileSystemEntity entity in dir.list(recursive: true)) {
        final String relativePath = path.relative(entity.path, from: rootPath);
        final bool isDirectory = await FileSystemEntity.isDirectory(entity.path);
        final bool isFile = await FileSystemEntity.isFile(entity.path);
        
        // Skip .git directory and other ignored paths
        if (relativePath.startsWith('.git/') || 
            relativePath.startsWith('node_modules/') || 
            relativePath.startsWith('build/') || 
            relativePath.startsWith('dist/') || 
            relativePath.endsWith('.log')) {
          continue;
        }

        if (isDirectory) {
          structure[relativePath] = {
            'type': 'directory',
            'lastModified': (await entity.stat()).modified.toIso8601String()
          };
        } else if (isFile) {
          structure[relativePath] = {
            'type': 'file',
            'size': (await entity.stat()).size,
            'lastModified': (await entity.stat()).modified.toIso8601String()
          };
        }
      }
    } catch (e) {
      print('Error generating directory structure: $e');
    }

    return structure;
  }
}