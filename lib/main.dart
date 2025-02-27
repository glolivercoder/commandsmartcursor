import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/directory_provider.dart';
import 'providers/command_provider.dart';
import 'providers/git_credentials_provider.dart';
import 'widgets/draggable_window.dart'; // Adicionada importação do DraggableWindow
// Removida importação não utilizada do theme/app_theme.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(375, 667),
    minimumSize: Size(300, 400),
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DirectoryProvider()),
        ChangeNotifierProvider(create: (_) => CommandProvider()),
        ChangeNotifierProvider(create: (_) => GitCredentialsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          primaryColor: Colors.green[400],
          colorScheme: ColorScheme.dark(
            primary: Colors.green[400]!,
            secondary: Colors.green[200]!,
          ),
          expansionTileTheme: ExpansionTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.green[400]!.withOpacity(0.7)),
            ),
            backgroundColor: Colors.black,
            collapsedBackgroundColor: Colors.black,
            textColor: Colors.green[400],
            iconColor: Colors.green[400],
            collapsedTextColor: Colors.green[400],
            collapsedIconColor: Colors.green[400],
          ),
          iconTheme: IconThemeData(
            color: Colors.green[400],
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.green[400]),
            bodyMedium: TextStyle(color: Colors.green[400]),
          ),
        ),
        home: Column(
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Command Smart',
                style: TextStyle(
                  color: Colors.green[400],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.green[400]!.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: DraggableWindow(
                  child: const HomeScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
