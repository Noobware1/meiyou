import 'package:flutter/material.dart';
import 'package:meiyou/notifers/async_notifer.dart';

abstract class FutureWidget<T> extends StatefulWidget
    with _FutureWidgetMixin<T> {
  @override
  final T? initialData;
  @override
  final Future<T> Function()? initFutureCallback;

  const FutureWidget({
    Key? key,
    this.initialData,
    this.initFutureCallback,
  }) : super(key: key);

  @override
  FutureState<T, FutureWidget<T>> createState();
}

abstract class FutureState<T, E extends FutureWidget<T>> extends State<E>
    with _FutureStateMixin<T, E> {
  @override
  void initState() {
    super.initState();
    _futureInitState();
  }

  @override
  void didUpdateWidget(E oldWidget) {
    super.didUpdateWidget(oldWidget);
    _futureDidUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _futureDispose();
    super.dispose();
  }
}

abstract mixin class _FutureWidgetMixin<T> {
  abstract final T? initialData;
  abstract final Future<T> Function()? initFutureCallback;
}

abstract mixin class _FutureStateMixin<T, E extends _FutureWidgetMixin<T>> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.

  abstract final E widget;

  Object? _activeCallbackIdentity;
  late AsyncValue<T> state;

  void _futureInitState() {
    state = widget.initialData == null
        ? AsyncValue<T>.loading()
        : AsyncValue<T>.data(widget.initialData as T);
    _subscribe(widget.initFutureCallback?.call());
  }

  void _futureDidUpdateWidget(E oldWidget) {
    if (oldWidget.initFutureCallback == widget.initFutureCallback) {
      return;
    }
    if (_activeCallbackIdentity != null) {
      _unsubscribe();
      state = AsyncValue<T>.loading();
    }
    _subscribe(widget.initFutureCallback?.call());
  }

  void listener(AsyncValue<T> state) {}

  void resetFuture(Future<T> future) {
    _unsubscribe();
    _subscribe(future);
  }

  Widget build(BuildContext context);

  void setState(void Function() callback);

  // @override
  void _futureDispose() {
    _unsubscribe();
    // super.dispose();
  }

  void _subscribe(Future<T>? future) {
    if (future == null) {
      // There is no future to subscribe to, do nothing.
      return;
    }
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    future.then<void>((T data) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() {
          state = AsyncValue<T>.data(data);
        });
      }
    }, onError: (Object error, StackTrace stackTrace) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() {
          state = AsyncValue<T>.error(error, stackTrace);
        });
      }

      listener(state);
      assert(() {
        if (FutureBuilder.debugRethrowError) {
          Future<Object>.error(error, stackTrace);
        }
        return true;
      }());
    });
    // An implementation like `SynchronousFuture` may have already called the
    // .then closure. Do not overwrite it in that case.
    if (!state.isLoading) {
      state = AsyncValue<T>.loading();
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }
}
