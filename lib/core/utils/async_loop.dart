import 'dart:async';

Future<List<T>> asyncStreamLooper<T>(int len, Future<T> Function(int index) fun,
    {int startFrom = 0, Duration delay = Duration.zero}) {
  final list = <T>[];
  final Completer<List<T>> completor = Completer<List<T>>();

  _stream(len, fun, startFrom, delay).listen((data) {
    if (data is List<T>) {
      list.addAll(data);
    } else {
      list.add(data);
    }
  })
    ..onDone(() {
      completor.complete(list);
    })
    ..onError((_, __) {
      completor.completeError(_, __);
    });

  return completor.future;
}

Stream<T> _stream<T>(int len, Future<T> Function(int index) fun, int startFrom,
    Duration delay) async* {
  for (var i = startFrom; i < len; i++) {
    await Future.delayed(delay);
    yield await fun.call(i);
  }
}

Future<void> asyncForLoop<T>(
    {required int len,
    required Future<T> Function(int index) fun,
    required Function(T) onData,
    int startFrom = 0,
    Function(Object, StackTrace)? onError}) async {
  for (var i = startFrom; i < len; i++) {
    try {
      final data = await fun.call(i);
      onData.call(data);
    } catch (_, __) {
      onError?.call(_, __);
    }
  }
}
