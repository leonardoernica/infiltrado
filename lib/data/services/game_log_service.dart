import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/game_log_entry.dart';

class GameLogService {
  static const String _logFileName = 'game_logs.json';
  static const String _logDirName = 'logs';
  static const String _promptVersion = '2.0'; // Update this when prompt changes

  // Get prompt version
  static String get promptVersion => _promptVersion;

  // Get log file path - tries to save in project directory first, falls back to app documents
  Future<File> _getLogFile() async {
    // Try to save in project directory (works in development/desktop)
    try {
      final currentDir = Directory.current;
      final projectLogDir = Directory('${currentDir.path}/$_logDirName');

      // Create logs directory if it doesn't exist
      if (!await projectLogDir.exists()) {
        await projectLogDir.create(recursive: true);
      }

      final projectLogFile = File('${projectLogDir.path}/$_logFileName');
      return projectLogFile;
    } catch (e) {
      // Fallback to app documents directory (for mobile/production)
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$_logFileName');
    }
  }

  // Get project log file path (for development)
  Future<File?> _getProjectLogFile() async {
    try {
      final currentDir = Directory.current;
      final projectLogDir = Directory('${currentDir.path}/$_logDirName');

      if (!await projectLogDir.exists()) {
        await projectLogDir.create(recursive: true);
      }

      return File('${projectLogDir.path}/$_logFileName');
    } catch (e) {
      return null;
    }
  }

  // Load all logs - tries project file first, then app documents
  Future<List<GameLogEntry>> loadLogs() async {
    // Try to load from project directory first
    final projectFile = await _getProjectLogFile();
    if (projectFile != null && await projectFile.exists()) {
      try {
        final content = await projectFile.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList
            .map((json) => GameLogEntry.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error loading from project log: $e');
        }
      }
    }

    // Fallback to app documents directory
    try {
      final file = await _getLogFile();
      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList
          .map((json) => GameLogEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading logs: $e');
      }
      return [];
    }
  }

  // Save a new log entry
  Future<void> saveLogEntry(GameLogEntry entry) async {
    try {
      final logs = await loadLogs();
      logs.add(entry);

      final jsonList = logs.map((log) => log.toJson()).toList();
      final jsonContent = jsonEncode(jsonList);

      // Save to project directory (if available)
      final projectFile = await _getProjectLogFile();
      if (projectFile != null) {
        try {
          await projectFile.writeAsString(jsonContent);
          if (kDebugMode) {
            print('Log saved to project: ${projectFile.path}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Failed to save to project directory: $e');
          }
        }
      }

      // Also save to app documents directory (for mobile/backup)
      final appFile = await _getLogFile();
      await appFile.writeAsString(jsonContent);
      if (kDebugMode) {
        print('Log saved to app directory: ${appFile.path}');
      }
    } catch (e) {
      print('Error saving log entry: $e');
    }
  }

  // Update feedback for a log entry
  Future<void> updateFeedback(
    String entryId, {
    bool? civilianFeedback,
    bool? infiltratorFeedback,
    String? notes,
  }) async {
    try {
      final logs = await loadLogs();
      final index = logs.indexWhere((log) => log.id == entryId);

      if (index != -1) {
        logs[index] = logs[index].copyWith(
          civilianFeedback: civilianFeedback ?? logs[index].civilianFeedback,
          infiltratorFeedback:
              infiltratorFeedback ?? logs[index].infiltratorFeedback,
          notes: notes ?? logs[index].notes,
        );

        final jsonList = logs.map((log) => log.toJson()).toList();
        final jsonContent = jsonEncode(jsonList);

        // Save to project directory (if available)
        final projectFile = await _getProjectLogFile();
        if (projectFile != null) {
          try {
            await projectFile.writeAsString(jsonContent);
          } catch (e) {
            if (kDebugMode) {
              print('Failed to update project log: $e');
            }
          }
        }

        // Also save to app documents directory
        final appFile = await _getLogFile();
        await appFile.writeAsString(jsonContent);
      }
    } catch (e) {
      print('Error updating feedback: $e');
    }
  }

  // Get the most recent log entry (for current round)
  Future<GameLogEntry?> getMostRecentEntry() async {
    final logs = await loadLogs();
    if (logs.isEmpty) return null;
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs.first;
  }

  // Get log file path (for debugging/access)
  // Returns project path if available, otherwise app documents path
  Future<String> getLogFilePath() async {
    final projectFile = await _getProjectLogFile();
    if (projectFile != null) {
      return projectFile.path;
    }
    final file = await _getLogFile();
    return file.path;
  }

  // Get all log file paths (project and app)
  Future<List<String>> getAllLogFilePaths() async {
    final paths = <String>[];

    final projectFile = await _getProjectLogFile();
    if (projectFile != null && await projectFile.exists()) {
      paths.add(projectFile.path);
    }

    final appFile = await _getLogFile();
    if (await appFile.exists()) {
      paths.add(appFile.path);
    }

    return paths;
  }

  // Export logs as JSON string
  Future<String> exportLogsAsJson() async {
    final logs = await loadLogs();
    return jsonEncode(logs.map((log) => log.toJson()).toList());
  }

  // Share the log file using the platform's share sheet
  Future<void> shareLogFile() async {
    try {
      final file = await _getLogFile();
      if (await file.exists()) {
        // Ensure content is up to date
        // Note: In a real scenario we might want to ensure flush, but simple write is usually fine.
        
        final XFile xFile = XFile(file.path);
        await Share.shareXFiles([xFile], text: 'Logs do jogo Infiltrado');
      } else {
        if (kDebugMode) {
          print('Log file not found for sharing');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing log file: $e');
      }
      rethrow; // Re-throw to handle in UI
    }
  }
}
