import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/directory_provider.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

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
                  String? path = await FilePicker.platform.getDirectoryPath();
                  if (path != null) {
                    await directoryProvider.setDirectory(path);
                    // Show dialog to save the directory
                    String? result = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Salvar Projeto'),
                        content: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Nome do Projeto',
                            hintText: 'Digite o nome do projeto',
                          ),
                          onSubmitted: (value) {
                            Navigator.of(context).pop(value);
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(
                              (context.findAncestorStateOfType<FormState>()?.validate() ?? false)
                                  ? (context.findAncestorWidgetOfExactType<TextField>() as TextField).controller?.text
                                  : null,
                            ),
                            child: const Text('Salvar'),
                          ),
                        ],
                      ),
                    );

                    if (result != null && result.isNotEmpty) {
                      await DatabaseService.saveDirectory(result, path);
                      _refreshDirectories();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Diretório salvo com sucesso')),
                      );
                    }
                  }
                },
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
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
                        final DateTime savedAt = DateTime.parse(directory['saved_at'] as String);
                        final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(savedAt);
                        return PopupMenuItem<String>(
                          value: directory['path'] as String,
                          child: Container(
                            width: 400,
                            child: ListTile(
                              title: Text(
                                directory['name'] as String,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${directory['path']} - $formattedDate',
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await DatabaseService.deleteDirectory(directory['id'] as int);
                                  Navigator.pop(context);
                                  _refreshDirectories();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Diretório removido com sucesso')),
                                  );
                                },
                              ),
                            ),
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