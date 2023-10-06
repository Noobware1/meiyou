import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/colors.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

// Widget gradient() => Positioned(
//     bottom: 0,
//     right: 0,
//     left: 0,
//     child: );

class DrawGradient extends StatelessWidget {
  final double height;
  final AlignmentGeometry begin;

  final AlignmentGeometry end;
  final List<Color> colors;
  const DrawGradient(
      {super.key,
      required this.height,
      required this.begin,
      required this.end,
      this.colors = blackWithTranspent});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [context.theme.scaffoldBackgroundColor, Colors.transparent])));
  }
}
