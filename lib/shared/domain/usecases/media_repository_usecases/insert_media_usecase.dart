import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';

class InsertMediaUseCase extends UseCase<Future<int>, InsertMediaParams> {
  final MediaRepository _mediaRepository;

  InsertMediaUseCase(this._mediaRepository);

  @override
  Future<int> call(InsertMediaParams params) {
    return _mediaRepository.insertMedia(params);
  }
}
