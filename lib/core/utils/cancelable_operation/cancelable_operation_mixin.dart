import 'package:async/async.dart';
import 'package:meiyou/core/utils/log/logger.dart';

mixin CancelableOperationMixin<T> {
  CancelableOperation<T>? _operation;

  Future<void> setFuture(Future<T> Function() future) async {
    onLoading();
    await cancel();
    _operation = CancelableOperation.fromFuture(future());

    try {
      final data = await _operation!.value;
      onData(data);
    } catch (err, stack) {
      onError(err, stack);
    }
  }

  void onData(T data);

  void onError(Object error, [StackTrace? stackTrace]);

  void onLoading();

  Future<void> cancel() async {
    try {
      await _operation?.cancel();
    } catch (e, s) {
      logger.severe('Error while canceling operation for $runtimeType', e, s);
    }
  }
}
