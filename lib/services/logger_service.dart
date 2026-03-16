import 'package:flutter/foundation.dart';

/// 应用日志服务
class AppLogger {
  static final List<LogEntry> _logs = [];
  static bool _debugMode = true;
  
  static void init({bool debugMode = true}) {
    _debugMode = debugMode;
    log('AppLogger', 'Logger initialized');
  }
  
  static void log(String tag, String message, {LogLevel level = LogLevel.info}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      tag: tag,
      message: message,
      level: level,
    );
    _logs.add(entry);
    
    if (_debugMode) {
      debugPrint('[${level.name.toUpperCase()}] [$tag] $message');
    }
  }
  
  static void info(String tag, String message) => log(tag, message, level: LogLevel.info);
  static void debug(String tag, String message) => log(tag, message, level: LogLevel.debug);
  static void warning(String tag, String message) => log(tag, message, level: LogLevel.warning);
  static void error(String tag, String message, [Object? error, StackTrace? stackTrace]) {
    log(tag, message, level: LogLevel.error);
    if (error != null) {
      log(tag, 'Error: $error', level: LogLevel.error);
    }
    if (stackTrace != null) {
      log(tag, 'StackTrace: $stackTrace', level: LogLevel.error);
    }
  }
  
  static List<LogEntry> getLogs() => List.unmodifiable(_logs);
  
  static String getAllLogsAsString() {
    final buffer = StringBuffer();
    buffer.writeln('=== Star Encounter App Logs ===');
    buffer.writeln('Total: ${_logs.length} entries');
    buffer.writeln('');
    for (final entry in _logs) {
      buffer.writeln('[${entry.timestamp.toIso8601String()}] [${entry.level.name.toUpperCase()}] [${entry.tag}] ${entry.message}');
    }
    return buffer.toString();
  }
  
  static void clear() => _logs.clear();
}

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final DateTime timestamp;
  final String tag;
  final String message;
  final LogLevel level;
  
  LogEntry({
    required this.timestamp,
    required this.tag,
    required this.message,
    required this.level,
  });
}
