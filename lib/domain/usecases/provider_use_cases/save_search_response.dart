import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class SaveSearchResponseUseCaseParams {
  final BaseProvider provider;
  final SearchResponseEntity searchResponse;
  final CacheRespository cacheRespository;

  SaveSearchResponseUseCaseParams(
      {required this.provider,
      required this.searchResponse,
      required this.cacheRespository});
}

class SaveSearchResponseUseCase
    extends UseCase<Future<void>, SaveSearchResponseUseCaseParams> {
  final WatchProviderRepository _repository;

  SaveSearchResponseUseCase(this._repository);

  @override
  Future<void> call(SaveSearchResponseUseCaseParams params) {
    return _repository.saveSearchResponse(
        provider: params.provider,
        searchResponse: params.searchResponse,
        cacheRespository: params.cacheRespository);
  }
}
