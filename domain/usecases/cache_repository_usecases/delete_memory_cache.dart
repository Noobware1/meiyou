import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class DeleteAllMemoryCacheUseCase extends UseCase<void, NoParams> {
  final CacheRespository _cacheRepository;

  DeleteAllMemoryCacheUseCase(this._cacheRepository);

  @override
  void call(NoParams params) {
    return _cacheRepository.deleteAllMemoryCache();
  }
}
