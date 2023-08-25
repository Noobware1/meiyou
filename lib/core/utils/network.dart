import 'dart:async';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

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
