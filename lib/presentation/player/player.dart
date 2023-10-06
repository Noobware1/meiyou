import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_subtitle_cue.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/player/button.dart';
import 'package:meiyou/presentation/player/change_episodes.dart';
import 'package:meiyou/presentation/player/initialise_player.dart';
import 'package:meiyou/presentation/player/progress_bar.dart';
import 'package:meiyou/presentation/player/subtitle_config.dart';
import 'package:meiyou/presentation/player/subtitle_renderer.dart';
import 'package:meiyou/presentation/player/video_controls/change_episode.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/buffering_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/is_ready.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/progress_bar_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/resize_mode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/show_controls_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/subtitle_worker_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/key_board_shortcuts.dart';
import 'package:meiyou/presentation/player/video_controls/play_button.dart';
import 'package:meiyou/presentation/player/video_controls/seek_animation.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/player/video_controls/subtitle_woker_bloc/subtitle_worker_bloc.dart';
import 'package:meiyou/presentation/player/video_controls/video_controls_theme.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/episode_selector/episode_selector/episode_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_movie_bloc/fetch_movie_bloc.dart';

class MeiyouPlayer extends StatefulWidget {
  const MeiyouPlayer({
    Key? key,
  }) : super(key: key);
  @override
  State<MeiyouPlayer> createState() => MeiyouPlayerState();
}

