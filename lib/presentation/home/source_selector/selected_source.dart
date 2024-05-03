import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SelectedSource extends Cubit<Source?> {
  late final StreamSubscription<Source?> _subscription;

  SelectedSource(
    SourcePreferences sourcePreferences,
    SourceManager sourceManager,
  ) : super(_initalState(sourcePreferences, sourceManager)) {
    _subscription = sourceManager
        .selectedSourceStream()
        .listen(emit, cancelOnError: false, onError: (err, stack) {
      logRat.logcatch(
        LogPriority.error,
        err,
        stack is StackTrace ? stack : StackTrace.current,
      );
    });
  }

  static Source? _initalState(
      SourcePreferences sourcePreferences, SourceManager sourceManager) {
    return sourcePreferences
        .lastUsedExtensionType()
        .get()
        .let((it) => sourceManager.getSource(
              it,
              sourcePreferences.lastUsedSourceByType(it).get(),
            ));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
