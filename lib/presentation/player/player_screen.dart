import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:media_kit_video/media_kit_video_controls/media_kit_video_controls.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/adaptive.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/core/state_listenable_builder.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou/presentation/player/fast_forward_button.dart';
import 'package:meiyou/presentation/player/notifers/buffering_notifer.dart';
import 'package:meiyou/presentation/player/notifers/player_state_notifer.dart';
import 'package:meiyou/presentation/player/notifers/show_controls_cubit.dart';
import 'package:meiyou/presentation/player/episodes_button.dart';
import 'package:meiyou/presentation/player/lock_button.dart';
import 'package:meiyou/presentation/player/next_previous_button.dart';
import 'package:meiyou/presentation/player/play_pause_button.dart';
import 'package:meiyou/presentation/player/player_settings.dart';
import 'package:meiyou/presentation/player/player_title.dart';
import 'package:meiyou/presentation/player/resize_button.dart';
import 'package:meiyou/presentation/player/seek_bar.dart';
import 'package:meiyou/presentation/player/selected_video.dart';
import 'package:meiyou/presentation/player/subtitle_view.dart';
import 'package:meiyou/presentation/player/video_settings.dart';
import 'package:meiyou/presentation/player/skip_button.dart';
import 'package:meiyou/presentation/player/video_link.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart' hide PlayerState;
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';
import 'package:meiyou/presentation/common/notifers/link_and_data_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef VideoStateKey = GlobalKey<media_kit_video.VideoState>;

extension PlayerGetItExtensions on GetIt {
  PlayerStateNotifer get playerNotifer => get<PlayerStateNotifer>();

  PlayerRepository get playerRepository => get<PlayerRepository>();

  VideoStateKey get videoStateKey => get<VideoStateKey>();

  InfoPage get infoPage => get<InfoScreenNotifer>().state.value!;
}

extension on Content {
  bool get isEpisodic => isAnime || isSeries;
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final Player player;

  late final media_kit_video.VideoController videoController;

  late final PlayerStateNotifer playerNotifer;

  late final ShowPlayerControlsNotifer showPlayerControlsNotifer;

  late final VideoStateKey _key;

  final PlayerRepository playerRepository = getIt.get();

  void onError(Exception error) {
    if (mounted) {
      if (error is NoContentDataException) {
        context.pop();
      }
      logRat.log(LogPriority.error, error.toString());
    }
  }

  late final LinkAndVideoNotifer linkAndDataNotifer;

  late final BufferingNotifer bufferingNotifer;

  @override
  void initState() {
    super.initState();

    changeOrientation();

    _key = getIt.registerSingleton<VideoStateKey>(GlobalKey());

    playerNotifer = getIt.registerSingleton(PlayerStateNotifer(
      onLoaded: () {
        playerNotifer.loaded();
      },
      onError: onError,
    ));

    showPlayerControlsNotifer =
        getIt.registerSingleton(ShowPlayerControlsNotifer());

    player = getIt.registerSingleton(Player(
      configuration: const PlayerConfiguration(bufferSize: 32 * 1024 * 1024),
    ));

    videoController = getIt.registerSingleton(media_kit_video.VideoController(
      player,
      configuration: const media_kit_video.VideoControllerConfiguration(
          androidAttachSurfaceAfterVideoParameters: false),
    ));

    linkAndDataNotifer = getIt.registerSingleton<LinkAndVideoNotifer>(
        LinkAndDataNotifer.video(onError));

    bufferingNotifer = getIt.registerSingleton<BufferingNotifer>(
        BufferingNotifer(playerRepository.isBufferingStream()));

    playerNotifer.load();
  }

  Widget video() {
    return media_kit_video.Video(
      key: _key,
      controller: videoController,
      controls: (state) {
        return defaultSizedBox;
      },
      subtitleViewConfiguration:
          const media_kit_video.SubtitleViewConfiguration(visible: false),
    );
  }

