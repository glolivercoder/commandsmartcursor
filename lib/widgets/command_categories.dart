import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/command_provider.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';
import '../providers/directory_provider.dart';

class CommandCategories extends StatefulWidget {
  const CommandCategories({Key? key}) : super(key: key);
  
  @override
  State<CommandCategories> createState() => _CommandCategoriesState();
}

class _CommandCategoriesState extends State<CommandCategories> {
  @override
  void initState() {
    super.initState();
    Provider.of<CommandProvider>(context, listen: false).initializeCommands();
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
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: DatabaseService.getSavedDirectories(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const ListTile(
                                title: Text('Nenhum projeto salvo'),
                                enabled: false,
                              );
                            }
                            
                            return Column(
                              children: snapshot.data!.map((directory) {
                                final DateTime savedAt = DateTime.parse(directory['saved_at'] as String);
                                final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(savedAt);
                                return ListTile(
                                  title: Text(directory['name'] as String),
                                  subtitle: Text('${directory['path']} - $formattedDate'),
                                  onTap: () {
                                    Provider.of<DirectoryProvider>(context, listen: false)
                                        .setDirectory(directory['path'] as String);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Diretório carregado com sucesso')),
                                    );
                                  },
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await DatabaseService.deleteDirectory(directory['id'] as int);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Diretório removido com sucesso')),
                                      );
                                      // Force rebuild of the FutureBuilder
                                      setState(() {});
                                    },
                                  ),
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
                                        // First close the dialog
                                        Navigator.pop(dialogContext);
                                        
                                        // Then add the command
                                        commandProvider.addCommand(
                                          category, 
                                          {
                                            'name': commandName!,
                                            'command': commandText!,
                                            'description': 'Comando personalizado',
                                            'interactive': 'false'
                                          }
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
                      return ListTile(
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
                                              command,
                                              {
                                                'name': newCommandName!,
                                                'command': newCommandText!,
                                                'description': command['description']!,
                                                'interactive': command['interactive']!
                                              }
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
                                await commandProvider.executeCommand(
                                  context,
                                  command
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () async {
                          await commandProvider.executeCommand(
                            context,
                            command
                          );
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