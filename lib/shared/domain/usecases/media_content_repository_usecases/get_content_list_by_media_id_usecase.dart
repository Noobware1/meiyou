import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class GetContentListByMediaIdUseCase
    extends UseCase<List<MediaContent>, GetContentListByMediaIdParams> {
  final MediaContentRepository _repository;

  GetContentListByMediaIdUseCase(this._repository);

  @override
  List<MediaContent> call(GetContentListByMediaIdParams params) {
    return _repository.getContentListByMediaId(params);
  }
}
