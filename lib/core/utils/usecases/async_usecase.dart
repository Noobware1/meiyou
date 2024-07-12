import 'package:nice_dart/nice_dart.dart';
import 'package:meiyou/core/utils/usecases/usecase.dart';



abstract class AsyncUsecase<Value, Params>
    implements UseCase<Future<Result<Value>>, Params> {
  @override
  Future<Result<Value>> call(Params params);
}
