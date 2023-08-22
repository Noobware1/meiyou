
import 'package:flutter/material.dart';

class CustomOrientationBuiler extends StatelessWidget {
  final Widget landscape;
  final Widget portrait;
  const CustomOrientationBuiler(
      {super.key, required this.landscape, required this.portrait});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return landscape;
    } else {
      return portrait;
    }
  }
}
