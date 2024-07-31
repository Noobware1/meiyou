class PlayerSeekBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  PlayerSeekBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}
