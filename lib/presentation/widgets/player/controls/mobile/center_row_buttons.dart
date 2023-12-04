import 'package:flutter/material.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/play_button.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/skip_forward_and_prev_button.dart';

class VideoPlayerMainRowButtonsMobile extends StatelessWidget {
  const VideoPlayerMainRowButtonsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PrevEpisodeButtonMobile(),
        addHorizontalSpace(30),
        const PlayButtonMobile(),
        addHorizontalSpace(30),
        const NextEpisodeButtonMobile(),
      ],
    );
  }
}
