import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class GetContentByIdUseCase
    extends UseCase<MediaContent?, GetContentByIdParams> {
  final MediaContentRepository _repository;

  GetContentByIdUseCase(this._repository);

  @override
  MediaContent? call(GetContentByIdParams params) {
    return _repository.getContentById(params);
  }
}
