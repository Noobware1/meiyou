import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class DeleteAllCacheUseCase extends UseCase<Future<void>, NoParams> {
  final CacheRespository _cacheRepository;

  DeleteAllCacheUseCase(this._cacheRepository);

  @override
  Future<void> call(NoParams params) {
    return _cacheRepository.deleteAllCache();
  }
}
