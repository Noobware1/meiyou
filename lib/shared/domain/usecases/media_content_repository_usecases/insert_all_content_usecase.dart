import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class InsertAllContentUseCase
    extends UseCase<Future<List<MediaContent>>, InsertAllContentParams> {
  final MediaContentRepository _repository;

  InsertAllContentUseCase(this._repository);

  @override
  Future<List<MediaContent>> call(InsertAllContentParams params) {
    return _repository.insertAllContent(params);
  }
}
