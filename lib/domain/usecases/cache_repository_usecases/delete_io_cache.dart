import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class DeleteAllIOCacheUseCase extends UseCase<Future<void>, NoParams> {
  final CacheRespository _cacheRepository;

  DeleteAllIOCacheUseCase(this._cacheRepository);

  @override
  Future<void> call(NoParams params) {
    return _cacheRepository.deleteAllIOCache();
  }
}
