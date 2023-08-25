import 'dart:typed_data';

extension ListUtils<T> on List<T> {
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
}
