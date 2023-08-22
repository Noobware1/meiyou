import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/double.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class FaceBasedOnScore extends StatelessWidget {
  final double score;
  final double iconSize;
  final TextStyle textStyle;
  const FaceBasedOnScore(
      {super.key,
      required this.score,
      this.iconSize = 25,
      this.textStyle = const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getSmilyFace(score),
        addHorizontalSpace(10),
        Text(
          '${score.toPercentage()}%',
          style: textStyle,
        ),
      ],
    );
  }

  Icon _getSmilyFace(double score) {
    const size = 25.0;
    if (score <= 3.0) {
      return Icon(
        Icons.sentiment_dissatisfied_outlined,
        color: Colors.red.shade400,
        size: size,
      );
    } else if (score <= 5.0 && score > 3.0) {
      return Icon(
        Icons.sentiment_neutral_outlined,
        color: Colors.yellow.shade400,
        size: size,
      );
    } else {
      return Icon(
        Icons.sentiment_satisfied_outlined,
        color: Colors.green.shade400,
        size: size,
      );
    }
  }
}
