E? trySync<E>(E Function()? fun, {bool log = false}) {
  try {
    return fun?.call();
  } catch (e, s) {
    if (log) {
      print(e);
      print(s);
    }
    return null;
  }
}

Future<E?> tryAsync<E>(Future<E>? Function()? fun,
    {Duration? timeout,
    bool log = false,
  
    void Function(Object error, StackTrace? stackTrace)? onError}) async {
  try {
    if (timeout != null) {
      return await fun?.call()?.timeout(timeout);
    }
    return await fun?.call();
  } catch (e, s) {
    if (log) {
      print(e);
      print(s);
    }
    onError?.call(e, s);
    return null;
  }
}
