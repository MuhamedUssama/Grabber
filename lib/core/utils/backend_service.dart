import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

class BackendService {
  static Process? _serverProcess;

  static Future<void> startServer() async {
    try {
      // 1. Determine extraction location
      final dir = await getApplicationSupportDirectory();
      final backendDir = Directory(p.join(dir.path, 'backend'));
      final serverExe = File(p.join(backendDir.path, 'server.exe'));

      // 2. Extract logic
      if (!await serverExe.exists()) {
        if (kDebugMode) print("📦 Extracting backend to: ${backendDir.path}");
        await _extractBackend(backendDir);
      } else {
        if (kDebugMode) print("✅ Backend files found.");
      }

      // 3. Kill existing processes (TWEAKED HERE)
      await _killExistingProcesses();

      await Future.delayed(const Duration(seconds: 1));

      // 4. Start the server
      if (kDebugMode) print("🚀 Starting server.exe...");

      _serverProcess = await Process.start(
        serverExe.path,
        [],
        runInShell: false,
        workingDirectory: backendDir.path,
      );

      if (kDebugMode) {
        print("🎉 Server started successfully (PID: ${_serverProcess?.pid})");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error handling backend: $e");
    }
  }

  static Future<void> _extractBackend(Directory targetDir) async {
    final zipData = await rootBundle.load('assets/backend.zip');
    final bytes = zipData.buffer.asUint8List();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final extractedFile = File(p.join(targetDir.path, filename));
        await extractedFile.create(recursive: true);
        await extractedFile.writeAsBytes(data);
      } else {
        await Directory(
          p.join(targetDir.path, filename),
        ).create(recursive: true);
      }
    }
  }

  static void stopServer() {
    if (kDebugMode) print("🛑 Stopping server...");
    _serverProcess?.kill();
    _killExistingProcesses();
  }

  static Future<void> _killExistingProcesses() async {
    if (Platform.isWindows) {
      try {
        await Process.run('taskkill', ['/F', '/IM', 'server.exe']);
        if (kDebugMode) print("💀 Killed old server instances.");
      } catch (e) {
        if (kDebugMode) print("❌ Error killing server: $e");
      }
    }
  }
}