  Widget centerControls() {
    return const Center(
      child: ToggleControls(
        child: SizedBox(
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerPreviousButton(),
              HorizontalSpace(35),
              PlayerPlayPause(),
              HorizontalSpace(35),
              PlayerNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomControls() {
    return const ToggleControls(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayerSkipButton(),
            VerticalSpace(10),
            PlayerSeekBar(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [VideoSettingsButton(), ChangeVideoSourceButton()],
                ),
                PlayerResizeButton(),
              ],
            ),
          ]),
    );
  }

  Widget loadingIndicator() {
    return GetItListenableBuilder<PlayerStateNotifer, PlayerState>(
      notifer: playerNotifer,
      builder: (context, state) {
        return IgnorePointer(
          child: StateListenableBuilder(
              stateListenable: bufferingNotifer,
              builder: (context, isBuffering, child) {
                if (state == PlayerState.loading || isBuffering) {
                  return const Center(
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
                return defaultSizedBox;
              }),
        );
      },
    );
  }

  Widget topControls() {
    return ToggleControls(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackButton(),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: PlayerTitle(),
          ),
          const Spacer(),
          if (getIt.infoPage.content!.isEpisodic) const ShowEpisodesButton(),
          const PlayerLockButton(),
          const PlayerSettingskButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding =
        MediaQuery.paddingOf(context).let((it) => EdgeInsets.only(
              left: max(it.left, 8.0),
              top: max(
                it.top,
                8.0,
              ),
              right: max(it.right, 8.0),
              bottom: max(it.bottom, 8.0),
            ));

    // final SafeArea
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: padding.copyWith(bottom: 0),
            child: topControls(),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showPlayerControlsNotifer.toggle();
        },
        child: Stack(children: [
          video(),
          const Positioned(
              bottom: 0, right: 0, left: 0, child: SubtitleRenderer()),
          background(),
          Positioned(
              top: kToolbarHeight,
              right: padding.right + 20,
              child: const ToggleControls(child: SelectedVideo())),
          fastforwardAndRewind(),
          centerControls(),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(padding: padding, child: bottomControls())),
          loadingIndicator(),
        ]),
      ),
    );
  }

  Widget fastforwardAndRewind() {
    return StateListenableBuilder(
        stateListenable: playerNotifer,
        builder: (context, state, child) {
          if (state != PlayerState.loaded) {
            return defaultSizedBox;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RewindButton(onTap: () {
                bufferingNotifer.forceBuffering();
                showPlayerControlsNotifer.forceHide();
              }, onFinished: (seconds) {
                showPlayerControlsNotifer.reset();
                playerRepository.rewind(seconds).then((_) {
                  bufferingNotifer.resetBuffering();
                });
              }),
              FastForwardButton(
                onTap: () {
                  bufferingNotifer.forceBuffering();
                  showPlayerControlsNotifer.forceHide();
                },
                onFinished: (seconds) {
                  showPlayerControlsNotifer.reset();
                  playerRepository.fastforward(seconds).then((_) {
                    bufferingNotifer.resetBuffering();
                  });
                },
              ),
            ],
          );
        });
  }

  Widget background() {
    return Positioned.fill(
      child: ToggleControls(
        child: Container(color: Colors.black.withOpacity(0.6)),
      ),
    );
  }

  Future changeOrientation() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future changeBackOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);
  }

  @override
  void dispose() {
    playerRepository.saveProgress();
    player.dispose().then((value) => getIt.unregister<Player>());
    getIt.unregister<PlayerStateNotifer>();
    getIt.unregister<ShowPlayerControlsNotifer>();
    getIt.unregister<media_kit_video.VideoController>();
    getIt.unregister<LinkAndVideoNotifer>();
    getIt.unregister<VideoStateKey>();
    getIt.unregister<BufferingNotifer>();

    playerRepository.unloadPlayer();
    changeBackOrientation();
    super.dispose();
  }
}

class ToggleControls extends StatelessWidget {
  const ToggleControls({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetItListenableBuilder<ShowPlayerControlsNotifer, bool>(
      builder: (context, state) {
        return IgnorePointer(
          ignoring: !state,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: state ? 1 : 0,
            child: child,
          ),
        );
      },
    );
  }
}
