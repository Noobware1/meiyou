import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadServerAndVideoUseCaseParams {
  final BaseProvider provider;
  final String url;
  final CacheRespository cacheRespository;

  final void Function(Map<String, VideoContainerEntity> data)? onData;
  final void Function(
      MeiyouException error, Map<String, VideoContainerEntity>? data)? onError;

  const LoadServerAndVideoUseCaseParams(
      {required this.provider,
      required this.url,
      required this.cacheRespository,
      this.onData,
      this.onError});
}

class LoadServerAndVideoUseCase extends UseCase<
    Future<ResponseState<Map<String, VideoContainerEntity>>>,
    LoadServerAndVideoUseCaseParams> {
  final WatchProviderRepository _repository;

  LoadServerAndVideoUseCase(this._repository);

  @override
  Future<ResponseState<Map<String, VideoContainerEntity>>> call(
      LoadServerAndVideoUseCaseParams params) {
    return _repository.loadServerAndVideo(
      provider: params.provider,
      url: params.url,
      cacheRespository: params.cacheRespository,
      onData: params.onData,
      onError: params.onError,
    );
  }
}
