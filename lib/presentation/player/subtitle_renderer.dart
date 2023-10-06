import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/presentation/player/subtitle_config.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/subtitle_worker_cubit.dart';

class SubtitleRenderer extends StatelessWidget {
  final SubtitleConfigruation subtitleConfigruation;
  const SubtitleRenderer(
      {super.key, this.subtitleConfigruation = const SubtitleConfigruation()});

  Widget _buildWithBorder(Widget child) {
    if (subtitleConfigruation.showBorder) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: subtitleConfigruation.borderColor,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: child,
      );
    }
    return child;
  }

  Widget _buildWithHighlight(List<SubtitleCue> cues) {
    if (subtitleConfigruation.showHighlight) {
      return Stack(
        children: [
          Text(
              [
                for (final line in cues)
                  if (line.text.trim().isNotEmpty) line.text.trim(),
              ].join('\n'),
              textAlign: TextAlign.center,
              style: subtitleConfigruation.textStyle.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = subtitleConfigruation.highlightWidth
                  ..color = subtitleConfigruation.highlightColor,
              )),
          Text(
              [
                for (final line in cues)
                  if (line.text.trim().isNotEmpty) line.text.trim(),
              ].join('\n'),
              textAlign: TextAlign.center,
              style: subtitleConfigruation.textStyle)
        ],
      );
    }
    return Text(
        [
          for (final line in cues)
            if (line.text.trim().isNotEmpty) line.text.trim(),
        ].join('\n'),
        textAlign: TextAlign.center,
        style: subtitleConfigruation.textStyle);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubtitleWorkerCubit, List<SubtitleCue>?>(
        builder: (context, state) {
      if (state != null && state.isNotEmpty) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _buildWithBorder(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: _buildWithHighlight(state),
              ),
            ),
          ),
        );
      } else {
        return defaultSizedBox;
      }
    });
  }
}
