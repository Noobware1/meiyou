import 'package:nice_dart/nice_dart.dart';

extension ResultsWhen<E> on Result<E> {
  T when<T>({
    required T Function(E value) success,
    required T Function(Exception error) error,
  }) {
    if (isSuccess) {
      return success(getOrNull() as E);
    } else {
      return error(exceptionOrNull()!);
    }
  }
}
