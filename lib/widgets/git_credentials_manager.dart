import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../database/database.dart';

class GitCredentialsManager extends StatefulWidget {
  const GitCredentialsManager({Key? key}) : super(key: key);

  @override
  State<GitCredentialsManager> createState() => _GitCredentialsManagerState();
}

class _GitCredentialsManagerState extends State<GitCredentialsManager> {
  List<GitCredential> _credentials = [];
  GitCredential? _selectedCredential;

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
        _selectedCredential = credentials.first;
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
            DropdownButton<GitCredential>(
              value: _selectedCredential,
              items: _credentials.map((cred) {
                return DropdownMenuItem(
                  value: cred,
                  child: Text(cred.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCredential = value);
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
              await DatabaseService.addGitCredentials(
                nameController.text,
                tokenController.text,
                clientId: clientIdController.text.isNotEmpty ? clientIdController.text : null,
                clientSecret: clientSecretController.text.isNotEmpty ? clientSecretController.text : null,
                apiUrl: apiUrlController.text.isNotEmpty ? apiUrlController.text : null,
              );
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