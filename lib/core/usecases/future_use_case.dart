import 'package:meiyou/core/resources/response_state.dart';

abstract interface class FutureUseCase<Type, Params> {
  Future<ResponseState<Type>> call(Params params);
}
