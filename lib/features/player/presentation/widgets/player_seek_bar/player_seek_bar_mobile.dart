part of 'player_seek_bar.dart';

class _PlayerSeekBarMobile extends StatelessWidget {
  final StateNotifier<PlayerSeekBarState> stateListenable;
  final void Function(Duration) onSeek;
  const _PlayerSeekBarMobile({
    super.key,
    required this.stateListenable,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final theme = PlayerTheme.of(context);

    final timeLabelTextStyle = theme.timeLabelTextStyle;

    final barHeight = theme.seekBarHeight;

    final bufferedBarColor = theme.bufferedBarColor;

    final baseBarColor = theme.baseBarColor;

    final progressBarColor = theme.progressBarColor;

    final thumbColor = theme.thumbColor;

    final thumbGlowColor = theme.thumbGlowColor;

    final timeLabelLocation = theme.timeLabelLocation;

    return StateListenableBuilder(
        stateListenable: stateListenable,
        builder: (context, state, _) {

          return ProgressBar(
            barHeight: barHeight,
            thumbGlowColor: thumbGlowColor,
            timeLabelLocation: timeLabelLocation,
            progress: state.position,
            buffered: state.buffered,
            timeLabelTextStyle: timeLabelTextStyle,
            bufferedBarColor: bufferedBarColor,
            baseBarColor: baseBarColor,
            progressBarColor: progressBarColor,
            thumbColor: thumbColor,
            total: state.total,
            onSeek: onSeek,
          );
        });
  }
}
