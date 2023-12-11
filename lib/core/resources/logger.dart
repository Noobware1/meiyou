import 'package:flutter/foundation.dart';

void log(Object? exception, [StackTrace? stackTrace, bool force = false]) {
  if (force) {
    // ignore: avoid_print
    print(exception);
    // ignore: avoid_print
    print(stackTrace);
  } else if (kDebugMode) {
    print(exception);
    print(stackTrace);
  }
}
