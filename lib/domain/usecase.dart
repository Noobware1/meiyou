import 'package:nice_dart/nice_dart.dart';

abstract interface class UseCase<Value, Params> {
  Value call(Params params);
}

abstract interface class ResultUseCase<Value, Params>
    implements AsyncUseCase<Result<Value>, Params> {
  @override
  Future<Result<Value>> call(Params params);
}

abstract class AsyncUseCase<Value, Params>
    implements UseCase<Future<Value>, Params> {
  @override
  Future<Value> call(Params params);
}


