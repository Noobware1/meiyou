import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';

class GetMediaByUrlAndSourceIdUseCase
    extends UseCase<Media?, GetMediaByUrlAndSourceIdParams> {
  final MediaRepository _mediaRepository;

  GetMediaByUrlAndSourceIdUseCase(this._mediaRepository);

  @override
  Media? call(GetMediaByUrlAndSourceIdParams params) {
    return _mediaRepository.getMediaByUrlAndSourceId(params);
  }
}
