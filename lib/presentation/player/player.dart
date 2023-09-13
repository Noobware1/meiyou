import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_episode_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_default_subtitle_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_default_video_usecase.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';

import 'package:meiyou/presentation/player/button.dart';
import 'package:meiyou/presentation/player/change_episodes.dart';
import 'package:meiyou/presentation/player/initialise_player.dart';
import 'package:meiyou/presentation/player/progress_bar.dart';
import 'package:meiyou/presentation/player/video_controls/change_episode.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/buffering_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/is_ready.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/progress_bar_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/resize_mode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/video_track_cubit.dart';

import 'package:meiyou/presentation/player/video_controls/key_board_shortcuts.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/playing_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/play_button.dart';
import 'package:meiyou/presentation/player/video_controls/seek_animation.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/player/video_controls/video_controls_theme.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/episode_selector/episode_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/state/movie_view/state/bloc/fetch_movie_bloc.dart';

class MeiyouPlayer extends StatefulWidget {
  // final SelectedServerCubit selectedServerCubit;
  const MeiyouPlayer({
    Key? key,
    // required this.selectedServerCubit,
  }) : super(key: key);
  @override
  State<MeiyouPlayer> createState() => MeiyouPlayerState();
}

class MeiyouPlayerState extends State<MeiyouPlayer>
    with TickerProviderStateMixin {
  late final AnimationController forwardAnimation;
  late final AnimationController rewindAnimation;
  late final ResizeModeCubit resizeModeCubit;
  late final player = Player();
  late final videoController = VideoController(player);

  ///roller = VideoController(player);
  // late final PlayerCubit playerCubit;
  late final IsPlayerReady isPlayerReady;
  late final ProgressBarCubit progressBarCubit;
  late final VideoPlayerControlsTheme theme;
  // late final CurrentSubtitleCubit currentSubtitleCubit;

  @override
  void initState() {
    super.initState();
    forwardAnimation = AnimationController(vsync: this);
    rewindAnimation = AnimationController(vsync: this);

    if (Platform.isAndroid || Platform.isIOS) {
      setLanscape();
    }

    // playerCubit = PlayerCubit(Player());

    theme = VideoPlayerControlsTheme();

    resizeModeCubit = ResizeModeCubit();

    isPlayerReady = IsPlayerReady(videoController);

    initialise(context, player, videoController);

    progressBarCubit = ProgressBarCubit(
        player.stream.position, player.stream.duration, player.stream.buffer);

    // listen() {
    //   BlocProvider.of<SeasonsSelectorBloc>(context).stream.listen((event) {
    //     print('current season: ${event.season}');
    //   });
    //   BlocProvider.of<CurrentEpisodeCubit>(context).stream.listen((event) {
    //     print('current episode: $event');
    //   });
    //   BlocProvider.of<SelectedServerCubit>(context).stream.listen((event) {
    //     print('current servers: ${event.server}, ${event.selectedVideoIndex}');
    //   });
    // }

    // listen();
  }

  @override
  void dispose() {
    if (Platform.isAndroid || Platform.isIOS) {
      changeBackOrientation();
    }

    player.dispose();
    forwardAnimation.dispose();
    resizeModeCubit.close();
    // rewindAnimation.dispose();
    isPlayerReady.close();
    super.dispose();
  }

  Future setLanscape() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // systemNavigationBarColor: Colors.transparent,
    ));
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future changeBackOrientation() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade900,
        systemNavigationBarColor: Colors.grey.shade900));

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);
  }

  get _blocProviders => [
        BlocProvider(
          create: (context) => PlayingCubit(player.stream.playing),
        ),
        BlocProvider.value(value: resizeModeCubit),
        BlocProvider.value(value: progressBarCubit),
        // BlocProvider.value(value: playerCubit),
        BlocProvider(
          create: (context) => BufferingCubit(player.stream.buffering),
        ),
        BlocProvider(create: (context) => TracksCubit(player.stream.tracks))
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
                        child:
                            // BlocBuilder<PlayerCubit, PlayerCubitState>(
                            //     bloc: playerCubit,
                            //     builder: (context, state) {
                            //       return
                            Video(
                          controller: videoController,
                          controls: (_) => const SizedBox.shrink(),
                        )
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
                      Positioned(
                          top: 10,
                          left: 20,
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.pop(context);
                                    },
                                    child: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 25),
                                  ),
                                ),
                                addHorizontalSpace(10),
                                const Flexible(
                                    fit: FlexFit.loose,
                                    child: BuildVideoTitle())
                              ],
                            ),
                          )),
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BlocBuilder<SelectedServerCubit, SelectedServer>(
                                builder: (context, state) {
                              return Text(
                                state.server,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              );
                            }),
                            addVerticalSpace(3),
                            BlocBuilder<SourceDropDownBloc,
                                SourceDropDownState>(builder: (context, state) {
                              return Text(
                                state.provider.name,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              );
                            }),
                            addVerticalSpace(3),
                            StreamBuilder<Track>(
                                stream: player.stream.track,
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data?.video.h ?? 0} x ${snapshot.data?.video.w ?? 0}',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  );
                                }),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (TapDownDetails tapDownDetails) {},
                        child: const Stack(
                          children: [
                            BuildPlayAndRewindForwardButtons(),
                            BuildProgressBar(),
                            Positioned(
                                bottom: 20,
                                right: 0,
                                left: 0,
                                child: VideoPlayerButtons())
                          ],
                        ),
                      ),
                      BlocBuilder<BufferingCubit, bool>(
                          builder: (context, buffering) {
                        if (!buffering) {
                          return const SizedBox.shrink();
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.progressBarTheme.progressColor,
                          ),
                        );
                      }),
                      _rewindButton(height, width),
                      _forWardButton(height, width),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _forWardButton(double height, double width) {
    return Positioned(
      // top: 30,
      top: theme.rewindForwardPadding.top,
      right: 0,
      bottom: theme.rewindForwardPadding.bottom,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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

  Widget _rewindButton(double height, double width) {
    return Positioned(
      top: theme.rewindForwardPadding.top,
      left: 0,
      bottom: theme.rewindForwardPadding.bottom,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () => _seekOnDoubleTap(false),
        child: Container(
          // color: Colors.black,
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
    if (isPlayerReady.state == false) {
      return;
    }
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

class BuildVideoTitle extends StatelessWidget {
  const BuildVideoTitle({super.key});

  static const _style =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

  static const _searchResponseStyle =
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocProvider.of<SelectedSearchResponseBloc>(context)
                    .state
                    .searchResponse
                    .type ==
                MediaType.movie
            ? BlocBuilder<FetchMovieBloc, FetchMovieState>(
                builder: (context, state) {
                return DefaultTextStyle(
                    style: _style,
                    child: Text(state.movie!.title ?? 'No Title'));
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
                            '${seasonsState.season == 0 ? '' : "S${seasonsState.season}:"}E${episodesState.episodes[state].number}-${episodesState.episodes[state].title}'),
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
            Align(
              alignment: Alignment.centerLeft,
              child: ChangeEpisode(
                  icon: ChangeEpisodeIcon.previous,
                  onTap: () {
                    changeEpisode(context, false);
                  }),
            ),
            Center(
              child: BlocBuilder<BufferingCubit, bool>(
                  builder: (context, buffering) {
                if (buffering) {
                  return SizedBox(
                    height: theme(context).playButtonSize,
                    width: theme(context).playButtonSize,
                  );
                }

                return const BuildPlayButton();
              }),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ChangeEpisode(
                  icon: ChangeEpisodeIcon.next,
                  onTap: () {
                    changeEpisode(context, true);
                  }),
            ),
          ].map((e) => Expanded(child: e)).toList(),
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
              thumbColor: Colors.pinkAccent,
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
