import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/player/buffering_cubit.dart';
import 'package:meiyou/presentation/blocs/player/full_screen_cubit.dart';
import 'package:meiyou/presentation/blocs/player/playback_speed.dart';
import 'package:meiyou/presentation/blocs/player/playing_cubit.dart';
import 'package:meiyou/presentation/blocs/player/progress_bar_cubit.dart';
import 'package:meiyou/presentation/blocs/player/resize_cubit.dart';
import 'package:meiyou/presentation/blocs/player/show_controls_cubit.dart';
import 'package:meiyou/presentation/blocs/player/show_episode_selector_widget_cubit.dart';
import 'package:meiyou/presentation/blocs/player/video_track_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';

class PlayerProviders {
  final PlayerProvider playerProvider;
  final PlayingCubit playingCubit;
  final BufferingCubit bufferingCubit;
  final ProgressBarCubit progressBarCubit;
  final ShowVideoControlsCubit showVideoControlsCubit;
  final FullScreenCubit? fullScreenCubit;
  final VideoTrackCubit videoTrackCubit;
  final PlaybackSpeedCubit playbackSpeedCubit;
  final ResizeCubit? resizeCubit;

  PlayerProviders(
      {required this.playerProvider,
      required this.playingCubit,
      required this.bufferingCubit,
      required this.progressBarCubit,
      required this.showVideoControlsCubit,
      required this.videoTrackCubit,
      required this.playbackSpeedCubit,
      this.fullScreenCubit,
      this.resizeCubit});

  factory PlayerProviders.fromContext(
      BuildContext context, Player player, VideoController videoController) {
    return PlayerProviders(
      playerProvider:
          PlayerProvider(player: player, controller: videoController),
      playingCubit: PlayingCubit(player.stream.playing),
      bufferingCubit: BufferingCubit(player.stream.buffering),
      progressBarCubit: ProgressBarCubit(player),
      showVideoControlsCubit: ShowVideoControlsCubit(),
      playbackSpeedCubit: PlaybackSpeedCubit(),
      videoTrackCubit: VideoTrackCubit(),
      fullScreenCubit:
          //  isMobile ? null :
          FullScreenCubit(),
      resizeCubit:
          //  !isMobile ? null :
          ResizeCubit(),
    );
  }

  Widget create(Widget child) {
    return RepositoryProvider.value(
        value: playerProvider,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: playingCubit),
            BlocProvider.value(value: bufferingCubit),
            BlocProvider.value(value: progressBarCubit),
            BlocProvider.value(value: showVideoControlsCubit),
            if (fullScreenCubit != null)
              BlocProvider.value(value: fullScreenCubit!),
            BlocProvider.value(value: videoTrackCubit),
            BlocProvider.value(value: playbackSpeedCubit),
            if (resizeCubit != null) BlocProvider.value(value: resizeCubit!),
          ],
          child: child,
        ));
  }

  static Widget wrap(BuildContext context, Widget child) {
    return RepositoryProvider.value(
        value: context.repository<PlayerProvider>(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.bloc<PlayingCubit>()),
            BlocProvider.value(value: context.bloc<BufferingCubit>()),
            BlocProvider.value(value: context.bloc<ProgressBarCubit>()),
            BlocProvider.value(value: context.bloc<ShowVideoControlsCubit>()),
            if (context.tryBloc<FullScreenCubit>() != null)
              BlocProvider.value(value: context.bloc<FullScreenCubit>()),
            BlocProvider.value(value: context.bloc<VideoTrackCubit>()),
            BlocProvider.value(value: context.bloc<PlaybackSpeedCubit>()),
            if (context.tryBloc<ResizeCubit>() != null)
              BlocProvider.value(value: context.bloc<ResizeCubit>()),
          ],
          child: child,
        ));
  }

  void dispose() {
    playerProvider.dispose();
    playingCubit.close();
    bufferingCubit.close();
    progressBarCubit.close();
    showVideoControlsCubit.close();
    fullScreenCubit?.close();
    videoTrackCubit.close();
    playbackSpeedCubit.close();
    resizeCubit?.close();
  }
}