class MeiyouPlayerState extends State<MeiyouPlayer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController forwardAnimation;
  late final AnimationController rewindAnimation;
  late final Player player;
  late final videoController = VideoController(player);

  late final ShowVideoControlsCubit showVideoControlsCubit;
  late final IsPlayerReady isPlayerReady;
  late final ResizeModeCubit resizeModeCubit;
  late final ProgressBarCubit progressBarCubit;
  late final VideoPlayerControlsTheme theme = VideoPlayerControlsTheme(
      progressBarTheme:
          ProgressBarTheme(progressColor: context.theme.colorScheme.primary));
  late final SubtitleWorkerBloc subtitleWorkerBloc;
  late final SubtitleWorkerCubit subtitleWorkerCubit;
  late final BufferingCubit bufferingCubit;

  @override
  void initState() {
    super.initState();
    forwardAnimation = AnimationController(vsync: this);
    rewindAnimation = AnimationController(vsync: this);
    WidgetsBinding.instance.addObserver(this);

    player = Player(
        configuration: const PlayerConfiguration(bufferSize: 30 * 1024 * 1024));

    if (Platform.isAndroid || Platform.isIOS) {
      setLanscape();
    } else {
      // toggleFullscreen(context);
    }

    isPlayerReady = IsPlayerReady();
    
    resizeModeCubit = ResizeModeCubit(isPlayerReady);

    bufferingCubit = BufferingCubit(player.stream.buffering);

    subtitleWorkerBloc = SubtitleWorkerBloc(
        RepositoryProvider.of<VideoPlayerUseCaseContainer>(context)
            .get<GetSubtitleCueUseCase>(),
        bufferingCubit,
        player);

    subtitleWorkerCubit =
        SubtitleWorkerCubit(subtitleWorkerBloc.stream.asyncMap((event) {
      if (event is SubtitleDecoded) {
        return event.subtitleCues;
      }
      return null;
    }), player.stream.position);

    showVideoControlsCubit = ShowVideoControlsCubit();

    progressBarCubit = ProgressBarCubit(
        player.stream.position, player.stream.duration, player.stream.buffer);

    initialise(
        context, player, videoController, isPlayerReady, subtitleWorkerBloc);
  }

  bool? playingState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      playingState = player.state.playing;
      player.pause();
    } else if (state == AppLifecycleState.resumed) {
      playingState == false ? player.pause() : player.play();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // errorStream.cancel();
    playingState = null;
    forwardAnimation.dispose();
    rewindAnimation.dispose();
    resizeModeCubit.close();
    isPlayerReady.close();
    bufferingCubit.close();
    subtitleWorkerBloc.close();
    subtitleWorkerCubit.close();
    progressBarCubit.close();
    showVideoControlsCubit.close();
    player.dispose();

    if (Platform.isAndroid || Platform.isIOS) {
      changeBackOrientation();
    }
    super.dispose();
  }

  Future setLanscape() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future changeBackOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);
  }

  get _blocProviders => [
        BlocProvider.value(
          value: showVideoControlsCubit,
        ),
        // BlocProvider(
        //   create: (context) => PlayingCubit(player.stream.playing),
        // ),
        BlocProvider.value(value: isPlayerReady),

        BlocProvider.value(value: bufferingCubit),
        BlocProvider.value(value: resizeModeCubit),
        BlocProvider.value(value: progressBarCubit),
        BlocProvider.value(value: subtitleWorkerBloc),
        BlocProvider.value(value: subtitleWorkerCubit),
        // BlocPsrovider(create: (context) => TracksCubit(player.stream.tracks)),
      ];

  get _repoProviders => [
        RepositoryProvider.value(value: theme),
        RepositoryProvider.value(
          value: player,
        ),
        RepositoryProvider(
            create: (context) => CacheRepositoryUseCaseContainer(
                RepositoryProvider.of<CacheRespository>(context))),
        RepositoryProvider.value(value: videoController)
      ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: BlocBuilder<ResizeModeCubit, ResizeMode>(
                bloc: resizeModeCubit,
                builder: (context, mode) {
                  return FittedBox(
                    fit: resize(mode),
                    child: SizedBox(
                        height: videoController.rect.value?.height ?? height,
                        width: videoController.rect.value?.width ?? width,
                        child: Video(
                            controller: videoController,
                            controls: (state) {
                              return defaultSizedBox;
                            },
                            subtitleViewConfiguration:
                                const SubtitleViewConfiguration(visible: false))
                        // })
                        ),
                  );
                }),
          ),
          Positioned.fill(
              child: MultiBlocProvider(
            providers: _blocProviders,
            child: MultiRepositoryProvider(
              providers: _repoProviders,
              child: AddKeyBoardShortcuts(
                forwardAnimationController: forwardAnimation,
                rewindAnimationController: rewindAnimation,
                child: Focus(
                  autofocus: true,
                  child: Stack(
                    children: [
                      SubtitleRenderer(
                          subtitleConfigruation: isMobile
                              ? const SubtitleConfigruation()
                              : const SubtitleConfigruation().copyWith(
                                  textStyle: forDesktop)), // SubtitleView(

                      BlocBuilder<ShowVideoControlsCubit, bool>(
                          bloc: showVideoControlsCubit,
                          builder: (context, visible) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (visible) {
                                  showVideoControlsCubit.hideControls();
                                } else {
                                  showVideoControlsCubit.showControls();
                                }
                              },
                              child: IgnorePointer(
                                ignoring: !visible,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: visible ? 1.0 : 0.0,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      const BuildPlayAndRewindForwardButtons(),
                                      const BuildProgressBar(),
                                      const Positioned(
                                          bottom: 20,
                                          right: 0,
                                          left: 0,
                                          child: VideoPlayerButtons())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      BlocBuilder<ShowVideoControlsCubit, bool>(
                          builder: (context, visible) {
                        return IgnorePointer(
                          ignoring: !visible,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: visible ? 1.0 : 0.0,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 100),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
                                child: Row(children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.arrow_back_ios_new_rounded,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        addHorizontalSpace(10),
                                        const Flexible(
                                            fit: FlexFit.loose,
                                            child: BuildVideoTitle()),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          BlocBuilder<SelectedServerCubit,
                                                  SelectedServer>(
                                              builder: (context, state) {
                                            return Text(
                                              state.server,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          }),
                                          addVerticalSpace(3),
                                          BlocBuilder<SourceDropDownBloc,
                                                  SourceDropDownState>(
                                              builder: (context, state) {
                                            return Text(
                                              state.provider.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800),
                                            );
                                          }),
                                          addVerticalSpace(3),
                                          const ShowCurrentVideoQuailty()
                                          // BlocBuilder<VideoTrackCubit, VideoTrack>(
                                          //     builder: (context, state) {
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        );
                      }),
                      BlocListener<SubtitleWorkerBloc, SubtitleWorkerState>(
                        listener: (context, state) {
                          if (state is SubtitleDecodingFailed) {
                            showSnackBAr(context, text: state.error.toString());
                          }
                        },
                        child: defaultSizedBox,
                      ),
                      BlocBuilder<IsPlayerReady, bool>(
                        builder: (context, ready) {
                          if (!ready) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: theme.progressBarTheme.progressColor,
                              ),
                            );
                          }

                          return BlocBuilder<BufferingCubit, bool>(
                              builder: (context, buffering) {
                            if (!buffering) {
                              return const SizedBox.shrink();
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: theme.progressBarTheme.progressColor,
                              ),
                            );
                          });
                        },
                      ),
                      _rewindButton(context, height, width),
                      _forWardButton(context, height, width),
                    ],
                  )
                  // .animate()
                  // .fade(

                  //   duration: Duration(seconds: 3),
                  // )
                  // .hide(
                  //     duration: const Duration(seconds: 1),
                  //     maintain: true),
                  ,
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _forWardButton(BuildContext context, double height, double width) {
    return Positioned(
      // top: 30,
      top: theme.rewindForwardPadding.top,
      right: 0,
      bottom: theme.rewindForwardPadding.bottom,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (showVideoControlsCubit.state == true) {
            showVideoControlsCubit.hideControls();
          } else {
            showVideoControlsCubit.showControls();
          }
        },
        onDoubleTap: () => _seekOnDoubleTap(true),
        child: Container(
          // color: Colors.black,
          height: height,
          width: width / 3,
          alignment: Alignment.centerLeft,
          child: SeeekAnimation(forward: true, controller: forwardAnimation),
          // color: Colors.red,
        ),
      ),
    );
  }

  Widget _rewindButton(BuildContext context, double height, double width) {
    return Positioned(
      top: theme.rewindForwardPadding.top,
      left: 0,
      bottom: theme.rewindForwardPadding.bottom,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (showVideoControlsCubit.state == true) {
            showVideoControlsCubit.hideControls();
          } else {
            showVideoControlsCubit.showControls();
          }
        },
        onDoubleTap: () => _seekOnDoubleTap(false),
        child: Container(
          height: height,
          alignment: Alignment.centerRight,
          width: width / 3,
          // color: Colors.red,
          child: SeeekAnimation(controller: rewindAnimation, forward: false),
        ),
      ),
    );
  }

  void _seekOnDoubleTap(bool forward) {
    const Duration duration = Duration(seconds: 10);
    final Duration seek;

    final currPostion = player.state.position;
    if (forward) {
      seek = currPostion + duration;
      startAnimation(forwardAnimation);
    } else {
      seek = currPostion - duration;
      startAnimation(rewindAnimation);
    }

    player.seek(seek);
  }
}

