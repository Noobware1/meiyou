import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class DeleteIOCacheFromDir extends UseCase<Future<void>, String> {
  final CacheRespository _respository;

  DeleteIOCacheFromDir(this._respository);

  @override
  Future<void> call(String params) {
    return _respository.deleteIOCacheFromDir(params);
  }
}
