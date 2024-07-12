import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:nice_dart/nice_dart.dart';

class SubtitleRenderer extends StatelessWidget {
  const SubtitleRenderer({super.key});

  Widget _buildWithBorder(
      SubtitleConfigruation subtitleConfigruation, Widget child) {
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

  Widget _buildWithHighlight(
      SubtitleConfigruation subtitleConfigruation, List<String> cues) {
    if (subtitleConfigruation.showHighlight) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text(cues.join('\n'),
              textAlign: TextAlign.center,
              style: subtitleConfigruation.textStyle.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = subtitleConfigruation.highlightWidth
                  ..color = subtitleConfigruation.highlightColor,
              )),
          Text(cues.join('\n'),
              textAlign: TextAlign.center,
              style: subtitleConfigruation.textStyle)
        ],
      );
    }
    return Text(cues.join('\n'),
        textAlign: TextAlign.center, style: subtitleConfigruation.textStyle);
  }

  @override
  Widget build(BuildContext context) {
    final subtitleConfigruation = isMobile
        ? const SubtitleConfigruation.mobile()
        : const SubtitleConfigruation.desktop();
    return StreamBuilder(
        initialData: getIt.get<Player>().state.subtitle,
        stream: getIt.get<Player>().stream.subtitle,
        builder: (context, snapshot) {
          if (snapshot.data.isEmptyOrNull) return defaultSizedBox;
          return Align(
            alignment: Alignment.bottomCenter,
            child: _buildWithBorder(
              subtitleConfigruation,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child:
                    _buildWithHighlight(subtitleConfigruation, snapshot.data!),
              ),
            ),
          );
        });
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

  const SubtitleConfigruation({
    this.highlightWidth = 2.0,
    this.showBorder = false,
    this.showHighlight = true,
    this.highlightColor = Colors.black,
    this.borderRadius = const BorderRadius.all(Radius.zero),
    this.borderColor = const Color(0xB8000000),
    required this.textStyle,
  });

  const SubtitleConfigruation.mobile()
      : this(
            textStyle: const TextStyle(
          fontSize: 21.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ));

  const SubtitleConfigruation.desktop()
      : this(
            textStyle: const TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ));

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
