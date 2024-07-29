import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class GetContentListByMediaIdAsStreamUseCase extends UseCase<
    Stream<List<MediaContent>>, GetContentListByMediaIdAsStreamParams> {
  final MediaContentRepository _repository;

  GetContentListByMediaIdAsStreamUseCase(this._repository);

  @override
  Stream<List<MediaContent>> call(
      GetContentListByMediaIdAsStreamParams params) {
    return _repository.getContentListByMediaIdAsStream(params);
  }
}
