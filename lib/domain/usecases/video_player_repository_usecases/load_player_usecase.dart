import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as vid;
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LoadPlayerUseCaseParams {
  final ExtractedMediaCubit<Video> extractedMediaCubit;
  final SelectedVideoDataCubit selectedVideoDataCubit;
  final PlayerProviders providers;
  final Player player;
  final vid.VideoController videoController;
  final Duration? startPostion;
  final void Function()? onDoneCallback;

  LoadPlayerUseCaseParams({
    required this.providers,
    required this.extractedMediaCubit,
    required this.selectedVideoDataCubit,
    required this.player,
    required this.videoController,
    this.startPostion,
    this.onDoneCallback,
  });
}

class LoadPlayerUseCase
    implements UseCase<StreamSubscription, LoadPlayerUseCaseParams> {
  final VideoPlayerRepository _videoPlayerRepository;

  LoadPlayerUseCase(this._videoPlayerRepository);

  @override
  StreamSubscription call(LoadPlayerUseCaseParams params) {
    return _videoPlayerRepository.loadPlayer(
        extractedMediaCubit: params.extractedMediaCubit,
        selectedVideoDataCubit: params.selectedVideoDataCubit,
        player: params.player,
        videoController: params.videoController,
        startPostion: params.startPostion,
        onDoneCallback: params.onDoneCallback,
        providers: params.providers);
  }
}
