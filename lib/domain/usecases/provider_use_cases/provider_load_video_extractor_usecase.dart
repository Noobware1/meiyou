import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class ProviderLoadVideoExtractorUseCase
    implements UseCase<VideoExtractor?, VideoSeverEntity> {
  final WatchProviderRepository _repository;
  final BaseProvider _provider;

  const ProviderLoadVideoExtractorUseCase(
      {required WatchProviderRepository repository,
      required BaseProvider provider})
      : _repository = repository,
        _provider = provider;

  @override
  VideoExtractor? call(VideoSeverEntity params) {
    return _repository.loadVideoExtractor(_provider, params);
  }
}
