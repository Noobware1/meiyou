import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class GetDefaultSubtitleUseCase
    implements UseCase<SubtitleEntity?, List<SubtitleEntity>?> {
  final VideoPlayerRepository _repository;

  GetDefaultSubtitleUseCase(this._repository);

  @override
  SubtitleEntity? call(List<SubtitleEntity>? params) {
    return _repository.getSubtitle(params);
  }
}
