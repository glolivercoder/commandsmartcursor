import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/command_provider.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';
import '../providers/directory_provider.dart';
import 'dart:io';
import '../database/database.dart';
import 'dart:async';
import 'dart:convert';

class CommandCategories extends StatefulWidget {
  const CommandCategories({Key? key}) : super(key: key);
  
  @override
  State<CommandCategories> createState() => _CommandCategoriesState();
}

class _CommandCategoriesState extends State<CommandCategories> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, TextEditingController> _timerControllers = {};
  final Map<String, bool> _timerEnabled = {};
  final Map<String, int> _savedTimers = {};
  final Map<String, Process> _runningProcesses = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<CommandProvider>(context, listen: false).initializeCommands();
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in _timerControllers.values) {
      controller.dispose();
    }
    for (var process in _runningProcesses.values) {
      process.kill();
    }
    super.dispose();
  }

  bool _filterProject(SavedDirectory directory) {
    if (_searchQuery.isEmpty) return true;
    
    final searchLower = _searchQuery.toLowerCase();
    return directory.name.toLowerCase().contains(searchLower) ||
           directory.path.toLowerCase().contains(searchLower);
  }

  void _showTimerDialog(BuildContext context, String commandId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Definir Tempo'),
        content: TextField(
          controller: _timerControllers[commandId],
          decoration: const InputDecoration(
            labelText: 'Tempo em segundos',
            hintText: 'Ex: 30',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final seconds = int.tryParse(_timerControllers[commandId]!.text) ?? 0;
              if (seconds > 0) {
                setState(() {
                  _savedTimers[commandId] = seconds;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _executeCommandWithTimer(BuildContext context, Map<String, dynamic> command, String commandId, int seconds) async {
    if (seconds <= 0) return;
    
    final commandProvider = Provider.of<CommandProvider>(context, listen: false);
    final workingDirectory = Provider.of<DirectoryProvider>(context, listen: false).currentDirectory;
    
    if (seconds == 1) {
      await commandProvider.executeCommand(context, command);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comando bem sucedido')),
      );
      return;
    }

    try {
      // Criar um arquivo batch temporário para executar o comando
      final batchFile = File('${workingDirectory}\\temp_command.bat');
      await batchFile.writeAsString('''
@echo off
title Command Smart Timer
echo Executando comando por ${seconds} segundos...
echo.
${command['command']}
echo.
echo Aguardando ${seconds} segundos para fechar...
timeout /t ${seconds} /nobreak
exit
''');

      // Executar o comando em uma nova janela do CMD
      final process = await Process.start(
        'cmd.exe',
        ['/c', 'start', 'cmd.exe', '/k', batchFile.path],
        runInShell: true,
        workingDirectory: workingDirectory,
      );

      _runningProcesses[commandId] = process;

      // Aguardar um pouco antes de deletar o arquivo batch
      Timer(Duration(seconds: seconds + 1), () async {
        if (await batchFile.exists()) {
          try {
            await batchFile.delete();
          } catch (e) {
            print('Error deleting batch file: $e');
          }
        }
        if (_runningProcesses.containsKey(commandId)) {
          _runningProcesses.remove(commandId);
        }
      });

    } catch (e) {
      print('Error executing command with timer: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao executar comando: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommandProvider>(
      builder: (context, commandProvider, child) {
        return Column(
          children: [
            // Add Category Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Nova Categoria'),
                          content: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Nome da categoria',
                            ),
                            onSubmitted: (value) {
                              commandProvider.addCategory(value);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const Text('Adicionar Categoria'),
                ],
              ),
            ),
            // Categories List
            Expanded(
              child: ListView.builder(
                itemCount: commandProvider.commands.length,
                itemBuilder: (context, index) {
                  final category = commandProvider.commands.keys.elementAt(index);
                  final commands = commandProvider.commands[category]!;
                  
                  if (category == 'Projetos Salvos') {
                    return ExpansionTile(
                      title: Text(category),
                      children: [
                        // Barra de busca
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar projetos...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        FutureBuilder<List<SavedDirectory>>(
                          future: DatabaseService.getSavedDirectories(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const ListTile(
                                title: Text('Nenhum projeto salvo'),
                                enabled: false,
                              );
                            }
                            
                            final filteredDirectories = snapshot.data!
                                .where(_filterProject)
                                .toList();

                            if (filteredDirectories.isEmpty) {
                              return ListTile(
                                title: Text('Nenhum resultado para "$_searchQuery"'),
                                enabled: false,
                              );
                            }

                            return Column(
                              children: filteredDirectories.map((SavedDirectory directory) {
                                final DateTime savedAt = DateTime.parse(directory.savedAt);
                                final DateTime lastModified = DateTime.parse(directory.lastModified);
                                final String formattedSavedAt = DateFormat('dd/MM/yyyy HH:mm').format(savedAt);
                                final String formattedLastModified = DateFormat('dd/MM/yyyy HH:mm').format(lastModified);
                                
                                return ExpansionTile(
                                  title: Text(directory.name),
                                  subtitle: Text('Caminho: ${directory.path}'),
                                  children: [
                                    ListTile(
                                      dense: true,
                                      title: Text('Criado em: $formattedSavedAt'),
                                      subtitle: Text('Última modificação: $formattedLastModified'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.folder_open, color: Theme.of(context).primaryColor),
                                            onPressed: () {
                                              Process.run('explorer.exe', [directory.path]);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () async {
                                              await DatabaseService.deleteDirectory(directory.id);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Provider.of<DirectoryProvider>(context, listen: false)
                                            .setDirectory(directory.path);
                                        Provider.of<CommandProvider>(context, listen: false)
                                            .loadSavedDirectories();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Diretório carregado com sucesso')),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(category),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            String? commandName;
                            String? commandText;
                            
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) => AlertDialog(
                                title: const Text('Novo Comando'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nome do comando',
                                      ),
                                      onChanged: (value) => commandName = value,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Comando',
                                      ),
                                      onChanged: (value) => commandText = value,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (commandName?.isNotEmpty == true && 
                                          commandText?.isNotEmpty == true) {
                                        Navigator.pop(dialogContext);
                                        commandProvider.addCommand(
                                          category, 
                                          {
                                            'name': commandName!,
                                            'command': commandText!,
                                            'description': 'Comando personalizado',
                                            'interactive': 'false',
                                            'id': null
                                          } as Map<String, dynamic>
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Comando adicionado!')),
                                        );
                                      }
                                    },
                                    child: const Text('Adicionar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    children: commands.map((command) {
                      final commandId = '${command['name']}_${command['command']}';
                      _timerControllers.putIfAbsent(
                        commandId,
                        () => TextEditingController(),
                      );
                      _timerEnabled.putIfAbsent(commandId, () => false);

                      return ListTile(
                        leading: Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.timer,
                                color: _timerEnabled[commandId]! ? Theme.of(context).primaryColor : Colors.grey,
                              ),
                              onPressed: () {
                                if (!_timerEnabled[commandId]!) {
                                  _showTimerDialog(context, commandId);
                                }
                                setState(() {
                                  _timerEnabled[commandId] = !_timerEnabled[commandId]!;
                                  if (!_timerEnabled[commandId]!) {
                                    _savedTimers.remove(commandId);
                                  }
                                });
                              },
                            ),
                            if (_timerEnabled[commandId]! && _savedTimers.containsKey(commandId))
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${_savedTimers[commandId]}s',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(command['name']!),
                        subtitle: Text(command['description']!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar Exclusão'),
                                    content: const Text('Deseja realmente excluir este comando?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Não'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          commandProvider.deleteCommand(category, command);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Comando excluído!')),
                                          );
                                        },
                                        child: const Text('Sim'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                String? newCommandName = command['name'];
                                String? newCommandText = command['command'];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Editar Comando'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Nome do comando',
                                          ),
                                          controller: TextEditingController(text: command['name']),
                                          onChanged: (value) => newCommandName = value,
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Comando',
                                          ),
                                          controller: TextEditingController(text: command['command']),
                                          onChanged: (value) => newCommandText = value,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (newCommandName?.isNotEmpty == true && 
                                              newCommandText?.isNotEmpty == true) {
                                            commandProvider.updateCommand(
                                              category,
                                              command as Map<String, dynamic>,
                                              {
                                                'name': newCommandName!,
                                                'command': newCommandText!,
                                                'description': command['description']!,
                                                'interactive': command['interactive']!,
                                                'id': command['id']
                                              } as Map<String, dynamic>
                                            );
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Comando atualizado!')),
                                            );
                                          }
                                        },
                                        child: const Text('Salvar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                commandProvider.copyToClipboard(command['command']!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Comando copiado!')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () async {
                                if (_timerEnabled[commandId]! && _savedTimers.containsKey(commandId)) {
                                  await _executeCommandWithTimer(context, command, commandId, _savedTimers[commandId]!);
                                } else {
                                  await commandProvider.executeCommand(
                                    context,
                                    command as Map<String, dynamic>
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (_timerEnabled[commandId]! && _savedTimers.containsKey(commandId)) {
                            await _executeCommandWithTimer(context, command, commandId, _savedTimers[commandId]!);
                          } else {
                            await commandProvider.executeCommand(
                              context,
                              command as Map<String, dynamic>
                            );
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}