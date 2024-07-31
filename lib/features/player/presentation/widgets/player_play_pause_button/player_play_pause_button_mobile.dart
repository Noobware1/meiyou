part of 'player_play_pause_button.dart';

class _PlayerPlayPauseButtonMobile extends StatefulWidget {
  final StateStream<bool> stateStream;
  final VoidCallback onPressed;

  const _PlayerPlayPauseButtonMobile({
    super.key,
    required this.stateStream,
    required this.onPressed,
  });

  @override
  State<_PlayerPlayPauseButtonMobile> createState() =>
      __PlayerPlayPauseButtonMobileState();
}

class __PlayerPlayPauseButtonMobileState
    extends State<_PlayerPlayPauseButtonMobile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: Durations.medium2,
        reverseDuration: Durations.medium2); // ..forward();

    widget.stateStream.let((it) {
      _moveAnimation(it.state);
      _subscription = it.listen((playing) {
        _moveAnimation(playing);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _moveAnimation(bool playing) {
    if (!playing) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = PlayerTheme.of(context);

    final buttonSize = theme.playButtonSize;

    final style = theme.playButtonStyle;

    final iconSize = theme.playButtonIconSize;

    final iconColor = theme.playButtonIconColor;

    return SizedBox.fromSize(
      size: buttonSize,
      child: IconButton(
        style: style,
        onPressed: widget.onPressed,
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          size: iconSize,
          progress: _animationController,
          color: iconColor,
        ),
      ),
    );
  }
}
