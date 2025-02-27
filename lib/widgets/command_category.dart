import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/directory_provider.dart';
import '../services/command_service.dart';

class CommandCategory extends StatefulWidget {
  final String title;
  final List<Map<String, String>> commands;

  const CommandCategory({
    Key? key,
    required this.title,
    required this.commands,
  }) : super(key: key);

  @override
  State<CommandCategory> createState() => _CommandCategoryState();
}

class _CommandCategoryState extends State<CommandCategory> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        children: widget.commands.map((command) => _buildCommandTile(command)).toList(),
      ),
    );
  }

  Widget _buildCommandTile(Map<String, String> command) {
    final directory = context.read<DirectoryProvider>().currentDirectory;
    
    return ListTile(
      title: Text(command['name']!),
      subtitle: Text(command['description']!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.copy, color: Theme.of(context).primaryColor),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: command['command']!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comando copiado!')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
            onPressed: directory == null ? null : () {
              CommandService.executeBatchCommand(
                command: command['command']!,
                directory: directory,
              );
            },
          ),
        ],
      ),
    );
  }
}