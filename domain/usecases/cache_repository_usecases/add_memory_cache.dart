import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class AddMemoryCacheParams {
  final String key;
  final Object data;

  AddMemoryCacheParams({required this.key, required this.data});
}

class AddMemoryCacheUseCase extends UseCase<void, AddMemoryCacheParams> {
  final CacheRespository _cacheRepository;

  AddMemoryCacheUseCase(this._cacheRepository);

  @override
  void call(AddMemoryCacheParams params) {
    return _cacheRepository.addMemoryCache(params.key, data: params.data);
  }
}
