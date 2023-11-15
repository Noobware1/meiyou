import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class UpdateMemoryCacheValueUseCaseParams {
  final String key;
  final Object data;

  UpdateMemoryCacheValueUseCaseParams({required this.key, required this.data});
}

class UpdateMemoryCacheValueUseCase
    extends UseCase<void, UpdateMemoryCacheValueUseCaseParams> {
  final CacheRespository _cacheRepository;

  UpdateMemoryCacheValueUseCase(this._cacheRepository);

  @override
  void call(UpdateMemoryCacheValueUseCaseParams params) {
    return _cacheRepository.updateMemoryCacheValue(params.key, params.data);
  }
}
