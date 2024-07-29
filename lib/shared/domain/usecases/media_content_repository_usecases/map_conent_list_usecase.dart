import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class MapContentListUseCase
    extends UseCase<List<MediaContent>, MapContentListParams> {
  final MediaContentRepository _repository;

  MapContentListUseCase(this._repository);

  @override
  List<MediaContent> call(MapContentListParams params) {
    return _repository.mapContentList(params);
  }
}
