extension IterableUtils<E> on Iterable<E> {
  List<T> mapAsList<T>(T Function(E it) toElement) => map(toElement).toList();

  List<T> mapWithIndex<T>(T Function(int index, E it) toElement) {
    return List.generate(
        length, (index) => toElement.call(index, elementAt(index)),
        growable: false);
  }

  E? tryfirstWhere(bool Function(E) test, {E Function()? orElse}) {
    try {
      return firstWhere(test, orElse: orElse);
    } catch (_, __) {
      // print(_);
      // print(__);
      return null;
    }
  }

  Iterable<E>? tryWhere(bool Function(E element) test) {
    try {
      return where(test);
    } catch (_) {
      return null;
    }
  }
}
