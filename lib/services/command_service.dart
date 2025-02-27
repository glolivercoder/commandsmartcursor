import 'package:process_run/shell.dart';
import 'dart:io';

class CommandService {
  static Future<String> executeCommand(String command, String workingDirectory) async {
    try {
      var shell = Shell(workingDirectory: workingDirectory);
      var result = await shell.run(command);
      return result.outText;
    } catch (e) {
      return 'Error executing command: ${e.toString()}';
    }
  }

  static Future<void> executeBatchCommand({
    required String command,
    required String directory,
  }) async {
    try {
      final file = await _createBatchFile(command, directory);
      
      await Process.start(
        'cmd.exe',
        ['/k', file.path],
        workingDirectory: directory,
        mode: ProcessStartMode.detached,
      );
    } catch (e) {
      print('Erro ao executar comando: $e');
    }
  }

  static Future<File> _createBatchFile(String command, String directory) async {
    final file = File('${directory}\\temp_command.bat');
    
    await file.writeAsString('''
@echo off
cd /d "${directory}"
$command
pause
''');
    
    return file;
  }
}