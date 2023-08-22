extension ListUtils<T> on List<T> {
  List<T> whereSafe(bool Function(T) fun) {
    try {
      return where(fun).toList();
    } catch (_) {
      return const [];
    }
  }
}