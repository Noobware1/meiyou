import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/toast.dart';

final LogRat logRat = LogRat();

enum LogPriority {
  verbose,
  debug,
  info,
  warning,
  error,
}

final class Log {
  final String message;
  final LogPriority priority;
  final String? debugMessage;

  Log({
    required this.message,
    required this.priority,
    required this.debugMessage,
  });

  @override
  String toString() {
    return '''Log: {
      message: $message,
      priority: $priority,
      debugMessage: $debugMessage,
    }''';
  }
}

class LogRat {
  LogRat();

  // final StreamController<Log> _logStreamController =
  //     StreamController<Log>.broadcast();

  // Stream<Log> get logStream => _logStreamController.stream;

  void logcatch(LogPriority priority, Object? error, StackTrace stackTrace) {
    return log(priority, error.toString(), stackTrace.toString());
  }

  void logVerbose(String message, String verboseMessage) {
    log(LogPriority.verbose, message, verboseMessage);
  }

  void logInfo(String message, String info) {
    log(LogPriority.info, message, info);
  }

  void logDebug(String message, String debugMessage) {
    log(LogPriority.debug, message, debugMessage);
  }

  void logError(String message, Object? error, [StackTrace? stackTrace]) {
    log(LogPriority.error, message, 'Error: $error\n$stackTrace');
  }

  void log(LogPriority priority, String message, [String? debugMessage]) {
    final log = Log(
      message: message,
      priority: priority,
      debugMessage: debugMessage,
    );
    debugPrint(log.toString());
    makeToast(log.message);
    // _logStreamController.add(log);
  }
}
