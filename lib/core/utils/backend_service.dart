import 'dart:io';
import 'dart:convert';
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
      final binaryName = Platform.isWindows ? 'server.exe' : 'server';
      final serverExe = File(p.join(backendDir.path, binaryName));
      final zipAsset = Platform.isWindows ? 'assets/backend.zip' : 'assets/server.zip';

      // 2. Extract logic
      if (!await serverExe.exists()) {
        if (kDebugMode) print("📦 Extracting backend from $zipAsset to: ${backendDir.path}");
        await _extractBackend(backendDir, zipAsset);
      } else {
        if (kDebugMode) print("✅ Backend files found.");
      }

      // 3. Kill existing processes (TWEAKED HERE)
      await _killExistingProcesses();

      await Future.delayed(const Duration(seconds: 1));

      // Grant execution permissions on Unix-based systems (macOS/Linux)
      if (Platform.isMacOS || Platform.isLinux) {
        if (kDebugMode) print("🔐 Granting execution permission to ${serverExe.path}");
        await Process.run('chmod', ['+x', serverExe.path]);

        // Grant permission to ffmpeg and ffprobe if they are bundled in bin/
        final ffmpegFile = File(p.join(backendDir.path, 'bin', 'ffmpeg'));
        final ffprobeFile = File(p.join(backendDir.path, 'bin', 'ffprobe'));
        if (await ffmpegFile.exists()) {
          if (kDebugMode) print("🔐 Granting execution permission to ${ffmpegFile.path}");
          await Process.run('chmod', ['+x', ffmpegFile.path]);
        }
        if (await ffprobeFile.exists()) {
          if (kDebugMode) print("🔐 Granting execution permission to ${ffprobeFile.path}");
          await Process.run('chmod', ['+x', ffprobeFile.path]);
        }
      }

      // 4. Start the server
      if (kDebugMode) print("🚀 Starting $binaryName...");

      _serverProcess = await Process.start(
        serverExe.path,
        [],
        runInShell: false,
        workingDirectory: backendDir.path,
      );

      if (kDebugMode) {
        print("🎉 Server process spawned (PID: ${_serverProcess?.pid})");
      }

      // Listen to stdout and stderr to prevent memory leaks and detect port conflicts
      int stdoutLines = 0;
      int stderrLines = 0;
      bool portConflictDetected = false;

      void handleLine(String line, bool isError) {
        final cleanLine = line.trim();
        if (cleanLine.isEmpty) return;

        // Print only the first 100 lines of logs to console to avoid flooding the IDE
        if (kDebugMode) {
          if (isError && stderrLines < 100) {
            print("[Backend Error] $cleanLine");
            stderrLines++;
          } else if (!isError && stdoutLines < 100) {
            print("[Backend] $cleanLine");
            stdoutLines++;
          }
        }

        // Check for port conflict or address already in use
        if (cleanLine.contains("Address already in use") || 
            cleanLine.contains("Port 5000 is in use") ||
            cleanLine.contains("Port 5001 is in use") ||
            cleanLine.contains("Port 8080 is in use")) {
          if (!portConflictDetected) {
            portConflictDetected = true;
            print("\n❌❌❌ CRITICAL ERROR ❌❌❌");
            print("The server port (5000/5001/8080) is already in use by another program.");
            print("On macOS, if it's port 5000, 'AirPlay Receiver' might be enabled in System Settings -> General -> Sharing.");
            print("👉 Please stop any other program using this port.");
            print("❌❌❌❌❌❌❌❌❌❌❌❌❌\n");
            
            // Kill the server process immediately to prevent infinite crash-reloader loop and memory leak
            stopServer();
          }
        }
      }

      _serverProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => handleLine(line, false),
            onError: (e) {
              if (kDebugMode) print("❌ Error reading backend stdout: $e");
            },
          );

      _serverProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => handleLine(line, true),
            onError: (e) {
              if (kDebugMode) print("❌ Error reading backend stderr: $e");
            },
          );
    } catch (e) {
      if (kDebugMode) print("❌ Error handling backend: $e");
    }
  }

  static Future<void> _extractBackend(Directory targetDir, String zipAsset) async {
    final zipData = await rootBundle.load(zipAsset);
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
    } else if (Platform.isMacOS) {
      try {
        await Process.run('pkill', ['-x', 'server']);
        if (kDebugMode) print("💀 Killed old server instances on macOS.");
      } catch (e) {
        if (kDebugMode) print("❌ Error killing server on macOS: $e");
      }
    }
  }
}
