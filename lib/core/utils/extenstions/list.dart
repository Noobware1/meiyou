import 'dart:typed_data';

extension ListUtils<T> on List<T> {
  bool containsIndex(int index) {
    return index >= 0 && index < length;
    // if (index <= length) {
    //   return true;
    // }
    // return false;
  }

  List<T> whereSafe(bool Function(T) fun) {
    try {
      return where(fun).toList();
    } catch (_) {
      return const [];
    }
  }

  List<T>? whereOrNull(bool Function(T) fun) {
    try {
      return where(fun).toList();
    } catch (_) {
      return null;
    }
  }

  Uint8List toUint8List() {
    assert(this is List<int>);
    return Uint8List.fromList(this as List<int>);
  }

  void fastMap<E>(List<E> data, T Function(E element) converter) {
    for (var element in data) {
      add(converter.call(element));
    }
  }
}
