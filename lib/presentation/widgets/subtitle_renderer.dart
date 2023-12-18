import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_subtitle_cues_usecase.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cue_cubit.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

class SubtitleRenderer extends StatelessWidget {
  final SubtitleConfigruation subtitleConfigruation;

  const SubtitleRenderer({required this.subtitleConfigruation, super.key});

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
    return BlocListener<SubtitleCubit, SubtitleState>(
      listener: (context, state) {
        if (state.current == Subtitle.noSubtitle) {
          context.bloc<SubtitleCuesCubit>().emitNoSubtitle();
          return;
        }
        context
            .bloc<SubtitleCuesCubit>()
            .loadSubtitles(GetSubtitleCuesUseCaseParams(
              subtitle: state.current,
              headers: context
                  .bloc<SelectedVideoDataCubit>()
                  .extractedMedia(context)
                  .media
                  .headers,
            ));
      },
      child: BlocListener<SubtitleCuesCubit, SubtitleCuesState>(child:
          BlocBuilder<CurrentSubtitleCuesCubit, List<SubtitleCue>?>(
              builder: (context, state) {
        if (state == null || state.isEmpty) {
          return defaultSizedBox;
        }
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
      }), listener: (context, state) {
        if (state is SubtitleCuesDecodingFailed) {
          showSnackBar(context, text: state.error!.message);
        }
      }),
    );
  }
}

class SubtitleConfigruation {
  final bool showBorder;
  final bool showHighlight;
  final Color highlightColor;
  final double highlightWidth;
  final BorderRadius borderRadius;
  final Color borderColor;
  final TextStyle textStyle;

  const SubtitleConfigruation(
      {this.highlightWidth = 2.0,
      this.showBorder = false,
      this.showHighlight = true,
      this.highlightColor = Colors.black,
      this.borderRadius = const BorderRadius.all(Radius.zero),
      this.borderColor = const Color(0xB8000000),
      this.textStyle = forMobileConfig});

  SubtitleConfigruation copyWith({
    bool? showBorder,
    BorderRadius? borderRadius,
    Color? borderColor,
    TextStyle? textStyle,
    bool? showHighlight,
    Color? highlightColor,
  }) {
    return SubtitleConfigruation(
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      showHighlight: showHighlight ?? this.showHighlight,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }
}

const forDesktopConfig = TextStyle(
  fontSize: 36.0,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

const forMobileConfig = TextStyle(
  fontSize: 21.0,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);
