import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';

class GetMediaByIdAsStreamUseCase
    extends UseCase<Stream<Media?>, GetMediaByIdAsStreamParams> {
  final MediaRepository _repository;

  GetMediaByIdAsStreamUseCase(this._repository);

  @override
  Stream<Media?> call(GetMediaByIdAsStreamParams params) {
    return _repository.getMediaByIdAsStream(params);
  }
}
