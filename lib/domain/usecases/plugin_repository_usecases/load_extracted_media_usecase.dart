import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/extracted_media.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
class LoadExtractedMediaStreamUseCaseParams {
  final String url;

  LoadExtractedMediaStreamUseCaseParams(this.url);
}

class LoadExtractedMediaStreamUseCase
    implements
        UseCase<Stream<ExtractedMediaEntity>,
            LoadExtractedMediaStreamUseCaseParams> {
  final PluginRepository _repository;
  LoadExtractedMediaStreamUseCase(this._repository);

  @override
  Stream<ExtractedMediaEntity> call(
      LoadExtractedMediaStreamUseCaseParams params) {
    return _repository.loadExtractedMediaStream(params.url);
  }
}
