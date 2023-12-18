import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LoadMediaDetailsUseCase
    implements UseCase<Future<ResponseState<MediaDetails>>, SearchResponse> {
  final PluginRepository _repository;

  LoadMediaDetailsUseCase(this._repository);

  @override
  Future<ResponseState<MediaDetails>> call(SearchResponse params) {
    return _repository.loadMediaDetails(params);
  }
}
