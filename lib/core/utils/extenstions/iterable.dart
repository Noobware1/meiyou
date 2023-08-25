extension IterableUtils<E> on Iterable<E> {
  List<T> mapAsList<T>(T Function(E it) toElement) => map(toElement).toList();

  List<T> mapWithIndex<T>(T Function(int index, E it) toElement) {
    return List.generate(
        length, (index) => toElement.call(index, elementAt(index)),
        growable: false);
  }
}
