import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
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

  controller.waitUntilFirstFrameRendered.then((_) {
    player.setVideoTrack(player.state.tracks.video
        .sublist(2)
        .reduce((high, low) => (high.h ?? 0) > (low.h ?? 0) ? high : low));

    BlocProvider.of<SelectedServerCubit>(context)
        .state
        .videoContainerEntity
        .subtitles
        ?.forEach((it) {
      player.state.tracks.subtitle.add(SubtitleTrack.uri(
        it.url,
        language: it.lang,
      ));
    });
  });

  if (startVideoForm != null) {
    player.stream.duration.first.then((value) => player.seek(startVideoForm));
  }
}

void reinitialise(
    BuildContext context, Player player, VideoController controller,
    {required Duration start}) {
  initialise(context, player, controller, start);
}
