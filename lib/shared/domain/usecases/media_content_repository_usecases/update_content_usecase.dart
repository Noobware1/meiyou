import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class UpdateContentUseCase extends UseCase<Future<int>, UpdateContentParams> {
  final MediaContentRepository _repository;

  UpdateContentUseCase(this._repository);

  @override
  Future<int> call(UpdateContentParams params) {
    return _repository.updateContent(params);
  }
}
