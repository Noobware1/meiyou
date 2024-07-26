import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';

class GetMediaByIdUseCase extends UseCase<Media?, GetMediaByIdParams> {
  final MediaRepository _mediaRepository;

  GetMediaByIdUseCase(this._mediaRepository);

  @override
  Media? call(GetMediaByIdParams params) {
    return _mediaRepository.getMediaById(params);
  }
}
