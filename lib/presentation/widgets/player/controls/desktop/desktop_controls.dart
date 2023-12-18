import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/current_episode_cubit.dart';
import 'package:meiyou/presentation/blocs/player/full_screen_cubit.dart';
import 'package:meiyou/presentation/blocs/player/progress_bar_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/show_controls_cubit.dart';
import 'package:meiyou/presentation/blocs/player/video_track_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/constants.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/episodes_selector.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/next_episode.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/options.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/previous_episode_button.dart';
import 'package:meiyou_extensions_lib/models.dart' as models;
import 'play_button.dart' as play_button;
import 'postion_indicator.dart' as postion_indicator;
import 'full_screen_button.dart' as full_screen_button;
import 'volume_button.dart' as volume_button;

class DesktopControls extends StatelessWidget {
  const DesktopControls({super.key});

  // void onHover() {
  //   setState(() {
  //     mount = true;
  //     visible = true;
  //   });
  //   shiftSubtitle();
  //   _timer?.cancel();
  //   _timer = Timer(_theme(context).controlsHoverDuration, () {
  //     if (mounted) {
  //       setState(() {
  //         visible = false;
  //       });
  //       unshiftSubtitle();
  //     }
  //   });
  // }

  // void onEnter() {
  //   setState(() {
  //     mount = true;
  //     visible = true;
  //   });
  //   shiftSubtitle();
  //   _timer?.cancel();
  //   _timer = Timer(_theme(context).controlsHoverDuration, () {
  //     if (mounted) {
  //       setState(() {
  //         visible = false;
  //       });
  //       unshiftSubtitle();
  //     }
  //   });
  // }

