import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/command_provider.dart';

class CommandCategories extends StatelessWidget {
  const CommandCategories({Key? key}) : super(key: key);

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
                  
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(category),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Novo Comando'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nome do comando',
                                      ),
                                      onChanged: (value) {
                                        // Store name
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Comando',
                                      ),
                                      onChanged: (value) {
                                        // Store command
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Add new command
                                      commandProvider.addCommand(category, {
                                        'name': 'New Command',
                                        'command': 'command',
                                        'description': 'description',
                                        'interactive': 'false'
                                      });
                                      Navigator.pop(context);
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
                                await commandProvider.executeCommand(context, command);
                              },
                            ),
                          ],
                        ),
                        onTap: () async {
                          await commandProvider.executeCommand(context, command);
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