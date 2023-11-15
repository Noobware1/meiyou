
import 'package:meiyou/core/utils/extenstions/iterable.dart';

class ListUtils {
  static List<T> mapList<T, E>(List<E> list, T Function(E) toElement) {
    return list.mapAsList(toElement);
  }
}

