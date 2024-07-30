extension ListExtensions<T extends R, R> on List<T> {
  List<R> insertSeparators(R Function(T?, T?) generator) {
    if (isEmpty) return <R>[];
    List<R> newList = <R>[];
    for (int i = -1; i <= length; i++) {
      T? before = (i >= 0 && i < length) ? this[i] : null;
      if (before != null) {
        newList.add(before);
      }
      T? after = (i + 1 >= 0 && i + 1 < length) ? this[i + 1] : null;
      R? separator = generator(before, after);
      if (separator != null) {
        newList.add(separator);
      }
    }
    return newList;
  }
}
