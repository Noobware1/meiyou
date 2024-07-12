import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('App');

void initLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.OFF;
  }
  hierarchicalLoggingEnabled = true;

  Logger.root.onRecord.listen((record) {
    if (!kDebugMode) {
      return;
    }

    var start = '\x1b[90m';
    const end = '\x1b[0m';

    switch (record.level) {
      case Level.INFO:
        start = '\x1b[92m';
        break;
      case Level.WARNING:
        start = '\x1b[93m';
        break;
      case Level.SEVERE:
        start = '\x1b[103m\x1b[31m';
        break;
      case Level.SHOUT:
        start = '\x1b[41m\x1b[93m';
        break;
    }

    final message = '$end$start${record.message}$end';
    debugPrint(
      message,
      // level: record.level.value,
    );
  });
}
