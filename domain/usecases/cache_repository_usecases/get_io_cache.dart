import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class GetFromIOCacheUseCaseParams<T> {
  final String path;
  final T Function(dynamic data) transformer;

  GetFromIOCacheUseCaseParams(this.path, this.transformer);
}

class GetFromIOCacheUseCase<T> extends UseCase<Future<T?>, GetFromIOCacheUseCaseParams<T>> {
  final CacheRespository _cacheRepository;

  GetFromIOCacheUseCase(this._cacheRepository);

  @override
  Future<T?> call(GetFromIOCacheUseCaseParams<T> params) {
    return _cacheRepository.getFromIOCache(params.path, params.transformer);
  }
}
