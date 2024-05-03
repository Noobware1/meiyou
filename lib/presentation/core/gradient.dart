import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

class Gradient extends StatelessWidget {
  final double height;
  final AlignmentGeometry begin;
  final double? width;
  final AlignmentGeometry end;
  final List<Color>? colors;
  const Gradient(
      {super.key,
      required this.height,
      required this.begin,
      required this.end,
      this.width,
      this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              [context.theme.scaffoldBackgroundColor, Colors.transparent],
        ),
      ),
    );
  }
}