class ShowCurrentVideoQuailty extends StatelessWidget {
  const ShowCurrentVideoQuailty({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VideoTrack>(
        initialData: VideoTrack.no(),
        stream: player(context).stream.tracks.asyncMap((event) =>
            event.video.tryfirstWhere(
                (video) => video == player(context).state.track.video) ??
            VideoTrack.no()),
        builder: (context, snapshot) {
          return Text(
            snapshot.data == VideoTrack.auto()
                ? 'Auto'
                : '${snapshot.data?.w ?? 0} x ${snapshot.data?.h ?? 0}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
          );
        });
  }
}

class BuildVideoTitle extends StatelessWidget {
  const BuildVideoTitle({super.key});

  static const _style =
      TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600);

  static const _searchResponseStyle =
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addVerticalSpace(5),
        BlocProvider.of<SelectedSearchResponseBloc>(context)
                    .state
                    .searchResponse
                    .type ==
                MediaType.movie
            ? BlocBuilder<FetchMovieBloc, FetchMovieState>(
                builder: (context, state) {
                return DefaultTextStyle(
                    style: _style,
                    child: Text(
                      state.movie!.title ?? 'No Title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ));
              })
            : BlocBuilder<SeasonsSelectorBloc, SeasonsSelectorState>(
                builder: (context, seasonsState) {
                  return BlocBuilder<EpisodeSelectorBloc, EpisodeSelectorState>(
                      builder: (context, episodesState) {
                    return BlocBuilder<CurrentEpisodeCubit, int>(
                        builder: (context, state) {
                      return DefaultTextStyle(
                        style: _style,
                        child: Text(
                            '${seasonsState.season == 0 ? '' : "S${seasonsState.season}:"}E${episodesState.episodes[state].number}-${episodesState.episodes[state].title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      );
                    });
                  });
                },
              ),
        addVerticalSpace(5),
        BlocBuilder<SelectedSearchResponseBloc, SelectedSearchResponseState>(
            builder: (context, state) {
          return DefaultTextStyle(
              style: _searchResponseStyle,
              child: Text(state.searchResponse.title));
        })
      ],
    );
  }
}

class BuildPlayAndRewindForwardButtons extends StatelessWidget {
  const BuildPlayAndRewindForwardButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: width / 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ChangeEpisode(
                    icon: ChangeEpisodeIcon.previous,
                    onTap: () {
                      changeEpisode(
                          context,
                          false,
                          (child) => playerDependenciesInjector(context,
                              child: child));
                    }),
              ),
            ),
            Expanded(
              child: Center(
                child: BlocBuilder<IsPlayerReady, bool>(
                  builder: (context, ready) {
                    return BlocBuilder<BufferingCubit, bool>(
                        builder: (context, buffering) {
                      final size = theme(context).playButtonSize;
                      if (!ready || buffering) {
                        return SizedBox(
                          height: size,
                          width: size,
                        );
                      }

                      return const BuildPlayButton();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: ChangeEpisode(
                    icon: ChangeEpisodeIcon.next,
                    onTap: () {
                      changeEpisode(
                          context,
                          true,
                          (child) => playerDependenciesInjector(context,
                              child: child));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildProgressBar extends StatelessWidget {
  const BuildProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: theme(context).progressBarTheme.padding,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: BlocBuilder<ProgressBarCubit, ProgressBarState>(
              builder: (context, state) {
            return ProgressBar(
              progress: state.postion,
              total: state.totalDuration,
              barHeight: theme(context).progressBarTheme.height,
              buffered: state.buffered,
              thumbColor: theme(context).progressBarTheme.progressColor,
              progressBarColor: theme(context).progressBarTheme.progressColor,
              bufferedBarColor: theme(context).progressBarTheme.bufferedColor,
              //  timeLabelType: Time,
              thumbRadius: theme(context).progressBarTheme.thumbSize,
              timeLabelLocation: TimeLabelLocation.sides,
              timeLabelTextStyle: const TextStyle(color: Colors.white),
              timeLabelType: TimeLabelType.totalTime,

              baseBarColor: theme(context).progressBarTheme.baseBarColor,
              thumbGlowColor: Colors.transparent,
              onSeek: (position) => player(context).seek(position),
            );
          })),
    );
  }
}
