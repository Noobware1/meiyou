import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class RemoveFromMemoryCacheUseCase extends UseCase<void, String> {
  final CacheRespository _cacheRepository;

  RemoveFromMemoryCacheUseCase(this._cacheRepository);

  @override
  void call(String params) {
    return _cacheRepository.removeMemoryCache(params);
  }
}
