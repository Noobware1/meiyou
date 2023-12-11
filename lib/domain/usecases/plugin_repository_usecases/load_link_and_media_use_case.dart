import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class LoadLinkAndMediaStreamUseCaseParams {
  final String url;

  LoadLinkAndMediaStreamUseCaseParams(this.url);
}

class LoadLinkAndMediaStreamUseCase
    implements
        UseCase<Stream<(ExtractorLink, Media)>,
            LoadLinkAndMediaStreamUseCaseParams> {
  final PluginRepository _repository;
  LoadLinkAndMediaStreamUseCase(this._repository);

  @override
  Stream<(ExtractorLink, Media)> call(
      LoadLinkAndMediaStreamUseCaseParams params) {
    return _repository.loadLinkAndMediaStream(params.url);
  }
}
