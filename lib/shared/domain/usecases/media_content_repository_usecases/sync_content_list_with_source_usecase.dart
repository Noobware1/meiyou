import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';

class SyncContentListWithSourceUseCase extends UseCase<
    Future<List<MediaContent>>, SyncContentListWithSourceParams> {
  final MediaContentRepository _mediaContentRepository;

  SyncContentListWithSourceUseCase(this._mediaContentRepository);

  @override
  Future<List<MediaContent>> call(SyncContentListWithSourceParams params) {
    return _mediaContentRepository.syncContentListWithSource(params);
  }
}
