import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class StateNotifier<State> extends ChangeNotifier with Disposable {
  StateNotifier(State state) : _state = state;

  State _state;

  State get state => _state;

  Future<State> get first {
    final completer = Completer<State>();
    void listener() {
      completer.complete(state);
      removeListener(listener);
    }

    addListener(listener);
    return completer.future;
  }

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @mustCallSuper
  void setState(State state) {
    if (_isDisposed) {
      throw StateError(
          'StateNotifier is already disposed cannot emit new state');
    }
    if (shouldChange(_state, state)) {
      _state = state;
      notifyListeners();
    }
  }

  bool shouldChange(State a, State b) => a != b;

  @mustCallSuper
  @protected
  @override
  FutureOr onDispose() {
    dispose();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
