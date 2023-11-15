import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class LoadSearchUseCase
    implements
        UseCase<Future<ResponseState<List<SearchResponseEntity>>>, String> {
  final PluginManagerRepository _repository;

  LoadSearchUseCase(this._repository);

  @override
  Future<ResponseState<List<SearchResponseEntity>>> call(String params) {
    return _repository.search(params);
  }
}
