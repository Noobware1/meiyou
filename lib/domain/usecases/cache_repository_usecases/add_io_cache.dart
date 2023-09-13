import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class AddIOCacheUseCaseParams {
  final String path;
  final String data;

  AddIOCacheUseCaseParams({required this.path, required this.data});
}

class AddIOCacheUseCase extends UseCase<Future<void>, AddIOCacheUseCaseParams> {
  final CacheRespository _cacheRepository;

  AddIOCacheUseCase(this._cacheRepository);

  @override
  Future<void> call(AddIOCacheUseCaseParams params) {
    return _cacheRepository.addIOCache(params.path, params.data);
  }
}
