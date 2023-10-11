import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_default_subtitle_usecase.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/is_ready.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/presentation/player/video_controls/subtitle_woker_bloc/subtitle_worker_bloc.dart';

void initialise(BuildContext context, Player player, VideoController controller,
    IsPlayerReady isPlayerReady, SubtitleWorkerBloc subtitleWorkerBloc,
    [Duration? startVideoForm]) {
  player.open(
      Media(BlocProvider.of<SelectedServerCubit>(context).video.url,
          httpHeaders: BlocProvider.of<SelectedServerCubit>(context)
              .state
              .videoContainerEntity
              .headers),
      play: false);
  player.pause();
  // player.setSubtitleTrack(SubtitleTrack.no());

  isPlayerReady.fromController(controller).then((value) {
    if (player.state.tracks.video.isNotEmpty &&
        player.state.tracks.video.length > 2) {
      player.setVideoTrack(player.state.tracks.video
          .sublist(2)
          .reduce((high, low) => (high.w ?? 0) > (low.w ?? 0) ? high : low));
    }

    final sub = RepositoryProvider.of<VideoPlayerUseCaseContainer>(context)
        .get<GetDefaultSubtitleUseCase>()
        .call(BlocProvider.of<SelectedServerCubit>(context)
            .state
            .videoContainerEntity
            .subtitles);

    if (sub != null) {
      subtitleWorkerBloc.add(ChangeSubtitle(subtitle: sub));
      //.setSubtitleTrack(S(sub.url, language: sub.lang));
    } else {
      subtitleWorkerBloc
          .add(const ChangeSubtitle(subtitle: SubtitleEntity.noSubtitle));
    }
  });

  _startFrom(startVideoForm, player);
}

Future<void> _startFrom(Duration? duration, Player player) async {
  if (duration != null) {
    await player.stream.duration.first;
    player.seek(duration);
    player.play();
  } else {
    player.play();
  }
}
