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

extension FutureIterableUtils<E> on Future<Iterable<E>> {
  Future<Iterable<T>> map<T>(Future<T> Function(E it) toElement) async {
    return Future.wait((await this).map((e) => toElement(e)));
  }

  Future<Iterator<E>> get asyncIterator => then((value) => value.iterator);

  Future<Iterable<E>> followedBy(Iterable<E> other) async =>
      (await this).followedBy(other);

  Future<Iterable<E>> where(bool Function(E element) test) async =>
      (await this).where(test);

  Future<Iterable<T>> whereType<T>() async => (await this).whereType<T>();

  Future<Iterable<T>> expand<T>(
          Iterable<T> Function(E element) toElements) async =>
      (await this).expand(toElements);

  Future<bool> asyncContains(Object? element) async =>
      (await this).contains(element);

  Future<void> forEach(void Function(E element) action) async =>
      (await this).forEach(action);

  Future<E> reduce(E Function(E value, E element) combine) async =>
      (await this).reduce(combine);

  Future<T> fold<T>(
          T initialValue, T combine(T previousValue, E element)) async =>
      (await this).fold<T>(initialValue, combine);

  Future<bool> every(bool test(E element)) async => (await this).every(test);

  Future<String> join([String separator = ""]) async =>
      (await this).join(separator);

  Future<bool> any(bool test(E element)) async => (await this).any(test);

  Future<List<E>> toList({bool growable = true}) async => (await this).toList();

  Future<Set<E>> toSet() async => (await this).toSet();

  Future<int> get length async => (await this).length;

  Future<bool> get isEmpty async => (await this).isEmpty;

  Future<bool> get isNotEmpty async => (await this).isNotEmpty;

  Future<Iterable<E>> take(int count) async => (await this).take(count);

  Future<Iterable<E>> takeWhile(bool test(E value)) async =>
      (await this).takeWhile(test);

  Future<Iterable<E>> skip(int count) async => (await this).skip(count);

  Future<Iterable<E>> skipWhile(bool test(E value)) async =>
      (await this).skipWhile(test);

  Future<E> get first async => (await this).first;

  Future<E> get last async => (await this).last;

  Future<E> get single async => (await this).single;

  Future<E> firstWhere(bool test(E element), {E orElse()?}) async =>
      (await this).firstWhere(test, orElse: orElse);

  Future<E> lastWhere(bool Function(E element) test,
          {E Function()? orElse}) async =>
      (await this).lastWhere(test, orElse: orElse);

  Future<E> singleWhere(bool Function(E element) test,
          {E Function()? orElse}) async =>
      (await this).singleWhere(test, orElse: orElse);

  Future<E> elementAt(int index) async => (await this).elementAt(index);
}
