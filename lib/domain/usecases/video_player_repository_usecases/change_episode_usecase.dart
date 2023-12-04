import 'package:flutter/material.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class ChangeEpisodeUseCaseParams {
  final BuildContext context;
  final EpisodeEntity episode;
  final int index;
  ChangeEpisodeUseCaseParams({
    required this.context,
    required this.episode,
    required this.index,
  });
}

class ChangeEpisodeUseCase
    implements UseCase<void, ChangeEpisodeUseCaseParams> {
  final VideoPlayerRepository _videoPlayerRepository;

  ChangeEpisodeUseCase(this._videoPlayerRepository);

  @override
  void call(ChangeEpisodeUseCaseParams params) {
    _videoPlayerRepository.changeEpisode(
      context: params.context,
      episode: params.episode,
      index: params.index,
    );
  }
}
