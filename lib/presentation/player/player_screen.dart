import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou/presentation/player/cubits/player_cubit.dart';
import 'package:meiyou/presentation/player/cubits/show_controls_cubit.dart';
import 'package:meiyou/presentation/player/episodes_button.dart';
import 'package:meiyou/presentation/player/lock_button.dart';
import 'package:meiyou/presentation/player/next_previous_button.dart';
import 'package:meiyou/presentation/player/play_pause_button.dart';
import 'package:meiyou/presentation/player/player_settings.dart';
import 'package:meiyou/presentation/player/player_title.dart';
import 'package:meiyou/presentation/player/resize_button.dart';
import 'package:meiyou/presentation/player/seek_bar.dart';
import 'package:meiyou/presentation/player/subtitle_view.dart';
import 'package:meiyou/presentation/player/video_settings.dart';
import 'package:meiyou/presentation/player/skip_button.dart';
import 'package:meiyou/presentation/player/video_link.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart' hide PlayerState;
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';
import 'package:meiyou/presentation/common/cubits/link_and_data_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';

typedef VideoStateKey = GlobalKey<media_kit_video.VideoState>;

extension PlayerInjectKtorExtensions on InjectKtorInterface {
  PlayerCubit get playerCubit => get<PlayerCubit>();

  PlayerRepository get playerRepository => get<PlayerRepository>();

  VideoStateKey get videoStateKey => get<VideoStateKey>();

  InfoPage get infoPage => get<InfoScreenCubit>().state.value!;
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

  late final PlayerCubit playerCubit;

  late final ShowPlayerControlsCubit showPlayerControlsCubit;

  late final VideoStateKey _key;

  final PlayerRepository playerRepository = InjectKtor.get();

  void onError(Exception error) {
    if (mounted) {
      if (error is NoContentDataException) {
        context.pop();
      }
      logRat.log(LogPriority.error, error.toString());
    }
  }

  late final LinkAndVideoCubit linkAndDataCubit;

  @override
  void initState() {
    super.initState();

    changeOrientation();

    _key = InjectKtor.addSingleton<VideoStateKey>(GlobalKey());

    playerCubit = InjectKtor.addSingleton(PlayerCubit(
      onLoaded: () {
        playerCubit.loaded();
        // player.stream.duration.first.then((value) {
        //   playerRepository.playOrPause();
        //   // if (mounted) {
        //   //   setState(() {});
        //   // }
        // });
      },
      onError: onError,
    ));

    showPlayerControlsCubit =
        InjectKtor.addSingleton(ShowPlayerControlsCubit());

    player = InjectKtor.addSingleton(Player(
      configuration: const PlayerConfiguration(bufferSize: 32 * 1024 * 1024),
    ));

    videoController = InjectKtor.addSingleton(media_kit_video.VideoController(
      player,
      configuration: const media_kit_video.VideoControllerConfiguration(
          androidAttachSurfaceAfterVideoParameters: false),
    ));

    linkAndDataCubit = InjectKtor.addSingleton<LinkAndVideoCubit>(
        LinkAndDataCubit<Video>(onError));

    playerCubit.load();
  }

  Widget video() {
    return media_kit_video.Video(
      key: _key,
      controller: videoController,
      controls: (state) {
        return defaultSizedBox;
      },
    );
  }

  // Widget topBar() {
  //   return const Positioned(
  //     top: 0,
  //     right: 0,
  //     left: 0,
  //     child: ,
  //   );
  // }

  Widget centerControls() {
    return const ToggleControls(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerPreviousButton(),
            HorizontalSpace(10),
            PlayerPlayPause(),
            HorizontalSpace(10),
            PlayerNextButton(),
          ],
        ),
      ),
    );
  }

  Widget bottomControls() {
    return const Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: ToggleControls(
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
                    children: [
                      VideoSettingsButton(),
                      ChangeVideoSourceButton()
                    ],
                  ),
                  PlayerResizeButton(),
                ],
              ),
            ]),
      ),
    );
  }

  Widget loadingIndicator() {
    return BlocBuilder<PlayerCubit, PlayerState>(
      bloc: playerCubit,
      builder: (context, state) {
        return IgnorePointer(
          child: StreamBuilder(
              initialData: InjectKtor.playerRepository.isBuffering(),
              stream: InjectKtor.playerRepository.isBufferingStream(),
              builder: (context, snapshot) {
                if (state == PlayerState.loading || snapshot.data!) {
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
    return BlocBuilder<PlayerCubit, PlayerState>(
      bloc: playerCubit,
      builder: (context, state) {
        if (state.isLoading) return const BackButton();
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
              if (InjectKtor.infoPage.content!.isEpisodic)
                const ShowEpisodesButton(),
              const PlayerLockButton(),
              const PlayerSettingskButton(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Align(
          alignment: Alignment.centerLeft,
          child: topControls(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            showPlayerControlsCubit.toggle();
          },
          child: Stack(children: [
            video(),
            const CustomSubtitleView(),
            background(),
            centerControls(),
            bottomControls(),
            loadingIndicator(),
          ]),
        ),
      ),
    );
  }

  Widget background() {
    return Positioned.fill(
      child: ToggleControls(
        child: Container(color: const Color(0x66000000)),
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
    player.dispose();
    InjectKtor.remove<PlayerCubit>();
    InjectKtor.remove<ShowPlayerControlsCubit>();
    InjectKtor.remove<Player>();
    InjectKtor.remove<media_kit_video.VideoController>();
    InjectKtor.remove<LinkAndDataCubit<Video>>();
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
    return InjecktorBlocBuilder<ShowPlayerControlsCubit, bool>(
      builder: (context, state) {
        return IgnorePointer(
          ignoring: !state,
          child: AnimatedOpacity(
            opacity: state ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state ? 1 : 0,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
