import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class GetFromMemoryCacheUseCase<T> extends UseCase<T?, String> {
  final CacheRespository _cacheRepository;

  GetFromMemoryCacheUseCase(this._cacheRepository);

  @override
  T? call(String params) {
    return _cacheRepository.getFromMemoryCache<T>(params);
  }
}
