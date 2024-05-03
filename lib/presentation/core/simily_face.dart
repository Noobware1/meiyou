import 'package:flutter/material.dart';

class SmilyFace extends StatelessWidget {
  final double score;
  final double size;
  const SmilyFace({super.key, required this.score, required this.size});

  @override
  Widget build(BuildContext context) {
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
