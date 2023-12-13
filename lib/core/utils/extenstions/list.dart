extension MeiyouListExtension<E> on Iterable<E> {
  List<E> whereAsList(bool Function(E element) test) {
    final list = <E>[];
    for (var element in this) {
      if (test(element)) {
        list.add(element);
      }
    }
    return list;
  }
}
