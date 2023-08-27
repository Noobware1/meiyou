import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadVideoExtractorParams {
  final VideoSeverEntity server;
  final BaseProvider provider;

  LoadVideoExtractorParams({required this.server, required this.provider});
}

class LoadVideoExtractorUseCase
    implements UseCase<VideoExtractor?, LoadVideoExtractorParams> {
  final WatchProviderRepository _repository;

  const LoadVideoExtractorUseCase(this._repository);

  @override
  VideoExtractor? call(LoadVideoExtractorParams params) {
    return _repository.loadVideoExtractor(params.provider, params.server);
  }
}
