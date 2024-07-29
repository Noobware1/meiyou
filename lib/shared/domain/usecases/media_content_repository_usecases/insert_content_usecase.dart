import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class InsertContentUseCase extends UseCase<Future<int>, InsertContentParams> {
  final MediaContentRepository _repository;

  InsertContentUseCase(this._repository);

  @override
  Future<int> call(InsertContentParams params) {
    return _repository.insertContent(params);
  }
}
