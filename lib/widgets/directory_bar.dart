import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/directory_provider.dart';
import '../services/database_service.dart';
import '../providers/command_provider.dart';
import 'package:intl/intl.dart';
import '../services/directory_watcher_service.dart';
import 'dart:io';
import '../database/database.dart';
import 'package:path/path.dart' as p;

class DirectoryBar extends StatefulWidget {
  const DirectoryBar({Key? key}) : super(key: key);
  @override
  State<DirectoryBar> createState() => _DirectoryBarState();
}

class _DirectoryBarState extends State<DirectoryBar> {
  final GlobalKey<State> _futureBuilderKey = GlobalKey();

  void _refreshDirectories() {
    setState(() {
      _futureBuilderKey.currentState?.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DirectoryProvider>(
      builder: (context, directoryProvider, _) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    directoryProvider.currentDirectory ?? 'Select a directory',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.folder_open, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  try {
                    await DatabaseService.initialize();
                    final String? path = await FilePicker.platform.getDirectoryPath();
                    print("Diretório selecionado: $path");

                    if (path != null) {
                      await directoryProvider.setDirectory(path);
                      await Future.delayed(const Duration(milliseconds: 100));
                      
                      if (!context.mounted) return;

                      final dirName = path.split(Platform.pathSeparator).last;
                      print("Nome do diretório: $dirName");
                      
                      final result = await showDialog<String>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          final textController = TextEditingController(text: dirName);
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              title: const Text('Salvar Projeto'),
                              content: SizedBox(
                                width: 400,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Diretório selecionado:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      path,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: textController,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Nome do Projeto',
                                        hintText: 'Digite o nome do projeto',
                                        border: OutlineInputBorder(),
                                      ),
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          Navigator.of(context).pop(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final text = textController.text.trim();
                                    if (text.isNotEmpty) {
                                      Navigator.of(context).pop(text);
                                    }
                                  },
                                  child: const Text('Salvar'),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      print("Resultado do diálogo: $result");

                      if (result != null && result.isNotEmpty) {
                        try {
                          final savedDir = await DatabaseService.saveDirectory(result, path);
                          print("Diretório salvo com ID: ${savedDir.id}"); // Debug print
                          await DirectoryWatcherService.startWatching(savedDir.id, path);
                          if (!context.mounted) return;
                          Provider.of<CommandProvider>(context, listen: false).loadSavedDirectories();
                          _refreshDirectories();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Diretório salvo com sucesso')),
                          );
                        } catch (e) {
                          print("Erro ao salvar diretório: $e");
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao salvar diretório: $e')),
                          );
                        }
                      }
                    }
                  } catch (e) {
                    print("Erro ao selecionar diretório: $e");
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao selecionar diretório: $e')),
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.save, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  try {
                    final projectDir = Directory.current;
                    final savedProjectsDir = Directory(p.join(projectDir.path, 'projetosalvos'));
                    await Process.run('explorer.exe', [savedProjectsDir.path]);
                  } catch (e) {
                    print("Erro ao abrir pasta de projetos salvos: $e");
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao abrir pasta de projetos salvos: $e')),
                    );
                  }
                },
              ),
              FutureBuilder<List<SavedDirectory>>(
                key: _futureBuilderKey,
                future: DatabaseService.getSavedDirectories(),
                builder: (context, snapshot) {
                  return PopupMenuButton<String>(
                    icon: Icon(Icons.save, color: Theme.of(context).primaryColor),
                    onSelected: (String path) async {
                      await directoryProvider.setDirectory(path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Diretório carregado com sucesso')),
                      );
                    },
                    itemBuilder: (BuildContext context) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return [
                          const PopupMenuItem<String>(
                            enabled: false,
                            child: Text('Nenhum diretório salvo'),
                          ),
                        ];
                      }

                      return snapshot.data!.map((directory) {
                        final DateTime savedAt = DateTime.parse(directory.savedAt);
                        final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(savedAt);
                        
                        return PopupMenuItem<String>(
                          value: directory.path,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      directory.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${directory.path} - $formattedDate',
                                      style: Theme.of(context).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await DatabaseService.deleteDirectory(directory.id);
                                  Navigator.pop(context);
                                  _refreshDirectories();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Diretório removido com sucesso')),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}