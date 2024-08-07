import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou/shared/presentation/widgets/resizeable_tab_bar.dart';
import 'package:nice_dart/nice_dart.dart';

part 'player_video_settings_mobile.dart';

class PlayerVideoSettings extends StatelessWidget {
  final List<VideoTrack> videoTracks;
  final VideoTrack selectedVideoTrack;
  final List<SubtitleTrack> subtitleTracks;
  final SubtitleTrack selectedSubtitleTrack;
  final List<AudioTrack> audioTracks;
  final AudioTrack selectedAudioTrack;
  final Future<void> Function(VideoTrack) onVideoTrackSelected;
  final Future<void> Function(SubtitleTrack) onSubtitleTrackSelected;
  final Future<void> Function(AudioTrack) onAudioTrackSelected;
  const PlayerVideoSettings({
    super.key,
    required this.videoTracks,
    required this.selectedVideoTrack,
    required this.subtitleTracks,
    required this.selectedSubtitleTrack,
    required this.audioTracks,
    required this.selectedAudioTrack,
    required this.onVideoTrackSelected,
    required this.onSubtitleTrackSelected,
    required this.onAudioTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerVideoSettingsMobile(
          videoTracks: videoTracks,
          selectedVideoTrack: selectedVideoTrack,
          subtitleTracks: subtitleTracks,
          selectedSubtitleTrack: selectedSubtitleTrack,
          audioTracks: audioTracks,
          selectedAudioTrack: selectedAudioTrack,
          onVideoTrackSelected: onVideoTrackSelected,
          onSubtitleTrackSelected: onSubtitleTrackSelected,
          onAudioTrackSelected: onAudioTrackSelected,
        ),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
