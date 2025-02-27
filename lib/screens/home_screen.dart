import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../widgets/directory_bar.dart';
import '../widgets/command_categories.dart';
import '../widgets/git_credentials_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAlwaysOnTop = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Settings action
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.push_pin_outlined,
              color: _isAlwaysOnTop ? Colors.green : null,
            ),
            onPressed: () async {
              final isAlwaysOnTop = await windowManager.isAlwaysOnTop();
              await windowManager.setAlwaysOnTop(!isAlwaysOnTop);
              setState(() => _isAlwaysOnTop = !isAlwaysOnTop);
            },
          ),
          IconButton(
            icon: const Icon(Icons.minimize),
            onPressed: () => windowManager.minimize(),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => windowManager.close(),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Removido _buildTitleBar(context),
            const DirectoryBar(),
            const Expanded(
              child: CommandCategories(),
            ),
          ],
        ),
      ),
    );
  }
}