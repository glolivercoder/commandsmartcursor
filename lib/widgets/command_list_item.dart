import 'package:flutter/material.dart';
import '../providers/command_provider.dart';

class CommandListItem extends StatelessWidget {
  final String category;
  final Map<String, String> command;
  final int index;
  final CommandProvider provider;

  const CommandListItem({
    required this.category,
    required this.command,
    required this.index,
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => provider.deleteCommand(context, category, index),
              tooltip: 'Deletar comando',
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => provider.editCommand(context, category, index),
              tooltip: 'Editar comando',
            ),
          ],
        ),
        title: Text(command['name'] ?? ''),
        subtitle: Text(command['description'] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => provider.copyToClipboard(command['command'] ?? ''),
              tooltip: 'Copiar comando',
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => provider.executeCommand(context, command),
              tooltip: 'Executar comando',
            ),
          ],
        ),
      ),
    );
  }
}