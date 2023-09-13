import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/usecases_container/usecase_container.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/delete_all_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/delete_io_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/delete_memory_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/get_io_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/get_memory_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/remove_io_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/remove_memory_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/update_io_cache.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/update_memory_cache.dart';

class CacheRepositoryUseCaseContainer
    extends UseCaseContainer<CacheRepositoryUseCaseContainer> {
  final CacheRespository _repository;

  CacheRepositoryUseCaseContainer(this._repository);

  @override
  Set<UseCase> get usecases => {
        GetFromIOCacheUseCase(_repository),
        GetFromMemoryCacheUseCase(_repository),
        DeleteAllCacheUseCase(_repository),
        DeleteAllMemoryCacheUseCase(_repository),
        DeleteAllIOCacheUseCase(_repository),
        RemoveFromIOCacheUseCase(_repository),
        RemoveFromMemoryCacheUseCase(_repository),
        UpdateIOCacheValueUseCase(_repository),
        UpdateMemoryCacheValueUseCase(_repository),
      };
}
