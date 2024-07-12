import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class StateFlow<T> extends Disposable {
  StateFlow(T initalData) : _state = initalData;

  factory StateFlow.stream(
    T initalData,
    Stream<T> stream, {
    void Function()? onDone,
    Function? onError,
    bool? cancelOnError,
  }) {
    return _StreamStateFlow(
      initalData,
      stream,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  T _state;

  T get state => _state;

  final StreamController<T> _controller = StreamController.broadcast();

  Stream<T> get stream => _controller.stream;

  void update(T data) {
    _controller.add(data);
    _state = data;
  }

  Future<void> close() async {
    await _controller.close();
  }

  @override
  Future<void> onDispose() async {
    await close();
  }
}

class _StreamStateFlow<T> extends StateFlow<T> {
  late final StreamSubscription<T> _subscription;
  _StreamStateFlow(
    T initalData,
    Stream<T> stream, {
    void Function()? onDone,
    Function? onError,
    bool? cancelOnError,
  }) : super(initalData) {
    _subscription = stream.listen(
      update,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

class StateFlowBuilder<T> extends StatelessWidget {
  const StateFlowBuilder(
      {super.key, required this.flow, required this.builder});

  final StateFlow<T> flow;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: flow.state,
      stream: flow.stream,
      builder: (context, snapshot) {
        return builder(context, snapshot.data as T);
      },
    );
  }
}
