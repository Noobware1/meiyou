import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meiyou/core/utils/extensions/stream_subscription.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:synchronized/synchronized.dart';

class _MappedStateNotifier<T, R> extends StateNotifier<R> {
  final R Function(T) _mapper;
  final StateNotifier<T> _stateNotifier;
  final bool _autoDispose;
  _MappedStateNotifier(StateNotifier<T> stateNotifier, R Function(T) mapper,
      {required bool autoDispose})
      : _mapper = mapper,
        _stateNotifier = stateNotifier,
        _autoDispose = autoDispose,
        super(mapper(stateNotifier.state)) {
    stateNotifier.addListener(_listener);
  }

  void _listener() {
    setState(_mapper(_stateNotifier.state));
  }

  @override
  FutureOr onDispose() {
    if (_autoDispose) {
      _stateNotifier.dispose();
    } else {
      _stateNotifier.removeListener(_listener);
    }
    return super.onDispose();
  }
}

class _CombinedStateNotifier<R, State> extends StateNotifier<State> {
  final List<StateNotifier<R>> _stateNotifiers;
  final State Function(List<R>) _combiner;
  final bool _autoDispose;
  late final List<R> _states;

  late final List<VoidCallback> _listeners;
  Lock? _lock = Lock();

  _CombinedStateNotifier(
      List<StateNotifier<R>> stateNotifiers, State Function(List<R>) combiner,
      {required bool autoDispose})
      : _stateNotifiers = stateNotifiers,
        _combiner = combiner,
        _autoDispose = autoDispose,
        super(combiner(stateNotifiers.map((e) => e.state).toList())) {
    _states = stateNotifiers.map((e) => e.state).toList(growable: false);
    _listeners = List.generate(
        stateNotifiers.length, (index) => () => _valueChanged(index));

    for (var i = 0; i < _states.length; i++) {
      stateNotifiers[i].addListener(_listeners[i]);
    }
  }

  Future<void> _valueChanged(int index) async {
    await _lock?.synchronized(() {
      _states[index] = _stateNotifiers[index].state;
      setState(_combiner(_states));
    });
  }

  @override
  FutureOr onDispose() {
    if (_autoDispose) {
      for (var element in _stateNotifiers) {
        element.dispose();
      }
    } else {
      for (var i = 0; i < _stateNotifiers.length; i++) {
        _stateNotifiers[i].removeListener(_listeners[i]);
      }
    }
    _lock = null;
    return super.onDispose();
  }
}

class _DistinctStateNotifier<T> extends StateNotifier<T> {
  final bool Function(T a, T b) _equals;
  final StateNotifier<T> _stateNotifier;
  final bool _autoDispose;
  _DistinctStateNotifier(StateNotifier<T> stateNotifier,
      {required bool Function(T a, T b) equals, required bool autoDispose})
      : _equals = equals,
        _stateNotifier = stateNotifier,
        _autoDispose = autoDispose,
        super(stateNotifier.state) {
    stateNotifier.addListener(_listener);
  }

  @override
  bool shouldChange(T a, T b) {
    return _equals(a, b);
  }

  void _listener() {
    setState(_stateNotifier.state);
  }

  @override
  FutureOr onDispose() {
    if (_autoDispose) {
      _stateNotifier.dispose();
    } else {
      _stateNotifier.removeListener(_listener);
    }
    return super.onDispose();
  }
}

class StreamStateNotifier<State> extends StateNotifier<State> {
  late final StreamSubscription<State> _streamSubscription;

  bool _isListeningLocked = false;

  bool get isListeningLocked => _isListeningLocked;

  StreamStateNotifier._(Stream<State> stream, {required State initialState})
      : super(initialState) {
    _streamSubscription = stream.listen((newState) {
      if (!_isListeningLocked) {
        setState(newState);
      }
    });
  }

  @override
  bool shouldChange(State a, State b) {
    return true;
  }

  void pause() {
    _streamSubscription.pause();
  }

  void resume() {
    _streamSubscription.resume();
  }

  void lockListening() {
    _isListeningLocked = true;
  }

  void unlockListening() {
    _isListeningLocked = false;
  }

  void cancel() {
    _streamSubscription.cancel();
  }

  @override
  Future<void> dispose() async {
    await _streamSubscription.tryCancel();
    super.dispose();
  }
}

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

  static StreamStateNotifier<State> fromStream<State>(Stream<State> stream,
      {required State initalState}) {
    return StreamStateNotifier._(stream, initialState: initalState);
  }

  StateNotifier<R> map<R>(R Function(State) mapper,
      {bool autoDispose = false}) {
    return _MappedStateNotifier(this, mapper, autoDispose: autoDispose);
  }

  StateStream<State> asStream([bool isBroadcast = true]) {
    return StateStream.fromListenable(this, isBroadcast: isBroadcast);
  }

  StateNotifier<State> distinct(
      {bool Function(State a, State b)? equals, bool autoDispose = false}) {
    return _DistinctStateNotifier(this,
        equals: equals ?? (a, b) => a == b, autoDispose: autoDispose);
  }

  static StateNotifier<State> combine<R, State>(
    List<StateNotifier<R>> stateListenables,
    State Function(List<R> states) combiner, {
    bool autoDispose = false,
  }) {
    return _CombinedStateNotifier<R, State>(stateListenables, combiner,
        autoDispose: autoDispose);
  }

  static StateNotifier<State> combine2<A, B, State>(
    StateNotifier<A> stateListenableA,
    StateNotifier<B> stateListenableB,
    State Function(A a, B b) combiner, {
    bool autoDispose = false,
  }) {
    return combine<dynamic, State>([
      stateListenableA,
      stateListenableB
    ], (states) => combiner(states[0], states[1]), autoDispose: autoDispose);
  }

  static StateNotifier<State> combine3<A, B, C, State>(
    StateNotifier<A> stateListenableA,
    StateNotifier<B> stateListenableB,
    StateNotifier<C> stateListenableC,
    State Function(A a, B b, C c) combiner, {
    bool autoDispose = false,
  }) {
    return combine<dynamic, State>(
        [stateListenableA, stateListenableB, stateListenableC],
        (states) => combiner(states[0], states[1], states[2]),
        autoDispose: autoDispose);
  }

  static StateNotifier<State> combine4<A, B, C, D, State>(
    StateNotifier<A> stateListenableA,
    StateNotifier<B> stateListenableB,
    StateNotifier<C> stateListenableC,
    StateNotifier<D> stateListenableD,
    State Function(A a, B b, C c, D d) combiner, {
    bool autoDispose = false,
  }) {
    return combine<dynamic, State>([
      stateListenableA,
      stateListenableB,
      stateListenableC,
      stateListenableD
    ], (states) => combiner(states[0], states[1], states[2], states[3]),
        autoDispose: autoDispose);
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
