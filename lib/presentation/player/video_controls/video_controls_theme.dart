import 'package:flutter/material.dart';

class VideoPlayerControlsTheme {
  final EdgeInsets rewindForwardPadding;
  final Duration rewindForwardAnimationDuration;
  final ProgressBarTheme progressBarTheme;
  final double changeEpisodeButtonSize;
  final double playButtonSize;




  VideoPlayerControlsTheme({
    this.rewindForwardPadding =
        const EdgeInsets.only(top: 70, left: 0, bottom: 100),
    this.progressBarTheme = const ProgressBarTheme(),
    this.changeEpisodeButtonSize = 40.0,
    this.playButtonSize = 50.0,
    this.rewindForwardAnimationDuration = const Duration(milliseconds: 600),
  });
}

class ProgressBarTheme {
  final EdgeInsets padding;
  final double thumbSize;
  final double height;
  final Color bufferedColor;
  final Color baseBarColor;
  final Color progressColor;

  const ProgressBarTheme(
      {this.padding = const EdgeInsets.only(bottom: 70, right: 20, left: 20),
      this.thumbSize = 12.0,
      this.height = 2.0,
      this.bufferedColor = Colors.white,
      this.baseBarColor = Colors.grey,
      this.progressColor = Colors.pinkAccent});
}
