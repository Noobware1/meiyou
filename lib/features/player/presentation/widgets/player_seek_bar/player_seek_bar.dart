import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/features/player/domain/models/player_seek_bar_state.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

part 'player_seek_bar_mobile.dart';

class PlayerSeekBar extends StatelessWidget {
  const PlayerSeekBar({
    super.key,
    required this.stateListenable,
    required this.onSeek,
  });

  final StateNotifier<PlayerSeekBarState> stateListenable;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerSeekBarMobile(
          stateListenable: stateListenable,
          onSeek: onSeek,
        ),
        desktop: () => const SizedBox(),
      );
    });
  }
}
