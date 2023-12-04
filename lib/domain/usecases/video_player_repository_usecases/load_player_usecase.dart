import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class LoadPlayerUseCaseParams {
  final BuildContext context;
  final Player player;
  final VideoController videoController;
  final Duration? startPostion;
  final void Function()? onDoneCallback;

  LoadPlayerUseCaseParams(
      {required this.context,
      required this.player,
      required this.videoController,
      this.startPostion,
      this.onDoneCallback});
}

class LoadPlayerUseCase implements UseCase<void, LoadPlayerUseCaseParams> {
  final VideoPlayerRepository _videoPlayerRepository;

  LoadPlayerUseCase(this._videoPlayerRepository);

  @override
  void call(LoadPlayerUseCaseParams params) {
    _videoPlayerRepository.loadPlayer(
        context: params.context,
        player: params.player,
        videoController: params.videoController,
        startPostion: params.startPostion,
        onDoneCallback: params.onDoneCallback);
  }
}
