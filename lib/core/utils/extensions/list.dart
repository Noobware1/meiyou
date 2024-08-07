import 'package:nice_dart/nice_dart.dart';

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

extension ListAsyncMap<E> on List<E> {
  Future<List<R>> asyncMap<R>(Future<R> Function(E) f,
      {void Function(R)? cleanUp}) async {
    return Future.wait(map(f), cleanUp: cleanUp);
  }

  Future<List<R>> asyncMapNotNull<R>(Future<R?> Function(E) f,
      {void Function(R)? cleanUp}) async {
    return Future.wait(map(f),
            cleanUp: cleanUp == null
                ? null
                : (R? val) {
                    if (val != null) {
                      cleanUp(val);
                    }
                  })
        .then((values) => values.whereType<R>().toList());
  }
}

// extension ListAsyncMapNotNull<E> on List<E?> {
//   Future<List<R>> asyncMapNotNull<R>(Future<R?> Function(E?) f,
//       {void Function(R)? cleanUp}) async {
//     return Future.wait(map(f),
//             cleanUp: cleanUp == null
//                 ? null
//                 : (R? val) {
//                     if (val != null) {
//                       cleanUp(val);
//                     }
//                   })
//         .then((values) => values.whereType<R>().toList());
//   }
// }
