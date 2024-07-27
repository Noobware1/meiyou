import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';

class UpdateMediaUsecase extends UseCase<Future<int>, UpdateMediaParams> {
  final MediaRepository repository;

  UpdateMediaUsecase(this.repository);

  @override
  Future<int> call(UpdateMediaParams params) {
    return repository.updateMedia(params);
  }
}
