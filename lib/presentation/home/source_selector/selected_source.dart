import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SelectedSourceState {
  final ExtensionType type;
  final Source? source;

  const SelectedSourceState(this.type, this.source);
}

class SelectedSource extends StateNotifer<SelectedSourceState> {
  late final StreamSubscription<(ExtensionType, Source?)> _subscription;
  final SourcePreferences _sourcePreferences;
  final SourceManager _sourceManager;
  SelectedSource(
    this._sourcePreferences,
    this._sourceManager,
  ) : super(_initalState(_sourcePreferences, _sourceManager)) {
    _subscription = _sourceManager.selectedSourceStream().listen(
        (data) => setState(SelectedSourceState(data.$1, data.$2)),
        cancelOnError: false, onError: (err, stack) {
      logRat.logcatch(
        LogPriority.error,
        err,
        stack is StackTrace ? stack : StackTrace.current,
      );
    });
  }

  Source? get source => state.source;

  ExtensionType get type => state.type;

  void forceEmit(ExtensionType type, Source? source) {
    setState(
      SelectedSourceState(
        type,
        source,
      ),
    );
  }

  void restore() {
    setState(_initalState(_sourcePreferences, _sourceManager));
  }

  static SelectedSourceState _initalState(
      SourcePreferences sourcePreferences, SourceManager sourceManager) {
    return sourcePreferences
        .lastUsedExtensionType()
        .get()
        .let((it) => SelectedSourceState(
            it,
            sourceManager.getSource(
              it,
              sourcePreferences.lastUsedSourceByType(it).get(),
            )));
  }

  @override
  FutureOr<void> onDispose() async {
    await _subscription.cancel();
    super.onDispose();
  }
}
