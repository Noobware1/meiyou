import 'dart:async';

import 'package:meiyou/core/utils/cancelable_operation/cancelable_operation_mixin.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:nice_dart/nice_dart.dart';

class AsyncStateNotifier<State> extends StateNotifier<AsyncValue<State>>
    with CancelableOperationMixin<State> {
  AsyncStateNotifier(super.state);

  AsyncStateNotifier.loading() : super(const AsyncValue.loading());

  AsyncStateNotifier.data(State data) : super(AsyncValue.data(data));

  AsyncStateNotifier.error(Object error, [StackTrace? stackTrace])
      : super(AsyncValue.error(error, stackTrace ?? StackTrace.current));

  AsyncStateNotifier.noData() : super(const AsyncValue.noData());

  void setResultFuture(Future<Result<State>> Function() future) async {
    setFuture(() => future().then((value) => value.getOrThrow()));
  }

  void setError(Object error, [StackTrace? stackTrace]) {
    setState(AsyncValue.error(error, stackTrace ?? StackTrace.current));
  }

  @override
  void setState(AsyncValue<State> state) {
    cancel();
    super.setState(state);
  }

  void setLoading() {
    setState(const AsyncValue.loading());
  }

  void setData(State data) {
    setState(AsyncValue.data(data));
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  void onData(State data) {
    setData(data);
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    setError(error, stackTrace);
  }

  @override
  void onLoading() {
    setLoading();
  }
}
