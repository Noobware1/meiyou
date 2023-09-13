import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class RemoveFromIOCacheUseCase extends UseCase<Future<void>, String> {
  final CacheRespository _cacheRepository;

  RemoveFromIOCacheUseCase(this._cacheRepository);

  @override
  Future<void> call(String params) {
    return _cacheRepository.removeIOCache(params);
  }
}
