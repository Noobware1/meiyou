import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadMovieParams {
  final BaseProvider provider;
  final String url;
  final CacheRespository cacheRepository;

  LoadMovieParams(
      {required this.provider,
      required this.url,
      required this.cacheRepository});
}

class LoadMovieUseCase
    implements UseCase<Future<ResponseState<MovieEntity>>, LoadMovieParams> {
  final WatchProviderRepository _repository;

  const LoadMovieUseCase(this._repository);

  @override
  Future<ResponseState<MovieEntity>> call(LoadMovieParams params) {
    return _repository.loadMovie(
        params.provider, params.url, params.cacheRepository);
  }
}
