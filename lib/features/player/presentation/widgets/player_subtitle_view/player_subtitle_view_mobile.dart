part of 'player_subtitle_view.dart';

class _PlayerSubtitleViewMobile extends StatelessWidget {
  final StateNotifier<List<String>> stateListenable;
  const _PlayerSubtitleViewMobile({super.key,required this.stateListenable});

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
    const subtitleConfigruation = SubtitleConfigruation.mobile();
    return StateListenableBuilder(
        stateListenable: stateListenable,
        builder: (context, state, _) {
          if (state.isEmpty) return defaultSizedBox;
          return Align(
            alignment: Alignment.bottomCenter,
            child: _buildWithBorder(
              subtitleConfigruation,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child:
                    _buildWithHighlight(subtitleConfigruation, state),
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
