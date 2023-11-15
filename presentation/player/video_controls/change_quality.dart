import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/player/video_controls/arrow_selector.dart';
import 'package:meiyou/presentation/widgets/apply_cancel.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/presentation/widgets/arrow_selector_list.dart';

class ChangeQuality extends StatelessWidget {
  final List<VideoTrack> videoTracks;

  final void Function(VideoTrack track) onApply;
  final void Function() onCancel;

  const ChangeQuality(
      {super.key,
      required this.videoTracks,
      required this.onApply,
      required this.onCancel});

  static Future showQuailtiesDialog(BuildContext context, Player player) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            child: RepositoryProvider.value(
              value: player,
              child: ChangeQuality(
                videoTracks: player.state.tracks.video,
                onApply: (track) {
                  Navigator.pop(context);
                  if (track != player.state.track.video) {
                    Future.microtask(() async {
                      await Future.delayed(const Duration(seconds: 1));
                      await player.setVideoTrack(track);
                    });
                  }
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // print(player(context).state.track.video);

    return Container(
        constraints: isMobile
            ? const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20)
            : const BoxConstraints(
                maxWidth: 350, maxHeight: 350, minHeight: 20),
        child: ArrowSelectorList(
            items: [VideoTrack.auto(), ...videoTracks.sublist(2)],
            label: 'Change Quality',
            onApply: onApply,
            onCancel: onCancel,
            initalValue: player(context).state.track.video,
            builder: (context, video) => video == VideoTrack.auto()
                ? 'Auto'
                : '${video.w ?? 0}x${video.h ?? 0}'));
  }
}
