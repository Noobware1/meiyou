import 'package:flutter/material.dart';

class SubtitleConfigruation {
  final bool showBorder;
  final bool showHighlight;
  final Color highlightColor;
  final double highlightWidth;
  final BorderRadius borderRadius;
  final Color borderColor;
  final TextStyle textStyle;

  const SubtitleConfigruation(
      {this.highlightWidth = 3.0,
      this.showBorder = false,
      this.showHighlight = true,
      this.highlightColor = Colors.black,
      this.borderRadius = const BorderRadius.all(Radius.zero),
      this.borderColor = const Color(0xB8000000),
      this.textStyle = forMobile});

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

const forDesktop = TextStyle(
  fontSize: 36.0,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

const forMobile = TextStyle(
  fontSize: 21.0,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);