  // void onExit() {
  //   setState(() {
  //     visible = false;
  //   });
  //   unshiftSubtitle();
  //   _timer?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    DateTime last = DateTime.now();
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: const Color(0x00000000),
        hoverColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        highlightColor: const Color(0x00000000),
      ),
      child: CallbackShortcuts(
        bindings: {
          // Default key-board shortcuts.
          // https://support.google.com/youtube/answer/7631406
          const SingleActivator(LogicalKeyboardKey.mediaPlay): () =>
              playerProvider(context).player.play(),
          const SingleActivator(LogicalKeyboardKey.mediaPause): () =>
              playerProvider(context).player.pause(),
          const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () =>
              playerProvider(context).player.playOrPause(),
          const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () =>
              playerProvider(context).player.next(),
          const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious): () =>
              playerProvider(context).player.previous(),
          const SingleActivator(LogicalKeyboardKey.space): () =>
              playerProvider(context).player.playOrPause(),
          const SingleActivator(LogicalKeyboardKey.keyJ): () {
            final rate = playerProvider(context).player.state.position -
                const Duration(seconds: 10);
            playerProvider(context).player.seek(rate);
          },
          const SingleActivator(LogicalKeyboardKey.keyI): () {
            final rate = playerProvider(context).player.state.position +
                const Duration(seconds: 10);
            playerProvider(context).player.seek(rate);
          },
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
            final rate = playerProvider(context).player.state.position -
                const Duration(seconds: 2);
            playerProvider(context).player.seek(rate);
          },
          const SingleActivator(LogicalKeyboardKey.arrowRight): () {
            final rate = playerProvider(context).player.state.position +
                const Duration(seconds: 2);
            playerProvider(context).player.seek(rate);
          },
          const SingleActivator(LogicalKeyboardKey.arrowUp): () {
            final volume = playerProvider(context).player.state.volume + 5.0;
            playerProvider(context).player.setVolume(volume.clamp(0.0, 100.0));
          },
          const SingleActivator(LogicalKeyboardKey.arrowDown): () {
            final volume = playerProvider(context).player.state.volume - 5.0;
            playerProvider(context).player.setVolume(volume.clamp(0.0, 100.0));
          },
          const SingleActivator(LogicalKeyboardKey.keyF): () =>
              context.bloc<FullScreenCubit>().toggleFullScreen(),
          const SingleActivator(LogicalKeyboardKey.escape): () =>
              context.bloc<FullScreenCubit>().exitFullScreen(),
        },
        child: Focus(
          autofocus: true,
          child: Material(
            elevation: 0.0,
            borderOnForeground: false,
            animationDuration: Duration.zero,
            color: const Color(0x00000000),
            shadowColor: const Color(0x00000000),
            surfaceTintColor: const Color(0x00000000),
            child: Listener(
              onPointerSignal: (e) {
                if (e is PointerScrollEvent) {
                  if (e.delta.dy > 0) {
                    final volume =
                        playerProvider(context).player.state.volume - 5.0;
                    playerProvider(context)
                        .player
                        .setVolume(volume.clamp(0.0, 100.0));
                  }
                  if (e.delta.dy < 0) {
                    final volume =
                        playerProvider(context).player.state.volume + 5.0;
                    playerProvider(context)
                        .player
                        .setVolume(volume.clamp(0.0, 100.0));
                  }
                }
              },
              child: MouseRegion(
                // onHover: (_) => onHover(),
                // onEnter: (_) => onEnter(),
                // onExit: (_) => onExit(),
                child: Stack(
                  children: [
                    BlocBuilder<ShowVideoControlsCubit, bool>(
                      builder: (context, visible) {
                        return AnimatedOpacity(
                          curve: Curves.easeInOut,
                          opacity: visible ? 1.0 : 0.0,
                          duration: controlsTransitionDuration,
                          onEnd: () {
                            if (!visible) {
                              context
                                  .bloc<ShowVideoControlsCubit>()
                                  .hideControls();
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Top gradient.
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      0.0,
                                      0.2,
                                    ],
                                    colors: [
                                      Color(0x61000000),
                                      Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),
                              // Bottom gradient.
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      0.5,
                                      1.0,
                                    ],
                                    colors: [
                                      Color(0x00000000),
                                      Color(0x61000000),
                                    ],
                                  ),
                                ),
                              ),
                              if (visible)
                                Padding(
                                  padding: (
                                      // Add padding in fullscreen!
                                      isFullscreen(context)
                                          ? MediaQuery.of(context).padding
                                          : EdgeInsets.zero),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: buttonBarHeight,
                                        margin: topButtonBarMargin,
                                        child: const Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [] // _theme(context).topButtonBar,
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 35, right: 35),
                                        child: BlocBuilder<ProgressBarCubit,
                                                ProgressBarState>(
                                            builder: (context, state) {
                                          return ProgressBar(
                                            barHeight: 2.5,
                                            thumbGlowColor: Colors.transparent,
                                            timeLabelLocation:
                                                TimeLabelLocation.none,
                                            progress: state.current,
                                            buffered: state.buffered,
                                            total: state.total,
                                            onSeek: (duration) {
                                              playerProvider(context)
                                                  .player
                                                  .seek(duration);
                                            },
                                          );
                                        }),
                                      ),
                                      Container(
                                        height: buttonBarHeight,
                                        margin: bottomButtonBarMargin,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const MaterialDesktopPrevEpisodeButton(
                                                iconSize: 30),
                                            const play_button
                                                .MaterialDesktopPlayOrPauseButton(
                                                iconSize: 30),
                                            const MaterialDesktopNextEpisodeButton(
                                                iconSize: 30),
                                            const volume_button
                                                .MaterialDesktopVolumeButton(),
                                            const postion_indicator
                                                .MaterialDesktopPositionIndicator(),
                                            const Spacer(),
                                            if (context
                                                .repository<
                                                    models.MediaDetails>()
                                                .mediaItem is! models.Movie)
                                              const EpisodeSelectorButton(),
                                            const MaterialDesktopOptionsButton(),
                                            const full_screen_button
                                                .MaterialDesktopFullscreenButton(
                                                iconSize: 30),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Buffering Indicator.

                    _buildHeader(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
        top: 0,
        left: 20,
        right: 20,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              tooltip: 'Back',
              onPressed: () {
                if (isFullscreen(context)) {
                  exitFullscreen(context);
                }
                context.pop();
              },
            ),
            addHorizontalSpace(20),
            Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTitle(context))),
            addHorizontalSpace(20),
            Align(
                alignment: Alignment.centerRight,
                child: _buildVideoData(context)),
          ],
        ));
  }

  Widget _buildVideoData(BuildContext context) {
    return BlocBuilder<SelectedVideoDataCubit, SelectedVideoDataState>(
      builder: (context, selected) {
        if (selected is SelectedVideoDataStateInital) {
          return defaultSizedBox;
        }
        return BlocBuilder<ExtractedMediaCubit<models.Video>,
            ExtractedMediaState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              addVerticalSpace(30),
              Text(
                state.data[selected.serverIndex].link.name,
                style: const TextStyle(
                    fontSize: 15.5, fontWeight: FontWeight.w500),
              ),
              addVerticalSpace(5),
              Text(context.bloc<PluginSelectorCubit>().state.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 15.5)),
              addVerticalSpace(5),
              BlocBuilder<VideoTrackCubit, VideoTrack>(
                  builder: (context, track) {
                return Text(
                  track == VideoTrack.auto()
                      ? 'Auto'
                      : '${track.w} x ${track.h}',
                  style: const TextStyle(
                      fontSize: 15.5, fontWeight: FontWeight.w500),
                );
              }),
            ],
          );
        });
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return BlocBuilder<CurrentEpisodeCubit, int>(
      builder: (context, state) {
        final videoTitle = context
            .repository<VideoPlayerRepositoryUseCases>()
            .getVideoTitleUseCase(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(10),
            if (videoTitle != null)
              Text(
                videoTitle.trim(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            Text(context.repository<models.MediaDetails>().name.trim(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ],
        );
      },
    );
  }
}
