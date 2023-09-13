import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/data/repositories/cache_repository_impl.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadSearchParams {
  final BaseProvider provider;
  final String? query;
  final CacheRespository cacheRespository;
  const LoadSearchParams(
      {this.query, required this.provider, required this.cacheRespository});
}

class LoadSearchUseCase
    implements
        UseCase<Future<ResponseState<List<SearchResponseEntity>>>,
            LoadSearchParams> {
  final WatchProviderRepository _repository;

  const LoadSearchUseCase(this._repository);

  @override
  Future<ResponseState<List<SearchResponseEntity>>> call(
      LoadSearchParams params) {
    return _repository.search(params.provider,
        query: params.query, cacheRespository: params.cacheRespository);
  }
}
