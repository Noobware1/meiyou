import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadSavedSearchResponseUseCaseParams {
  final BaseProvider provider;
  final CacheRespository cacheRespository;

  LoadSavedSearchResponseUseCaseParams(
      {required this.provider, required this.cacheRespository});
}

class LoadSavedSearchResponseUseCase extends UseCase<
    Future<SearchResponseEntity?>, LoadSavedSearchResponseUseCaseParams> {
  final WatchProviderRepository _repository;

  LoadSavedSearchResponseUseCase(this._repository);

  @override
  Future<SearchResponseEntity?> call(
      LoadSavedSearchResponseUseCaseParams params) {
    return _repository.loadSavedSearchResponse(
        params.provider, params.cacheRespository);
  }
}