import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DraggableAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DraggableAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) async {
        await windowManager.startDragging();
      },
      child: AppBar(
        title: const Text('Action Workflow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.minimize),
            onPressed: () async => await windowManager.minimize(),
          ),
          IconButton(
            icon: const Icon(Icons.crop_square),
            onPressed: () async {
              if (await windowManager.isMaximized()) {
                await windowManager.restore();
              } else {
                await windowManager.maximize();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async => await windowManager.close(),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}