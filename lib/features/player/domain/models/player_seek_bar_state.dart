class PlayerSeekBarState {
  final Duration position;
  final Duration buffered;
  final Duration total;

  PlayerSeekBarState({
    required this.position,
    required this.buffered,
    required this.total,
  });
}
