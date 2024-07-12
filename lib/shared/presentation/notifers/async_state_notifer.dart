import 'dart:async';

import 'package:async/async.dart' hide Result;

import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';

import 'package:nice_dart/nice_dart.dart';

class AsyncStateNotifier<State> extends StateNotifier<AsyncValue<State>> {
  AsyncStateNotifier(super.state);

  CancelableOperation<State>? _operation;

  AsyncStateNotifier.loading() : super(const AsyncValue.loading());

  AsyncStateNotifier.data(State data) : super(AsyncValue.data(data));

  AsyncStateNotifier.error(Object error, [StackTrace? stackTrace])
      : super(AsyncValue.error(error, stackTrace ?? StackTrace.current));

  AsyncStateNotifier.noData() : super(const AsyncValue.noData());

  void setFuture(Future<State> Function() future) async {
    setLoading();
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(future());
    try {
      final data = await _operation!.value;
      setData(data);
    } catch (err, stack) {
      setError(err, stack);
    }
  }

  void setResultFuture(Future<Result<State>> Function() future) async {
    setFuture(() => future().then((value) => value.getOrThrow()));
  }

  void setError(Object error, [StackTrace? stackTrace]) {
    setState(AsyncValue.error(error, stackTrace ?? StackTrace.current));
  }

  void setLoading() {
    setState(const AsyncValue.loading());
  }

  void setData(State data) {
    setState(AsyncValue.data(data));
  }

  @override
  Future<void> dispose() async {
    await _operation?.cancel().then((value) {
      super.dispose();
    }).catchError((err) {
      super.dispose();
    });
  }
}
