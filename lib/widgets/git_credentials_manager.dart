import 'package:flutter/material.dart';
import '../models/git_credentials.dart';
import '../services/database_service.dart';

class GitCredentialsManager extends StatefulWidget {
  const GitCredentialsManager({Key? key}) : super(key: key);

  @override
  State<GitCredentialsManager> createState() => _GitCredentialsManagerState();
}

class _GitCredentialsManagerState extends State<GitCredentialsManager> {
  List<GitCredentials> _credentials = [];
  GitCredentials? _selectedCredentials;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final credentials = await DatabaseService.getGitCredentials();
    setState(() {
      _credentials = credentials;
      if (credentials.isNotEmpty) {
        _selectedCredentials = credentials.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Git Credentials'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCredentialsDialog(),
              ),
            ],
          ),
          if (_credentials.isNotEmpty)
            DropdownButton<GitCredentials>(
              value: _selectedCredentials,
              items: _credentials.map((cred) {
                return DropdownMenuItem(
                  value: cred,
                  child: Text(cred.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCredentials = value);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _showCredentialsDialog() async {
    final nameController = TextEditingController();
    final tokenController = TextEditingController();
    final clientIdController = TextEditingController();
    final clientSecretController = TextEditingController();
    final apiUrlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Credenciais'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Conta'),
              ),
              TextField(
                controller: tokenController,
                decoration: const InputDecoration(labelText: 'Token'),
              ),
              TextField(
                controller: clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
              ),
              TextField(
                controller: clientSecretController,
                decoration: const InputDecoration(labelText: 'Client Secret'),
              ),
              TextField(
                controller: apiUrlController,
                decoration: const InputDecoration(labelText: 'API URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final credentials = GitCredentials(
                id: 0,
                name: nameController.text,
                token: tokenController.text,
                clientId: clientIdController.text,
                clientSecret: clientSecretController.text,
                apiUrl: apiUrlController.text,
              );
              
              await DatabaseService.addGitCredentials(credentials);
              Navigator.pop(context);
              _loadCredentials();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}