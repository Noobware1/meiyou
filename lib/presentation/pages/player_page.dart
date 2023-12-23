import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/load_player_usecase.dart';
import 'package:meiyou/presentation/blocs/player/buffering_cubit.dart';
import 'package:meiyou/presentation/blocs/player/resize_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/show_controls_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/desktop_controls.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/mobile_controls.dart';
import 'package:meiyou/presentation/widgets/subtitle_renderer.dart';
import 'package:meiyou_extensions_lib/models.dart' as models;

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final Player player;
  late final VideoController videoController;
  late final PlayerProviders providers;
  late final StreamSubscription loadPlayer;
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

    loadPlayer = context
        .repository<VideoPlayerRepositoryUseCases>()
        .loadPlayerUseCase(
          LoadPlayerUseCaseParams(
              extractedMediaCubit:
                  context.bloc<ExtractedMediaCubit<models.Video>>(),
              selectedVideoDataCubit: context.bloc<SelectedVideoDataCubit>(),
              player: player,
              videoController: videoController,
              providers: providers,
              onDoneCallback: () {
                print('fuck you');
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
    return providers.create(
      BlocListener<ExtractedMediaCubit<models.Video>, ExtractedMediaState>(
        listener: (context, state) {
          if (state.data.isEmpty && state.isDone) {
            showSnackBar(context,
                text: state.error?.message ?? 'Failed to extract videos');
            context.pop();
          } else if (state.error != null) {
            showSnackBar(context, text: state.error!.message);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocListener<ExtractedMediaCubit<models.Video>,
              ExtractedMediaState>(
            listener: (context, state) {
              if (state.error != null) {
                showSnackBar(context, text: state.error!.message);
              }
              if (state.isDone && state.data.isEmpty) {
                showSnackBar(context, text: 'Failed to extract videos');
                context.pop();
              }
            },
            child: GestureDetector(
              onTap: () {
                providers.showVideoControlsCubit.toggleShowControls();
              },
              child: Stack(children: [
                const _BuildVideo(),
                SubtitleRenderer(
                    subtitleConfigruation: SubtitleConfigruation(
                        textStyle:
                            isMobile ? forMobileConfig : forDesktopConfig)),
                Positioned.fill(
                    child: BlocBuilder<ShowVideoControlsCubit, bool>(
                  builder: (context, showControls) {
                    return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: showControls ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: !showControls,
                          child: isMobile
                              ? const MobileControls()
                              : const DesktopControls(),
                        ));
                  },
                )),
                Center(child: BlocBuilder<BufferingCubit, bool>(
                  builder: (context, isBuffering) {
                    if (!isBuffering) return defaultSizedBox;
                    return isMobile
                        ? const SizedBox(
                            height: 35,
                            width: 35,
                            child: CircularProgressIndicator(),
                          )
                        : const CircularProgressIndicator();
                  },
                )),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    loadPlayer.cancel();
    if (isMobile) changeBackOrientation();
    player.dispose();

    providers.dispose();
    super.dispose();
  }
}

class _BuildVideo extends StatelessWidget {
  const _BuildVideo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;
    return SizedBox.expand(
      child: !isMobile
          ? SizedBox(
              height: context
                      .repository<PlayerProvider>()
                      .controller
                      .rect
                      .value
                      ?.height ??
                  height,
              width: context
                      .repository<PlayerProvider>()
                      .controller
                      .rect
                      .value
                      ?.width ??
                  width,
              child: Video(
                  controller: context.repository<PlayerProvider>().controller,
                  controls: (state) {
                    return defaultSizedBox;
                  },
                  subtitleViewConfiguration:
                      const SubtitleViewConfiguration(visible: false)),
            )
          : BlocConsumer<ResizeCubit, ResizeMode>(
              builder: (context, resizeMode) {
                return FittedBox(
                  fit: resizeMode.toBoxFit(),
                  child: SizedBox(
                    height: context
                            .repository<PlayerProvider>()
                            .controller
                            .rect
                            .value
                            ?.height ??
                        height,
                    width: context
                            .repository<PlayerProvider>()
                            .controller
                            .rect
                            .value
                            ?.width ??
                        width,
                    child: Video(
                        controller:
                            context.repository<PlayerProvider>().controller,
                        controls: (state) {
                          return defaultSizedBox;
                        },
                        subtitleViewConfiguration:
                            const SubtitleViewConfiguration(visible: false)),
                  ),
                );
              },
              listener: (context, state) {
                showSnackBar(context, text: state.toString());
              },
            ),
    );
  }
}
