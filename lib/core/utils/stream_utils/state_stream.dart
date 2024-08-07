import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';

class _StateStreamFromListenable<T> extends StateStream<T> {
  final StateNotifier<T> stateListenable;

  _StateStreamFromListenable(this.stateListenable, {super.isBroadcast})
      : super(initialData: stateListenable.state) {
    stateListenable.addListener(_valueChanged);
  }

  @override
  FutureOr onDispose() {
    stateListenable.removeListener(_valueChanged);
    return super.onDispose();
  }

  void _valueChanged() {
    update(stateListenable.state);
  }
}

class StateStream<T> with Disposable implements Stream<T> {
  StateStream({required T initialData, bool isBroadcast = true}) {
    _init(this, initialData, isBroadcast);
  }

  factory StateStream.fromListenable(StateNotifier<T> stateListenable,
      {bool isBroadcast = true}) {
    return _StateStreamFromListenable(stateListenable,
        isBroadcast: isBroadcast);
  }

  static void _init<T>(
      StateStream<T> stream, T? initialData, bool isBroadcast) {
    stream
      .._state = initialData
      .._controller =
          isBroadcast ? StreamController<T>.broadcast() : StreamController<T>()
      .._subscription = stream._controller.stream.listen(
        (data) {
          stream._state = data;
        },
      );
  }

  StateStream.fromStream(Stream<T> stream,
      {required T initialData, bool isBroadcast = true}) {
    _init(this, initialData, isBroadcast);
    _controller.addStream(stream);
  }

  late final StreamController<T> _controller;
  late final StreamSubscription<T> _subscription;

  bool hasUpdated = false;

  Completer _completer = Completer()..complete();

  final Queue<Function> _queue = Queue();

  @override
  bool get isBroadcast => _controller.stream.isBroadcast;

  T? _state;

  // this is unsafe, use with caution
  T get state => _state is T
      ? _state as T
      : (throw StateError(
          'State is null. this could mean that no initial value was provided'));

  T? stateOrNull() => _state;

  T? stateOrDefault(T defaultValue) => _state is T ? _state as T : defaultValue;

  bool get hasData => _state != null;

  void update(T data) {
    if (_completer.isCompleted) {
      _controller.add(data);
    } else {
      _queue.add(() => _controller.add(data));
    }
    if (!hasUpdated) {
      hasUpdated = true;
    }
  }

  bool get isTaskRunning => _completer.isCompleted;

  void addStream(Stream<T> stream, {bool cancelOnError = false}) {
    if (_completer.isCompleted) {
      _addStream(stream, cancelOnError);
    } else {
      _queue.add(() => _addStream(stream, cancelOnError));
    }
  }

  void _addStream(Stream<T> stream, bool cancelOnError) {
    _completer = Completer();
    _controller
        .addStream(stream, cancelOnError: cancelOnError)
        .then((value) => completeCompleter())
        .catchError((error, s) => _controller.addError(error, s));
  }

