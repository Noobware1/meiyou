import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class LoadMediaUseCase
    implements UseCase<Future<ResponseState<Media?>>, ExtractorLink> {
  final PluginRepository _repository;

  LoadMediaUseCase(this._repository);

  @override
  Future<ResponseState<Media?>> call(ExtractorLink params) {
    return _repository.loadMedia(params);
  }
}
