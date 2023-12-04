import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/extractor_link.dart';
import 'package:meiyou/domain/entities/media.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class LoadLinkAndMediaStreamUseCaseParams {
  final String url;

  LoadLinkAndMediaStreamUseCaseParams(this.url);
}

class LoadLinkAndMediaStreamUseCase
    implements
        UseCase<Stream<(ExtractorLinkEntity, MediaEntity)>,
            LoadLinkAndMediaStreamUseCaseParams> {
  final PluginManagerRepository _repository;
  LoadLinkAndMediaStreamUseCase(this._repository);

  @override
  Stream<(ExtractorLinkEntity, MediaEntity)> call(
      LoadLinkAndMediaStreamUseCaseParams params) {
    return _repository.loadLinkAndMediaStream(params.url);
  }
}
