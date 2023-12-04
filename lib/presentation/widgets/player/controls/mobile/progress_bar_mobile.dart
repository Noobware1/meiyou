import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/player/progress_bar_cubit.dart';

class VideoProgressbarMobile extends StatelessWidget {
  const VideoProgressbarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBarCubit, ProgressBarState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          width: context.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.current.label(reference: state.total)} / ${state.total.label(reference: state.total)}',
                style: const TextStyle(
                  height: 1.0,
                  fontSize: 12.0,
                ),
              ),
              ProgressBar(
                barHeight: 2.5,
                thumbGlowColor: Colors.transparent,
                timeLabelLocation: TimeLabelLocation.none,
                progress: state.current,
                buffered: state.buffered,
                total: state.total,
                onSeek: (duration) {
                  // playerProvider(context).player.seek(duration);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
