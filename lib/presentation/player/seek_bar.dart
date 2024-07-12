import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';

class PlayerSeekBar extends StatelessWidget {
  const PlayerSeekBar({
    super.key,
  });

  static const seekBarHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SeekBarState>(
        initialData: getIt.get<PlayerRepository>().seekBarState(),
        stream: getIt.get<PlayerRepository>().seekBarStateFlow(),
        builder: (context, snapshot) {
          final state = snapshot.data!;
          return ProgressBar(
            barHeight: 2.0,
            thumbGlowColor: Colors.transparent,
            timeLabelLocation: TimeLabelLocation.sides,
            progress: state.current,
            buffered: state.buffered,
            timeLabelTextStyle: const TextStyle(
              fontSize: MobileFontSize.normal,
            ),
            bufferedBarColor: context.theme.colorScheme.onSurface,
            baseBarColor: const Color(0x3DFFFFFF),
            progressBarColor: context.theme.colorScheme.primary,
            thumbColor: context.theme.colorScheme.primary,
            total: state.total,
            onSeek: onSeek,
          );
        });
  }

  void onSeek(Duration duration) {
    getIt.get<Player>().seek(duration);
  }
}
