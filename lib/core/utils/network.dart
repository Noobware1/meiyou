import 'dart:async';
import 'package:meiyou/core/resources/response_state.dart';

Future<ResponseState<T>> tryWithAsync<T>(Future<T> Function() fun,
    {Duration? timeout}) async {
  try {
    if (timeout != null) {
      return ResponseSuccess(await fun.call().timeout(timeout,
          onTimeout: () => throw TimeoutException('Request Timeout')));
    } else {
      return ResponseSuccess(await fun.call());
    }
    // if (verify != null) assert(verify);
  } catch (_, __) {
    return ResponseFailed.defaultError(_, __);
  }
}

Future<T?> tryWithAsyncSafe<T>(Future<T> Function() fun,
    {Duration? timeout}) async {
  try {
    final T future;
    if (timeout != null) {
      future = await fun.call().timeout(timeout);
    } else {
      future = await fun.call();
    }
    return future;
  } catch (_, __) {
    print(_);
    print(__);
    return null;
  }
}
