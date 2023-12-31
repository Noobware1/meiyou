import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart' as vid show Video;

class ChangeSourceUseCaseParams {
  final vid.Video video;
  final int selectedSource;
  final Player player;
  final Duration? startPostion;
  final SubtitleCubit subtitleCubit;
  ChangeSourceUseCaseParams({
    required this.video,
    required this.selectedSource,
    required this.player,
    required this.subtitleCubit,
    this.startPostion,
  });
}

class ChangeSourceUseCase
    implements UseCase<Future<void>, ChangeSourceUseCaseParams> {
  final VideoPlayerRepository _videoPlayerRepository;

  ChangeSourceUseCase(this._videoPlayerRepository);

  @override
  Future<void> call(ChangeSourceUseCaseParams params) {
    return _videoPlayerRepository.changeSource(
      video: params.video,
      selectedSource: params.selectedSource,
      player: params.player,
      startPostion: params.startPostion,
      subtitleCubit: params.subtitleCubit,
    );
  }
}
