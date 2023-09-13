import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class UpdateIOCacheValueUseCaseParams {
  final String path;
  final String data;

  UpdateIOCacheValueUseCaseParams({required this.path, required this.data});
}

class UpdateIOCacheValueUseCase
    extends UseCase<Future<void>, UpdateIOCacheValueUseCaseParams> {
  final CacheRespository _cacheRepository;

  UpdateIOCacheValueUseCase(this._cacheRepository);

  @override
  Future<void> call(UpdateIOCacheValueUseCaseParams params) {
    return _cacheRepository.updateIOCacheValue(params.path, params.data);
  }
}
