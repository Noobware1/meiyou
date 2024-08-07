part of 'player_screen.dart';

class _PlayerScreenMobile extends StatefulWidget {
  final PlayerScreenViewModel viewModel;
  const _PlayerScreenMobile({super.key, required this.viewModel});

  @override
  State<_PlayerScreenMobile> createState() => _PlayerScreenMobileState();
}

class _PlayerScreenMobileState extends State<_PlayerScreenMobile> {
  late PlayerScreenState state;
  bool initialized = false;
  @override
  void initState() {
    super.initState();
    state = widget.viewModel.state;
    changeOrientation();

    viewModel.waitForInit().then((_) {
      setState(() {
        initialized = true;
      });
    });

    viewModel.stateListenable.addListener(() {
      if (!_equals(state, viewModel.state)) {
        setState(() {
          state = viewModel.state;
        });
      }
    });
  }

  // use this method to avoid unnecessary rebuilds when new linkAndVideo is added to the state
  bool _equals(PlayerScreenState a, PlayerScreenState b) {
    return a.isLoading != b.isLoading &&
        a.media != b.media &&
        a.content != b.content;
  }

  @override
  void dispose() {
    changeBackOrientation();
    super.dispose();
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

  PlayerScreenViewModel get viewModel => widget.viewModel;

  PlayerThemeData? _theme;

  PlayerThemeData get theme => _theme!;

  Widget loadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox.square(
          dimension: theme.loadingIndicatorSize,
          child: const CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = PlayerTheme.of(context);

    if (!initialized) return loadingScreen();

    final safePadding = context.getSafePadding(
      minimum: theme.minimumPadding,
    );

    // final SafeArea
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: safePadding,
            child: topControls(),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          viewModel.toggleControlsVisibilty();
        },
        child: Stack(children: [
          video(),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: PlayerSubtitleView(
              stateListenable: viewModel.subtitleListenable,
            ),
          ),
          background(),
          fastForwardAndRewind(),
          centerControls(),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(padding: safePadding, child: bottomControls())),
          loadingIndicator(),
        ]),
      ),
    );
  }

  Widget topControls() {
    return ToggleControls(
      stateListenable: viewModel.controlVisibilityNotifier,
      child: SizedBox(
        width: context.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BackButton(),
            Padding(
              padding: const EdgeInsets.only(top: MaterialTheme.spacing),
              child: PlayerTitle(
                media: state.media!,
                content: state.content!,
              ),
            ),
            const Spacer(),
            ShowMediaContentListButton(
              onPressed: () => viewModel.showMediaContentList(context),
            ),
            // / const PlayerLockButton(),
            // const PlayerSettingskButton(),
          ],
        ),
      ),
    );
  }

  Widget bottomControls() {
    return ToggleControls(
      stateListenable: viewModel.controlVisibilityNotifier,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayerSkipButton(
              onPressed: viewModel.skipForward,
              seconds: viewModel.skipSeconds,
            ),
            const VerticalSpace(MaterialTheme.spacing),
            PlayerSeekBar(
              stateListenable: viewModel.seekBarStateListenable,
              onSeek: viewModel.seek,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ShowVideoSourcesButton(
                      onPressed: () => viewModel.showVideoSources(context),
                    ),
                    const HorizontalSpace(MaterialTheme.spacing),
                    VideoSettingsButton(
                      onPressed: () => viewModel.showVideoSettings(context),
                    ),
                  ],
                ),
                PlayerResizeButton(
                  stateListenable: viewModel.playerFitNotifier,
                  onPressed: viewModel.changeVideoFit,
                ),
              ],
            ),
          ]),
    );
  }

  Widget background() {
    return Positioned.fill(
      child: ToggleControls(
        stateListenable: viewModel.controlVisibilityNotifier,
        child: Container(color: theme.backgroundColor),
      ),
    );
  }

  Widget video() {
    return Video(
      key: viewModel.videoKey,
      controller: viewModel.videoController,
      controls: (state) {
        return defaultSizedBox;
      },
      subtitleViewConfiguration:
          const SubtitleViewConfiguration(visible: false),
    );
  }

  Widget centerControls() {
    return Center(
      child: ToggleControls(
        stateListenable: viewModel.controlVisibilityNotifier,
        child: SizedBox(
          height: theme.playButtonSize.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerPreviousButton(
                hasPrevious: viewModel.hasPrevious,
                onPressed: viewModel.previous,
              ),
              HorizontalSpace(theme.nextPreviousButtonSpacing),
              StateListenableBuilder(
                  stateListenable: viewModel.bufferingListenable,
                  builder: (context, buffering, _) {
                    if (state.isLoading || buffering) {
                      return SizedBox.fromSize(
                        size: theme.playButtonSize,
                      );
                    }
                    return PlayerPlayPause(
                      onPressed: viewModel.playPause,
                      stateListenable: viewModel.playPauseStateListenable,
                    );
                  }),
              HorizontalSpace(theme.nextPreviousButtonSpacing),
              PlayerNextButton(
                hasNext: viewModel.hasNext,
                onPressed: viewModel.next,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fastForwardAndRewind() {
    if (state.isLoading) return defaultSizedBox;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RewindButton(onTap: (seconds) {
          viewModel.forceHideControls();
          viewModel.rewind(seconds);
        }, onFinished: (seconds) {
          viewModel.releaseHideControls();
        }),
        FastForwardButton(
          onTap: (seconds) {
            viewModel.forceHideControls();
            viewModel.forward(seconds);
          },
          onFinished: (_) {
            viewModel.releaseHideControls();
          },
        ),
      ],
    );
  }

  Widget loadingIndicator() {
    final loadingIndicator = Center(
        child: SizedBox.square(
      dimension: theme.loadingIndicatorSize,
      child: const CircularProgressIndicator.adaptive(),
    ));
    return StateListenableBuilder(
        stateListenable: viewModel.bufferingListenable,
        builder: (context, buffering, _) {
          if (state.isLoading || buffering) return loadingIndicator;
          return defaultSizedBox;
        });
  }
}

class ToggleControls extends StatelessWidget {
  const ToggleControls(
      {super.key, required this.stateListenable, required this.child});

  final StateNotifier<bool> stateListenable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
      stateListenable: stateListenable,
      builder: (context, visible, _) {
        return IgnorePointer(
          ignoring: !visible,
          child: AnimatedOpacity(
            duration: Durations.medium2,
            opacity: visible ? 1 : 0,
            child: child,
          ),
        );
      },
    );
  }
}
