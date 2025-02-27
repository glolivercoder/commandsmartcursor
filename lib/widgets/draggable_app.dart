import 'package:flutter/material.dart';

class DraggableApp extends StatefulWidget {
  const DraggableApp({Key? key}) : super(key: key);

  @override
  State<DraggableApp> createState() => _DraggableAppState();
}

class _DraggableAppState extends State<DraggableApp> {
  Offset position = Offset(100, 100); // Posição inicial

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                position = Offset(
                  position.dx + details.delta.dx,
                  position.dy + details.delta.dy,
                );
              });
            },
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black87,
                border: Border.all(color: Colors.green[400]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Barra de título arrastável
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(color: Colors.green[400]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ACTIONWORKFLOW',
                          style: TextStyle(
                            color: Colors.green[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.settings, color: Colors.green[400], size: 16),
                            SizedBox(width: 8),
                            Icon(Icons.close, color: Colors.green[400], size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Conteúdo existente do seu app aqui
                  Expanded(
                    child: YourExistingContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}