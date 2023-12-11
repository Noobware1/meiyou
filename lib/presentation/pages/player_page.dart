import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/load_player_usecase.dart';
import 'package:meiyou/presentation/blocs/player/resize_cubit.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/show_controls_cubit.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/desktop_controls.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/mobile_controls.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final Player player;
  late final VideoController videoController;
  late final PlayerProviders providers;

  @override
  void initState() {
    if (isMobile) {
      setLanscape();
    }

    player = Player(
      configuration: const PlayerConfiguration(bufferSize: 32 * 1024 * 1024),
    );

    videoController = VideoController(player,
        configuration: const VideoControllerConfiguration(
            androidAttachSurfaceAfterVideoParameters: false));

    providers = PlayerProviders.fromContext(context, player, videoController);

    context.repository<VideoPlayerRepositoryUseCases>().loadPlayerUseCase(
          LoadPlayerUseCaseParams(
              context: context,
              player: player,
              videoController: videoController,
              providers: providers,
              onDoneCallback: () {
                player.play();
              }),
        );

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;

    return providers.create(
      Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<ExtractedVideoDataCubit, ExtractedVideoDataState>(
          listener: (context, state) {
            if (state.error != null) {
              showSnackBar(context, text: state.error!.message);
            }
          },
          child: GestureDetector(
            onTap: () {
              providers.showVideoControlsCubit.toggleShowControls();
            },
            child: Stack(children: [
              SizedBox.expand(
                child: _BuildWithResizeMode(
                  child: SizedBox(
                    height: videoController.rect.value?.height ?? height,
                    width: videoController.rect.value?.width ?? width,
                    child: Video(
                        controller: videoController,
                        controls: (state) {
                          return defaultSizedBox;
                        },
                        subtitleViewConfiguration:
                            const SubtitleViewConfiguration(visible: false)),
                  ),
                ),
              ),
              Positioned.fill(child: BlocBuilder<ShowVideoControlsCubit, bool>(
                builder: (context, showControls) {
                  return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: showControls ? 1.0 : 0.0,
                      child: isMobile
                          ? const MobileControls()
                          : const DesktopControls());
                },
              ))
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (isMobile) changeBackOrientation();
    providers.fullScreenCubit?.exitFullScreen();

    providers.dispose();
    super.dispose();
  }
}

class _BuildWithResizeMode extends StatelessWidget {
  final Widget child;
  const _BuildWithResizeMode({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // if (!isMobile) return child;

    return BlocBuilder<ResizeCubit, ResizeMode>(builder: (context, resizeMode) {
      return FittedBox(
        fit: resizeMode.toBoxFit(),
        child: child,
      );
    });
  }
}