  void completeCompleter() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
    if (_queue.isNotEmpty) {
      _completer = Completer();
      _queue.removeFirst().call();
    }
  }

  void completeErrorCompleter(Object error, [StackTrace? stackTrace]) {
    if (!_completer.isCompleted) {
      _completer.completeError(error, stackTrace);
    }
    _controller.addError(error, stackTrace);
    if (_queue.isNotEmpty) {
      _completer = Completer();
      _queue.removeFirst().call();
    }
  }

  @override
  StreamSubscription<T> listen(void Function(T value)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  FutureOr onDispose() async {
    await _subscription.cancel();
    await _controller.close();
  }

  @override
  StateStream<T> asBroadcastStream(
      {void Function(StreamSubscription<T> subscription)? onListen,
      void Function(StreamSubscription<T> subscription)? onCancel}) {
    throw UnsupportedError('Use the constructor to create a broadcast stream');
  }

  @override
  StateStream<S> map<S>(S Function(T event) convert) {
    return StateStream.fromStream(_controller.stream.map(convert),
        initialData: convert(state), isBroadcast: isBroadcast);
  }

  StateStream<E> stateStreamAsyncExpand<E>(
    E initalData,
    Stream<E>? Function(T event) convert,
  ) {
    return StateStream.fromStream(_controller.stream.asyncExpand(convert),
        initialData: initalData, isBroadcast: isBroadcast);
  }

  @override
  Stream<E> asyncExpand<E>(
    Stream<E>? Function(T event) convert,
  ) {
    return _controller.stream.asyncExpand(convert);
  }

  StateStream<S> stateStreamExpand<S>(
      S initalData, Iterable<S> Function(T element) convert) {
    return StateStream.fromStream(_controller.stream.expand(convert),
        initialData: initalData, isBroadcast: isBroadcast);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(T element) convert) {
    return _controller.stream.expand(convert);
  }

  StateStream<E> stateStreamAsyncMap<E>(
      E initalData, FutureOr<E> Function(T event) convert) {
    return StateStream.fromStream(_controller.stream.asyncMap(convert),
        initialData: initalData, isBroadcast: isBroadcast);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) {
    return _controller.stream.asyncMap(convert);
  }

  @override
  StateStream<R> cast<R>() {
    return StateStream.fromStream(_controller.stream.cast<R>(),
        initialData: state as R, isBroadcast: isBroadcast);
  }

  StateStream<S> stateStreamTransform<S>(
      S initalData, StreamTransformer<T, S> streamTransformer,
      {bool isBroadcast = true}) {
    return StateStream.fromStream(
      _controller.stream.transform(streamTransformer),
      initialData: initalData,
      isBroadcast: isBroadcast,
    );
  }

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) {
    return _controller.stream.transform(streamTransformer);
  }

  @override
  StateStream<T> distinct([bool Function(T previous, T next)? equals]) {
    return StateStream.fromStream(_controller.stream.distinct(equals),
        initialData: state, isBroadcast: isBroadcast);
  }

  @override
  StateStream<T> skip(int count) {
    return StateStream.fromStream(_controller.stream.skip(count),
        initialData: state, isBroadcast: isBroadcast);
  }

  @override
  StateStream<T> skipWhile(bool Function(T element) test) {
    return StateStream.fromStream(_controller.stream.skipWhile(test),
        initialData: state, isBroadcast: isBroadcast);
  }

  @override
  StateStream<T> take(int count) {
    return StateStream.fromStream(_controller.stream.take(count),
        initialData: state, isBroadcast: isBroadcast);
  }

  @override
  StateStream<T> takeWhile(bool Function(T element) test) {
    return StateStream.fromStream(_controller.stream.takeWhile(test),
        initialData: state, isBroadcast: isBroadcast);
  }

  @override
  StateStream<T> timeout(Duration timeLimit,
      {void Function(EventSink<T> sink)? onTimeout}) {
    return StateStream.fromStream(
        _controller.stream.timeout(timeLimit, onTimeout: onTimeout),
        initialData: state,
        isBroadcast: isBroadcast);
  }

  @override
  Stream<T> where(bool Function(T event) test) {
    return _controller.stream.where(test);
  }

  @override
  Future<bool> any(bool Function(T element) test) {
    return _controller.stream.any(test);
  }

  @override
  Future<bool> contains(Object? needle) {
    return _controller.stream.contains(needle);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return _controller.stream.drain(futureValue);
  }

  @override
  Future<T> elementAt(int index) => _controller.stream.elementAt(index);

  @override
  Future<bool> every(bool Function(T element) test) {
    return _controller.stream.every(test);
  }

  @override
  Future<T> get first => _controller.stream.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _controller.stream.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine) {
    return _controller.stream.fold(initialValue, combine);
  }

  @override
  Future<void> forEach(void Function(T element) action) {
    return _controller.stream.forEach(action);
  }

  @override
  Stream<T> handleError(Function onError,
      {bool Function(dynamic error)? test}) {
    return _controller.stream.handleError(onError, test: test);
  }

  @override
  Future<bool> get isEmpty => _controller.stream.isEmpty;

  @override
  Future<String> join([String separator = ""]) {
    return _controller.stream.join(separator);
  }

  @override
  Future<T> get last => _controller.stream.last;

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _controller.stream.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => _controller.stream.length;

  @override
  Future pipe(StreamConsumer<T> streamConsumer) {
    return _controller.stream.pipe(streamConsumer);
  }

  @override
  Future<T> reduce(T Function(T previous, T element) combine) {
    return _controller.stream.reduce(combine);
  }

  @override
  Future<T> get single => _controller.stream.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _controller.stream.singleWhere(test, orElse: orElse);
  }

  @override
  Future<List<T>> toList() {
    return _controller.stream.toList();
  }

  @override
  Future<Set<T>> toSet() {
    return _controller.stream.toSet();
  }
}
