import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/video.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class GetDefaultVideoUseCase
    implements UseCase<VideoEntity, List<VideoEntity>> {
  final VideoPlayerRepository _repository;

  GetDefaultVideoUseCase(this._repository);
  @override
  VideoEntity call(List<VideoEntity> params) {
    return _repository.getVideo(params);
  }
}
