import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

// Widget gradient() => Positioned(
//     bottom: 0,
//     right: 0,
//     left: 0,
//     child: );

class DrawGradient extends StatelessWidget {
  final double height;
  final AlignmentGeometry begin;
  final double? width;
  final AlignmentGeometry end;
  final List<Color>? colors;
  const DrawGradient(
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
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: colors ??
                    [
                      context.theme.scaffoldBackgroundColor,
                      Colors.transparent,
                    ])));
  }
}
