import 'package:nice_dart/nice_dart.dart';

extension ResultsWhen<E> on Result<E> {
  T when<T>({
    required T Function(E value) success,
    required T Function(Exception failure) failure,
  }) {
    if (isSuccess) {
      return success(getOrNull() as E);
    } else {
      return failure(exceptionOrNull()!);
    }
  }
}

Future<Result<T>> runAsyncCatching<T>(Future<T> Function() callback) async {
  try {
    return Result.success(await callback());
  } catch (e) {
    return Result.failure(e is Exception ? e : Exception(e.toString()));
  }
}
