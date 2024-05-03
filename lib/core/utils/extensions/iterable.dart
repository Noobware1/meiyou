extension IterableExtensions<T> on Iterable<T> {
  T? find(bool Function(T) test, {T Function()? orElse}) {
    try {
      return firstWhere(test, orElse: orElse);
    } catch (_) {
      return null;
    }
  }
}
