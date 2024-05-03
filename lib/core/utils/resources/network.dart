import 'package:nice_dart/nice_dart.dart';

Future<Result<R>> runAsyncCatching<R>(Future<R> Function() block) async {
  try {
    return Result.success<R>(await block());
  } catch (e) {
    return Result.failure<R>(e is Exception ? e : Exception(e.toString()));
  }
}
