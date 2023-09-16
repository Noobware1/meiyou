import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_default_subtitle_usecase.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter/material.dart';

void initialise(BuildContext context, Player player, VideoController controller,
    [Duration? startVideoForm]) {
  player.open(Media(BlocProvider.of<SelectedServerCubit>(context).video.url,
      httpHeaders: BlocProvider.of<SelectedServerCubit>(context)
          .state
          .videoContainerEntity
          .headers));
  final sub = RepositoryProvider.of<VideoPlayerUseCaseContainer>(context)
      .get<GetDefaultSubtitleUseCase>()
      .call(BlocProvider.of<SelectedServerCubit>(context)
          .state
          .videoContainerEntity
          .subtitles);

  player.stream.duration.first.then((value) {
    player.setVideoTrack(player.state.tracks.video
        .sublist(2)
        .reduce((high, low) => (high.w ?? 0) > (low.w ?? 0) ? high : low));

    if (sub != null) {
      player.setSubtitleTrack(SubtitleTrack.uri(sub.url, language: sub.lang));
    } else {
      player.setSubtitleTrack(SubtitleTrack.no());
    }
    if (startVideoForm != null) {
      player.seek(startVideoForm);
    }
  });
}
