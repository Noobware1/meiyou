import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class StateNotifer<State> extends ChangeNotifier with Disposable {
  StateNotifer(State state) : _state = state;

  State _state;

  State get state => _state;

  Future<State> get first {
    final completer = Completer<State>();
    void listener() => completer.complete(state);
    addListener(listener);
    return completer.future.then((value) {
      removeListener(listener);
      return value;
    });
  }

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @mustCallSuper
  void setState(State state) {
    if (_isDisposed) {
      throw StateError(
          'StateNotifer is already disposed cannot emit new state');
    }
    if (shouldChange(_state, state)) {
      _state = state;
      notifyListeners();
    }
  }

  bool shouldChange(State a, State b) => a != b;

  void addStateListner(void Function(State state) listener) {
    addListener(() {
      listener(state);
    });
  }

  void removeStateListner(void Function(State state) listener) {
    removeListener(() {
      listener(state);
    });
  }

  @mustCallSuper
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
