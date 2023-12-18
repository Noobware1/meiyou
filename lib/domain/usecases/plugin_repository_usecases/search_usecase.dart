import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LoadSearchUseCase
    implements UseCase<Future<ResponseState<List<SearchResponse>>>, String> {
  final PluginRepository _repository;

  LoadSearchUseCase(this._repository);

  @override
  Future<ResponseState<List<SearchResponse>>> call(String params) {
    return _repository.search(params);
  }
}
